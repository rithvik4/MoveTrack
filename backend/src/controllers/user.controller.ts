import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { ApiResponse, User } from '../types';

export const userController = {
  getAllUsers: async (req: Request, res: Response): Promise<void> => {
    try {
      const { page = 1, limit = 20, search = '' } = req.query;
      const offset = (Number(page) - 1) * Number(limit);

      let query = 'SELECT id, email, is_verified, is_active, last_login, created_at FROM users';
      const params: any[] = [];

      if (search) {
        query += ' WHERE email ILIKE $1';
        params.push(`%${search}%`);
      }

      query += ` ORDER BY created_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
      params.push(Number(limit), offset);

      const result = await pool.query(query, params);
      const countResult = await pool.query('SELECT COUNT(*) FROM users');

      const response: ApiResponse<User[]> = {
        success: true,
        data: result.rows,
        pagination: {
          page: Number(page),
          limit: Number(limit),
          total: parseInt(countResult.rows[0].count),
          totalPages: Math.ceil(parseInt(countResult.rows[0].count) / Number(limit)),
        },
      };

      res.status(200).json(response);
    } catch (error) {
      logger.error('Get users error:', error);
      throw error;
    }
  },

  getUserById: async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      const result = await pool.query(
        'SELECT id, email, is_verified, is_active, last_login, created_at FROM users WHERE id = $1',
        [id]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'User not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Get user error:', error);
      throw error;
    }
  },

  deleteUser: async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      await pool.query('DELETE FROM users WHERE id = $1', [id]);

      res.status(200).json({
        success: true,
        message: 'User deleted successfully',
      } as ApiResponse);
    } catch (error) {
      logger.error('Delete user error:', error);
      throw error;
    }
  },

  searchUsers: async (req: Request, res: Response): Promise<void> => {
    try {
      const { query } = req.params;

      const result = await pool.query(
        'SELECT id, email, is_verified FROM users WHERE email ILIKE $1 LIMIT 20',
        [`%${query}%`]
      );

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse);
    } catch (error) {
      logger.error('Search users error:', error);
      throw error;
    }
  },
};