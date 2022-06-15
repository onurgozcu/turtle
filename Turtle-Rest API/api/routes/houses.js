const express = require('express');
const router = express.Router();
const houseController = require('../controllers/houseController');

router.get('/getHousesViaDistrictId', houseController.getHousesViaDistrictId);
router.get('/getPhotos', houseController.getPhotos);
router.post('/addHouse', houseController.addHouse);
router.post('/addPhoto', houseController.addPhoto);
router.delete('/deleteHouse', houseController.deleteHouse);
router.delete('/deletePhoto', houseController.deletePhoto);
router.patch('/searchHouse', houseController.searchHouse);
router.patch('/changeLockStatus', houseController.changeLockStatus);
router.get('/getOwnerHouses', houseController.getOwnerHouses);
router.get('/getHouseMessages', houseController.getHouseMessages);

module.exports = router;
