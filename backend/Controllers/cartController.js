// controllers/cartController.js
const Cart = require('../models/Cart');
const Product = require('../models/Product');

// Add item to cart
exports.addToCart = async (req, res) => {
  try {
    const userId = req.body.user_id; // Obtain user_id directly from request body
    const { productId, quantity } = req.body;

    // Check if product exists
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Check if item already exists in the cart
    const existingCartItem = await Cart.findOne({ user_id: userId, product_id: productId });
    if (existingCartItem) {
      existingCartItem.quantity += quantity;
      await existingCartItem.save();
    } else {
      const newCartItem = new Cart({
        user_id: userId,
        product_id: productId,
        quantity,
      });
      await newCartItem.save();
    }

    res.status(201).json({ message: 'Item added to cart' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get user's cart items
exports.getCartItems = async (req, res) => {
  try {
    const userId = req.query.user_id; // Obtain user_id directly from query parameters
    const cartItems = await Cart.find({ user_id: userId }).populate('product_id');
    res.json(cartItems);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Remove item from cart
exports.removeFromCart = async (req, res) => {
  try {
    const userId = req.body.user_id; // Obtain user_id directly from request body
    const { cartItemId } = req.params;

    const cartItem = await Cart.findOneAndDelete({ _id: cartItemId, user_id: userId });
    if (!cartItem) {
      return res.status(404).json({ message: 'Cart item not found' });
    }

    res.json({ message: 'Item removed from cart' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update item quantity in cart
exports.updateCartItemQuantity = async (req, res) => {
  try {
    const userId = req.body.user_id; // Obtain user_id directly from request body
    const { cartItemId } = req.params;
    const { quantity } = req.body;

    const cartItem = await Cart.findOne({ _id: cartItemId, user_id: userId });
    if (!cartItem) {
      return res.status(404).json({ message: 'Cart item not found' });
    }

    cartItem.quantity = quantity;
    await cartItem.save();

    res.json({ message: 'Cart item quantity updated', cartItem });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
