-- MoveTrack Database Schema
-- PostgreSQL Database for Fitness Platform

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable PostGIS for geospatial queries
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    firebase_uid VARCHAR(255) UNIQUE,
    google_id VARCHAR(255) UNIQUE,
    apple_id VARCHAR(255) UNIQUE,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_firebase_uid ON users(firebase_uid);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- ============================================
-- PROFILES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    photo_url TEXT,
    full_name VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    bio TEXT,
    gender VARCHAR(50),
    date_of_birth DATE,
    height DECIMAL(5,2),
    weight DECIMAL(5,2),
    blood_group VARCHAR(10),
    fitness_level VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    emergency_contact JSONB,
    fitness_goals TEXT[],
    total_distance DECIMAL(10,2) DEFAULT 0,
    total_activities INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    xp_points INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    coins INTEGER DEFAULT 0,
    is_premium BOOLEAN DEFAULT FALSE,
    premium_expiry TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for profiles
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles(username);
CREATE INDEX IF NOT EXISTS idx_profiles_city ON profiles(city);
CREATE INDEX IF NOT EXISTS idx_profiles_country ON profiles(country);

-- ============================================
-- ACTIVITIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('walking', 'running', 'cycling')),
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed')),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    duration INTEGER DEFAULT 0,
    distance DECIMAL(10,2) DEFAULT 0,
    calories DECIMAL(7,2) DEFAULT 0,
    average_pace DECIMAL(5,2),
    average_speed DECIMAL(5,2),
    max_speed DECIMAL(5,2),
    elevation_gain DECIMAL(7,2) DEFAULT 0,
    elevation_loss DECIMAL(7,2) DEFAULT 0,
    steps INTEGER,
    heart_rate JSONB,
    cadence INTEGER,
    route JSONB NOT NULL,
    map_image_url TEXT,
    photos TEXT[],
    notes TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    event_id UUID,
    challenge_id UUID,
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for activities
CREATE INDEX IF NOT EXISTS idx_activities_user_id ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_type ON activities(type);
CREATE INDEX IF NOT EXISTS idx_activities_start_time ON activities(start_time);
CREATE INDEX IF NOT EXISTS idx_activities_event_id ON activities(event_id);
CREATE INDEX IF NOT EXISTS idx_activities_challenge_id ON activities(challenge_id);
CREATE INDEX IF NOT EXISTS idx_activities_created_at ON activities(created_at);

-- Add spatial index for route coordinates
CREATE INDEX IF NOT EXISTS idx_activities_route ON activities USING GIN(route);

-- ============================================
-- EVENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('5k', '10k', 'half_marathon', 'marathon', 'walking_challenge', 'corporate', 'charity')),
    category VARCHAR(50) NOT NULL CHECK (category IN ('running', 'walking', 'cycling')),
    banner_url TEXT,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    registration_start_date TIMESTAMP NOT NULL,
    registration_end_date TIMESTAMP NOT NULL,
    registration_fee DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    participant_limit INTEGER,
    current_participants INTEGER DEFAULT 0,
    is_virtual BOOLEAN DEFAULT TRUE,
    location JSONB,
    rules TEXT[],
    prizes JSONB,
    certificate_template TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for events
CREATE INDEX IF NOT EXISTS idx_events_type ON events(type);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category);
CREATE INDEX IF NOT EXISTS idx_events_start_date ON events(start_date);
CREATE INDEX IF NOT EXISTS idx_events_is_active ON events(is_active);
CREATE INDEX IF NOT EXISTS idx_events_is_featured ON events(is_featured);

-- ============================================
-- EVENT REGISTRATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS event_registrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    registration_number VARCHAR(50) UNIQUE NOT NULL,
    bib_number VARCHAR(50),
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    payment_status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    activity_id UUID,
    rank INTEGER,
    finish_time INTEGER,
    certificate_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, user_id)
);

