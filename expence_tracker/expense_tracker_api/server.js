const express = require('express');
const app = express();
const cors = require('cors');

// Middleware
app.use(express.json());
app.use(cors());

// In-memory data storage
let transactions = [];
let categories = ['Food', 'Transport', 'Entertainment', 'Bills', 'Income'];
let budgets = [];

// Routes

// Get all transactions
app.get('/api/transactions', (req, res) => {
    res.json(transactions);
});

// Add a transaction
app.post('/api/transactions', (req, res) => {
    const { title, amount, type, category } = req.body;
    const newTransaction = {
        id: transactions.length + 1,
        title,
        amount,
        type, // 'income' or 'expense'
        category,
        date: new Date(),
    };
    transactions.push(newTransaction);
    res.status(201).json(newTransaction);
});

// Delete a transaction
app.delete('/api/transactions/:id', (req, res) => {
    const transactionId = parseInt(req.params.id);
    transactions = transactions.filter(transaction => transaction.id !== transactionId);
    res.status(204).send();
});

// Get all categories
app.get('/api/categories', (req, res) => {
    res.json(categories);
});

// Add a category
app.post('/api/categories', (req, res) => {
    const { name } = req.body;
    if (!categories.includes(name)) {
        categories.push(name);
        res.status(201).json({ message: 'Category added', categories });
    } else {
        res.status(400).json({ message: 'Category already exists' });
    }
});

// Get all budgets
app.get('/api/budgets', (req, res) => {
    res.json(budgets);
});

// Set a budget
app.post('/api/budgets', (req, res) => {
    const { category, limit } = req.body;
    const existingBudget = budgets.find(budget => budget.category === category);
    if (existingBudget) {
        existingBudget.limit = limit;
        res.status(200).json({ message: 'Budget updated', budgets });
    } else {
        budgets.push({ category, limit });
        res.status(201).json({ message: 'Budget set', budgets });
    }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
