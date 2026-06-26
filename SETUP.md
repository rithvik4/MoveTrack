# MoveTrack Setup Guide

Since Docker is not installed on your system, here's how to run MoveTrack manually.

## Prerequisites

- Node.js 18+ and npm 9+
- PostgreSQL 14+
- Redis 7+ (optional, for caching)

## Quick Start

### 1. Setup PostgreSQL Database

```bash
# Install PostgreSQL if not already installed
# Then create database and run schema

# Using psql command line
psql -U postgres
CREATE DATABASE movetrack;
\q

# Run the schema
psql -U postgres -d movetrack -f database/schema.sql
```

Or use pgAdmin/PostgreSQL GUI to:
1. Create database named "movetrack"
2. Open Query Tool
3. Copy and paste contents from `database/schema.sql`
4. Execute the query

### 2. Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Edit .env file with your database credentials
# Update these lines:
# DB_HOST=localhost
# DB_PORT=5432
# DB_NAME=movetrack
# DB_USER=postgres
# DB_PASSWORD=your_password

# Start backend server
npm run dev
```

The backend will run on http://localhost:3000

### 3. Setup Frontend

Open a new terminal window:

```bash
cd frontend

# Install dependencies
npm install

# Create environment file
cp .env.example .env.local

# Start frontend server
npm run dev
```

The frontend will run on http://localhost:5000

### 4. Access the Application

- **Frontend Website**: http://localhost:5000
- **Backend API**: http://localhost:3000
- **API Health Check**: http://localhost:3000/health
- **Admin Panel** (when created): http://localhost:3002

## Alternative: Run Without Database

If you want to test the frontend without setting up the backend:

```bash
cd frontend
npm install
npm run dev
```

The frontend will load but API calls will fail without the backend running.

## Troubleshooting

### Port Already in Use

If port 3000 or 5000 is already in use:

**Backend:**
```bash
# Edit backend/.env
PORT=3003
```

**Frontend:**
```bash
# Windows PowerShell
$env:PORT=5000; npm run dev
```

### Database Connection Issues

1. Verify PostgreSQL is running:
   ```bash
   # Windows
   Get-Service -Name postgresql*
   
   # Start PostgreSQL
   net start postgresql
   ```

2. Check credentials in `backend/.env`

3. Test connection:
   ```bash
   psql -U postgres -d movetrack
   ```

### Module Not Found Errors

```bash
# Clear cache and reinstall
cd backend
rm -rf node_modules package-lock.json
npm install

# Same for frontend
cd ../frontend
rm -rf node_modules package-lock.json
npm install
```

## Next Steps

1. **Configure Firebase** (for authentication):
   - Create project at https://console.firebase.google.com
   - Update Firebase credentials in `.env` files

2. **Configure Google Maps** (for maps):
   - Get API key from https://console.cloud.google.com
   - Add to `.env` files

3. **Setup Payment Gateways** (optional):
   - Razorpay: https://dashboard.razorpay.com
   - Stripe: https://dashboard.stripe.com

## Development Workflow

1. Start PostgreSQL service
2. Run backend in one terminal: `cd backend && npm run dev`
3. Run frontend in another terminal: `cd frontend && npm run dev`
4. Open http://localhost:5000 in browser

## Testing the API

Use the test credentials or register a new user:

```bash
# Register
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123!","fullName":"Test User","username":"testuser"}'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123!"}'
```

## Project Structure

```
MoveTrack/
├── backend/          # Node.js API server
├── frontend/         # Next.js website
├── mobile/           # Flutter mobile app
├── admin/            # Admin panel
├── database/         # SQL schemas
└── docs/             # Documentation
```

## Support

For issues:
- Check console logs for errors
- Verify all environment variables are set
- Ensure PostgreSQL is running
- Check that ports 3000 and 5000 are available