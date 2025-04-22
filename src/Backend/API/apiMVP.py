from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

GOOGLE_API_KEY = '************************************'  # Substitua pela chave da API

theta = [4.04740054, 0.00173841945, 0.000977577408]

def predict_price(distance_m, duration_s):
    return theta[0] + theta[1] * distance_m + theta[2] * duration_s

def get_distance_and_duration(origin, destination):
    url = (
        f"https://maps.googleapis.com/maps/api/distancematrix/json"
        f"?origins={origin}&destinations={destination}&key={GOOGLE_API_KEY}"
    )
    print(f"🔗 Requisição para Google Maps API: {url}")
    response = requests.get(url)
    print(f"📨 Resposta da Google API: {response.status_code}")
    data = response.json()
    print("📦 Conteúdo da resposta:", data)

    if data['rows'] and data['rows'][0]['elements'][0]['status'] == 'OK':
        element = data['rows'][0]['elements'][0]
        distance = element['distance']['value']
        duration = element['duration']['value']
        print(f"✅ Distância: {distance}m | Duração: {duration}s")
        return distance, duration
    else:
        print("❌ Erro ao obter distância e duração da Google API.")
        raise Exception("Erro ao obter distância/duração da API.")

@app.route('/')
def index():
    return "API FUNCIONANDO!"

@app.route('/predict', methods=['POST'])
def predict():
    print("📥 Requisição recebida:")
    print("Headers:", dict(request.headers))
    print("Body bruto:", request.data)

    try:
        data = request.get_json(force=True)
        print("🧾 JSON processado:", data)
    except Exception as e:
        print(f"❌ Erro ao ler JSON: {e}")
        return jsonify({"error": "Erro ao ler JSON"}), 400

    origin = data.get('origin')
    destination = data.get('destination')

    if not origin or not destination:
        print("⚠️ Campos ausentes: origin ou destination")
        return jsonify({"error": "Origem e destino são obrigatórios"}), 400

    try:
        distance_m, duration_s = get_distance_and_duration(origin, destination)
        price = predict_price(distance_m, duration_s)
        print(f"💰 Preço previsto: R${round(price, 2)}")
        return jsonify({
            "distance_m": distance_m,
            "duration_s": duration_s,
            "price": round(price, 2)
        })
    except Exception as e:
        print(f"❌ Erro durante previsão: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
