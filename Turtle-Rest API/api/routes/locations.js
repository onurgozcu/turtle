const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');

router.get('/getCountries', locationController.getCountries);
router.get('/getCities', locationController.getCities);
router.get('/getDistricts', locationController.getDistricts);

module.exports = router;
