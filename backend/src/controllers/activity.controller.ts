import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { ApiResponse, AuthRequest, Activity } from '../types';

export const activityController = {
  getActivities: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { page = 1, limit = 20, type, startDate, endDate } = req.query;
      const offset = (Number(page) - 1) * Number(limit);

      let query = 'SELECT * FROM activities WHERE user_id = $1';
      const params: any[] = [userId];
      let paramCount = 2;

      if (type) {
        query += ` AND type = $${paramCount}`;
        params.push(type);
        paramCount++;
      }

      if (startDate) {
        query += ` AND start_time >= $${paramCount}`;
        params.push(startDate);
        paramCount++;
      }

      if (endDate) {
        query += ` AND start_time <= $${paramCount}`;
        params.push(endDate);
        paramCount++;
      }

      query += ` ORDER BY start_time DESC LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
      params.push(Number(limit), offset);

      const result = await pool.query(query, params);
      const countResult = await pool.query('SELECT COUNT(*) FROM activities WHERE user_id = $1', [userId]);

      res.status(200).json({
        success: true,
        data: result.rows,
        pagination: {
          page: Number(page),
          limit: Number(limit),
          total: parseInt(countResult.rows[0].count),
          totalPages: Math.ceil(parseInt(countResult.rows[0].count) / Number(limit)),
        },
      } as ApiResponse<Activity[]>);
    } catch (error) {
      logger.error('Get activities error:', error);
      throw error;
    }
  },

  getActivityById: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      const result = await pool.query(
        'SELECT * FROM activities WHERE id = $1 AND user_id = $2',
        [id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Activity not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Get activity error:', error);
      throw error;
    }
  },

  startActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { type } = req.body;

      const result = await pool.query(
        'INSERT INTO activities (user_id, type, status, start_time) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING *',
        [userId, type, 'active']
      );

      res.status(201).json({
        success: true,
        message: 'Activity started',
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Start activity error:', error);
      throw error;
    }
  },

  updateActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;
      const updateData = req.body;

      const result = await pool.query(
        'UPDATE activities SET route = $1, distance = $2, duration = $3, calories = $4, updated_at = CURRENT_TIMESTAMP WHERE id = $5 AND user_id = $6 RETURNING *',
        [updateData.route, updateData.distance, updateData.duration, updateData.calories, id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Activity not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Update activity error:', error);
      throw error;
    }
  },

  pauseActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      const result = await pool.query(
        'UPDATE activities SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND user_id = $3 RETURNING *',
        ['paused', id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Activity not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        message: 'Activity paused',
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Pause activity error:', error);
      throw error;
    }
  },

  resumeActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      const result = await pool.query(
        'UPDATE activities SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND user_id = $3 RETURNING *',
        ['active', id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Activity not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        message: 'Activity resumed',
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Resume activity error:', error);
      throw error;
    }
  },

  stopActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      const result = await pool.query(
        'UPDATE activities SET status = $1, end_time = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND user_id = $3 RETURNING *',
        ['completed', id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Activity not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        message: 'Activity completed',
        data: result.rows[0],
      } as ApiResponse<Activity>);
    } catch (error) {
      logger.error('Stop activity error:', error);
      throw error;
    }
  },

  deleteActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      await pool.query('DELETE FROM activities WHERE id = $1 AND user_id = $2', [id, userId]);

      res.status(200).json({
        success: true,
        message: 'Activity deleted successfully',
      } as ApiResponse);
    } catch (error) {
      logger.error('Delete activity error:', error);
      throw error;
    }
  },

  uploadPhotos: async (req: AuthRequest, res: Response): Promise<void> => {
    // Implementation for photo upload
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  updateNotes: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const userId = req.user?.id;
      const { notes } = req.body;

      const result = await pool.query(
        'UPDATE activities SET notes = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND user_id = $3 RETURNING *',
        [notes, id, userId]
      );

      res.status(200).json({
        success: true,
        message: 'Notes updated',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update notes error:', error);
      throw error;
    }
  },

  getActivityStats: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;

      const result = await pool.query(
        'SELECT COUNT(*) as total_activities, SUM(distance) as total_distance, SUM(duration) as total_duration, SUM(calories) as total_calories FROM activities WHERE user_id = $1 AND status = $2',
        [userId, 'completed']
      );

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get activity stats error:', error);
      throw error;
    }
  },
};