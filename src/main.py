from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from contextlib import asynccontextmanager
import uvicorn
from loguru import logger
import os
from typing import Dict, Any

# Import API routers
from src.api.agents import router as agents_router
from src.api.tasks import router as tasks_router
from src.api.analytics import router as analytics_router
from src.api.health import router as health_router

# Import core components
from src.core.config import settings
from src.core.security import verify_token
from src.database.connection import init_database

# Security scheme
security = HTTPBearer()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan management."""
    # Startup
    logger.info("Starting Ask Polestar Influence System...")
    await init_database()
    logger.info("Database initialized successfully")
    
    yield
    
    # Shutdown
    logger.info("Shutting down Ask Polestar Influence System...")

# Create FastAPI application
app = FastAPI(
    title="Ask Polestar Influence System",
    description="FastAPI-based backend services system with multi-agent orchestration",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    lifespan=lifespan
)

# Add middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=settings.ALLOWED_HOSTS
)

# Authentication dependency
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Verify JWT token and return user information."""
    try:
        payload = verify_token(credentials.credentials)
        return payload
    except Exception as e:
        logger.error(f"Authentication failed: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

# Include API routers
app.include_router(
    health_router,
    prefix="/api/v1/health",
    tags=["Health"]
)

app.include_router(
    agents_router,
    prefix="/api/v1/agents",
    tags=["Agents"],
    dependencies=[Depends(get_current_user)]
)

app.include_router(
    tasks_router,
    prefix="/api/v1/tasks",
    tags=["Tasks"],
    dependencies=[Depends(get_current_user)]
)

app.include_router(
    analytics_router,
    prefix="/api/v1/analytics",
    tags=["Analytics"],
    dependencies=[Depends(get_current_user)]
)

@app.get("/", response_model=Dict[str, Any])
async def root():
    """Root endpoint with system information."""
    return {
        "message": "Ask Polestar Influence System API",
        "version": "1.0.0",
        "status": "operational",
        "docs": "/docs",
        "redoc": "/redoc"
    }

@app.get("/api/v1/info", response_model=Dict[str, Any])
async def system_info():
    """Get system information and status."""
    return {
        "system": "Ask Polestar Influence System",
        "version": "1.0.0",
        "environment": settings.ENVIRONMENT,
        "features": [
            "Multi-Agent Orchestration",
            "Real-time Task Processing",
            "Advanced Analytics",
            "Secure API Management",
            "Comprehensive Monitoring"
        ]
    }

if __name__ == "__main__":
    uvicorn.run(
        "src.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )