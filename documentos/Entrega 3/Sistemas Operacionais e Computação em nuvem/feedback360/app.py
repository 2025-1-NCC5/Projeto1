from flask import Flask, render_template, request, redirect
from flask import session as flask_session
import sqlite3
from datetime import datetime
from analysis import gerar_relatorio, gerar_relatorio_individual
import uuid


app = Flask(__name__)
app.secret_key = "chave-secreta-aleatoria"

# Criação do banco de dados e tabela
def init_db():
    with sqlite3.connect("feedbacks.db") as conn:
        c = conn.cursor()
        c.execute('''
            CREATE TABLE IF NOT EXISTS avaliados (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT UNIQUE
            )
        ''')
        c.execute('''
            CREATE TABLE IF NOT EXISTS feedback (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                session_id TEXT,
                avaliado TEXT,
                comunicacao INTEGER,
                empatia INTEGER,
                lideranca INTEGER,
                proatividade INTEGER,
                data TEXT
            )
        ''')
        conn.commit()



@app.route('/')
def index():
    return render_template('cadastro_avaliados.html')

@app.route('/nova-sessao')
def nova_sessao():
    flask_session['session_id'] = str(uuid.uuid4())  # nova sessão
    return render_template('cadastrar_nomes_sessao.html')

@app.route('/cadastrar', methods=['POST'])
def cadastrar():
    nomes = request.form.getlist('avaliado')
    with sqlite3.connect("feedbacks.db") as conn:
        c = conn.cursor()
        for nome in nomes:
            if nome.strip():
                c.execute("INSERT OR IGNORE INTO avaliados (nome) VALUES (?)", (nome.strip(),))
        conn.commit()
    return redirect('/avaliar')

@app.route('/avaliar', methods=['POST'])
def avaliar_iniciar():
    nomes = request.form.getlist('avaliado')
    flask_session['avaliados'] = nomes
    flask_session['index'] = 0
    return redirect('/avaliar-sequencial')


@app.route('/avaliar-sequencial')
def avaliar_sequencial():
    session_id = flask_session.get('session_id')
    nomes = flask_session.get('avaliados', [])
    index = flask_session.get('index', 0)

    if index >= len(nomes):
        return redirect('/report')

    nome_atual = nomes[index]
    return render_template(
        'avaliar.html',
        nome=nome_atual,
        index=index,
        total=len(nomes),
        session_id=session_id
    )

@app.route('/submit/<avaliado>/<int:index>', methods=['POST'])
def submit_feedback(avaliado, index):
    session_id = flask_session.get('session_id')
    data = request.form

    with sqlite3.connect("feedbacks.db") as conn:
        c = conn.cursor()
        c.execute('''
            INSERT INTO feedback (session_id, avaliado, comunicacao, empatia, lideranca, proatividade, data)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            session_id,
            avaliado,
            int(data['comunicacao']),
            int(data['empatia']),
            int(data['lideranca']),
            int(data['proatividade']),
            datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        ))
        conn.commit()

    flask_session['index'] = index + 1
    return redirect('/avaliar-sequencial')

@app.route('/report')
def report():
    registros, analise = gerar_relatorio()
    return render_template('report.html', analise=analise)

@app.route('/report/<nome>')
def report_individual(nome):
    graficos = gerar_relatorio_individual(nome)
    return render_template('grafico_individual.html', nome=nome, graficos=graficos)

if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0')
