const House = require('../models/house');

exports.getHousesViaDistrictId = (req, res, next) => {
  House.getHousesViaDistrictId(req.query.districtId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getPhotos = (req, res, next) => {
  House.getPhotos(req.query.houseId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};


exports.addHouse = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    House.addHouse(req.body.title, req.body.priceDaily, req.body.priceMonthly, req.body.latCoordinate, req.body.longCoordinate, req.body.hasInternet, req.body.hasHeater, req.body.hasTv, req.body.hasLaundry, req.body.hasKitchen, req.body.doubleBedCount, req.body.singleBedCount, req.body.singleSeatCount, req.body.doubleSeatCount, req.body.tripleSeatCount, req.body.peopleStayCount, req.body.countryId, req.body.cityId, req.body.districtId, req.body.userId, (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.addPhoto = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    House.addPhoto(req.body.houseId, req.body.photo, "house", (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.deleteHouse = (req, res, next) => {
  House.deleteHouse(req.query.houseId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.deletePhoto = (req, res, next) => {
  House.deletePhoto(req.query.photoId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.searchHouse = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    console.log(JSON.parse(req.body.searchCriterias));
    House.searchHouse(JSON.parse(req.body.searchCriterias), (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.changeLockStatus = (req, res, next) => {
  House.changeLockStatus(req.query.houseId, req.query.lockStatus, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getOwnerHouses = (req, res, next) => {
  House.getOwnerHouses(req.query.userId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getHouseMessages = (req, res, next) => {
  House.getHouseMessages(req.query.houseId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};
