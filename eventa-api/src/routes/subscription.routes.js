const express = require('express');
const subscriptionController = require('../controllers/subscription.controller');
const authMiddleware = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware.protect);

router.post('/trial', subscriptionController.startTrial);

router.get('/current', subscriptionController.getSubscription);

router.patch('/cancel', subscriptionController.cancelSubscription);

module.exports = router;
