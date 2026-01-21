# Recipe Management API

A comprehensive FastAPI-based REST API for managing cooking recipes with CRUD operations, batch processing, search capabilities, user authentication, and Docker containerization.

## Quick Start

### Prerequisites
- Docker Desktop installed

### Run the Application
```bash
# Start all services
docker-compose up --build

# Access the API
# Swagger UI: http://localhost:8000/docs
# API Root: http://localhost:8000
```

## Project Structure
```
recipe-api/
├── app/
│   ├── __init__.py
│   ├── main.py          # API endpoints
│   ├── database.py      # PostgreSQL configuration
│   ├── models.py        # SQLAlchemy models
│   ├── schemas.py       # Pydantic validation schemas
│   ├── crud.py          # Database operations
│   ├── auth.py          # JWT authentication
│   ├── init_data.py     # Sample data initialization
│   └── __pycache__/
├── recipes/
│   └── test_recipes.py  # Test client
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── .env                 # Configuration (API_KEY, SECRET_KEY)
├── initial_recipes.py
└── README.md
```

## Authentication

The API supports two authentication methods:

### 1. JWT Bearer Tokens (For User Operations)
Protected endpoints require a Bearer token:
```bash
# Register new user
POST /auth/register
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securepass123"
}

# Login and get token
POST /auth/login
{
  "username": "john_doe",
  "password": "securepass123"
}
# Returns: {"access_token": "eyJ...", "token_type": "bearer"}

# Use token in requests
Authorization: Bearer eyJ...
```

### 2. API Key (For Admin Operations)
```bash
X-API-Key: your-secret-api-key-12345
```

## API Endpoints

### Public Endpoints (No Authentication)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API welcome message |
| GET | `/health` | Health check |
| GET | `/recipes/` | List recipes (paginated) |
| GET | `/recipes/{id}` | Get recipe by ID |
| GET | `/recipes/stats` | Recipe statistics |
| GET | `/recipes/search/` | Search recipes by title/description |
| GET | `/recipes/cuisine/{cuisine}` | Filter recipes by cuisine |
| POST | `/auth/register` | Register new user |
| POST | `/auth/login` | Login and get token |
| GET | `/auth/me` | Get current user info |
| POST | `/recipes/shopping-list` | Generate shopping list |

### Protected Endpoints (Bearer Token Required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/recipes/` | Create recipe |
| POST | `/recipes/batch` | Create multiple recipes |
| PUT | `/recipes/{id}` | Update recipe |
| DELETE | `/recipes/{id}` | Delete recipe |

### Admin Endpoints (API Key Required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/recipes/admin/all` | Get all recipes without pagination |

## Database Schema

**Users Table:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Recipes Table:**
```sql
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    prep_time INTEGER,
    cook_time INTEGER,
    servings INTEGER,
    cuisine VARCHAR(100),
    difficulty VARCHAR(50)
);
```

## Configuration (.env)

```env
# PostgreSQL Configuration
POSTGRES_USER=recipeuser
POSTGRES_PASSWORD=recipepass123
POSTGRES_DB=recipedb
POSTGRES_HOST=db
POSTGRES_PORT=5432

# JWT Secret Key (change in production!)
SECRET_KEY="your-super-secret-jwt-key-change-this-in-production"

# API Key for admin endpoints
API_KEY="your-secret-api-key-12345"
```

## Security Features

- **JWT Bearer Tokens**: Secure token-based authentication for user operations
- **API Key Authentication**: Additional security layer for admin endpoints
- **Argon2 Password Hashing**: Industry-standard password hashing (no length limitations)
- **Environment Variables**: Sensitive data stored in .env, never in code
- **Pydantic Validation**: Input validation for all endpoints
- **Custom Error Handling**: Secure error messages without exposing internals
- **SQL Injection Protection**: SQLAlchemy ORM prevents SQL injection

## Key Technologies

- **FastAPI** - Modern async Python web framework
- **PostgreSQL** - Reliable relational database
- **SQLAlchemy** - Python SQL toolkit and ORM
- **Pydantic** - Python data validation using type hints
- **Python-Jose** - JWT token handling
- **Passlib + Argon2** - Secure password hashing
- **Docker & Docker Compose** - Containerization
- **Uvicorn** - ASGI web server

## Example API Calls

### Register and Login
```bash
# Register
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepass123"
  }'

# Login
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=john_doe&password=securepass123"
```

### Create Recipe (requires Bearer token)
```bash
curl -X POST "http://localhost:8000/recipes/" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "Pasta Carbonara",
    "ingredients": "pasta, eggs, bacon, cheese",
    "instructions": "Boil pasta, cook bacon, mix with eggs and cheese",
    "prep_time": 10,
    "cook_time": 20,
    "servings": 4,
    "cuisine": "Italian",
    "difficulty": "Medium"
  }'
```

### Get All Recipes
```bash
curl "http://localhost:8000/recipes/?skip=0&limit=10"
```

### Search Recipes
```bash
curl "http://localhost:8000/recipes/search/?q=pasta"
```

### Generate Shopping List
```bash
curl -X POST "http://localhost:8000/recipes/shopping-list" \
  -H "Content-Type: application/json" \
  -d '{"recipe_ids": [1, 2, 3]}'
```

### Admin: Get All Recipes
```bash
curl "http://localhost:8000/recipes/admin/all" \
  -H "X-API-Key: your-secret-api-key-12345"
```

## Statistics Example
```json
{
  "total_recipes": 32,
  "by_cuisine": {
    "Italian": 5,
    "Mexican": 8,
    "Thai": 7,
    "Indian": 6,
    "Greek": 3,
    "British": 3
  },
  "by_difficulty": {
    "Easy": 10,
    "Medium": 15,
    "Hard": 7
  },
  "average_prep_time_minutes": 15.5,
  "average_cook_time_minutes": 22.3
}
```

## Troubleshooting

### Port Already in Use
```bash
# Change port in docker-compose.yml or kill process using port 8000
lsof -i :8000
kill -9 <PID>
```

### Database Connection Error
```bash
# Check if PostgreSQL container is running
docker ps

# View container logs
docker logs recipe_database
```

### Token Invalid
- Tokens expire after 30 minutes
- Re-login using `/auth/login` to get a new token
- Ensure token is in format: `Authorization: Bearer <token>`

## Test Coverage

The test client (`recipes/test_recipes.py`) validates:
- Single and batch creation
- Read operations (all, by ID, search, filter)
- Update operations
- Delete operations
- Authentication (success & failure)
- Error handling (404, 401, 422)
- Statistics calculation