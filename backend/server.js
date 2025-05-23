// server.js
const express = require('express');
const fs = require("fs");

const { Pool } = require('pg');

require('dotenv').config();

const app = express();
app.use(express.json());

console.log(process.env.PG_LINK)

const pool = new Pool({
  connectionString:  process.env.PG_LINK,
  ssl: {
    rejectUnauthorized: false,
    ca: fs
      .readFileSync("/root/.postgresql/root.crt")
      .toString(),
  },
});

  pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err)
    process.exit(-1)
  })

  pool.connect( (err, connection) => {
    if (err) throw err;
    console.log('Database is connected successfully !');
    connection.release();
  });

// Создание таблицы (один раз)
const createTable = async () => {
  const query = `
    CREATE TABLE IF NOT EXISTS tasks (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      completed BOOLEAN DEFAULT false
    );
  `;
  await pool.query(query);
};

createTable();

// Получить все задачи
app.get('/api/tasks', async (req, res) => {
  const result = await pool.query('SELECT * FROM tasks');
  res.json(result.rows);
});

// Создать задачу
app.post('/api/tasks', async (req, res) => {
  const { title } = req.body;
  const result = await pool.query(
    'INSERT INTO tasks (title) VALUES ($1) RETURNING *',
    [title]
  );
  res.status(201).json(result.rows[0]);
});

// Обновить задачу
app.put('/api/tasks/:id', async (req, res) => {
    const { id } = req.params;
    const { title, completed } = req.body;

    // Формируем динамический запрос
    const fields = [];
    const values = [];
    let counter = 1;

    if (title !== undefined) {
      fields.push(`title = $${counter++}`);
      values.push(title);
    }
    if (completed !== undefined) {
      fields.push(`completed = $${counter++}`);
      values.push(completed);
    }

    if (fields.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    values.push(id);

    try {
      const result = await pool.query(
        `UPDATE tasks SET ${fields.join(', ')} WHERE id = $${counter} RETURNING *`,
        values
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Task not found' });
      }

      res.json(result.rows[0]);
    } catch (err) {
      console.error('Update error:', err.message);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

// Удалить задачу
app.delete('/api/tasks/:id', async (req, res) => {
  const { id } = req.params;
  await pool.query('DELETE FROM tasks WHERE id = $1', [id]);
  res.sendStatus(204);
});

// Запуск сервера
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
