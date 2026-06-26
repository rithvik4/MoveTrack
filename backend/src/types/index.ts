import { Request } from 'express';

export interface User {
  id: string;
  email: string;
  phone?: string;
  firebaseUid?: string;
  googleId?: string;
  appleId?: string;
  isVerified: boolean;
  isActive: boolean;
  lastLogin?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface Profile {
  id: string;
  userId: string;
  photoUrl?: string;
  fullName: string;
  username: string;
  bio?: string;
  gender?: 'male' | 'female' | 'other' | 'prefer_not_to_say';
  dateOfBirth?: Date;
  height?: number;
  weight?: number;
  bloodGroup?: string;
  fitnessLevel?: 'beginner' | 'intermediate' | 'advanced';
  city?: string;
  state?: string;
  country?: string;
  emergencyContact?: {
    name: string;
    phone: string;
    relationship: string;
  };
  fitnessGoals?: string[];
  totalDistance: number;
  totalActivities: number;
  totalDuration: number;
  currentStreak: number;
  longestStreak: number;
  xpPoints: number;
  level: number;
  coins: number;
  isPremium: boolean;
  premiumExpiry?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface Activity {
  id: string;
  userId: string;
  type: 'walking' | 'running' | 'cycling';
  status: 'active' | 'paused' | 'completed';
  startTime: Date;
  endTime?: Date;
  duration: number;
  distance: number;
  calories: number;
  averagePace: number;
  averageSpeed: number;
  maxSpeed: number;
  elevationGain: number;
  elevationLoss: number;
  steps?: number;
  heartRate?: {
    average: number;
    max: number;
    min: number;
  };
  cadence?: number;
  route: {
    coordinates: Array<{
      latitude: number;
      longitude: number;
      timestamp: Date;
      altitude?: number;
      speed?: number;
    }>;
    totalPoints: number;
  };
  mapImageUrl?: string;
  photos: string[];
  notes?: string;
  isPublic: boolean;
  eventId?: string;
  challengeId?: string;
  likesCount: number;
  commentsCount: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface Event {
  id: string;
  title: string;
  description: string;
  type: '5k' | '10k' | 'half_marathon' | 'marathon' | 'walking_challenge' | 'corporate' | 'charity';
  category: 'running' | 'walking' | 'cycling';
  bannerUrl?: string;
  startDate: Date;
  endDate: Date;
  registrationStartDate: Date;
  registrationEndDate: Date;
  registrationFee: number;
  currency: string;
  participantLimit?: number;
  currentParticipants: number;
  isVirtual: boolean;
  location?: {
    name: string;
    address: string;
    city: string;
    state: string;
    country: string;
    coordinates: {
      latitude: number;
      longitude: number;
    };
  };
  rules: string[];
  prizes?: {
    description: string;
    positions: Array<{
      position: number;
      prize: string;
    }>;
  };
  certificateTemplate?: string;
  isActive: boolean;
  isFeatured: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface EventRegistration {
  id: string;
  eventId: string;
  userId: string;
  registrationNumber: string;
  bibNumber?: string;
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed';
  paymentStatus: 'pending' | 'completed' | 'failed' | 'refunded';
  paymentId?: string;
  amount: number;
  currency: string;
  activityId?: string;
  rank?: number;
  finishTime?: number;
  certificateUrl?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Challenge {
  id: string;
  title: string;
  description: string;
  type: 'daily' | 'weekly' | 'monthly' | 'custom';
  category: 'distance' | 'duration' | 'frequency' | 'calories';
  targetValue: number;
  targetUnit: string;
  startDate: Date;
  endDate: Date;
  participantCount: number;
  isActive: boolean;
  isFeatured: boolean;
  rewards: {
    xp: number;
    coins: number;
    badgeId?: string;
  };
  rules: string[];
  createdAt: Date;
  updatedAt: Date;
}

export interface ChallengeProgress {
  id: string;
  challengeId: string;
  userId: string;
  currentValue: number;
  isCompleted: boolean;
  completedAt?: Date;
  rank?: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface Achievement {
  id: string;
  title: string;
  description: string;
  category: 'distance' | 'duration' | 'frequency' | 'streak' | 'special';
  badgeIcon: string;
  badgeColor: string;
  requirement: {
    type: string;
    value: number;
    unit: string;
  };
  xpReward: number;
  coinReward: number;
  isActive: boolean;
  createdAt: Date;
}

export interface UserAchievement {
  id: string;
  userId: string;
  achievementId: string;
  unlockedAt: Date;
}

export interface Friendship {
  id: string;
  userId: string;
  friendId: string;
  status: 'pending' | 'accepted' | 'blocked';
  createdAt: Date;
  updatedAt: Date;
}

export interface Group {
  id: string;
  name: string;
  description?: string;
  photoUrl?: string;
  isPublic: boolean;
  createdBy: string;
  memberCount: number;
  maxMembers?: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface GroupMember {
  id: string;
  groupId: string;
  userId: string;
  role: 'admin' | 'moderator' | 'member';
  joinedAt: Date;
}

export interface Notification {
  id: string;
  userId: string;
  type: 'friend_request' | 'friend_accepted' | 'achievement' | 'event' | 'challenge' | 'activity_like' | 'activity_comment' | 'system' | 'payment';
  title: string;
  message: string;
  data?: Record<string, any>;
  isRead: boolean;
  createdAt: Date;
}

export interface Payment {
  id: string;
  userId: string;
  type: 'event_registration' | 'premium_subscription' | 'donation';
  amount: number;
  currency: string;
  status: 'pending' | 'completed' | 'failed' | 'refunded';
  paymentMethod: 'razorpay' | 'stripe' | 'upi' | 'card';
  paymentId?: string;
  orderId?: string;
  metadata?: Record<string, any>;
  createdAt: Date;
  updatedAt: Date;
}

export interface Certificate {
  id: string;
  eventId: string;
  userId: string;
  registrationId: string;
  certificateNumber: string;
  rank?: number;
  finishTime?: number;
  downloadUrl: string;
  createdAt: Date;
}

export interface Leaderboard {
  id: string;
  type: 'global' | 'country' | 'state' | 'city' | 'friends' | 'event' | 'challenge';
  period: 'today' | 'week' | 'month' | 'year' | 'all_time';
  entityId?: string;
  entries: Array<{
    userId: string;
    rank: number;
    value: number;
    unit: string;
  }>;
  updatedAt: Date;
}

export interface Comment {
  id: string;
  activityId: string;
  userId: string;
  content: string;
  parentId?: string;
  likesCount: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface Like {
  id: string;
  activityId: string;
  userId: string;
  createdAt: Date;
}

export interface RefreshToken {
  id: string;
  userId: string;
  token: string;
  expiresAt: Date;
  createdAt: Date;
}

export interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export interface ApiResponse<T = any> {
  success: boolean;
  message?: string;
  data?: T;
  pagination?: Pagination;
  error?: string;
  errors?: Record<string, string[]>;
}

export interface PaginatedResponse<T = any> {
  success: boolean;
  message?: string;
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export interface JwtPayload {
  userId: string;
  email: string;
  iat: number;
  exp: number;
}

export interface AuthRequest extends Request {
  user?: User;
}
