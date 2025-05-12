// App.tsx
import React, { useState, useEffect } from 'react';
import './App.css';

interface Task {
    id: number;
    title: string;
    completed: boolean;
}

// @todo добавить забавных изображений для галочки Object Storage
function App() {
    const [tasks, setTasks] = useState<Task[]>([]);
    const [newTask, setNewTask] = useState<string>('');

    useEffect(() => {
        fetchTasks();
    }, []);

    const fetchTasks = async (): Promise<void> => {
        try {
            const response = await fetch('http://localhost:3000/api/tasks');
            const data: Task[] = await response.json();
            setTasks(data);
        } catch (error) {
            console.error('Error fetching tasks:', error);
        }
    };

    const addTask = async (e: React.FormEvent): Promise<void> => {
        e.preventDefault();
        if (!newTask.trim()) return;

        try {
            const response = await fetch('http://localhost:3000/api/tasks', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ title: newTask }),
            });
            const data: Task = await response.json();
            setTasks([...tasks, data]);
            setNewTask('');
        } catch (error) {
            console.error('Error adding task:', error);
        }
    };

    const toggleTask = async (id: number, completed: boolean): Promise<void> => {
        try {
            await fetch(`http://localhost:3000/api/tasks/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ completed: !completed }),
            });
            fetchTasks();
        } catch (error) {
            console.error('Error updating task:', error);
        }
    };

    const deleteTask = async (id: number): Promise<void> => {
        try {
            await fetch(`http://localhost:3000/api/tasks/${id}`, {
                method: 'DELETE',
            });
            setTasks(tasks.filter(task => task.id !== id));
        } catch (error) {
            console.error('Error deleting task:', error);
        }
    };

    return (
        <div className="app">
            <h1>Todo List</h1>

            <form onSubmit={addTask} className="task-form">
                <input
                    type="text"
                    value={newTask}
                    onChange={(e) => setNewTask(e.target.value)}
                    placeholder="New task..."
                />
                <button type="submit">Add Task</button>
            </form>

            <div className="task-list">
                {tasks.map(task => (
                    <div key={task.id} className={`task-item ${task.completed ? 'completed' : ''}`}>
                        <input
                            type="checkbox"
                            checked={task.completed}
                            onChange={() => toggleTask(task.id, task.completed)}
                        />
                        <span>{task.title}</span>
                        <button
                            onClick={() => deleteTask(task.id)}
                            className="delete-btn"
                        >
                            Delete
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default App;