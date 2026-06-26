# MoveTrack API Documentation

Base URL: `http://localhost:3000/api/v1`

## Table of Contents

1. [Authentication](#authentication)
2. [Users](#users)
3. [Profile](#profile)
4. [Activities](#activities)
5. [Events](#events)
6. [Challenges](#challenges)
7. [Social](#social)
8. [Notifications](#notifications)
9. [Payments](#payments)
10. [Leaderboards](#leaderboards)
11. [AI Coach](#ai-coach)
12. [Admin](#admin)

## Authentication

All protected endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

### Register
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "fullName": "John Doe",
  "username": "johndoe"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "isVerified": false
    },
    "token": "jwt_token"
  }
}
```

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

### Google OAuth
```http
POST /auth/google
Content-Type: application/json

{
  "idToken": "google_id_token"
}
```

### Apple OAuth
```http
POST /auth/apple
Content-Type: application/json

{
  "identityToken": "apple_identity_token",
  "authorizationCode": "apple_auth_code"
}
```

### Phone OTP
```http
POST /auth/phone/send-otp
Content-Type: application/json

{
  "phone": "+919876543210"
}
```

```http
POST /auth/phone/verify-otp
Content-Type: application/json

{
  "phone": "+919876543210",
  "otp": "123456"
}
```

## Users

### Get All Users (Admin)
```http
GET /users?page=1&limit=20&search=john
Authorization: Bearer <token>
```

### Get User by ID
```http
GET /users/:id
Authorization: Bearer <token>
```

### Delete User (Admin)
```http
DELETE /users/:id
Authorization: Bearer <token>
```

### Search Users
```http
GET /users/search/:query
Authorization: Bearer <token>
```

## Profile

### Get My Profile
```http
GET /profile/me
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "userId": "uuid",
    "fullName": "John Doe",
    "username": "johndoe",
    "photoUrl": "https://...",
    "gender": "male",
    "height": 175,
    "weight": 70,
    "city": "Mumbai",
    "totalDistance": 125.5,
    "totalActivities": 42,
    "xpPoints": 2500,
    "level": 5
  }
}
```

### Get Profile by Username
```http
GET /profile/username/:username
```

### Update Profile
```http
PUT /profile/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "fullName": "John Doe",
  "bio": "Fitness enthusiast",
  "gender": "male",
  "height": 175,
  "weight": 70,
  "city": "Mumbai"
}
```

### Upload Profile Photo
```http
POST /profile/me/photo
Authorization: Bearer <token>
Content-Type: multipart/form-data

photo: <file>
```

### Get User Stats
```http
GET /profile/me/stats
Authorization: Bearer <token>
```

## Activities

### Get Activities
```http
GET /activities?page=1&limit=20&type=running&startDate=2024-01-01&endDate=2024-01-31
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "type": "running",
      "status": "completed",
      "startTime": "2024-01-15T06:30:00Z",
      "endTime": "2024-01-15T07:15:00Z",
      "duration": 2700,
      "distance": 5.2,
      "calories": 450,
      "averagePace": 8.5,
      "averageSpeed": 6.9,
      "elevationGain": 45,
      "route": {
        "coordinates": [...],
        "totalPoints": 120
      },
      "photos": ["https://..."],
      "likesCount": 12,
      "commentsCount": 3
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 42,
    "totalPages": 3
  }
}
```

### Get Activity by ID
```http
GET /activities/:id
Authorization: Bearer <token>
```

### Start Activity
```http
POST /activities/start
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "running"
}
```

### Update Activity (Live Tracking)
```http
PUT /activities/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "route": {
    "coordinates": [
      {
        "latitude": 19.0760,
        "longitude": 72.8777,
        "timestamp": "2024-01-15T06:30:00Z"
      }
    ],
    "totalPoints": 10
  },
  "distance": 2.5,
  "duration": 1200,
  "calories": 210
}
```

### Pause Activity
```http
POST /activities/:id/pause
Authorization: Bearer <token>
```

### Resume Activity
```http
POST /activities/:id/resume
Authorization: Bearer <token>
```

### Stop Activity
```http
POST /activities/:id/stop
Authorization: Bearer <token>
```

### Delete Activity
```http
DELETE /activities/:id
Authorization: Bearer <token>
```

### Upload Activity Photos
```http
POST /activities/:id/photos
Authorization: Bearer <token>
Content-Type: multipart/form-data

photos: [<files>]
```

### Update Activity Notes
```http
PUT /activities/:id/notes
Authorization: Bearer <token>
Content-Type: application/json

{
  "notes": "Great morning run! Felt energetic today."
}
```

### Get Activity Stats
```http
GET /activities/stats/summary
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalActivities": 42,
    "totalDistance": 125.5,
    "totalDuration": 10800,
    "totalCalories": 12500
  }
}
```

## Events

### Get All Events
```http
GET /events?type=5k&category=running&upcoming=true
```

### Get Event by ID
```http
GET /events/:id
```

### Get Events by Type
```http
GET /events/type/:type
```

### Register for Event
```http
POST /events/register/:eventId
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "message": "Registered for event successfully",
  "data": {
    "id": "uuid",
    "eventId": "uuid",
    "userId": "uuid",
    "registrationNumber": "EVT-1705312800-ABC123XYZ",
    "status": "pending",
    "paymentStatus": "pending"
  }
}
```

### Get My Registrations
```http
GET /events/my-registrations
Authorization: Bearer <token>
```

### Submit Activity for Event
```http
POST /events/:eventId/submit-activity
Authorization: Bearer <token>
Content-Type: application/json