-- Create indexes for event_registrations
CREATE INDEX IF NOT EXISTS idx_event_registrations_event_id ON event_registrations(event_id);
CREATE INDEX IF NOT EXISTS idx_event_registrations_user_id ON event_registrations(user_id);
CREATE INDEX IF NOT EXISTS idx_event_registrations_status ON event_registrations(status);
CREATE INDEX IF NOT EXISTS idx_event_registrations_payment_status ON event_registrations(payment_status);

-- ============================================
-- CHALLENGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('daily', 'weekly', 'monthly', 'custom')),
    category VARCHAR(50) NOT NULL CHECK (category IN ('distance', 'duration', 'frequency', 'calories')),
    target_value DECIMAL(10,2) NOT NULL,
    target_unit VARCHAR(50) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    participant_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    rewards JSONB NOT NULL,
    rules TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for challenges
CREATE INDEX IF NOT EXISTS idx_challenges_type ON challenges(type);
CREATE INDEX IF NOT EXISTS idx_challenges_category ON challenges(category);
CREATE INDEX IF NOT EXISTS idx_challenges_start_date ON challenges(start_date);
CREATE INDEX IF NOT EXISTS idx_challenges_end_date ON challenges(end_date);
CREATE INDEX IF NOT EXISTS idx_challenges_is_active ON challenges(is_active);

-- ============================================
-- CHALLENGE PROGRESS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS challenge_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    current_value DECIMAL(10,2) DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    rank INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(challenge_id, user_id)
);

-- Create indexes for challenge_progress
CREATE INDEX IF NOT EXISTS idx_challenge_progress_challenge_id ON challenge_progress(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenge_progress_user_id ON challenge_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_challenge_progress_is_completed ON challenge_progress(is_completed);

-- ============================================
-- ACHIEVEMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('distance', 'duration', 'frequency', 'streak', 'special')),
    badge_icon VARCHAR(255) NOT NULL,
    badge_color VARCHAR(50) NOT NULL,
    requirement JSONB NOT NULL,
    xp_reward INTEGER NOT NULL,
    coin_reward INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for achievements
CREATE INDEX IF NOT EXISTS idx_achievements_category ON achievements(category);
CREATE INDEX IF NOT EXISTS idx_achievements_is_active ON achievements(is_active);

-- ============================================
-- USER ACHIEVEMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS user_achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, achievement_id)
);

-- Create indexes for user_achievements
CREATE INDEX IF NOT EXISTS idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_user_achievements_achievement_id ON user_achievements(achievement_id);

-- ============================================
-- FRIENDSHIPS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'blocked')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (user_id != friend_id),
    UNIQUE(user_id, friend_id)
);

-- Create indexes for friendships
CREATE INDEX IF NOT EXISTS idx_friendships_user_id ON friendships(user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_friend_id ON friendships(friend_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON friendships(status);

-- ============================================
-- GROUPS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    photo_url TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    member_count INTEGER DEFAULT 0,
    max_members INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for groups
CREATE INDEX IF NOT EXISTS idx_groups_created_by ON groups(created_by);
CREATE INDEX IF NOT EXISTS idx_groups_is_public ON groups(is_public);

-- ============================================
-- GROUP MEMBERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL DEFAULT 'member' CHECK (role IN ('admin', 'moderator', 'member')),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(group_id, user_id)
);

-- Create indexes for group_members
CREATE INDEX IF NOT EXISTS idx_group_members_group_id ON group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_group_members_user_id ON group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_group_members_role ON group_members(role);

-- ============================================
-- COMMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    activity_id UUID NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for comments
CREATE INDEX IF NOT EXISTS idx_comments_activity_id ON comments(activity_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent_id ON comments(parent_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at);

-- ============================================
-- LIKES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    activity_id UUID NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(activity_id, user_id)
);

-- Create indexes for likes
CREATE INDEX IF NOT EXISTS idx_likes_activity_id ON likes(activity_id);
CREATE INDEX IF NOT EXISTS idx_likes_user_id ON likes(user_id);

-- ============================================
-- NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);

