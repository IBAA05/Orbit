from fastapi import FastAPI
from core.database import engine, Base
from controllers import item_controller

# Automatically build the database tables on startup.
# In a larger project, you would use Alembic for migrations instead.
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Orbit Backend API",
    description="Backend service for the Orbit app using FastAPI, SQLite, and an MVC structure.",
    version="1.0.0"
)

# Root endpoint
@app.get("/", tags=["root"])
def read_root():
    return {
        "message": "Welcome to the Orbit Backend API.", 
        "documentation": "Go to /docs for Swagger UI documentation."
    }

# Include controllers (routers)
app.include_router(item_controller.router)
