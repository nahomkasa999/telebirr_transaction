const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

app.use(cors());

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());

// In-memory storage for transactions
let transactions = [];

// Endpoint to receive transaction data
app.post('/transactions', (req, res) => {
  const { transactionId, paidPrice } = req.body;

  if (!transactionId || !paidPrice) {
    return res.status(400).json({ error: 'Missing transactionId or paidPrice' });
  }

  transactions.push({ transactionId, paidPrice });
  console.log(transactions)
  res.status(201).json({ message: 'Transaction added successfully' });
});

// Endpoint to fetch all transactions
app.get('/transactions', (req, res) => {
  res.status(200).json(transactions);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});