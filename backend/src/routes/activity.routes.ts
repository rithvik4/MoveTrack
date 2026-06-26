import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { activityController } from '../controllers/activity.controller';

const router = Router();

// Get all activities
router.get('/', authenticate, asyncHandler(activityController.getActivities));

// Get activity by ID
router.get('/:id', authenticate, asyncHandler(activityController.getActivityById));

// Start activity
router.post('/start', authenticate, asyncHandler(activityController.startActivity));

// Update activity (live tracking)
router.put('/:id', authenticate, asyncHandler(activityController.updateActivity));

// Pause activity
router.post('/:id/pause', authenticate, asyncHandler(activityController.pauseActivity));

// Resume activity
router.post('/:id/resume', authenticate, asyncHandler(activityController.resumeActivity));

// Stop activity
router.post('/:id/stop', authenticate, asyncHandler(activityController.stopActivity));

// Delete activity
router.delete('/:id', authenticate, asyncHandler(activityController.deleteActivity));

// Upload activity photos
router.post('/:id/photos', authenticate, asyncHandler(activityController.uploadPhotos));

// Add notes to activity
router.put('/:id/notes', authenticate, asyncHandler(activityController.updateNotes));

// Get activity statistics
router.get('/stats/summary', authenticate, asyncHandler(activityController.getActivityStats));

export default router;