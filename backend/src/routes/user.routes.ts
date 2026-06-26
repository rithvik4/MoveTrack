import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { userController } from '../controllers/user.controller';

const router = Router();

// Get all users (admin)
router.get('/', authenticate, asyncHandler(userController.getAllUsers));

// Get user by ID
router.get('/:id', authenticate, asyncHandler(userController.getUserById));

// Delete user (admin)
router.delete('/:id', authenticate, asyncHandler(userController.deleteUser));

// Search users
router.get('/search/:query', authenticate, asyncHandler(userController.searchUsers));

export default router;