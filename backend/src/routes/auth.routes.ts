import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate } from '../middleware/auth.middleware';
import { authController } from '../controllers/auth.controller';

const router = Router();

// Register
router.post('/register', asyncHandler(authController.register));

// Login
router.post('/login', asyncHandler(authController.login));

// Refresh token
router.post('/refresh-token', asyncHandler(authController.refreshToken));

// Forgot password
router.post('/forgot-password', asyncHandler(authController.forgotPassword));

// Reset password
router.post('/reset-password', asyncHandler(authController.resetPassword));

// Verify email
router.get('/verify-email/:token', asyncHandler(authController.verifyEmail));

// Resend verification email
router.post('/resend-verification', authenticate, asyncHandler(authController.resendVerification));

// Google OAuth
router.post('/google', asyncHandler(authController.googleAuth));

// Apple OAuth
router.post('/apple', asyncHandler(authController.appleAuth));

// Phone OTP
router.post('/phone/send-otp', asyncHandler(authController.sendPhoneOTP));
router.post('/phone/verify-otp', asyncHandler(authController.verifyPhoneOTP));

export default router;