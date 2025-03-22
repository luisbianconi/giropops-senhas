# Etapa de build
FROM cgr.dev/chainguard/python:latest-dev AS building

WORKDIR /app
RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Etapa final
FROM cgr.dev/chainguard/python:latest

WORKDIR /app
COPY . .
COPY --from=building /app/venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Variáveis para rodar o Flask
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

EXPOSE 5000
ENTRYPOINT ["flask", "run", "--host=0.0.0.0", "--port=5000"]

