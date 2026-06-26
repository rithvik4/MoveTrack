import { Request, Response } from 'express';
import { pool } from '../config/database.config';
import { AppError } from '../middleware/error.middleware';
import { logger } from '../utils/logger';
import { ApiResponse, AuthRequest, Event } from '../types';

export const eventController = {
  getAllEvents: async (req: Request, res: Response): Promise<void> => {
    try {
      const { type, category, upcoming } = req.query;
      
      let query = 'SELECT * FROM events WHERE is_active = true';
      const params: any[] = [];
      let paramCount = 1;

      if (type) {
        query += ` AND type = $${paramCount}`;
        params.push(type);
        paramCount++;
      }

      if (category) {
        query += ` AND category = $${paramCount}`;
        params.push(category);
        paramCount++;
      }

      if (upcoming === 'true') {
        query += ` AND start_date > CURRENT_TIMESTAMP`;
      }

      query += ' ORDER BY start_date ASC';

      const result = await pool.query(query, params);

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse<Event[]>);
    } catch (error) {
      logger.error('Get events error:', error);
      throw error;
    }
  },

  getEventById: async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      const result = await pool.query('SELECT * FROM events WHERE id = $1', [id]);

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Event not found',
        } as ApiResponse);
        return;
      }

      res.status(200).json({
        success: true,
        data: result.rows[0],
      } as ApiResponse<Event>);
    } catch (error) {
      logger.error('Get event error:', error);
      throw error;
    }
  },

  getEventsByType: async (req: Request, res: Response): Promise<void> => {
    try {
      const { type } = req.params;

      const result = await pool.query(
        'SELECT * FROM events WHERE type = $1 AND is_active = true ORDER BY start_date ASC',
        [type]
      );

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse<Event[]>);
    } catch (error) {
      logger.error('Get events by type error:', error);
      throw error;
    }
  },

  registerForEvent: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { eventId } = req.params;

      // Check if event exists
      const eventResult = await pool.query('SELECT * FROM events WHERE id = $1', [eventId]);
      if (eventResult.rows.length === 0) {
        res.status(404).json({
          success: false,
          message: 'Event not found',
        } as ApiResponse);
        return;
      }

      const event = eventResult.rows[0];

      // Check if already registered
      const existingRegistration = await pool.query(
        'SELECT id FROM event_registrations WHERE event_id = $1 AND user_id = $2',
        [eventId, userId]
      );

      if (existingRegistration.rows.length > 0) {
        res.status(400).json({
          success: false,
          message: 'Already registered for this event',
        } as ApiResponse);
        return;
      }

      // Generate registration number
      const registrationNumber = `EVT-${Date.now()}-${Math.random().toString(36).substr(2, 9).toUpperCase()}`;

      const result = await pool.query(
        'INSERT INTO event_registrations (event_id, user_id, registration_number, amount, currency) VALUES ($1, $2, $3, $4, $5) RETURNING *',
        [eventId, userId, registrationNumber, event.registration_fee, event.currency]
      );

      res.status(201).json({
        success: true,
        message: 'Registered for event successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Event registration error:', error);
      throw error;
    }
  },

  getMyRegistrations: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;

      const result = await pool.query(
        `SELECT er.*, e.title, e.start_date, e.end_date, e.type 
         FROM event_registrations er 
         JOIN events e ON er.event_id = e.id 
         WHERE er.user_id = $1 
         ORDER BY er.created_at DESC`,
        [userId]
      );

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse);
    } catch (error) {
      logger.error('Get registrations error:', error);
      throw error;
    }
  },

  submitActivity: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const userId = req.user?.id;
      const { eventId } = req.params;
      const { activityId } = req.body;

      const result = await pool.query(
        'UPDATE event_registrations SET activity_id = $1, status = $2 WHERE event_id = $3 AND user_id = $4 RETURNING *',
        [activityId, 'completed', eventId, userId]
      );

      res.status(200).json({
        success: true,
        message: 'Activity submitted successfully',
        data: result.rows[0],
      } as ApiResponse);
    } catch (error) {
      logger.error('Submit activity error:', error);
      throw error;
    }
  },

  getEventLeaderboard: async (req: Request, res: Response): Promise<void> => {
    try {
      const { eventId } = req.params;

      const result = await pool.query(
        `SELECT er.rank, er.finish_time, p.full_name, p.photo_url, p.username, a.distance, a.duration
         FROM event_registrations er
         JOIN profiles p ON er.user_id = p.user_id
         JOIN activities a ON er.activity_id = a.id
         WHERE er.event_id = $1 AND er.rank IS NOT NULL
         ORDER BY er.rank ASC`,
        [eventId]
      );

      res.status(200).json({
        success: true,
        data: result.rows,
      } as ApiResponse);
    } catch (error) {
      logger.error('Get event leaderboard error:', error);
      throw error;
    }
  },

  createEvent: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const eventData = req.body;

      const result = await pool.query(
        'INSERT INTO events (title, description, type, category, start_date, end_date, registration_start_date, registration_end_date, registration_fee, currency) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
        [
          eventData.title,
          eventData.description,
          eventData.type,
          eventData.category,
          eventData.start_date,
          eventData.end_date,
          eventData.registration_start_date,
          eventData.registration_end_date,
          eventData.registration_fee,
          eventData.currency || 'INR',
        ]
      );

      res.status(201).json({
        success: true,
        message: 'Event created successfully',
        data: result.rows[0],
      } as ApiResponse<Event>);
    } catch (error) {
      logger.error('Create event error:', error);
      throw error;
    }
  },

  updateEvent: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const eventData = req.body;

      const result = await pool.query(
        'UPDATE events SET title = $1, description = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3 RETURNING *',
        [eventData.title, eventData.description, id]
      );

      res.status(200).json({
        success: true,
        message: 'Event updated successfully',
        data: result.rows[0],
      } as ApiResponse<Event>);
    } catch (error) {
      logger.error('Update event error:', error);
      throw error;
    }
  },

  deleteEvent: async (req: AuthRequest, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      await pool.query('DELETE FROM events WHERE id = $1', [id]);

      res.status(200).json({
        success: true,
        message: 'Event deleted successfully',
      } as ApiResponse);
    } catch (error) {
      logger.error('Delete event error:', error);
      throw error;
    }
  },
};