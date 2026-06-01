from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os

app = FastAPI(
    title="GCP FastAPI App",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Models ───────────────────────────────────────────────────
class Item(BaseModel):
    id: int
    name: str
    description: str

class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str

# ── In memory store ──────────────────────────────────────────
items_db: List[Item] = [
    Item(id=1, name="item-one",   description="First item"),
    Item(id=2, name="item-two",   description="Second item"),
    Item(id=3, name="item-three", description="Third item"),
]

# ── Endpoint 1: Health ───────────────────────────────────────



@app.get("/health", response_model=HealthResponse)
def health():
    return HealthResponse(
        status="healthy",
        version=os.getenv("APP_VERSION", "1.0.0"),
        environment=os.getenv("ENVIRONMENT", "dev")
    )

# ── Endpoint 2: Root ─────────────────────────────────────────
@app.get("/")
def root():
    return {"message": "FastAPI on GCP Cloud Run", "docs": "/docs"}

# ── Endpoint 3: Get all items ────────────────────────────────
@app.get("/items", response_model=List[Item])
def get_items():
    return items_db

# ── Endpoint 4: Get item by ID ───────────────────────────────
@app.get("/items/{item_id}", response_model=Item)
def get_item(item_id: int):
    item = next((i for i in items_db if i.id == item_id), None)
    if not item:
        raise HTTPException(status_code=404, detail=f"Item {item_id} not found")
    return item

# ── Endpoint 5: Create item ──────────────────────────────────
@app.post("/items", response_model=Item)
def create_item(item: Item):
    if any(i.id == item.id for i in items_db):
        raise HTTPException(status_code=400, detail=f"Item {item.id} already exists")
    items_db.append(item)
    return item