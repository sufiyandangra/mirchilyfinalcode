const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  total_amount: Number,
  status: { type: String, enum: ['pending', 'delivered'], default: 'pending' },
  payment_status: { type: String, enum: ['paid', 'unpaid'], default: 'unpaid' },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Order', orderSchema);
