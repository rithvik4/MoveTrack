import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { ApiResponse, AuthRequest, Profile } from '../types';

export const profileController = {
  getMyProfile: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;

      const result = await pool.query(
        'SELECT * FROM profiles WHERE user_id = $1',
        [userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Profile not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse<Profile>);
    } catch (error) {
      logger.error('Get profile error:', error);
      throw error;
    }
  },

  getProfileByUsername: async (req: Request, res: Response): Promise<void> => {
    try {
      const { username } = req.params;

      const result = await pool.query(
        'SELECT p.*, u.email FROM profiles p JOIN users u ON p.user_id = u.id WHERE p.username = $1',
        [username]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Profile not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get profile by username error:', error);
      throw error;
    }
  },

  updateProfile: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const updateData = (req.body as Record<string, any>) || {};

      const allowedFields = [
        'full_name', 'bio', 'gender', 'date_of_birth', 'height', 'weight',
        'blood_group', 'fitness_level', 'city', 'state', 'country'
      ];

      const updates: string[] = [];
      const values: any[] = [];
      let paramCount = 1;

      for (const [key, value] of Object.entries(updateData)) {
        if (allowedFields.includes(key)) {
          updates.push(`${key.replace(/([A-Z])/g, '_$1').toLowerCase()} = $${paramCount}`);
          values.push(value);
          paramCount++;
        }
      }

      if (updates.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No valid fields to update',
        } as ApiResponse);
        return;
      }

      values.push(userId);
      const query = `UPDATE profiles SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE user_id = $${paramCount} RETURNING *`;

      const result = await pool.query(query, values);

      res.status(200).json({
        success: true,
        message: 'Profile updated successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update profile error:', error);
      throw error;
    }
  },

  uploadPhoto: async (req: AuthRequest, res: Response): Promise<void> => {
    // Implementation for photo upload
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  deletePhoto: async (req: AuthRequest, res: Response): Promise<void> => {
    // Implementation for photo deletion
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getUserStats: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;

      const result = await pool.query(
        'SELECT * FROM profiles WHERE user_id = $1',
        [userId]
      );

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get user stats error:', error);
      throw error;
    }
  },

  updateFitnessGoals: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { goals } = (req.body as any) || {};

      const result = await pool.query(
        'UPDATE profiles SET fitness_goals = $1, updated_at = CURRENT_TIMESTAMP WHERE user_id = $2 RETURNING *',
        [goals, userId]
      );

      res.status(200).json({
        success: true,
        message: 'Fitness goals updated',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update fitness goals error:', error);
      throw error;
    }
  },

  updateEmergencyContact: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { emergencyContact } = (req.body as any) || {};

      const result = await pool.query(
        'UPDATE profiles SET emergency_contact = $1, updated_at = CURRENT_TIMESTAMP WHERE user_id = $2 RETURNING *',
        [JSON.stringify(emergencyContact), userId]
      );

      res.status(200).json({
        success: true,
        message: 'Emergency contact updated',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update emergency contact error:', error);
      throw error;
    }
  },
};