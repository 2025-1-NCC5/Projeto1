# Imagem base oficial do Python
FROM python:3.10-slim

# Diretório de trabalho no container
WORKDIR /app

# Copiar arquivos para dentro do container
COPY . .

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Expor porta do Flask
EXPOSE 5000

# Rodar a aplicação
CMD ["python", "app.py"]
