const mongoose = require('mongoose');

const subscriptionSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Subscription must belong to a user']
  },
  type: {
    type: String,
    enum: ['trial', 'monthly', 'yearly'],
    default: 'trial'
  },
  status: {
    type: String,
    enum: ['active', 'expired', 'cancelled'],
    default: 'active'
  },
  startDate: {
    type: Date,
    default: Date.now
  },
  expiryDate: {
    type: Date,
    required: [true, 'Subscription must have an expiry date']
  },
  price: {
    type: Number,
    default: 0
  },
  features: {
    eventsPerMonth: {
      type: Number,
      default: 20
    },
    onlinePayment: {
      type: Boolean,
      default: true
    },
    reports: {
      type: Boolean,
      default: true
    },
    analytics: {
      type: Boolean,
      default: true
    },
    ticketTemplates: {
      type: Boolean,
      default: true
    },
    promotionsPerMonth: {
      type: Number,
      default: 2
    }
  }
}, {
  timestamps: true
});

const Subscription = mongoose.model('Subscription', subscriptionSchema);

module.exports = Subscription;
