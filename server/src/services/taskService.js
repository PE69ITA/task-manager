const prisma = require('../lib/prisma');

const getAllTasks = async () => {
    return prisma.task.findMany({
        orderBy: {
            createdAt: 'desc'
        }
    });
};

const getTaskById = async (id) => {
    return prisma.task.findUnique({
        where: { id }
    });
};

const createTask = async (data) => {
    return prisma.task.create({
        data: {
            title: data.title,
            description: data.description
        }
    });
};

const updateTask = async (id, data) => {
    return prisma.task.update({
        where: { id },
        data
    });
};

const deleteTask = async (id) => {
    return prisma.task.delete({
        where: { id }
    });
};

module.exports = {
    getAllTasks,
    getTaskById,
    createTask,
    updateTask,
    deleteTask
};