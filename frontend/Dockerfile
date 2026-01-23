# --- FÁZE 1: BUILD (Stavitel) ---
FROM node:20-slim as builder

WORKDIR /app

# Instalace závislostí
COPY package*.json ./
RUN npm install

# Zkopírování zdrojového kódu
COPY . .

# --- PŘIDAT TOTO: ---
# Přijmeme argument z docker-compose
ARG VITE_API_URL 
# Nastavíme ho jako proměnnou prostředí pro build
ENV VITE_API_URL=$VITE_API_URL
# --------------------

# Tady proběhne "vaření". Výsledkem je složka /app/dist
RUN npm run build


# --- FÁZE 2: PRODUCTION (Servírka) ---
FROM nginx:alpine

# Zkopírujeme naši konfiguraci Nginxu
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Zkopírujeme POUZE hotové soubory z fáze 1 (ze složky dist) do Nginxu
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx běží na portu 80
EXPOSE 80

# Nginx se spustí automaticky, nemusíme psát CMD