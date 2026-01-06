import os
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
import joblib
from utils import extract_features  # Tvoje funkce z minula

def prepare_dataset():
    features_list = []
    labels = []
    
    # Cesty k datům
    data_dir = "./data"
    categories = {"normal": 0, "fault": 1}
    
    print("Zahajuji extrakci rysů z MAFAULDA souborů...")
    
    for category, label in categories.items():
        folder_path = os.path.join(data_dir, category)
        files = os.listdir(folder_path)
        
        for f in files:
            if f.endswith('.csv'):
                file_path = os.path.join(folder_path, f)
                try:
                    # Použijeme tvůj feature extractor
                    features = extract_features(file_path)
                    features_list.append(features)
                    labels.append(label)
                except Exception as e:
                    print(f"Chyba při zpracování {f}: {e}")
    
    # Převedeme na DataFrame
    X = pd.DataFrame(features_list)
    y = labels
    return X, y

def train():
    # 1. Příprava dat
    X, y = prepare_dataset()
    
    # 2. Rozdělení na trénovací a testovací sadu (80% učení, 20% test)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # 3. Trénink Random Forestu
    print(f"Trénuji Random Forest na {len(X_train)} vzorcích...")
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_train, y_train)
    
    # 4. Validace
    y_pred = clf.predict(X_test)
    print("\nVýsledky modelu (Confusion Matrix):")
    print(confusion_matrix(y_test, y_pred))
    print("\nDetailed Report:")
    print(classification_report(y_test, y_pred))
    
    # 5. Uložení modelu
    os.makedirs('models', exist_ok=True)
    joblib.dump(clf, 'models/mafaulda_model.joblib')
    print("\nModel uložen do 'models/mafaulda_model.joblib'")

if __name__ == "__main__":
    train()