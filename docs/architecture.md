# MoveTrack System Architecture

## Overview

MoveTrack is a modern, scalable fitness platform built with a microservices-oriented architecture, designed to handle millions of users tracking their walking and running activities.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Client Layer                         │
├──────────────┬──────────────┬───────────────────────────────┤
│   Flutter    │   Next.js    │      Admin Panel              │
│   Mobile     │   Website    │      (Next.js)                │
│     App      │              │                               │
└──────┬───────┴──────┬───────┴───────────────┬───────────────┘
       │              │                       │
       └──────────────┼───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                      API Gateway Layer                        │
│                   (Express.js Server)                         │
├──────────────┬──────────────┬───────────────────────────────┤
│   Auth       │   Rate       │      Middleware                │
│   Middleware │   Limiter    │      (CORS, Helmet, etc.)      │
└──────┬───────┴──────┬───────┴───────────────┬───────────────┘
       │              │                       │
       ▼              ▼                       ▼
┌──────────────┐ ┌──────────────┐   ┌──────────────────────┐
│  Controllers │ │  Services    │   │   WebSocket Server   │
│  (Route      │ │  (Business   │   │   (Socket.io)        │
│   Handlers)  │ │   Logic)     │   │   Real-time Updates) │
└──────┬───────┘ └──────┬───────┘   └──────────────────────┘
       │                │
       ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                               │
├──────────────┬──────────────┬───────────────────────────────┤
│  PostgreSQL  │    Redis     │         AWS S3                 │
│  (Primary    │   (Cache &   │      (File Storage)            │
│   Database)  │   Sessions)  │                               │
└──────────────┴──────────────┴───────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                   External Services                           │
├──────────────┬──────────────┬───────────────────────────────┤
│   Firebase   │   Google     │   Payment Gateways             │
│   (Auth &    │   Maps API   │   (Razorpay/Stripe)            │
│   FCM)       │              │                                 │
├──────────────┼──────────────┼───────────────────────────────┤
│   OpenAI     │   Health     │   Twilio                        │
│   (AI Coach) │   APIs       │   (SMS/OTP)                     │
└──────────────┴──────────────┴───────────────────────────────┘
```

## Technology Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: Zustand + React Query
- **Forms**: React Hook Form + Zod
- **Animations**: Framer Motion
- **Maps**: React Map GL (Mapbox)
- **Charts**: Recharts
- **Authentication**: NextAuth.js + Firebase

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Language**: TypeScript
- **ORM**: pg (PostgreSQL client)
- **Authentication**: JWT + Firebase Admin
- **Real-time**: Socket.io
- **Validation**: Joi
- **Logging**: Winston

### Mobile
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Maps**: Google Maps Flutter
- **Location**: Geolocator
- **Storage**: Hive + Shared Preferences
- **Authentication**: Firebase Auth

### Database
- **Primary**: PostgreSQL 15+ (with PostGIS)
- **Cache**: Redis 7+
- **Extensions**: uuid-ossp, PostGIS

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **Cloud**: AWS (ECS/RDS/S3/CloudFront)
- **CDN**: CloudFront
- **Monitoring**: CloudWatch
- **File Storage**: AWS S3

## Database Architecture

### Core Tables

```
users (authentication)
  └─> profiles (user data & stats)
  └─> refresh_tokens (JWT management)

activities (GPS tracking data)
  └─> likes
  └─> comments

events (virtual events)
  └─> event_registrations
  └─> certificates

challenges
  └─> challenge_progress

achievements
  └─> user_achievements

friendships (social connections)
groups
  └─> group_members