{
  "activityId": "uuid"
}
```

### Get Event Leaderboard
```http
GET /events/:eventId/leaderboard
```

### Create Event (Admin)
```http
POST /events
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Summer 5K Run",
  "description": "Join our annual summer run",
  "type": "5k",
  "category": "running",
  "startDate": "2024-06-01T06:00:00Z",
  "endDate": "2024-06-01T10:00:00Z",
  "registrationStartDate": "2024-05-01T00:00:00Z",
  "registrationEndDate": "2024-05-31T23:59:59Z",
  "registrationFee": 10,
  "currency": "USD",
  "participantLimit": 500
}
```

## Challenges

### Get All Challenges
```http
GET /challenges?type=daily&active=true
```

### Get Challenge by ID
```http
GET /challenges/:id
```

### Join Challenge
```http
POST /challenges/:id/join
Authorization: Bearer <token>
```

### Get My Challenges
```http
GET /challenges/my-challenges
Authorization: Bearer <token>
```

### Get Challenge Progress
```http
GET /challenges/:id/progress
Authorization: Bearer <token>
```

### Update Progress
```http
PUT /challenges/:id/progress
Authorization: Bearer <token>
Content-Type: application/json

{
  "currentValue": 7.5
}
```

## Social

### Send Friend Request
```http
POST /social/friends/request/:userId
Authorization: Bearer <token>
```

### Accept Friend Request
```http
PUT /social/friends/accept/:requestId
Authorization: Bearer <token>
```

### Get Friends
```http
GET /social/friends
Authorization: Bearer <token>
```

### Create Group
```http
POST /social/groups
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Morning Runners",
  "description": "Early morning running group",
  "isPublic": true
}
```

### Like Activity
```http
POST /social/activities/:activityId/like
Authorization: Bearer <token>
```

### Comment on Activity
```http
POST /social/activities/:activityId/comment
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Great run! 🏃‍♂️"
}
```

### Get Activity Feed
```http
GET /social/feed
Authorization: Bearer <token>
```

## Notifications

### Get Notifications
```http
GET /notifications?page=1&limit=20
Authorization: Bearer <token>
```

### Get Unread Count
```http
GET /notifications/unread/count
Authorization: Bearer <token>
```

### Mark as Read
```http
PUT /notifications/:id/read
Authorization: Bearer <token>
```

### Mark All as Read
```http
PUT /notifications/read-all
Authorization: Bearer <token>
```

## Payments

### Create Order
```http
POST /payments/create-order
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "event_registration",
  "amount": 10,
  "currency": "USD",
  "eventId": "uuid"
}
```

### Verify Payment
```http
POST /payments/verify
Authorization: Bearer <token>
Content-Type: application/json

