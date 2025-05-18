import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import os

def gerar_relatorio():
    conn = sqlite3.connect("feedbacks.db")
    df = pd.read_sql_query("SELECT * FROM feedback", conn)
    conn.close()

    if df.empty:
        return [], {}

    medias = df.groupby("avaliado")[["comunicacao", "empatia", "lideranca", "proatividade"]].mean().round(2)
    return df.to_dict(orient="records"), medias.to_dict(orient="index")


def gerar_relatorio_individual(nome):
    conn = sqlite3.connect("feedbacks.db")
    df = pd.read_sql_query("SELECT * FROM feedback WHERE avaliado = ?", conn, params=(nome,))
    conn.close()

    if df.empty:
        return None

    media = df[["comunicacao", "empatia", "lideranca", "proatividade"]].mean()
    categorias = list(media.index)
    valores = media.tolist()

    # Preparar gráfico radar
    categorias += [categorias[0]]  
    valores += [valores[0]]

    angles = [n / float(len(categorias)) * 2 * 3.141592 for n in range(len(categorias))]

    fig, ax = plt.subplots(figsize=(6, 6), subplot_kw=dict(polar=True))
    ax.plot(angles, valores, linewidth=2, linestyle='solid')
    ax.fill(angles, valores, alpha=0.25)
    ax.set_ylim(0, 5) 
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(categorias[:-1])
    ax.set_title(f"Soft Skills de {nome}")

    # Criar pasta se não existir
    path = f"static/graficos"
    os.makedirs(path, exist_ok=True)

    # Salvar gráfico
    filename = f"{path}/{nome}.png"
    plt.savefig(filename, bbox_inches='tight')
    plt.close()

    return filename