-- ============================================
-- PAYMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('event_registration', 'premium_subscription', 'donation')),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('razorpay', 'stripe', 'upi', 'card')),
    payment_id VARCHAR(255),
    order_id VARCHAR(255),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for payments
CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_type ON payments(type);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);

-- ============================================
-- CERTIFICATES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS certificates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    registration_id UUID NOT NULL REFERENCES event_registrations(id) ON DELETE CASCADE,
    certificate_number VARCHAR(100) UNIQUE NOT NULL,
    rank INTEGER,
    finish_time INTEGER,
    download_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for certificates
CREATE INDEX IF NOT EXISTS idx_certificates_event_id ON certificates(event_id);
CREATE INDEX IF NOT EXISTS idx_certificates_user_id ON certificates(user_id);
CREATE INDEX IF NOT EXISTS idx_certificates_registration_id ON certificates(registration_id);
CREATE INDEX IF NOT EXISTS idx_certificates_certificate_number ON certificates(certificate_number);

-- ============================================
-- REFRESH TOKENS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for refresh_tokens
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_activities_updated_at BEFORE UPDATE ON activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_event_registrations_updated_at BEFORE UPDATE ON event_registrations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_challenges_updated_at BEFORE UPDATE ON challenges
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_challenge_progress_updated_at BEFORE UPDATE ON challenge_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_friendships_updated_at BEFORE UPDATE ON friendships
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_groups_updated_at BEFORE UPDATE ON groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNCTIONS FOR LEADERBOARDS
-- ============================================

-- Function to get user's total distance
CREATE OR REPLACE FUNCTION get_user_total_distance(user_uuid UUID)
RETURNS DECIMAL AS $$
BEGIN
    RETURN COALESCE((SELECT SUM(distance) FROM activities WHERE user_id = user_uuid AND status = 'completed'), 0);
END;
$$ LANGUAGE plpgsql;

