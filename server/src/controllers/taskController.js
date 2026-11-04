const taskService = require('../services/taskService');

const getAllTasks = async (req, res) => {
    try {
        const tasks = await taskService.getAllTasks();
        res.status(200).json(tasks);
    } catch (error) {
        res.status(500).json({ message: 'Failed to fetch tasks' });
    }
};

const getTaskById = async (req, res) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({ message: 'Invalid task ID' });
        }

        const task = await taskService.getTaskById(id);

        if (!task) {
            return res.status(404).json({ message: 'Task not found' });
        }

        res.status(200).json(task);
    } catch (error) {
        res.status(500).json({ message: 'Failed to fetch task' });
    }
};

const createTask = async (req, res) => {
    try {
        const { title, description } = req.body;

        if (typeof title !== 'string' || !title.trim()) {
            return res.status(400).json({ message: 'Title is required' });
        }

        const task = await taskService.createTask({
            title: title.trim(),
            description
        });

        res.status(201).json(task);
    } catch (error) {
        res.status(500).json({ message: 'Failed to create task' });
    }
};

const updateTask = async (req, res) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({ message: 'Invalid task ID' });
        }

        const { title, description, status } = req.body;
        const data = {};

        if (title !== undefined) {
            if (typeof title !== 'string' || !title.trim()) {
                return res.status(400).json({ message: 'Invalid title' });
            }
            data.title = title.trim();
        }

        if (description !== undefined) {
            if (description !== null && typeof description !== 'string') {
                return res.status(400).json({ message: 'Invalid description' });
            }
            data.description = description;
        }

        if (status !== undefined) {
            const allowedStatuses = ['TODO', 'IN_PROGRESS', 'DONE'];

            if (!allowedStatuses.includes(status)) {
                return res.status(400).json({ message: 'Invalid status' });
            }
            data.status = status;
        }

        if (Object.keys(data).length === 0) {
            return res.status(400).json({ message: 'No fields to update' });
        }

        const existingTask = await taskService.getTaskById(id);

        if (!existingTask) {
            return res.status(404).json({ message: 'Task not found' });
        }

        const updatedTask = await taskService.updateTask(id, data);

        res.status(200).json(updatedTask);
    } catch (error) {
        res.status(500).json({ message: 'Failed to update task' });
    }
};

const deleteTask = async (req, res) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({ message: 'Invalid task ID' });
        }

        const existingTask = await taskService.getTaskById(id);

        if (!existingTask) {
            return res.status(404).json({ message: 'Task not found' });
        }

        await taskService.deleteTask(id);

        res.status(200).json({
            message: 'Task deleted successfully'
        });
    } catch (error) {
        res.status(500).json({ message: 'Failed to delete task' });
    }
};

module.exports = {
    getAllTasks,
    getTaskById,
    createTask,
    updateTask,
    deleteTask
};