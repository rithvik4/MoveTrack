import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import compression from 'compression';
import cookieParser from 'cookie-parser';
import { config } from './config/app.config';
import { connectDatabase } from './config/database.config';
import { logger } from './utils/logger';
import { errorHandler } from './middleware/error.middleware';
import { rateLimiter } from './middleware/rate-limit.middleware';

// Import routes
import authRoutes from './routes/auth.routes';
import userRoutes from './routes/user.routes';
import profileRoutes from './routes/profile.routes';
import activityRoutes from './routes/activity.routes';
import eventRoutes from './routes/event.routes';
import challengeRoutes from './routes/challenge.routes';
import socialRoutes from './routes/social.routes';
import notificationRoutes from './routes/notification.routes';
import paymentRoutes from './routes/payment.routes';
import leaderboardRoutes from './routes/leaderboard.routes';
import adminRoutes from './routes/admin.routes';
import aiRoutes from './routes/ai.routes';

const app = express();

// Security middleware
app.use(helmet());
app.use(cors(config.cors));
app.use(compression());
app.use(cookieParser());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate limiting
app.use(rateLimiter);

// Logging
if (config.env !== 'test') {
  app.use(morgan('combined', {
    stream: {
      write: (message: string) => logger.info(message.trim()),
    },
  }));
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'MoveTrack API is running',
    timestamp: new Date().toISOString(),
    environment: config.env,
  });
});

// API routes
app.use(`/api/${config.apiVersion}/auth`, authRoutes);
app.use(`/api/${config.apiVersion}/users`, userRoutes);
app.use(`/api/${config.apiVersion}/profile`, profileRoutes);
app.use(`/api/${config.apiVersion}/activities`, activityRoutes);
app.use(`/api/${config.apiVersion}/events`, eventRoutes);
app.use(`/api/${config.apiVersion}/challenges`, challengeRoutes);
app.use(`/api/${config.apiVersion}/social`, socialRoutes);
app.use(`/api/${config.apiVersion}/notifications`, notificationRoutes);
app.use(`/api/${config.apiVersion}/payments`, paymentRoutes);
app.use(`/api/${config.apiVersion}/leaderboards`, leaderboardRoutes);
app.use(`/api/${config.apiVersion}/ai`, aiRoutes);
app.use(`/api/${config.apiVersion}/admin`, adminRoutes);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
    error: `Cannot ${req.method} ${req.originalUrl}`,
  });
});

// Error handler
app.use(errorHandler);

// Start server
const startServer = async (): Promise<void> => {
  try {
    await connectDatabase();
    
    app.listen(config.port, () => {
      logger.info(`🚀 MoveTrack API server running on port ${config.port}`);
      logger.info(`📝 Environment: ${config.env}`);
      logger.info(`🔗 API Version: ${config.apiVersion}`);
      logger.info(`🌐 Health check: http://localhost:${config.port}/health`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('SIGINT signal received: closing HTTP server');
  process.exit(0);
});

startServer();

export default app;