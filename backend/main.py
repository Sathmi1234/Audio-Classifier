from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import librosa
import numpy as np
import joblib
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

model = joblib.load("audio_model.pkl")

def extract_features(file_path):
    audio, sr = librosa.load(file_path, duration=3)
    mfcc = librosa.feature.mfcc(y=audio, sr=sr, n_mfcc=40)
    return np.mean(mfcc.T, axis=0)

@app.post("/predict")
async def predict_audio(file: UploadFile = File(...)):
    temp_path = "temp.wav"

    with open(temp_path, "wb") as f:
        f.write(await file.read())

    features = extract_features(temp_path)
    prediction = model.predict([features])[0]

    os.remove(temp_path)

    return {"prediction": prediction}
