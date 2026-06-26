import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { profileController } from '../controllers/profile.controller';

const router = Router();

// Get my profile
router.get('/me', authenticate, asyncHandler(profileController.getMyProfile));

// Get profile by username
router.get('/username/:username', asyncHandler(profileController.getProfileByUsername));

// Update my profile
router.put('/me', authenticate, asyncHandler(profileController.updateProfile));

// Upload profile photo
router.post('/me/photo', authenticate, asyncHandler(profileController.uploadPhoto));

// Delete profile photo
router.delete('/me/photo', authenticate, asyncHandler(profileController.deletePhoto));

// Get user stats
router.get('/me/stats', authenticate, asyncHandler(profileController.getUserStats));

// Update fitness goals
router.put('/me/goals', authenticate, asyncHandler(profileController.updateFitnessGoals));

// Update emergency contact
router.put('/me/emergency-contact', authenticate, asyncHandler(profileController.updateEmergencyContact));

export default router;