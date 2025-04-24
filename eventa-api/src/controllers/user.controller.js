const User = require('../models/user.model');
const Event = require('../models/event.model');

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();

    res.status(200).json({
      status: 'success',
      results: users.length,
      data: {
        users
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        status: 'fail',
        message: 'No user found with that ID'
      });
    }

    res.status(200).json({
      status: 'success',
      data: {
        user
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.getUserEvents = async (req, res) => {
  try {
    const userId = req.params.id || req.user.id;

    const events = await Event.find({
      participants: userId,
      date: { $gte: new Date() }
    }).sort({ date: 1 });

    res.status(200).json({
      status: 'success',
      results: events.length,
      data: {
        events
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.getUserPastEvents = async (req, res) => {
  try {
    const userId = req.params.id || req.user.id;

    const events = await Event.find({
      participants: userId,
      date: { $lt: new Date() }
    }).sort({ date: -1 });

    res.status(200).json({
      status: 'success',
      results: events.length,
      data: {
        events
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.getOrganizedEvents = async (req, res) => {
  try {
    const userId = req.params.id || req.user.id;

    const events = await Event.find({ organizer: userId }).sort({ date: -1 });

    res.status(200).json({
      status: 'success',
      results: events.length,
      data: {
        events
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};

exports.getLikedEvents = async (req, res) => {
  try {
    const userId = req.params.id || req.user.id;

    const events = await Event.find({ likes: userId }).sort({ date: -1 });

    res.status(200).json({
      status: 'success',
      results: events.length,
      data: {
        events
      }
    });
  } catch (error) {
    res.status(400).json({
      status: 'fail',
      message: error.message
    });
  }
};
