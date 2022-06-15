const User = require('../models/user');

exports.login = (req, res, next) => {
  User.login(req.query.firebaseId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.createAccount = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    User.createAccount(req.body.firebaseId, req.body.name, req.body.userName, req.body.email, req.body.phoneNumber, req.body.countryId, req.body.cityId, req.body.districtId, (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.leaveHouse = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    User.leaveHouse(req.body.houseId, req.body.userId, req.body.photo, (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.rentHouse = (req, res, next) => {
  User.rentHouse(req.query.houseId, req.query.userId, req.query.rentType, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      if(result == undefined || result == null || result.errno){
        res.status(404).send({
          status: 404,
          success: false,
          message: "House not found",
          rentId: null
        });
      }else {
        res.status(result.status).send(result);
      }
    }
  });
};

exports.sendMessage = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    User.sendMessage(req.body.userId, req.body.houseId, req.body.message, (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};
