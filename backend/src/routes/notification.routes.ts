import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { notificationController } from '../controllers/notification.controller';

const router = Router();

// Get all notifications
router.get('/', authenticate, asyncHandler(notificationController.getNotifications));

// Get unread count
router.get('/unread/count', authenticate, asyncHandler(notificationController.getUnreadCount));

// Mark notification as read
router.put('/:id/read', authenticate, asyncHandler(notificationController.markAsRead));

// Mark all as read
router.put('/read-all', authenticate, asyncHandler(notificationController.markAllAsRead));

// Delete notification
router.delete('/:id', authenticate, asyncHandler(notificationController.deleteNotification));

// Delete all notifications
router.delete('/', authenticate, asyncHandler(notificationController.deleteAllNotifications));

export default router;