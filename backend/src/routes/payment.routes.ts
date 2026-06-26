import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { paymentController } from '../controllers/payment.controller';

const router = Router();

// Create payment order
router.post('/create-order', authenticate, asyncHandler(paymentController.createOrder));

// Verify payment
router.post('/verify', authenticate, asyncHandler(paymentController.verifyPayment));

// Get payment history
router.get('/history', authenticate, asyncHandler(paymentController.getPaymentHistory));

// Get payment by ID
router.get('/:id', authenticate, asyncHandler(paymentController.getPaymentById));

// Refund payment
router.post('/:id/refund', authenticate, asyncHandler(paymentController.refundPayment));

// Webhook for payment gateway
router.post('/webhook/razorpay', asyncHandler(paymentController.razorpayWebhook));
router.post('/webhook/stripe', asyncHandler(paymentController.stripeWebhook));

export default router;