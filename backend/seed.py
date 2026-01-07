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

def generate_fault_scenario():
    print("Zahajuji simulaci postupne poruchy loziska...")

    with engine.connect() as conn:
        for i in range(15):
            now = datetime.now(timezone.utc)
            # Simulace progresivniho rustu:
            # i=0 (zdravy stroj) az i=14 (vazna porucha)
            # Zvedneme zakladni hodnoty a pridame "sum"
            
            # RMS roste z cca 0.8 na 4.5
            rms_raw = 0.8 + (i * 0.25) + random.uniform(-0.1, 0.1)
            
            # Kurtosis u lozisek roste skokove pri vzniku razu (3.0 -> 7.0+)
            kurtosis = 3.0 + (i * 0.3) + random.uniform(-0.2, 0.2)
            
            # PTP (Peak-to-Peak) roste nejrychleji (4.0 -> 30.0)
            peak_raw = 5.0 + (i * 1.8) + random.uniform(-1.0, 1.0)

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
            
            status = "VYSTRIHA" if i > 8 else "NORMAL"
            print(f"Krok {i+1}/15 - [{status}] RMS: {rms_raw:.2f}, Kurt: {kurtosis:.2f}, PTP: {peak_raw:.2f}")
            time.sleep(0.5)

if __name__ == "__main__":
    generate_fault_scenario()