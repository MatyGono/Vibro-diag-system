from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
import uvicorn

# Script FastAPI

app = FastAPI(title="VibroDiag API")

# Nastaveni Cross-Origin Resource Sharing
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_methods=['*'],
    allow_headers=['*'],    
)

# Pripojeni k DB
DB_URL = "postgresql://admin:secret@localhost:5432/vibro_diag"
engine = create_engine(DB_URL)

@app.get("/")
def home():
    return {"massage":"Vibrodiagnosticky system bezi!"}

@app.get("/latest-data")
def get_latest_data():
    """Vytahne posledni zaznam z databaze"""
    with engine.connect() as conn:
        query = text("SELECT * FROM feature_data ORDER BY time DESC LIMIT 1")
        result = conn.execute(query).fetchone()
        # Pokud v DB nic neni
        if not result:
            return {"massage":"Zadna data nebyla nalezena"}
        # Prevedeni vysledku na JSON slovnik
        data = {
            "time": result[0],
            "rms_raw": result[11],
            "peak_raw": result[6],
            "kurtosis": result[9],
            "asset_id": result[1]    
        }
        return data

@app.get("/history")
def get_history(limit: int = 100):
    """Vrati poslednich 'limit' zaznamu z databaze pro grafy"""
    with engine.connect() as conn:
        query = text("SELECT * FROM feature_data ORDER BY time DESC LIMIT :limit")
        result = conn.execute(query, {"limit":limit}).fetchall()
        # Pokud v DB nic neni
        if not result:
            return {"massage":"Zadna data nebyla nalezena"}
        # Prevedeni vysledku na JSON slovnik
        history = []
        for row in result:
            history.append({
                "time": row[0],
                "asset_id": row[1],
                "peak_raw": row[6],
                "kurtosis": row[9],
                "rms_raw": row[11]  
            })
        # Vratime data 
        return history

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)