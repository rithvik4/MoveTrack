import { Router } from 'express';
import { asyncHandler } from '../middleware/error.middleware';
import { authenticate, AuthRequest } from '../middleware/auth.middleware';
import { socialController } from '../controllers/social.controller';

const router = Router();

// Friends
router.post('/friends/request/:userId', authenticate, asyncHandler(socialController.sendFriendRequest));
router.put('/friends/accept/:requestId', authenticate, asyncHandler(socialController.acceptFriendRequest));
router.put('/friends/reject/:requestId', authenticate, asyncHandler(socialController.rejectFriendRequest));
router.get('/friends', authenticate, asyncHandler(socialController.getFriends));
router.get('/friends/requests', authenticate, asyncHandler(socialController.getFriendRequests));
router.delete('/friends/:friendId', authenticate, asyncHandler(socialController.removeFriend));

// Groups
router.post('/groups', authenticate, asyncHandler(socialController.createGroup));
router.get('/groups', authenticate, asyncHandler(socialController.getGroups));
router.get('/groups/:id', authenticate, asyncHandler(socialController.getGroupById));
router.put('/groups/:id', authenticate, asyncHandler(socialController.updateGroup));
router.delete('/groups/:id', authenticate, asyncHandler(socialController.deleteGroup));
router.post('/groups/:id/join', authenticate, asyncHandler(socialController.joinGroup));
router.post('/groups/:id/leave', authenticate, asyncHandler(socialController.leaveGroup));
router.get('/groups/:id/members', authenticate, asyncHandler(socialController.getGroupMembers));

// Activity interactions
router.post('/activities/:activityId/like', authenticate, asyncHandler(socialController.likeActivity));
router.delete('/activities/:activityId/like', authenticate, asyncHandler(socialController.unlikeActivity));
router.post('/activities/:activityId/comment', authenticate, asyncHandler(socialController.commentOnActivity));
router.get('/activities/:activityId/comments', authenticate, asyncHandler(socialController.getComments));

// Activity feed
router.get('/feed', authenticate, asyncHandler(socialController.getActivityFeed));

export default router;