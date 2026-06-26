import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { eventController } from '../controllers/event.controller';

const router = Router();

// Public routes
router.get('/', asyncHandler(eventController.getAllEvents));
router.get('/:id', asyncHandler(eventController.getEventById));
router.get('/type/:type', asyncHandler(eventController.getEventsByType));

// Protected routes
router.post('/register/:eventId', authenticate, asyncHandler(eventController.registerForEvent));
router.get('/my-registrations', authenticate, asyncHandler(eventController.getMyRegistrations));
router.post('/:eventId/submit-activity', authenticate, asyncHandler(eventController.submitActivity));
router.get('/:eventId/leaderboard', asyncHandler(eventController.getEventLeaderboard));

// Admin routes
router.post('/', authenticate, asyncHandler(eventController.createEvent));
router.put('/:id', authenticate, asyncHandler(eventController.updateEvent));
router.delete('/:id', authenticate, asyncHandler(eventController.deleteEvent));

export default router;