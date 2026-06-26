import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { aiController } from '../controllers/ai.controller';

const router = Router();

// AI Coaching
router.post('/coach/recommendations', authenticate, asyncHandler(aiController.getRecommendations));
router.post('/coach/training-plan', authenticate, asyncHandler(aiController.generateTrainingPlan));
router.post('/coach/pace-suggestion', authenticate, asyncHandler(aiController.getPaceSuggestion));
router.post('/coach/recovery', authenticate, asyncHandler(aiController.getRecoverySuggestions));
router.post('/coach/nutrition', authenticate, asyncHandler(aiController.getNutritionSuggestions));

// Performance Analysis
router.get('/analysis/performance', authenticate, asyncHandler(aiController.analyzePerformance));
router.get('/analysis/injury-prevention', authenticate, asyncHandler(aiController.getInjuryPreventionTips));

// Motivational content
router.get('/motivation/daily', authenticate, asyncHandler(aiController.getDailyMotivation));
router.get('/motivation/quote', authenticate, asyncHandler(aiController.getMotivationalQuote));

export default router;