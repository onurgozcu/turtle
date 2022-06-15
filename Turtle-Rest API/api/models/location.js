var dbConn = require('../config/dbConfig');

var Location = {}

Location.getCountries = (result) => {
  dbConn.query("SELECT * FROM countries", (err, countries) => {
    if (err) {
      console.log("Error occured while fetching countries. => Location Model", err);
      result(null, err);
    } else {
      console.log("Countries fetched successfully");
      result(null, {
        status: 200,
        success: true,
        countries: countries
      });
    }
  });
};

Location.getCities = (countryId, result) => {
  dbConn.query("SELECT * FROM cities WHERE countryId = ?", countryId, (err, cities) => {
    if (err) {
      console.log("Error occured while fetching cities. => Location Model", err);
      result(null, err);
    } else {
      console.log("Cities fetched successfully");
      result(null, {
        status: 200,
        success: true,
        cities: cities
      });
    }
  });
};

Location.getDistricts = (cityId, result) => {
  dbConn.query("SELECT * FROM districts WHERE cityId = ?", cityId, (err, districts) => {
    if (err) {
      console.log("Error occured while fetching districts. => Location Model", err);
      result(null, err);
    } else {
      console.log("Districts fetched successfully");
      result(null, {
        status: 200,
        success: true,
        districts: districts
      });
    }
  });
};


module.exports = Location;
