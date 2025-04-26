const Review = require('../models/review.model');
const Event = require('../models/event.model');

exports.getEventReviews = async (req, res) => {
  try {
    const { eventId } = req.params;
    const { type } = req.query;
    
    const event = await Event.findById(eventId);
    if (!event) {
      return res.status(404).json({
        status: 'fail',
        message: 'No event found with that ID'
      });
    }
    
    let query = { event: eventId };
    if (type && ['positive', 'negative'].includes(type)) {
      query.type = type;
    }
    
    const reviews = await Review.find(query).sort('-createdAt');
    
    res.status(200).json({
      status: 'success',
      results: reviews.length,
      data: {
        reviews
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.createReview = async (req, res) => {
  try {
    const event = await Event.findById(req.params.eventId);
    if (!event) {
      return res.status(404).json({
        status: 'fail',
        message: 'No event found with that ID'
      });
    }
    
    req.body.event = req.params.eventId;
    req.body.user = req.user.id;
    
    const existingReview = await Review.findOne({
      event: req.body.event,
      user: req.body.user
    });
    
    if (existingReview) {
      return res.status(400).json({
        status: 'fail',
        message: 'You have already reviewed this event'
      });
    }
    
    const review = await Review.create(req.body);
    
    res.status(201).json({
      status: 'success',
      data: {
        review
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.updateReview = async (req, res) => {
  try {
    const review = await Review.findById(req.params.reviewId);
    
    if (!review) {
      return res.status(404).json({
        status: 'fail',
        message: 'No review found with that ID'
      });
    }
    
    if (review.user.id !== req.user.id) {
      return res.status(403).json({
        status: 'fail',
        message: 'You can only update your own reviews'
      });
    }
    
    const updatedReview = await Review.findByIdAndUpdate(
      req.params.reviewId,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );
    
    res.status(200).json({
      status: 'success',
      data: {
        review: updatedReview
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.deleteReview = async (req, res) => {
  try {
    const review = await Review.findById(req.params.reviewId);
    
    if (!review) {
      return res.status(404).json({
        status: 'fail',
        message: 'No review found with that ID'
      });
    }
    
    if (review.user.id !== req.user.id) {
      return res.status(403).json({
        status: 'fail',
        message: 'You can only delete your own reviews'
      });
    }
    
    await Review.findByIdAndDelete(req.params.reviewId);
    
    res.status(204).json({
      status: 'success',
      data: null
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};
