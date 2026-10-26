from fastapi.testclient import TestClient
import sys
from pathlib import Path

parent_dir = Path(__file__).parent.parent
sys.path.append(parent_dir)
from main import app

client = TestClient(app)

class TestHealth:

    def health(self):
        return client.get("/health")

    def test_health(self):
        response = self.health()
        assert response.status_code == 200
        resultat = response.json()
        assert resultat["status"] == "ok"
        assert "version" in resultat