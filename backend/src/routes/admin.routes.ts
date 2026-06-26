import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { adminController } from '../controllers/admin.controller';

const router = Router();

// All admin routes require authentication
router.use(authenticate);

// Dashboard
router.get('/dashboard', asyncHandler(adminController.getDashboard));

// User management
router.get('/users', asyncHandler(adminController.getAllUsers));
router.put('/users/:id', asyncHandler(adminController.updateUser));
router.delete('/users/:id', asyncHandler(adminController.deleteUser));

// Event management
router.post('/events', asyncHandler(adminController.createEvent));
router.put('/events/:id', asyncHandler(adminController.updateEvent));
router.delete('/events/:id', asyncHandler(adminController.deleteEvent));

// Challenge management
router.post('/challenges', asyncHandler(adminController.createChallenge));
router.put('/challenges/:id', asyncHandler(adminController.updateChallenge));
router.delete('/challenges/:id', asyncHandler(adminController.deleteChallenge));

// Payment management
router.get('/payments', asyncHandler(adminController.getAllPayments));
router.post('/payments/:id/refund', asyncHandler(adminController.refundPayment));

// Certificate management
router.get('/certificates', asyncHandler(adminController.getAllCertificates));
router.post('/certificates/:id/regenerate', asyncHandler(adminController.regenerateCertificate));

// Push notifications
router.post('/notifications/send', asyncHandler(adminController.sendPushNotification));

// Reports
router.get('/reports/users', asyncHandler(adminController.getUserReport));
router.get('/reports/activities', asyncHandler(adminController.getActivityReport));
router.get('/reports/revenue', asyncHandler(adminController.getRevenueReport));

export default router;