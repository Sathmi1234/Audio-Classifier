## Frontend run
``` bash
flutter run -d chrome
```

## Train the model
``` bash
python train_model.py
```

## Backend run
``` bash
uvicorn main:app--reload
```

# Audio Classifier

A modern machine learning application that classifies audio files in real-time. The project features a Flutter web interface for uploading audio files and a FastAPI backend that uses an SVM machine learning model to classify audio into categories such as ambient sounds, birdsong, and music.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [How It Works](#how-it-works)
- [Dataset](#dataset)
- [Training the Model](#training-the-model)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)

## 🎯 Overview

The Audio Classifier is a full-stack application that demonstrates machine learning in action. It allows users to upload WAV audio files through an intuitive Flutter interface and receive instant predictions about the audio content using a pre-trained Support Vector Machine (SVM) model.

## ✨ Features

- **Easy-to-use Web Interface**: Built with Flutter, provides a clean and responsive UI for audio uploads
- **Real-time Predictions**: Get instant classification results for uploaded audio files
- **Multiple Audio Categories**: Classifies audio into categories including:
  - Ambient sounds
  - Birdsong
  - Music
- **Feature Extraction**: Uses MFCC (Mel-frequency cepstral coefficients) for advanced audio feature analysis
- **CORS Support**: API supports cross-origin requests for seamless frontend-backend integration
- **Model Persistence**: Trained model is saved and can be reused without retraining

## 🏗️ Architecture

The application follows a client-server architecture:

```
┌─────────────────────┐
│   Flutter UI        │
│  (Web Interface)    │
└──────────┬──────────┘
           │ HTTP Request
           │ (Multipart Form)
           ▼
┌─────────────────────┐
│   FastAPI Server    │
│  - File Upload      │
│  - Feature Extract  │
│  - ML Prediction    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   SVM ML Model      │
│  (audio_model.pkl)  │
└─────────────────────┘
```

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.10.7+**: Cross-platform UI framework
- **Dart**: Programming language
- **http Package**: HTTP client for API communication
- **file_picker**: File selection functionality

### Backend
- **FastAPI**: Modern Python web framework for building APIs
- **Python 3.8+**: Programming language
- **LibROSA**: Audio processing and feature extraction
- **Scikit-learn**: Machine learning (SVM model)
- **NumPy**: Numerical computing
- **Joblib**: Model serialization and persistence

## 📂 Project Structure

```
Audio-Classifier/
├── README.md
├── audio_classifier_app/           # Flutter Frontend
│   ├── lib/
│   │   └── main.dart              # Main Flutter app
│   ├── pubspec.yaml               # Flutter dependencies
│
└── backend/                        # Python Backend
    ├── main.py                    # FastAPI server
    ├── train_model.py             # Model training script
    ├── audio_model.pkl            # Trained SVM model (generated)
    └── dataset/                   # Training data
        ├── ambient/               # Ambient sound samples
        ├── birds/                 # Birdsong samples
        └── music/                 # Music samples
```

## 📦 Prerequisites

### System Requirements
- Flutter SDK 3.10.7 or higher
- Python 3.8 or higher
- pip (Python package manager)
- Modern web browser (Chrome, Firefox, Edge, etc.)

### Required Python Packages
- fastapi>=0.104.0
- uvicorn>=0.24.0
- librosa>=0.10.0
- numpy>=1.20.0
- scikit-learn>=1.0.0
- joblib>=1.0.0
- python-multipart

## 🚀 Installation

### 1. Clone or Extract the Project
```bash
cd Audio-Classifier
```

### 2. Backend Setup

#### Install Python Dependencies
```bash
cd backend
pip install -r requirements.txt
```

Or install manually:
```bash
pip install fastapi uvicorn librosa numpy scikit-learn joblib python-multipart
```

#### Prepare Your Dataset (if training a new model)
Organize your audio files in the `dataset/` directory:
```
dataset/
├── ambient/
│   └── *.wav files
├── birds/
│   └── *.wav files
└── music/
    └── *.wav files
```

### 3. Frontend Setup

#### Install Flutter Dependencies
```bash
cd audio_classifier_app
flutter pub get
```

## ▶️ Running the Project

The application requires both backend and frontend to be running simultaneously.

### Step 1: Train the Model (First Time Only)
```bash
cd backend
python train_model.py
```
This generates `audio_model.pkl` from your training dataset.

### Step 2: Start the Backend Server
```bash
cd backend
uvicorn main:app --reload
```
The API server will start at `http://127.0.0.1:8000`

### Step 3: Start the Frontend Application
In a new terminal:
```bash
cd audio_classifier_app
flutter run -d chrome
```
The Flutter app will open in your default web browser at `http://localhost:XXXX`

### Alternative: Run Multiple Terminals
Open three separate terminal windows:

**Terminal 1 - Backend Server:**
```bash
cd backend
uvicorn main:app --reload
```

**Terminal 2 - Frontend App:**
```bash
cd audio_classifier_app
flutter run -d chrome
```

## 🔬 How It Works

### 1. Audio Feature Extraction
When an audio file is uploaded, the system:
- Loads the WAV file using LibROSA
- Limits the audio duration to the first 3 seconds
- Extracts MFCC (Mel-frequency cepstral coefficients) features with 40 coefficients
- Computes the mean of the MFCC features to create a 40-dimensional feature vector

### 2. ML Classification
The trained SVM model:
- Receives the extracted feature vector
- Uses a linear kernel for classification
- Predicts which category the audio belongs to
- Returns the prediction result to the frontend

### 3. User Feedback
The Flutter interface:
- Displays a loading indicator while processing
- Shows the prediction result
- Allows users to upload and classify multiple files
- Provides error handling for failed uploads

## 📊 Dataset

The training dataset should contain WAV audio files organized by category:

- **Ambient**: Environmental sounds (traffic, rain, wind, etc.)
- **Birds**: Birdsong and avian sounds
- **Music**: Musical recordings across various genres

Each category folder should contain representative audio samples to train the model effectively.

## 🧠 Training the Model

To train a new model with your dataset:

```bash
cd backend
python train_model.py
```

This script will:
1. Iterate through all audio files in the `dataset/` directory
2. Extract MFCC features from each file
3. Train an SVM classifier with a linear kernel
4. Save the trained model as `audio_model.pkl`

Training time depends on the number and duration of audio files in your dataset.

## 🔌 API Endpoints

### POST /predict
Upload an audio file for classification

**Request:**
- Method: `POST`
- URL: `http://127.0.0.1:8000/predict`
- Content-Type: `multipart/form-data`
- Parameter: `file` (WAV audio file)

**Response:**
```json
{
  "prediction": "ambient"
}
```

**Example cURL:**
```bash
curl -X POST -F "file=@audio.wav" http://127.0.0.1:8000/predict
```

## 🤝 Contributing

Contributions, improvements, and suggestions are welcome! Feel free to:
- Report issues or bugs
- Suggest new features
- Improve documentation
- Add more audio categories
- Optimize the ML model

## 📄 License

This project is provided as-is for educational and research purposes.