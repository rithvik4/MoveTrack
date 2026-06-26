import { Request, Response } from 'express';
import { ApiResponse, AuthRequest } from '../types';

export const paymentController = {
  createOrder: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  verifyPayment: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getPaymentHistory: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getPaymentById: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  refundPayment: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  razorpayWebhook: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  stripeWebhook: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },
};