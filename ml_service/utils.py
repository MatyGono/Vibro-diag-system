import pandas as pd
import numpy as np
from scipy.stats import kurtosis

def extract_features(file_path):
    """
    Načte MAFAULDA CSV a vypočítá RMS a Kurtosis pro 5. sloupec 
    (overhang bearing - radial).
    """
    # Načtení dat (MAFAULDA nemá header, oddělovač je čárka)
    df = pd.read_csv(file_path, header=None)
    
    # Vybereme 5. sloupec (index 4) - Overhang bearing axial/radial
    signal = df.iloc[:, 4].values
    
    # 1. Výpočet RMS
    rms_value = np.sqrt(np.mean(signal**2))
    
    # 2. Výpočet Kurtosis
    kurt_value = kurtosis(signal)
    
    # 3. Peak-to-Peak (volitelný, ale užitečný rys)
    ptp_value = np.ptp(signal)
    
    return {
        "rms": rms_value,
        "kurtosis": kurt_value,
        "ptp": ptp_value
    }