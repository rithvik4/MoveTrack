import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { config } from '../config/app.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { User, Profile, ApiResponse } from '../types';

interface UserWithPassword extends User {
  password: string;
}

export const authController = {
  register: async (req: Request, res: Response): Promise<void> => {
    try {
      const { email, password, fullName, username } = req.body;

      // Check if user exists
      const existingUser = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
      if (existingUser.rows.length > 0) {
        res.status(400).json({
          success: false,
          message: 'User already exists with this email',
        } as ApiResponse);
        return;
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, config.bcrypt.rounds);

      // Create user with password
      const userResult = await pool.query(
        'INSERT INTO users (email, password) VALUES ($1, $2) RETURNING id, email, is_verified',
        [email, hashedPassword]
      );

      const user: User = userResult.rows[0];

      // Create profile
      await pool.query(
        'INSERT INTO profiles (user_id, full_name, username) VALUES ($1, $2, $3)',
        [user.id, fullName, username]
      );

      // Generate JWT
      const token = jwt.sign(
        { userId: user.id, email: user.email } as object,
        config.jwt.secret,
        { expiresIn: config.jwt.expiresIn } as any
      );

      const response: ApiResponse = {
        success: true,
        message: 'User registered successfully',
        data: { user, token },
      };

      res.status(201).json(response);
    } catch (error) {
      logger.error('Registration error:', error);
      throw error;
    }
  },

  login: async (req: Request, res: Response): Promise<void> => {
    try {
      const { email, password } = req.body;

      // Find user
      const userResult = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
      if (userResult.rows.length === 0) {
        res.status(401).json({
          success: false,
          message: 'Invalid credentials',
        } as ApiResponse);
        return;
      }

      const user: UserWithPassword = userResult.rows[0];

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, user.password || '');
      if (!isPasswordValid) {
        res.status(401).json({
          success: false,
          message: 'Invalid credentials',
        } as ApiResponse);
        return;
      }

      // Update last login
      await pool.query('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [user.id]);

      // Generate JWT
      const token = jwt.sign(
        { userId: user.id, email: user.email } as object,
        config.jwt.secret,
        { expiresIn: config.jwt.expiresIn } as any
      );

      const response: ApiResponse = {
        success: true,
        message: 'Login successful',
        data: { user, token },
      };

      res.status(200).json(response);
    } catch (error) {
      logger.error('Login error:', error);
      throw error;
    }
  },

  refreshToken: async (req: Request, res: Response): Promise<void> => {
    // Implementation for refresh token
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  forgotPassword: async (req: Request, res: Response): Promise<void> => {
    // Implementation for forgot password
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  resetPassword: async (req: Request, res: Response): Promise<void> => {
    // Implementation for reset password
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  verifyEmail: async (req: Request, res: Response): Promise<void> => {
    // Implementation for email verification
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  resendVerification: async (req: Request, res: Response): Promise<void> => {
    // Implementation for resend verification
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  googleAuth: async (req: Request, res: Response): Promise<void> => {
    // Implementation for Google OAuth
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  appleAuth: async (req: Request, res: Response): Promise<void> => {
    // Implementation for Apple OAuth
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  sendPhoneOTP: async (req: Request, res: Response): Promise<void> => {
    // Implementation for sending phone OTP
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  verifyPhoneOTP: async (req: Request, res: Response): Promise<void> => {
    // Implementation for verifying phone OTP
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },
};