notifications
payments
```

### Key Database Features

- **UUID Primary Keys**: All tables use UUIDs for better scalability
- **JSONB Fields**: Flexible storage for complex data (routes, achievements)
- **PostGIS**: Geospatial queries for location-based features
- **Indexes**: Optimized for common query patterns
- **Triggers**: Automatic `updated_at` timestamp management
- **Views**: Pre-computed queries for leaderboards and activity feeds

## API Architecture

### RESTful Design

```
/api/v1
├── /auth
│   ├── POST   /register
│   ├── POST   /login
│   ├── POST   /refresh-token
│   ├── POST   /forgot-password
│   ├── POST   /reset-password
│   ├── GET    /verify-email/:token
│   ├── POST   /google
│   ├── POST   /apple
│   └── POST   /phone/send-otp
│
├── /users
│   ├── GET    /
│   ├── GET    /:id
│   ├── DELETE /:id
│   └── GET    /search/:query
│
├── /profile
│   ├── GET    /me
│   ├── GET    /username/:username
│   ├── PUT    /me
│   ├── POST   /me/photo
│   ├── DELETE /me/photo
│   ├── GET    /me/stats
│   ├── PUT    /me/goals
│   └── PUT    /me/emergency-contact
│
├── /activities
│   ├── GET    /
│   ├── GET    /:id
│   ├── POST   /start
│   ├── PUT    /:id
│   ├── POST   /:id/pause
│   ├── POST   /:id/resume
│   ├── POST   /:id/stop
│   ├── DELETE /:id
│   ├── POST   /:id/photos
│   ├── PUT    /:id/notes
│   └── GET    /stats/summary
│
├── /events
│   ├── GET    /
│   ├── GET    /:id
│   ├── GET    /type/:type
│   ├── POST   /register/:eventId
│   ├── GET    /my-registrations
│   ├── POST   /:eventId/submit-activity
│   ├── GET    /:eventId/leaderboard
│   ├── POST   /
│   ├── PUT    /:id
│   └── DELETE /:id
│
├── /challenges
│   ├── GET    /
│   ├── GET    /:id
│   ├── POST   /:id/join
│   ├── GET    /my-challenges
│   ├── GET    /:id/progress
│   ├── PUT    /:id/progress
│   ├── POST   /
│   ├── PUT    /:id
│   └── DELETE /:id
│
├── /social
│   ├── POST   /friends/request/:userId
│   ├── PUT    /friends/accept/:requestId
│   ├── PUT    /friends/reject/:requestId
│   ├── GET    /friends
│   ├── GET    /friends/requests
│   ├── DELETE /friends/:friendId
│   ├── POST   /groups
│   ├── GET    /groups
│   ├── GET    /groups/:id
│   ├── PUT    /groups/:id
│   ├── DELETE /groups/:id
│   ├── POST   /groups/:id/join
│   ├── POST   /groups/:id/leave
│   ├── GET    /groups/:id/members
│   ├── POST   /activities/:activityId/like
│   ├── DELETE /activities/:activityId/like
│   ├── POST   /activities/:activityId/comment
│   ├── GET    /activities/:activityId/comments
│   └── GET    /feed
│
├── /notifications
│   ├── GET    /
│   ├── GET    /unread/count
│   ├── PUT    /:id/read
│   ├── PUT    /read-all
│   ├── DELETE /:id
│   └── DELETE /
│
├── /payments
│   ├── POST   /create-order
│   ├── POST   /verify
│   ├── GET    /history
│   ├── GET    /:id
│   ├── POST   /:id/refund
│   ├── POST   /webhook/razorpay
│   └── POST   /webhook/stripe
│
├── /leaderboards
│   ├── GET    /global
│   ├── GET    /country/:country
│   ├── GET    /state/:state
│   ├── GET    /city/:city
│   ├── GET    /friends
│   ├── GET    /event/:eventId
│   ├── GET    /challenge/:challengeId
│   └── GET    /my-rank
│
├── /ai
│   ├── POST   /coach/recommendations
│   ├── POST   /coach/training-plan
│   ├── POST   /coach/pace-suggestion
│   ├── POST   /coach/recovery
│   ├── POST   /coach/nutrition
│   ├── GET    /analysis/performance
│   ├── GET    /analysis/injury-prevention
│   ├── GET    /motivation/daily
│   └── GET    /motivation/quote
│
└── /admin
    ├── GET    /dashboard
    ├── GET    /users
    ├── PUT    /users/:id
    ├── DELETE /users/:id
    ├── POST   /events
    ├── PUT    /events/:id
    ├── DELETE /events/:id
    ├── POST   /challenges
    ├── PUT    /challenges/:id
    ├── DELETE /challenges/:id
    ├── GET    /payments
    ├── POST   /payments/:id/refund
    ├── GET    /certificates
    ├── POST   /certificates/:id/regenerate
    ├── POST   /notifications/send
    ├── GET    /reports/users
    ├── GET    /reports/activities
    └── GET    /reports/revenue
```

## Authentication Flow

```
┌──────────┐      ┌──────────┐      ┌──────────┐
│  Client  │      │  Backend │      │ Firebase │
└────┬─────┘      └────┬─────┘      └────┬─────┘
     │                 │                 │
     │  1. Login       │                 │
     │  (email/pass)   │                 │
     │────────────────>│                 │
     │                 │                 │
     │                 │  2. Verify      │
     │                 │────────────────>│
     │                 │                 │
     │                 │  3. User Data   │
     │                 │<────────────────│
     │                 │                 │
     │                 │  4. Create JWT  │
     │                 │                 │
     │  5. JWT Token   │                 │
     │<────────────────│                 │
     │                 │                 │
     │  6. API Request │                 │
     │  (with JWT)     │                 │
     │────────────────>│                 │
     │                 │                 │
     │                 │  7. Verify JWT  │
     │                 │  & Fetch User   │
     │                 │                 │
     │  8. Response    │                 │
     │<────────────────│                 │
     │                 │                 │
