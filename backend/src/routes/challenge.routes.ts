import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { challengeController } from '../controllers/challenge.controller';

const router = Router();

// Public routes
router.get('/', asyncHandler(challengeController.getAllChallenges));
router.get('/:id', asyncHandler(challengeController.getChallengeById));

// Protected routes
router.post('/:id/join', authenticate, asyncHandler(challengeController.joinChallenge));
router.get('/my-challenges', authenticate, asyncHandler(challengeController.getMyChallenges));
router.get('/:id/progress', authenticate, asyncHandler(challengeController.getChallengeProgress));
router.put('/:id/progress', authenticate, asyncHandler(challengeController.updateProgress));

// Admin routes
router.post('/', authenticate, asyncHandler(challengeController.createChallenge));
router.put('/:id', authenticate, asyncHandler(challengeController.updateChallenge));
router.delete('/:id', authenticate, asyncHandler(challengeController.deleteChallenge));

export default router;