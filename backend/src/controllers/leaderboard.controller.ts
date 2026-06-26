import { Request, Response } from 'express';
import { ApiResponse, AuthRequest } from '../types';

export const leaderboardController = {
  getGlobalLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getCountryLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getStateLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getCityLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getFriendsLeaderboard: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getEventLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getChallengeLeaderboard: async (req: Request, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },

  getMyRank: async (req: AuthRequest, res: Response): Promise<void> => {
    res.status(501).json({
      success: false,
      message: 'Not implemented yet',
    } as ApiResponse);
  },
};