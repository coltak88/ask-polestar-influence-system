-- Initial database schema for Ask Polestar Influence System
-- Created: 2025-09-19
-- Database: PostgreSQL

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    profile_image_url TEXT,
    bio TEXT,
    website_url TEXT,
    location VARCHAR(255),
    timezone VARCHAR(50) DEFAULT 'UTC',
    language VARCHAR(10) DEFAULT 'en',
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    is_premium BOOLEAN DEFAULT false,
    email_verified_at TIMESTAMP,
    phone_verified_at TIMESTAMP,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create social media accounts table
CREATE TABLE social_media_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    platform_user_id VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    profile_url TEXT,
    profile_image_url TEXT,
    follower_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0,
    post_count INTEGER DEFAULT 0,
    bio TEXT,
    location VARCHAR(255),
    website_url TEXT,
    is_verified BOOLEAN DEFAULT false,
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP,
    last_sync_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, platform)
);

-- Create influence_metrics table
CREATE TABLE influence_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID REFERENCES social_media_accounts(id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    followers INTEGER DEFAULT 0,
    following INTEGER DEFAULT 0,
    posts INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    profile_visits INTEGER DEFAULT 0,
    website_clicks INTEGER DEFAULT 0,
    email_clicks INTEGER DEFAULT 0,
    phone_clicks INTEGER DEFAULT 0,
    engagement_rate DECIMAL(5,4) DEFAULT 0.0000,
    influence_score DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_id, metric_date)
);

-- Create posts table
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID REFERENCES social_media_accounts(id) ON DELETE CASCADE,
    platform_post_id VARCHAR(255) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    content TEXT,
    content_type VARCHAR(50) DEFAULT 'text',
    media_urls TEXT[],
    media_types VARCHAR(50)[],
    post_url TEXT,
    posted_at TIMESTAMP,
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    engagement_rate DECIMAL(5,4) DEFAULT 0.0000,
    hashtags TEXT[],
    mentions TEXT[],
    location VARCHAR(255),
    is_promoted BOOLEAN DEFAULT false,
    is_story BOOLEAN DEFAULT false,
    is_reel BOOLEAN DEFAULT false,
    is_live BOOLEAN DEFAULT false,
    duration_seconds INTEGER,
    language VARCHAR(10),
    sentiment_score DECIMAL(3,2),
    toxicity_score DECIMAL(3,2),
    spam_score DECIMAL(3,2),
    quality_score DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(platform_post_id, platform)
);

-- Create post_analytics table
CREATE TABLE post_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    analysis_date DATE NOT NULL,
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    profile_visits INTEGER DEFAULT 0,
    website_clicks INTEGER DEFAULT 0,
    email_clicks INTEGER DEFAULT 0,
    phone_clicks INTEGER DEFAULT 0,
    engagement_rate DECIMAL(5,4) DEFAULT 0.0000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(post_id, analysis_date)
);

-- Create audience_demographics table
CREATE TABLE audience_demographics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID REFERENCES social_media_accounts(id) ON DELETE CASCADE,
    demographic_date DATE NOT NULL,
    age_group VARCHAR(20),
    gender VARCHAR(10),
    country VARCHAR(100),
    city VARCHAR(100),
    language VARCHAR(50),
    percentage DECIMAL(5,2),
    count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create competitor_tracking table
CREATE TABLE competitor_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    competitor_account_id VARCHAR(255) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    competitor_username VARCHAR(255) NOT NULL,
    competitor_name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, competitor_account_id, platform)
);

-- Create campaigns table
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    campaign_type VARCHAR(50) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    target_audience JSONB,
    goals JSONB,
    kpis JSONB,
    is_active BOOLEAN DEFAULT true,
    status VARCHAR(50) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create campaign_posts table
CREATE TABLE campaign_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID REFERENCES campaigns(id) ON DELETE CASCADE,
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    scheduled_at TIMESTAMP,
    posted_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'scheduled',
    performance_metrics JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create api_usage table
CREATE TABLE api_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    endpoint VARCHAR(255) NOT NULL,
    method VARCHAR(10) NOT NULL,
    status_code INTEGER,
    response_time_ms INTEGER,
    request_size_bytes INTEGER,
    response_size_bytes INTEGER,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create subscriptions table
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan_name VARCHAR(100) NOT NULL,
    plan_id VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    current_period_start TIMESTAMP,
    current_period_end TIMESTAMP,
    cancel_at_period_end BOOLEAN DEFAULT false,
    canceled_at TIMESTAMP,
    payment_method_id VARCHAR(255),
    customer_id VARCHAR(255),
    subscription_id VARCHAR(255),
    price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    features JSONB,
    usage_limits JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit_logs table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(100),
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE INDEX idx_social_accounts_user_id ON social_media_accounts(user_id);
CREATE INDEX idx_social_accounts_platform ON social_media_accounts(platform);
CREATE INDEX idx_social_accounts_platform_user_id ON social_media_accounts(platform_user_id);

CREATE INDEX idx_influence_metrics_account_id ON influence_metrics(account_id);
CREATE INDEX idx_influence_metrics_metric_date ON influence_metrics(metric_date);
CREATE INDEX idx_influence_metrics_influence_score ON influence_metrics(influence_score);

CREATE INDEX idx_posts_account_id ON posts(account_id);
CREATE INDEX idx_posts_platform ON posts(platform);
CREATE INDEX idx_posts_posted_at ON posts(posted_at);
CREATE INDEX idx_posts_engagement_rate ON posts(engagement_rate);

CREATE INDEX idx_post_analytics_post_id ON post_analytics(post_id);
CREATE INDEX idx_post_analytics_analysis_date ON post_analytics(analysis_date);

CREATE INDEX idx_audience_demographics_account_id ON audience_demographics(account_id);
CREATE INDEX idx_audience_demographics_demographic_date ON audience_demographics(demographic_date);

CREATE INDEX idx_competitor_tracking_user_id ON competitor_tracking(user_id);
CREATE INDEX idx_competitor_tracking_platform ON competitor_tracking(platform);

CREATE INDEX idx_campaigns_user_id ON campaigns(user_id);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_start_date ON campaigns(start_date);

CREATE INDEX idx_campaign_posts_campaign_id ON campaign_posts(campaign_id);
CREATE INDEX idx_campaign_posts_post_id ON campaign_posts(post_id);
CREATE INDEX idx_campaign_posts_status ON campaign_posts(status);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

CREATE INDEX idx_api_usage_user_id ON api_usage(user_id);
CREATE INDEX idx_api_usage_endpoint ON api_usage(endpoint);
CREATE INDEX idx_api_usage_created_at ON api_usage(created_at);

CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_plan_id ON subscriptions(plan_id);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_resource_type ON audit_logs(resource_type);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_social_media_accounts_updated_at BEFORE UPDATE ON social_media_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_influence_metrics_updated_at BEFORE UPDATE ON influence_metrics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_post_analytics_updated_at BEFORE UPDATE ON post_analytics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_audience_demographics_updated_at BEFORE UPDATE ON audience_demographics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_competitor_tracking_updated_at BEFORE UPDATE ON competitor_tracking
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_campaign_posts_updated_at BEFORE UPDATE ON campaign_posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();