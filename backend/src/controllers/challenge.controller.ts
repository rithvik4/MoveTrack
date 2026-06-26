import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { ApiResponse, AuthRequest } from '../types';

export const challengeController = {
  getAllChallenges: async (req: Request, res: Response): Promise<void> => {
    try {
      const { type, active } = req.query;

      let query = 'SELECT * FROM challenges';
      const params: any[] = [];
      let paramCount = 1;

      if (type) {
        query += ` WHERE type = $${paramCount}`;
        params.push(type);
        paramCount++;
      }

      if (active === 'true') {
        query += paramCount === 1 ? ' WHERE' : ' AND';
        query += ` is_active = true`;
      }

      query += ' ORDER BY created_at DESC';

      const result = await pool.query(query, params);

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse);
    } catch (error) {
      logger.error('Get challenges error:', error);
      throw error;
    }
  },

  getChallengeById: async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      const result = await pool.query('SELECT * FROM challenges WHERE id = $1', [id]);

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Challenge not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get challenge error:', error);
      throw error;
    }
  },

  joinChallenge: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { id } = req.params;

      const result = await pool.query(
        'INSERT INTO challenge_progress (challenge_id, user_id) VALUES ($1, $2) RETURNING *',
        [id, userId]
      );

      res.status(201).json({
        success: true,
        message: 'Joined challenge successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Join challenge error:', error);
      throw error;
    }
  },

  getMyChallenges: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;

      const result = await pool.query(
        `SELECT cp.*, c.title, c.description, c.type, c.category, c.target_value, c.target_unit, c.end_date
         FROM challenge_progress cp
         JOIN challenges c ON cp.challenge_id = c.id
         WHERE cp.user_id = $1
         ORDER BY cp.created_at DESC`,
        [userId]
      );

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse);
    } catch (error) {
      logger.error('Get my challenges error:', error);
      throw error;
    }
  },

  getChallengeProgress: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { id } = req.params;

      const result = await pool.query(
        'SELECT * FROM challenge_progress WHERE challenge_id = $1 AND user_id = $2',
        [id, userId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Progress not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get challenge progress error:', error);
      throw error;
    }
  },

  updateProgress: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { id } = req.params;
      const { currentValue } = req.body;

      const result = await pool.query(
        'UPDATE challenge_progress SET current_value = $1, updated_at = CURRENT_TIMESTAMP WHERE challenge_id = $2 AND user_id = $3 RETURNING *',
        [currentValue, id, userId]
      );

      res.status(200).json({
        success: true,
        message: 'Progress updated',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update progress error:', error);
      throw error;
    }
  },

  createChallenge: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const challengeData = req.body;

      const result = await pool.query(
        'INSERT INTO challenges (title, description, type, category, target_value, target_unit, start_date, end_date, rewards, rules) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
        [
          challengeData.title,
          challengeData.description,
          challengeData.type,
          challengeData.category,
          challengeData.target_value,
          challengeData.target_unit,
          challengeData.start_date,
          challengeData.end_date,
          JSON.stringify(challengeData.rewards),
          challengeData.rules,
        ]
      );

      res.status(201).json({
        success: true,
        message: 'Challenge created successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Create challenge error:', error);
      throw error;
    }
  },

  updateChallenge: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const challengeData = req.body;

      const result = await pool.query(
        'UPDATE challenges SET title = $1, description = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3 RETURNING *',
        [challengeData.title, challengeData.description, id]
      );

      res.status(200).json({
        success: true,
        message: 'Challenge updated successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Update challenge error:', error);
      throw error;
    }
  },

  deleteChallenge: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      await pool.query('DELETE FROM challenges WHERE id = $1', [id]);

      res.status(200).json({
        success: true,
        message: 'Challenge deleted successfully',
      } as ApiResponse);
    } catch (error) {
      logger.error('Delete challenge error:', error);
      throw error;
    }
  },
};