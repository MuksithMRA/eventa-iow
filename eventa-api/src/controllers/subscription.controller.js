const Subscription = require('../models/subscription.model');
const User = require('../models/user.model');

exports.startTrial = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const existingSubscription = await Subscription.findOne({
      user: userId,
      status: 'active'
    });
    
    if (existingSubscription) {
      return res.status(400).json({
        success: false,
        message: 'You already have an active subscription'
      });
    }
    
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 14);
    
    const subscription = await Subscription.create({
      user: userId,
      type: 'trial',
      status: 'active',
      startDate: new Date(),
      expiryDate,
      price: 0,
      features: {
        eventsPerMonth: 20,
        onlinePayment: true,
        reports: true,
        analytics: true,
        ticketTemplates: true,
        promotionsPerMonth: 2
      }
    });
    
    return res.status(201).json({
      success: true,
      message: 'Trial subscription started successfully',
      subscriptionId: subscription._id,
      expiryDate: expiryDate.toISOString()
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error starting trial subscription',
      error: error.message
    });
  }
};

exports.getSubscription = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const subscription = await Subscription.findOne({
      user: userId,
      status: 'active'
    });
    
    if (!subscription) {
      return res.status(404).json({
        success: false,
        message: 'No active subscription found'
      });
    }
    
    return res.status(200).json({
      success: true,
      subscription
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error fetching subscription',
      error: error.message
    });
  }
};

exports.cancelSubscription = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const subscription = await Subscription.findOne({
      user: userId,
      status: 'active'
    });
    
    if (!subscription) {
      return res.status(404).json({
        success: false,
        message: 'No active subscription found'
      });
    }
    
    subscription.status = 'cancelled';
    await subscription.save();
    
    return res.status(200).json({
      success: true,
      message: 'Subscription cancelled successfully'
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error cancelling subscription',
      error: error.message
    });
  }
};
