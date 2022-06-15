const Location = require('../models/location');

exports.getCountries = (req, res, next) => {
  Location.getCountries((err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getCities = (req, res, next) => {
  Location.getCities(req.query.countryId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getDistricts = (req, res, next) => {
  Location.getDistricts(req.query.cityId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};