{
  "orderId": "order_uuid",
  "paymentId": "razorpay_payment_id",
  "signature": "razorpay_signature"
}
```

### Get Payment History
```http
GET /payments/history
Authorization: Bearer <token>
```

## Leaderboards

### Global Leaderboard
```http
GET /leaderboards/global?period=week
```

### Country Leaderboard
```http
GET /leaderboards/country/:country?period=month
```

### City Leaderboard
```http
GET /leaderboards/city/:city?period=week
```

### Friends Leaderboard
```http
GET /leaderboards/friends?period=month
Authorization: Bearer <token>
```

### Event Leaderboard
```http
GET /leaderboards/event/:eventId
```

### My Rank
```http
GET /leaderboards/my-rank?period=week
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "rank": 42,
    "value": 125.5,
    "unit": "km",
    "totalParticipants": 1250
  }
}
```

## AI Coach

### Get Recommendations
```http
POST /ai/coach/recommendations
Authorization: Bearer <token>
Content-Type: application/json

{
  "goal": "improve_pace",
  "currentLevel": "intermediate"
}
```

### Generate Training Plan
```http
POST /ai/coach/training-plan
Authorization: Bearer <token>
Content-Type: application/json

{
  "targetDistance": 10,
  "targetDate": "2024-06-01",
  "currentAbility": "5k in 30 minutes"
}
```

### Get Pace Suggestion
```http
POST /ai/coach/pace-suggestion
Authorization: Bearer <token>
Content-Type: application/json

{
  "distance": 5,
  "terrain": "flat",
  "weather": "clear"
}
```

### Performance Analysis
```http
GET /ai/analysis/performance
Authorization: Bearer <token>
```

## Admin

### Get Dashboard
```http
GET /admin/dashboard
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalUsers": 12500,
    "activeUsers": 8500,
    "totalActivities": 45000,
    "totalEvents": 25,
    "revenue": 12500
  }
}
```

### Get All Users
```http
GET /admin/users?page=1&limit=20
Authorization: Bearer <token>
```

### Update User
```http
PUT /admin/users/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "isActive": true,
  "isVerified": true
}
```

### Create Event
```http
POST /admin/events
Authorization: Bearer <token>
```

### Send Push Notification
```http
POST /admin/notifications/send
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "New Challenge Available",
  "message": "Join our 30-day walking challenge!",
  "targetAudience": "all"
}
```

### Get User Report
```http
GET /admin/reports/users?startDate=2024-01-01&endDate=2024-01-31
Authorization: Bearer <token>
```

## Error Responses

All endpoints return errors in this format:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message (development only)",
  "errors": {
    "field": ["Error message"]
  }
}
```

### HTTP Status Codes

- `200 OK` - Request successful
- `201 Created` - Resource created
- `400 Bad Request` - Invalid input
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error

## Rate Limiting

- **Limit**: 100 requests per 15 minutes per IP
- **Headers**: 
  - `X-RateLimit-Limit`: 100
  - `X-RateLimit-Remaining`: 95
  - `X-RateLimit-Reset`: 1705312800

## Pagination

List endpoints support pagination:

```
GET /activities?page=2&limit=20
```

**Response includes:**
```json
{
  "pagination": {
    "page": 2,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

## Webhooks

### Razorpay Webhook
```http
POST /payments/webhook/razorpay
X-Razorpay-Signature: <signature>
```

### Stripe Webhook
```http
POST /payments/webhook/stripe
Stripe-Signature: <signature>
```

## Testing

Use the following test credentials:

```
Email: test@example.com
Password: TestPass123!
```

## SDKs

### JavaScript/TypeScript
```typescript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
});

// Add token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Flutter
```dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api/v1',
  ));
  
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}