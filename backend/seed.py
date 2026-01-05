import time
import random
from datetime import datetime, timezone
from sqlalchemy import create_engine, text

# Script pro generovani dummy dat do db

# Pripojeni k db
DB_URL = "postgresql://admin:secret@localhost:5432/vibro_diag"
engine = create_engine(DB_URL)

def generate_dummy_data():
    print("Generuji data do databaze...")

    with engine.connect() as conn:
        for _ in range(10): # 10 zaznamu
            now = datetime.now(timezone.utc)
            # data
            rms_raw = random.uniform(0.5, 2.5)
            peak_raw = rms_raw * random.uniform(1.4, 2.0)
            kurtosis = random.uniform(2.8, 4.5)
            # SQL vlozeni dat
            query = text("""
                         INSERT INTO feature_data (time, rms_raw, peak_raw, kurtosis_raw, asset_id)
                         VALUES (:time, :rms, :peak, :kurt, :asset)
                         """)
            conn.execute(query, {
                "time": now,
                "rms": rms_raw,
                "peak": peak_raw,
                "kurt": kurtosis,
                "asset": "motor_test_01"
                })
            conn.commit()
            print(f"Zapis v {now.strftime('%H:%M:%S')} - RMS: {rms_raw:.2f}")
            time.sleep(1) # Pockat sekundu mezi zapisy

if __name__ == "__main__":
    generate_dummy_data()