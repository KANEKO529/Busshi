import express from 'express';
import sqlite3 from 'sqlite3';

const app = express();
const port = 3000;

const db = new sqlite3.Database('db/migrate/development.sqlite3');

app.get('/api/user-products', (req, res) => {
    db.all('SELECT * FROM user_products', [], (err, rows) => {
        if (err) {
            res.status(400).json({ error: err.message });
            return;
        }
        res.json({
            data: rows
        });
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
