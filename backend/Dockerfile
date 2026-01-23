# Použijeme tvou verzi Pythonu
FROM python:3.13-slim

WORKDIR /app

# Instalace systémových knihoven
# libpq-dev a gcc jsou nutné, pokud máš v requirements.txt 'psycopg2' (ne binary verzi)
# curl se hodí pro healthchecky
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Zkopírujeme requirements a nainstalujeme
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Zkopírujeme zbytek aplikace
COPY . .

# Port
EXPOSE 8000

# Spuštění
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]