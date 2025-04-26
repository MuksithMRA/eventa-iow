const express = require('express');
const eventController = require('../controllers/event.controller');
const authMiddleware = require('../middleware/auth.middleware');
const reviewRouter = require('./review.routes');

const router = express.Router();

router.get('/', eventController.getAllEvents);
router.get('/featured', eventController.getFeaturedEvents);
router.get('/search', eventController.searchEvents);
router.get('/:id', eventController.getEvent);

router.use(authMiddleware.protect);
router.post('/', eventController.createEvent);
router.patch('/:id', eventController.updateEvent);
router.delete('/:id', eventController.deleteEvent);
router.patch('/:id/join', eventController.joinEvent);
router.patch('/:id/leave', eventController.leaveEvent);
router.patch('/:id/like', eventController.likeEvent);

router.use('/:eventId/reviews', reviewRouter);

module.exports = router;
