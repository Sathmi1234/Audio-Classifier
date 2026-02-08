import os
import librosa
import numpy as np
import joblib
from sklearn.svm import SVC

def extract_features(file_path):
    audio, sr = librosa.load(file_path, duration=3)
    mfcc = librosa.feature.mfcc(y=audio, sr=sr, n_mfcc=40)
    return np.mean(mfcc.T, axis=0)

X = []
y = []

for label in os.listdir("dataset"):
    label_path = os.path.join("dataset", label)
    for file in os.listdir(label_path):
        file_path = os.path.join(label_path, file)
        features = extract_features(file_path)
        X.append(features)
        y.append(label)

model = SVC(kernel="linear")
model.fit(X, y)

joblib.dump(model, "audio_model.pkl")
print("Model trained & saved")