-- Function to get user's total activities
CREATE OR REPLACE FUNCTION get_user_total_activities(user_uuid UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN COALESCE((SELECT COUNT(*) FROM activities WHERE user_id = user_uuid AND status = 'completed'), 0);
END;
$$ LANGUAGE plpgsql;

-- Function to get user's total duration
CREATE OR REPLACE FUNCTION get_user_total_duration(user_uuid UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN COALESCE((SELECT SUM(duration) FROM activities WHERE user_id = user_uuid AND status = 'completed'), 0);
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- User stats view
CREATE OR REPLACE VIEW user_stats AS
SELECT
    u.id as user_id,
    p.username,
    p.full_name,
    p.photo_url,
    p.city,
    p.country,
    COUNT(DISTINCT a.id) as total_activities,
    COALESCE(SUM(a.distance), 0) as total_distance,
    COALESCE(SUM(a.duration), 0) as total_duration,
    COALESCE(SUM(a.calories), 0) as total_calories,
    MAX(a.start_time) as last_activity_date
FROM users u
JOIN profiles p ON u.id = p.user_id
LEFT JOIN activities a ON u.id = a.user_id AND a.status = 'completed'
GROUP BY u.id, p.username, p.full_name, p.photo_url, p.city, p.country;

-- Activity feed view
CREATE OR REPLACE VIEW activity_feed AS
SELECT
    a.id,
    a.user_id,
    p.username,
    p.full_name,
    p.photo_url,
    a.type,
    a.distance,
    a.duration,
    a.calories,
    a.average_pace,
    a.photos,
    a.likes_count,
    a.comments_count,
    a.created_at,
    e.title as event_title
FROM activities a
JOIN profiles p ON a.user_id = p.user_id
LEFT JOIN events e ON a.event_id = e.id
WHERE a.is_public = TRUE AND a.status = 'completed'
ORDER BY a.created_at DESC;

-- ============================================
-- SAMPLE DATA (Optional - for development)
-- ============================================

-- Insert sample achievement types
INSERT INTO achievements (title, description, category, badge_icon, badge_color, requirement, xp_reward, coin_reward, is_active) VALUES
('First Steps', 'Complete your first activity', 'distance', '🏃', '#FF6B6B', '{"type": "total_activities", "value": 1, "unit": "activities"}', 100, 50, TRUE),
('5K Runner', 'Run 5 kilometers in a single activity', 'distance', '🏅', '#4ECDC4', '{"type": "single_activity_distance", "value": 5, "unit": "km"}', 200, 100, TRUE),
('10K Warrior', 'Run 10 kilometers in a single activity', 'distance', '🏆', '#45B7D1', '{"type": "single_activity_distance", "value": 10, "unit": "km"}', 500, 250, TRUE),
('Half Marathon Hero', 'Complete a half marathon', 'distance', '🎖️', '#96CEB4', '{"type": "single_activity_distance", "value": 21.1, "unit": "km"}', 1000, 500, TRUE),
('Marathon Master', 'Complete a full marathon', 'distance', '🌟', '#FFEAA7', '{"type": "single_activity_distance", "value": 42.2, "unit": "km"}', 2000, 1000, TRUE),
('Century Club', 'Accumulate 100 kilometers total', 'distance', '💯', '#DDA0DD', '{"type": "total_distance", "value": 100, "unit": "km"}', 500, 250, TRUE),
('500K Club', 'Accumulate 500 kilometers total', 'distance', '🔥', '#FF6347', '{"type": "total_distance", "value": 500, "unit": "km"}', 2000, 1000, TRUE),
('100 Activities', 'Complete 100 activities', 'frequency', '💪', '#20B2AA', '{"type": "total_activities", "value": 100, "unit": "activities"}', 1000, 500, TRUE),
('Week Warrior', 'Maintain a 7-day streak', 'streak', '⚡', '#FFA500', '{"type": "streak", "value": 7, "unit": "days"}', 300, 150, TRUE),
('Month Champion', 'Maintain a 30-day streak', 'streak', '👑', '#FFD700', '{"type": "streak", "value": 30, "unit": "days"}', 1000, 500, TRUE),
('Early Bird', 'Complete an activity before 6 AM', 'special', '🌅', '#FF4500', '{"type": "early_activity", "value": 1, "unit": "times"}', 150, 75, TRUE),
('Night Owl', 'Complete an activity after 10 PM', 'special', '🌙', '#483D8B', '{"type": "late_activity", "value": 1, "unit": "times"}', 150, 75, TRUE)
ON CONFLICT DO NOTHING;

-- ============================================
-- GRANTS (Adjust based on your user)
-- ============================================

-- Grant permissions (adjust as needed)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO movetrack_user;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO movetrack_user;

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE users IS 'Stores user authentication information';
COMMENT ON TABLE profiles IS 'Stores user profile and fitness statistics';
COMMENT ON TABLE activities IS 'Stores GPS activity tracking data';
COMMENT ON TABLE events IS 'Stores virtual event information';
COMMENT ON TABLE event_registrations IS 'Stores user registrations for events';
COMMENT ON TABLE challenges IS 'Stores challenge information';
COMMENT ON TABLE challenge_progress IS 'Tracks user progress in challenges';
COMMENT ON TABLE achievements IS 'Stores achievement definitions';
COMMENT ON TABLE user_achievements IS 'Tracks user unlocked achievements';
COMMENT ON TABLE friendships IS 'Stores user friendships and connections';
COMMENT ON TABLE groups IS 'Stores running groups';
COMMENT ON TABLE group_members IS 'Stores group membership information';
COMMENT ON TABLE comments IS 'Stores activity comments';
COMMENT ON TABLE likes IS 'Stores activity likes';
COMMENT ON TABLE notifications IS 'Stores user notifications';
COMMENT ON TABLE payments IS 'Stores payment transactions';
COMMENT ON TABLE certificates IS 'Stores event certificates';
COMMENT ON TABLE refresh_tokens IS 'Stores JWT refresh tokens';

-- ============================================
-- END OF SCHEMA
-- ============================================