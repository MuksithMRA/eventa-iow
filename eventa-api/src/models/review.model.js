const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  content: {
    type: String,
    required: [true, 'Review content is required'],
    trim: true
  },
  rating: {
    type: Number,
    required: [true, 'Rating is required'],
    min: 1,
    max: 5
  },
  confidence: {
    type: Number,
    min: 0,
    max: 1,
    default: 0.5
  },
  type: {
    type: String,
    enum: ['positive', 'negative'],
    required: [true, 'Review type is required']
  },
  event: {
    type: mongoose.Schema.ObjectId,
    ref: 'Event',
    required: [true, 'Review must belong to an event']
  },
  user: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: [true, 'Review must belong to a user']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

reviewSchema.index({ event: 1, user: 1 }, { unique: true });

reviewSchema.pre(/^find/, function(next) {
  this.populate({
    path: 'user',
    select: 'firstName lastName profileImage'
  });
  next();
});

const Review = mongoose.model('Review', reviewSchema);

module.exports = Review;
