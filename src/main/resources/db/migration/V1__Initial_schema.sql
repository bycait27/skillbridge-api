-- initial schema for SkillBridge API
-- this migration creates all the core tables for the application

-- users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    bio TEXT,
    hours_available INTEGER DEFAULT 0 NOT NULL CHECK (hours_available >= 0),
    rating DECIMAL(3, 2) DEFAULT 0.0,
    active BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- skills table
CREATE TABLE skills (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL
);

-- user_skills junction table
CREATE TABLE user_skills (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    skill_id BIGINT NOT NULL REFERENCES skills(id),
    proficiency_level SMALLINT NOT NULL CHECK (proficiency_level BETWEEN 0 AND 3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, skill_id)
);

-- exchanges table
CREATE TABLE exchanges (
    id BIGSERIAL PRIMARY KEY,
    skill_id BIGINT NOT NULL REFERENCES skills(id),
    requester_id BIGINT NOT NULL REFERENCES users(id),
    provider_id BIGINT NOT NULL REFERENCES users(id),
    hours INTEGER NOT NULL CHECK (hours >= 1),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    scheduled_date TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- reviews table
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    exchange_id BIGINT NOT NULL REFERENCES exchanges(id),
    reviewer_id BIGINT NOT NULL REFERENCES users(id),
    reviewed_id BIGINT NOT NULL REFERENCES users(id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(exchange_id, reviewer_id)
);

-- indexes for better performance
CREATE INDEX idx_user_skills_user_id ON user_skills(user_id);
CREATE INDEX idx_user_skills_skill_id ON user_skills(skill_id);
CREATE INDEX idx_exchanges_requester_id ON exchanges(requester_id);
CREATE INDEX idx_exchanges_provider_id ON exchanges(provider_id);
CREATE INDEX idx_exchanges_skill_id ON exchanges(skill_id);
CREATE INDEX idx_exchanges_status ON exchanges(status);
CREATE INDEX idx_exchanges_scheduled_date ON exchanges(scheduled_date);
CREATE INDEX idx_reviews_exchange_id ON reviews(exchange_id);
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);
CREATE INDEX idx_reviews_reviewed_id ON reviews(reviewed_id);