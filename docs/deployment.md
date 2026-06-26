# MoveTrack Deployment Guide

This guide covers deploying MoveTrack to various environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development](#local-development)
3. [Docker Deployment](#docker-deployment)
4. [AWS Deployment](#aws-deployment)
5. [Environment Variables](#environment-variables)
6. [CI/CD Setup](#cicd-setup)

## Prerequisites

- Node.js 18+ and npm 9+
- PostgreSQL 14+
- Redis 7+
- Docker & Docker Compose
- Git

## Local Development

### 1. Clone Repository

```bash
git clone https://github.com/rithvik4/MoveTrack.git
cd MoveTrack
```

### 2. Setup Backend

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

### 3. Setup Frontend

```bash
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your configuration
npm run dev
```

### 4. Setup Database

```bash
# Install PostgreSQL and create database
psql -U postgres
CREATE DATABASE movetrack;
\q

# Run schema
psql -U postgres -d movetrack -f database/schema.sql
```

### 5. Access Applications

- Frontend: http://localhost:3001
- Backend API: http://localhost:3000
- API Health: http://localhost:3000/health

## Docker Deployment

### Quick Start

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Services

- PostgreSQL: localhost:5432
- Redis: localhost:6379
- Backend API: http://localhost:3000
- Frontend: http://localhost:3001
- Admin Panel: http://localhost:3002

### Database Migration

```bash
# Schema is automatically loaded on first run
# For subsequent migrations:
docker-compose exec postgres psql -U postgres -d movetrack -f /docker-entrypoint-initdb.d/01-schema.sql
```

## AWS Deployment

### 1. Infrastructure Setup

Use AWS CDK or Terraform to provision:

- ECS/EKS for container orchestration
- RDS PostgreSQL for database
- ElastiCache Redis for caching
- S3 for file storage
- CloudFront for CDN
- Route53 for DNS

### 2. Backend Deployment (ECS)

```bash
# Build and push Docker image
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com

docker build -t movetrack-backend ./backend
docker tag movetrack-backend:latest <account>.dkr.ecr.us-east-1.amazonaws.com/movetrack-backend:latest
docker push <account>.dkr.ecr.us-east-1.amazonaws.com/movetrack-backend:latest
```

### 3. Frontend Deployment (Vercel/Netlify)

#### Vercel

```bash
cd frontend
vercel --prod
```

#### Netlify

```bash
cd frontend
netlify deploy --prod
```

### 4. Database (RDS)

```bash
# Create RDS instance
aws rds create-db-instance \
  --db-instance-identifier movetrack-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username postgres \
  --master-user-password <password> \
  --allocated-storage 20
```

## Environment Variables

### Backend (.env)

```env
# Server
NODE_ENV=production
PORT=3000

# Database
DB_HOST=<db-host>
DB_PORT=5432
DB_NAME=movetrack
DB_USER=<db-user>
DB_PASSWORD=<db-password>

# JWT
JWT_SECRET=<secure-secret>
JWT_EXPIRES_IN=7d

# Firebase
FIREBASE_PROJECT_ID=<project-id>
FIREBASE_PRIVATE_KEY=<private-key>
FIREBASE_CLIENT_EMAIL=<client-email>

# AWS S3
AWS_ACCESS_KEY_ID=<access-key>
AWS_SECRET_ACCESS_KEY=<secret-key>
AWS_REGION=us-east-1
AWS_S3_BUCKET=<bucket-name>

# Google Maps
GOOGLE_MAPS_API_KEY=<api-key>

# Payments
RAZORPAY_KEY_ID=<key-id>
RAZORPAY_KEY_SECRET=<key-secret>
STRIPE_SECRET_KEY=<secret-key>

# OpenAI
OPENAI_API_KEY=<api-key>

# Redis
REDIS_HOST=<redis-host>
REDIS_PORT=6379
```

### Frontend (.env.local)

```env
NEXT_PUBLIC_API_URL=https://api.movetrack.com/api/v1
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=<api-key>
NEXT_PUBLIC_FIREBASE_API_KEY=<firebase-key>
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=<auth-domain>
NEXT_PUBLIC_FIREBASE_PROJECT_ID=<project-id>
```

## CI/CD Setup

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy MoveTrack

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm ci
      - run: npm run lint
      - run: npm run test

  deploy-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: <account>.dkr.ecr.us-east-1.amazonaws.com/movetrack-backend:${{ github.sha }}

  deploy-frontend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: cd frontend && npm ci && npm run build
      - uses: vercel/action@v1
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

## Production Checklist

- [ ] Set strong JWT secrets
- [ ] Enable HTTPS
- [ ] Configure CORS properly
- [ ] Set up monitoring (CloudWatch, Sentry)
- [ ] Configure backup strategy
- [ ] Enable rate limiting
- [ ] Set up logging
- [ ] Configure CDN
- [ ] Enable database encryption
- [ ] Set up health checks
- [ ] Configure auto-scaling
- [ ] Enable DDoS protection

## Monitoring

### Health Checks

```bash
# Backend
curl https://api.movetrack.com/health

# Frontend
curl https://movetrack.com
```

### Logs

```bash
# Docker logs
docker-compose logs -f backend
docker-compose logs -f frontend

# AWS CloudWatch
aws logs tail /ecs/movetrack-backend --follow
```

## Backup Strategy

### Database Backups

```bash
# Automated daily backups
pg_dump -h <host> -U postgres movetrack > backup_$(date +%Y%m%d).sql

# Restore
psql -h <host> -U postgres -d movetrack < backup_20240101.sql
```

### S3 Backups

Enable versioning and lifecycle policies for S3 buckets.

## Security

- Use HTTPS everywhere
- Enable security headers (Helmet.js)
- Implement rate limiting
- Use parameterized queries
- Sanitize user inputs
- Regular security audits
- Keep dependencies updated

## Performance Optimization

- Enable Redis caching
- Use CDN for static assets
- Optimize database queries
- Enable gzip compression
- Use image optimization
- Implement lazy loading
- Monitor with APM tools

## Troubleshooting

### Common Issues

1. **Database connection failed**
   - Check DB_HOST and credentials
   - Verify security groups/firewall

2. **CORS errors**
   - Update CORS_ORIGIN in backend .env
   - Check API URL in frontend

3. **File upload fails**
   - Check S3 configuration
   - Verify file size limits

4. **Slow performance**
   - Enable Redis cache
   - Check database indexes
   - Monitor API response times

## Support

For issues and questions:
- GitHub Issues: https://github.com/rithvik4/MoveTrack/issues
- Email: support@movetrack.com