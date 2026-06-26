# MoveTrack - Modern Fitness Platform

A comprehensive walking and running platform with AI coaching, virtual events, and social features.

## 🏃 Features

- **GPS Activity Tracking** - Track walks/runs with live maps
- **Virtual Events** - 5K, 10K, Half Marathon, Marathon challenges
- **AI Coaching** - Personalized training plans and recommendations
- **Social Features** - Connect with friends, share activities
- **Leaderboards** - Compete globally, locally, and with friends
- **Achievements** - Badges, XP points, and levels
- **Health Integrations** - Google Fit, Apple Health, Fitbit
- **Premium Membership** - Advanced features and exclusive content

## 🛠 Tech Stack

### Frontend
- **Website**: Next.js 14 + TypeScript + Tailwind CSS
- **Mobile**: Flutter 3.x
- **Admin Panel**: Next.js + shadcn/ui

### Backend
- **API**: Node.js + Express.js
- **Database**: PostgreSQL
- **Authentication**: Firebase Auth + JWT
- **Storage**: AWS S3
- **Maps**: Google Maps API
- **Payments**: Razorpay + Stripe

## 📁 Project Structure

```
MoveTrack/
├── backend/                 # Node.js + Express API
│   ├── src/
│   │   ├── controllers/    # Route controllers
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   ├── middleware/     # Auth, validation, etc.
│   │   ├── services/       # Business logic
│   │   ├── utils/          # Helper functions
│   │   ├── config/         # Configuration files
│   │   └── types/          # TypeScript types
│   ├── tests/              # Unit tests
│   └── package.json
│
├── frontend/               # Next.js Website
│   ├── src/
│   │   ├── app/           # App router pages
│   │   ├── components/    # React components
│   │   ├── lib/           # Utilities, API client
│   │   ├── hooks/         # Custom hooks
│   │   ├── store/         # State management
│   │   └── types/         # TypeScript types
│   └── package.json
│
├── mobile/                 # Flutter App
│   ├── lib/
│   │   ├── screens/       # UI screens
│   │   ├── widgets/       # Reusable widgets
│   │   ├── services/      # API, GPS, etc.
│   │   ├── models/        # Data models
│   │   ├── providers/     # State management
│   │   └── utils/         # Helper functions
│   └── pubspec.yaml
│
├── admin/                  # Admin Panel
│   ├── src/
│   │   ├── app/           # Admin pages
│   │   ├── components/    # Admin components
│   │   └── lib/           # Utilities
│   └── package.json
│
├── database/               # Database scripts
│   ├── migrations/        # SQL migrations
│   ├── seeds/             # Seed data
│   └── schema.sql         # Database schema
│
└── docs/                   # Documentation
    ├── api.md             # API documentation
    ├── architecture.md    # System architecture
    └── deployment.md      # Deployment guide
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL 14+
- Flutter 3.x
- Firebase Account
- Google Maps API Key

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/rithvik4/MoveTrack.git
cd MoveTrack
```

2. **Setup Backend**
```bash
cd backend
npm install
cp .env.example .env
# Configure environment variables
npm run dev
```

3. **Setup Frontend**
```bash
cd frontend
npm install
cp .env.example .env
# Configure environment variables
npm run dev
```

4. **Setup Mobile**
```bash
cd mobile
flutter pub get
flutter run
```

5. **Setup Database**
```bash
cd database
psql -U postgres -f schema.sql
```

## 📊 Database Schema

### Core Tables
- users
- profiles
- activities
- events
- challenges
- achievements
- friendships
- groups
- notifications
- payments
- certificates
- leaderboards

## 🔐 Authentication

- Email/Password
- Google OAuth
- Apple OAuth
- Phone OTP
- JWT Tokens

## 📱 Features Breakdown

### Phase 1: Core Features ✅
- [x] Project Architecture
- [x] Database Schema
- [x] Authentication System
- [x] User Profile Management
- [x] GPS Activity Tracking
- [x] Map Integration
- [x] Activity History

### Phase 2: Social & Events 🚧
- [ ] Virtual Events
- [ ] Challenges
- [ ] Leaderboards
- [ ] Social Features
- [ ] Achievements

### Phase 3: Advanced Features 📅
- [ ] AI Coaching
- [ ] Health Integrations
- [ ] Payments
- [ ] Premium Features
- [ ] Admin Panel

### Phase 4: Polish & Deploy 🚀
- [ ] Testing
- [ ] Documentation
- [ ] CI/CD
- [ ] Deployment

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines.

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Built with ❤️ by MoveTrack Team