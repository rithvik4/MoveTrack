import { Request, Response, NextFunction } from 'express';
import { config } from '../config/app.config';

interface RateLimitStore {
  [key: string]: {
    count: number;
    resetTime: number;
  };
}

const store: RateLimitStore = {};

export const rateLimiter = (req: Request, res: Response, next: NextFunction): void => {
  const clientId = req.ip || req.connection.remoteAddress || 'unknown';
  const now = Date.now();
  const windowMs = config.rateLimit.windowMs;
  const maxRequests = config.rateLimit.maxRequests;

  if (!store[clientId] || now > store[clientId].resetTime) {
    store[clientId] = {
      count: 1,
      resetTime: now + windowMs,
    };
    next();
    return;
  }

  store[clientId].count++;

  if (store[clientId].count > maxRequests) {
    res.status(429).json({
      success: false,
      message: 'Too many requests, please try again later.',
      retryAfter: Math.ceil((store[clientId].resetTime - now) / 1000),
    });
    return;
  }

  next();
};

// Cleanup old entries periodically
setInterval(() => {
  const now = Date.now();
  Object.keys(store).forEach((key) => {
    const entry = store[key];
    if (entry && now > entry.resetTime) {
      delete store[key];
    }
  });
}, config.rateLimit.windowMs);
