# Použijeme stejnou verzi jako u backendu
FROM python:3.13-slim

WORKDIR /app

# Instalace systémových knihoven
# libgomp1 je často potřeba pro scikit-learn/numpy optimalizace
RUN apt-get update && apt-get install -y \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Zkopírujeme requirements a nainstalujeme
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Zkopírujeme celý obsah složky ml_service
# DŮLEŽITÉ: Tím se zkopíruje i složka "models" s tvým .joblib souborem
COPY . .

# ML service běží na portu 8001
EXPOSE 8001

# Spuštění uvicornu na portu 8001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]