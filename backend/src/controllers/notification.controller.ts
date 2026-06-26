import { Request, Response } from 'express';
import { ApiResponse, AuthRequest } from '../types';

export const notificationController = {
  getNotifications: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getUnreadCount: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  markAsRead: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  markAllAsRead: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  deleteNotification: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  deleteAllNotifications: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },
};