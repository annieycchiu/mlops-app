from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd
from google.cloud import storage
import os
import uvicorn

# Load the pipeline
preprocessor = joblib.load('preprocessor.pkl')
model = joblib.load('gaming_clf.pkl')

# Define the input data model
class PlayerData(BaseModel):
    Age: float
    PlayTimeHours: float
    SessionsPerWeek: float
    AvgSessionDurationMinutes: float
    PlayerLevel: float
    AchievementsUnlocked: float
    Gender: str
    Location: str
    GameGenre: str
    InGamePurchases: str
    GameDifficulty: str

class CalculationRequest(BaseModel):
    num1: float
    num2: float
    operation: str


# Initialize the FastAPI app
app = FastAPI()

@app.post("/predict")
def predict(data: PlayerData):
    # Convert input data to DataFrame
    data_df = pd.DataFrame([data.dict()])

    # Proprocess input data
    preprocessed_data_df = preprocessor.transform(data_df)
    
    # Make predictions
    try:
        prediction = model.predict(preprocessed_data_df)
        return {"prediction": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/calculate")
def calculate(request: CalculationRequest):
    num1 = request.num1
    num2 = request.num2
    operation = request.operation

    if operation == "add":
        result = num1 + num2
    elif operation == "subtract":
        result = num1 - num2
    elif operation == "multiply":
        result = num1 * num2
    elif operation == "divide":
        if num2 == 0:
            raise HTTPException(status_code=400, detail="Division by zero is not allowed")
        result = num1 / num2
    else:
        raise HTTPException(status_code=400, detail="Invalid operation")

    return {"result": result}