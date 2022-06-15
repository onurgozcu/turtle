const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.get('/login', userController.login);
router.post('/createAccount', userController.createAccount);
router.post('/rentHouse', userController.rentHouse);
router.patch('/leaveHouse', userController.leaveHouse)
router.post('/sendMessage', userController.sendMessage);

module.exports = router;
