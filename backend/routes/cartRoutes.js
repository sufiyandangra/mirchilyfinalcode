// routes/cartRoutes.js
const express = require('express');
const cartController = require('../controllers/cartController');
const router = express.Router();

router.post('/', cartController.addToCart);
router.get('/', cartController.getCartItems);
router.delete('/:cartItemId', cartController.removeFromCart);
router.put('/:cartItemId', cartController.updateCartItemQuantity);

module.exports = router;
