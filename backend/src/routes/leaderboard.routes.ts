import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { leaderboardController } from '../controllers/leaderboard.controller';

const router = Router();

// Get global leaderboard
router.get('/global', asyncHandler(leaderboardController.getGlobalLeaderboard));

// Get leaderboard by location
router.get('/country/:country', asyncHandler(leaderboardController.getCountryLeaderboard));
router.get('/state/:state', asyncHandler(leaderboardController.getStateLeaderboard));
router.get('/city/:city', asyncHandler(leaderboardController.getCityLeaderboard));

// Get friends leaderboard
router.get('/friends', authenticate, asyncHandler(leaderboardController.getFriendsLeaderboard));

// Get event leaderboard
router.get('/event/:eventId', asyncHandler(leaderboardController.getEventLeaderboard));

// Get challenge leaderboard
router.get('/challenge/:challengeId', asyncHandler(leaderboardController.getChallengeLeaderboard));

// Get user rank
router.get('/my-rank', authenticate, asyncHandler(leaderboardController.getMyRank));

export default router;