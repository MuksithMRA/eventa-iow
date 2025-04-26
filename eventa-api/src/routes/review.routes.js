const express = require('express');
const reviewController = require('../controllers/review.controller');
const authMiddleware = require('../middleware/auth.middleware');

const router = express.Router({ mergeParams: true });

router.use(authMiddleware.protect);

router
  .route('/')
  .get(reviewController.getEventReviews)
  .post(reviewController.createReview);

router
  .route('/:reviewId')
  .patch(reviewController.updateReview)
  .delete(reviewController.deleteReview);

module.exports = router;
