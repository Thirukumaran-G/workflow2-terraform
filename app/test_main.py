import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

# ── Test 1: Root endpoint ────────────────────────────────────
def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()

# ── Test 2: Health endpoint ──────────────────────────────────
def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "version" in data
    assert "environment" in data

# ── Test 3: Get all items ────────────────────────────────────
def test_get_items():
    response = client.get("/items")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0

# ── Test 4: Get item by ID ───────────────────────────────────
def test_get_item_found():
    response = client.get("/items/1")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 1
    assert "name" in data
    assert "description" in data

# ── Test 5: Get item not found ───────────────────────────────
def test_get_item_not_found():
    response = client.get("/items/999")
    assert response.status_code == 404
    assert "detail" in response.json()

# ── Test 6: Create item ──────────────────────────────────────
def test_create_item():
    new_item = {
        "id": 99,
        "name": "test-item",
        "description": "test description"
    }
    response = client.post("/items", json=new_item)
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 99
    assert data["name"] == "test-item"

# ── Test 7: Create duplicate item ────────────────────────────
def test_create_duplicate_item():
    duplicate = {
        "id": 1,
        "name": "duplicate",
        "description": "this already exists"
    }
    response = client.post("/items", json=duplicate)
    assert response.status_code == 400
    assert "detail" in response.json()