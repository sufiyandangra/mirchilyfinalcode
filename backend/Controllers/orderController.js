// controllers/orderController.js
const Order = require('../models/Order');
const Product = require('../models/Product');
const Cart = require('../models/Cart');

// Create a new order
exports.createOrder = async (req, res) => {
  try {
    const userId = req.body.user_id; // Obtain user_id directly from request body
    const cartItems = await Cart.find({ user_id: userId });

    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'Cart is empty, cannot place order' });
    }

    // Calculate total amount
    let totalAmount = 0;
    const productsInOrder = [];
    for (const item of cartItems) {
      const product = await Product.findById(item.product_id);
      if (!product) {
        return res.status(404).json({ message: 'Product not found' });
      }
      totalAmount += product.price * item.quantity;
      productsInOrder.push({ product_id: product._id, quantity: item.quantity });
    }

    // Create the order
    const newOrder = new Order({
      user_id: userId,
      products: productsInOrder,
      total_amount: totalAmount,
      status: 'Pending',
    });
    await newOrder.save();

    // Clear user's cart after placing the order
    await Cart.deleteMany({ user_id: userId });

    res.status(201).json({ message: 'Order placed successfully', order: newOrder });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all orders for a user
exports.getUserOrders = async (req, res) => {
  try {
    const userId = req.query.user_id; // Obtain user_id directly from query parameters
    const orders = await Order.find({ user_id: userId }).populate('products.product_id');
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all orders (Admin access)
exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find().populate('products.product_id');
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update order status (Admin access)
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status } = req.body;

    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    order.status = status;
    await order.save();

    res.json({ message: 'Order status updated', order });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
