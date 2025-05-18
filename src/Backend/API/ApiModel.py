from flask import Flask, request, jsonify
import pandas as pd
import pytz
import requests
import joblib
import json

app = Flask(__name__)


GOOGLE_API_KEY = 'AIzaSyBKR1ZzdzQtdg7FX7KTND2DlBfUUFGsukk'  


modelo = joblib.load('modelo_uber.pkl')
with open('treino_x_columns.json') as f:
    treino_x_colunas = json.load(f)

# Função para obter distância e duração usando a API do Google
def get_distance_and_duration(origin, destination):
    url = (
        f"https://maps.googleapis.com/maps/api/distancematrix/json"
        f"?origins={origin}&destinations={destination}&key={GOOGLE_API_KEY}"
    )
    response = requests.get(url)
    data = response.json()

    if data['rows'] and data['rows'][0]['elements'][0]['status'] == 'OK':
        element = data['rows'][0]['elements'][0]
        distance = element['distance']['value']
        duration = element['duration']['value']
        return distance, duration
    else:
        raise Exception("Erro ao obter distância/duração da API.")

# Função para verificar se é dia útil
def calcular_dia_util(data):
    return data.weekday() < 5

# Função para prever preço
def prever_preco(origin, destination, cod_categoria):
    distancia_m, duracao_s = get_distance_and_duration(origin, destination)
    fuso_brasilia = pytz.timezone('America/Sao_Paulo')
    data_hora = pd.to_datetime('now').tz_localize('UTC').astimezone(fuso_brasilia)

    hora = data_hora.hour
    dia_semana = data_hora.weekday()
    dia_util = calcular_dia_util(data_hora)


    novo_dado = pd.DataFrame([{
        'distancia_api_m': distancia_m,
        'duracao_api_s': duracao_s,
        'flg_dia_util': 1 if dia_util else 0,
        'cod_provedor': cod_categoria,  
        'cod_categoria': cod_categoria,
        'hora': hora,
        'dia_semana': dia_semana
    }])

    novo_dado = pd.get_dummies(novo_dado, drop_first=True)

    for col in treino_x_colunas:
        if col not in novo_dado.columns:
            novo_dado[col] = 0

    novo_dado = novo_dado[treino_x_colunas]

 
    preco = modelo.predict(novo_dado)[0]

    return round(preco, 2), distancia_m, duracao_s, hora, dia_semana, dia_util, cod_categoria

# Rota de conferência
@app.route('/')
def index():
    return "Rota de Conferencia se a API está Rodando"


# Rota para previsão de preço
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json(force=True)
        origin = data.get('origin')
        destination = data.get('destination')

        if not origin or not destination:
            return jsonify({"error": "Origem e destino são obrigatórios"}), 400

        categorias = {
            "uber": 3,
            "app99": 5
        }

        response_data = {}

        for nome, cod_categoria in categorias.items():
            try:
                preco, dist_m, tempo_s, hora, dia_semana, dia_util, cat = prever_preco(origin, destination, cod_categoria)
                response_data[nome] = {
                    "distance_m": dist_m,
                    "duration_s": tempo_s,
                    "price": preco
                }
            except Exception as e:
                response_data[nome] = {"error": str(e)}

        print(f"[LOG] Requisição recebida: origem={origin}, destino={destination}")
        print(f"[LOG] Resposta gerada: {response_data}")
        return jsonify(response_data)

    except Exception as e:
        print(f"[LOG] Erro geral: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