```

## Security Architecture

### Authentication & Authorization
- **JWT Tokens**: Access tokens (7d) + Refresh tokens (30d)
- **Firebase Auth**: Social login (Google, Apple)
- **Phone OTP**: Twilio integration
- **Password Hashing**: bcrypt (12 rounds)

### API Security
- **Rate Limiting**: 100 requests per 15 minutes per IP
- **CORS**: Configurable allowed origins
- **Helmet.js**: Security headers
- **Input Validation**: Joi schemas
- **SQL Injection Prevention**: Parameterized queries

### Data Security
- **Encryption at Rest**: PostgreSQL encryption
- **Encryption in Transit**: HTTPS/TLS
- **S3 Encryption**: Server-side encryption
- **Secrets Management**: Environment variables

## Scalability Considerations

### Horizontal Scaling
- **Stateless API**: No server-side sessions
- **Redis Session Store**: Shared session data
- **Load Balancer**: Multiple API instances
- **Database Replication**: Read replicas

### Caching Strategy
```
Request Flow:
Client → CDN → Redis → API → Database
              ↓         ↓
           Static    Dynamic
           Assets    Queries
```

### Database Optimization
- **Indexes**: On frequently queried columns
- **Connection Pooling**: 20 max connections
- **Query Optimization**: Views for common queries
- **Partitioning**: By date for large tables

## Real-time Features

### WebSocket Events
```javascript
// Activity tracking
activity:update
activity:pause
activity:resume
activity:stop

// Social features
friend:request
friend:accepted
activity:like
activity:comment

// Notifications
notification:new
achievement:unlocked
```

### Socket.io Integration
- **Namespaces**: `/activities`, `/social`, `/notifications`
- **Rooms**: User-specific, Event-specific, Group-specific
- **Authentication**: JWT handshake

## File Storage Architecture

### AWS S3 Structure
```
s3://movetrack-uploads/
├── profiles/
│   └── {userId}/
│       └── profile-photo.jpg
├── activities/
│   └── {activityId}/
│       ├── photo-1.jpg
│       └── photo-2.jpg
├── events/
│   └── {eventId}/
│       └── banner.jpg
└── certificates/
    └── {certificateId}.pdf
```

### Upload Flow
1. Client requests presigned URL
2. Backend generates S3 presigned URL
3. Client uploads directly to S3
4. S3 triggers Lambda (optional) for processing
5. Client confirms upload to backend

## AI/ML Integration

### OpenAI Integration
- **Training Plans**: GPT-4 for personalized plans
- **Nutrition Advice**: Context-aware suggestions
- **Motivation**: Dynamic motivational content
- **Performance Analysis**: Activity pattern recognition

### Future ML Features
- **Pace Prediction**: Based on historical data
- **Injury Prevention**: Risk factor analysis
- **Route Recommendations**: ML-based suggestions
- **Performance Insights**: Anomaly detection

## Monitoring & Observability

### Metrics
- **API Response Times**: P50, P95, P99
- **Error Rates**: 4xx, 5xx counts
- **Database Queries**: Slow query log
- **Cache Hit Rate**: Redis metrics
- **User Activity**: DAU, MAU, retention

### Logging
- **Structured Logging**: Winston + JSON format
- **Log Levels**: error, warn, info, debug
- **Log Aggregation**: CloudWatch Logs
- **Error Tracking**: Sentry integration

### Health Checks
```javascript
// Backend
GET /health
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z",
  "services": {
    "database": "connected",
    "redis": "connected",
    "s3": "connected"
  }
}
```

## Deployment Architecture

### Docker Compose (Development)
```yaml
services:
  - postgres:5432
  - redis:6379
  - backend:3000
  - frontend:3001
  - admin:3002
```

### Production (AWS)
```
Route53 (DNS)
    ↓
CloudFront (CDN)
    ↓
  ┌───┴───┐
  ↓       ↓
ALB      S3 (Frontend)
  ↓
ECS (Backend)
  ↓
  ├─> RDS (PostgreSQL)
  ├─> ElastiCache (Redis)
  └─> S3 (Files)
```

## Performance Targets

### API Performance
- **Response Time**: < 200ms (P95)
- **Throughput**: 1000 req/s
- **Availability**: 99.9%
- **Error Rate**: < 0.1%

### Database Performance
- **Query Time**: < 50ms (P95)
- **Connection Pool**: 20 max
- **Cache Hit Rate**: > 80%

### Frontend Performance
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Time to Interactive**: < 3.5s
- **Cumulative Layout Shift**: < 0.1

## Future Enhancements

### Phase 2
- [ ] GraphQL API layer
- [ ] Microservices split (Auth, Activities, Events)
- [ ] Kubernetes orchestration
- [ ] Advanced caching (CDN, Edge)
- [ ] Real-time analytics pipeline

### Phase 3
- [ ] Machine Learning pipeline
- [ ] Recommendation engine
- [ ] Predictive analytics
- [ ] Advanced security (WAF, DDoS protection)
- [ ] Multi-region deployment

## Conclusion

This architecture provides a solid foundation for a scalable, maintainable fitness platform. The modular design allows for independent scaling of components, while the comprehensive tech stack ensures modern UX and developer experience.