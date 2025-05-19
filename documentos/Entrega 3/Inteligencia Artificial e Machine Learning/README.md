# API

A api utiliza um modelo exportado do colab via PKL <a href="https://edufecap-my.sharepoint.com/:u:/g/personal/guilherme_oliveira10_edu_fecap_br/EbT2tdZuGe1BkJPNCd5803UBWhUxvXX9ZvwZZT-6hzss3A?e=FjIa8t)" target="_blank">(Baixe o modelo por aqui ou pelo link no arquivo TXT)</a> . 

<a href="https://github.com/2025-1-NCC5/Projeto1/blob/main/documentos/Entrega%203/Inteligencia%20Artificial%20e%20Machine%20Learning/Notebooks/MLNotebookCompleto.ipynb">Notebook de tratamento e treinamento</a> 




## Estrutura

|-->API <br>
&nbsp;&nbsp;|---> ApiModel.py <br>
&nbsp;&nbsp;|---> Dockerfile <br>
&nbsp;&nbsp;|---> LINK PARA BAIXAR O MODELO<br> 
&nbsp;&nbsp;|---> requirements.txt<br>
&nbsp;&nbsp;|---> treino_x_columns.json<br>


## Como utilizar a API

Usar api em <a href="http://15.229.102.105:5000/">15.229.102.105:5000</a>. <br>
Para mais detalhes, consulte o <a href="https://github.com/2025-1-NCC5/Projeto1/blob/main/documentos/Entrega%203/Inteligencia%20Artificial%20e%20Machine%20Learning/Relat%C3%B3rio%20de%20Implanta%C3%A7%C3%A3o%20do%20Modelo%20Preditivo%20com%20API%20Flask%20e%20Docker.pdf">Relatorio</a>

Caso queira rodar a API localmente, baixe o Docker na sua máquina, e rode esses comandos:
```bash
docker pull guialvesoliveira/previsao-api
docker run -p 5000:5000 guialvesoliveira/previsao-api

