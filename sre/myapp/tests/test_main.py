import random
import pytest
from main import app


def test_welcome():
    """Welcome page OK"""

    response = app.test_client().get('/')
    assert response.status_code == 200

def test_health():
    """Healthcheck OK"""

    response = app.test_client().get('/health')
    assert response.status_code == 200

def test_get_files():
    """Get int page"""
    random_int = random.randint(1, 529852)

    response = app.test_client().get('/123')#+str(random_int))
    assert response.status_code == 200

