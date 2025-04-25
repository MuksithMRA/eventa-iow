const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Event title is required'],
    trim: true
  },
  description: {
    type: String,
    required: [true, 'Event description is required']
  },
  date: {
    type: Date,
    required: [true, 'Event date is required']
  },
  starttime: {
    type: String,
    required: [true, 'Event start time is required']
  },
  endtime: {
    type: String,
    required: [true, 'Event end time is required']
  },
  location: {
    address: {
      type: String,
      required: [true, 'Event address is required']
    },
    city: {
      type: String,
      required: [true, 'City is required']
    },
    coordinates: {
      latitude: {
        type: Number,
        required: [true, 'Latitude is required']
      },
      longitude: {
        type: Number,
        required: [true, 'Longitude is required']
      }
    }
  },
  price: {
    amount: {
      type: Number,
      required: [true, 'Price amount is required']
    },
    currency: {
      type: String,
      default: 'LKR'
    }
  },
  category: {
    type: String,
    required: [true, 'Event category is required'],
    enum: ['Technology', 'Business', 'Design', 'Marketing', 'Health', 'Education', 'Sports', 'Music', 'Arts', 'Food']
  },
  image: {
    type: String,
    default: 'default-event.jpg'
  },
  organizer: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: [true, 'Event must belong to an organizer']
  },
  participants: [{
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  }],
  likes: [{
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  }],
  featured: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

eventSchema.virtual('participantCount').get(function() {
  return this.participants.length;
});

eventSchema.virtual('likeCount').get(function() {
  return this.likes.length;
});

eventSchema.pre(/^find/, function(next) {
  this.populate({
    path: 'organizer',
    select: 'firstName lastName profileImage'
  });
  next();
});

const Event = mongoose.model('Event', eventSchema);

module.exports = Event;
