 const express = require('express');
 const orderController = require('../controllers/orderController');
 const router = express.Router();

 router.post('/', orderController.createOrder);
 router.get('/', orderController.getUserOrders);
 router.get('/all', orderController.getAllOrders); // Admin only
 router.put('/:orderId', orderController.updateOrderStatus); // Admin only

 module.exports = router;
