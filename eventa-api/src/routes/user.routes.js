const express = require('express');
const userController = require('../controllers/user.controller');
const authMiddleware = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware.protect);

router.get('/my-events', userController.getUserEvents);
router.get('/my-past-events', userController.getUserPastEvents);
router.get('/my-organized-events', userController.getOrganizedEvents);
router.get('/my-liked-events', userController.getLikedEvents);

router.get('/', authMiddleware.restrictTo('admin'), userController.getAllUsers);

router.get('/:id', userController.getUser);
router.get('/:id/events', userController.getUserEvents);
router.get('/:id/past-events', userController.getUserPastEvents);
router.get('/:id/organized-events', userController.getOrganizedEvents);

module.exports = router;
