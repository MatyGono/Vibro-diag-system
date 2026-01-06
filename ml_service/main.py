from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np
import pandas as pd

# Definice vstupních dat (co nám pošle backend nebo frontend)
class VibrationData(BaseModel):
    rms: float
    kurtosis: float
    ptp: float

app = FastAPI(title="Machine Learning Service")

# Načtení natrénovaného modelu hned při startu
model = joblib.load('models/mafaulda_model.joblib')

@app.get("/")
def home():
    return {"message": "Inference service is running"}

@app.post("/predict")
def predict(data: VibrationData):
    # Převod dat pro model (vstup musí být 2D pole)
    features_df = pd.DataFrame([{
        "rms": data.rms,
        "kurtosis": data.kurtosis,
        "ptp": data.ptp
    }])
    
    # Výpočet predikce
    prediction = model.predict(features_df)[0]
    
    # Výpočet pravděpodobnosti (jak moc si je model jistý)
    probabilities = model.predict_proba(features_df)[0]
    confidence = float(np.max(probabilities))
    
    result = "PORUCHA" if prediction == 1 else "V POŘÁDKU"
    
    return {
        "status": result,
        "label": int(prediction),
        "confidence": round(confidence, 4)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8001)