import pandas as pd
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import joblib

X, y = make_classification(n_samples = 1000, n_features = 4, random_state = 42)

X_treino, X_teste, y_treino, y_teste = train_test_split(X, y, test_size = 0.2, random_state = 42)

modelo = LogisticRegression()
modelo.fit(X_treino, y_treino)

predictions = modelo.predict(X_teste)
accuracy = accuracy_score(y_teste, predictions)
print(f"Acurácia do modelo: {accuracy:.2f}")

joblib.dump(modelo, 'modelo_treinado.pkl')