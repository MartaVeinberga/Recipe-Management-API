# Recipe Management API

A comprehensive FastAPI-based REST API for managing cooking recipes with CRUD operations,
authentication, search, statistics, and Docker support.

---

## Features

- CRUD operations for recipes
- Batch recipe creation
- Recipe search, filters, and statistics
- JWT authentication for users
- API key authentication for admin endpoints
- PostgreSQL database
- Docker & Docker Compose
- Swagger UI documentation

---

## Requirements

- Docker Desktop

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/MartaVeinberga/Recipe-Management-API.git
cd recipe-api
```

### 2. Environment variables

An example environment file is provided.

```bash
cp .env.example .env
```

Edit `.env` and update secrets as needed.

### 3. Run the application

```bash
docker-compose up --build
```

### 4. Access the API

- Swagger UI: http://localhost:8000/docs
- API root: http://localhost:8000

---

## Project Structure

```text
recipe-api/
├── app/
│   ├── __init__.py
│   ├── main.py          # API endpoints
│   ├── database.py      # PostgreSQL configuration
│   ├── models.py        # SQLAlchemy models
│   ├── schemas.py       # Pydantic schemas
│   ├── crud.py          # Database operations
│   ├── auth.py          # Authentication
│   └── init_data.py     # Sample data
├── recipes/
│   └── test_recipes.py  # Tests
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example
├── .env
└── README.md
```

---

## Authentication

### JWT Authentication (Users)

- Register: `POST /auth/register`
- Login: `POST /auth/login`
- Use token in requests:

```text
Authorization: Bearer <your_token>
```

### API Key Authentication (Admin)

```text
X-API-Key: your-api-key
```

---

## API Endpoints

### Public Endpoints

| Method | Endpoint | Description |
|------|---------|-------------|
| GET | `/` | Welcome message |
| GET | `/health` | Health check |
| GET | `/recipes` | List recipes |
| GET | `/recipes/{id}` | Get recipe by ID |
| GET | `/recipes/search` | Search recipes |
| GET | `/recipes/cuisine/{cuisine}` | Filter by cuisine |
| GET | `/recipes/stats` | Recipe statistics |
| POST | `/auth/register` | Register user |
| POST | `/auth/login` | Login |
| POST | `/recipes/shopping-list` | Generate shopping list |

### Authenticated Endpoints (JWT)

| Method | Endpoint | Description |
|------|---------|-------------|
| POST | `/recipes` | Create recipe |
| POST | `/recipes/batch` | Create multiple recipes |
| PUT | `/recipes/{id}` | Update recipe |
| DELETE | `/recipes/{id}` | Delete recipe |

### Admin Endpoints (API Key)

| Method | Endpoint | Description |
|------|---------|-------------|
| GET | `/recipes/admin/all` | Get all recipes |

---

## Example Requests

### Register User

```bash
curl -X POST http://localhost:8000/auth/register \
-H "Content-Type: application/json" \
-d '{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securepass123"
}'
```

### Login

```bash
curl -X POST http://localhost:8000/auth/login \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=john_doe&password=securepass123"
```

### Create Recipe (JWT required)

```bash
curl -X POST http://localhost:8000/recipes \
-H "Authorization: Bearer YOUR_TOKEN" \
-H "Content-Type: application/json" \
-d '{
  "title": "Pasta Carbonara",
  "ingredients": "pasta, eggs, bacon, cheese",
  "instructions": "Cook pasta and mix with sauce",
  "prep_time": 10,
  "cook_time": 20,
  "servings": 4,
  "cuisine": "Italian",
  "difficulty": "Medium"
}'
```

---

## Environment Variables (.env)

```env
# PostgreSQL credentials
POSTGRES_USER=recipeuser
POSTGRES_PASSWORD=recipepass123
POSTGRES_DB=recipedb
POSTGRES_HOST=db
POSTGRES_PORT=5432

# JWT Secret Key
SECRET_KEY="your-jwt-secret-key-67890"

#Api key
API_KEY="your-secret-api-key-12345"
```

---

## Testing

Tests are located in:

```text
recipes/test_recipes.py
```

They cover:
- CRUD operations
- Authentication
- Batch creation
- Search and filters
- Error handling
- Statistics

---

### Database issues

```bash
docker ps
docker logs recipe_database
```

---

## License

MIT

