# Ask Polestar Influence System

A FastAPI-based backend services system with multi-agent orchestration, task management, real-time data processing, and AI-powered digital presence automation.

## Overview

This repository contains the influence and authority building system component of the Ask Polestar ecosystem, separated from the public website for enhanced security and modularity.

## Features

- **Multi-Agent Architecture**: Distributed agent systems for task orchestration
- **Real-time Processing**: Celery task queue with Redis message broker
- **API Management**: FastAPI with automatic OpenAPI documentation
- **Data Processing**: Advanced analytics and data transformation
- **Security**: Cryptographic security and authentication systems
- **Monitoring**: Comprehensive logging and system monitoring

## Technology Stack

- **Web Framework**: FastAPI (high-performance async API)
- **Task Queue**: Celery with Redis
- **Database**: SQLAlchemy ORM with PostgreSQL/SQLite
- **Security**: Cryptography, JWT authentication
- **Testing**: Pytest with comprehensive test coverage
- **Logging**: Loguru advanced logging
- **Monitoring**: Prometheus metrics and health checks

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/coltak88/ask-polestar-influence-system.git
   cd ask-polestar-influence-system
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Run the application**
   ```bash
   # Start Redis (required for Celery)
   redis-server
   
   # Start Celery worker
   celery -A src.core.celery_app worker --loglevel=info
   
   # Start FastAPI application
   uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
   ```

## Project Structure

```
ask-polestar-influence-system/
├── src/                       # Core source code
│   ├── api/                  # API endpoints and routes
│   ├── core/                 # Core application logic
│   ├── database/             # Database models and connections
│   ├── middleware/           # FastAPI middleware components
│   ├── services/             # Business logic services
│   ├── utils/                # Utility functions
│   └── main.py              # FastAPI application entry point
├── tests/                     # Test suite
├── docs/                      # Documentation
├── scripts/                   # Deployment and utility scripts
├── requirements.txt           # Python dependencies
├── .env.example              # Environment variables template
└── README.md                 # This file
```

## API Documentation

Once the application is running, you can access:

- **Interactive API Docs**: http://localhost:8000/docs
- **ReDoc Documentation**: http://localhost:8000/redoc
- **OpenAPI Schema**: http://localhost:8000/openapi.json

## Key Components

### Agent Management
- Multi-agent orchestration system
- Task distribution and load balancing
- Agent health monitoring and recovery

### Data Processing Pipeline
- Real-time data ingestion
- ETL processes with Celery
- Data validation and transformation

### Security Layer
- JWT-based authentication
- Role-based access control (RBAC)
- API rate limiting and throttling
- Cryptographic data protection

### Monitoring & Observability
- Health check endpoints
- Prometheus metrics collection
- Structured logging with Loguru
- Performance monitoring

## Contributing

Please read the contributing guidelines and ensure all tests pass before submitting pull requests.

## License

This project is part of the Rasa-X-Machina ecosystem.