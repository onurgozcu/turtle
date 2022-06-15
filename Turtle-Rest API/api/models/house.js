var dbConn = require('../config/dbConfig');
var mqtt = require('mqtt');
var House = {}

House.getHousesViaDistrictId = (districtId, result) => {
  dbConn.query("SELECT * FROM houses WHERE status = 'active' AND districtId = ?", districtId, (err, houses) => {
    if (err) {
      console.log("Error occured while fetching houses via districtId. => House Model", err);
      result(null, err);
    } else {
      console.log("Houses fetched successfully via districtId.");
      result(null, {
        status: 200,
        success: true,
        houses: houses
      });
    }
  });
};

House.getPhotos = (houseId, result) => {
  dbConn.query("SELECT * FROM housephotos WHERE houseId = ? AND type = 'house'", houseId, (err, photos) => {
    if (err) {
      console.log("Error occured while fetching house's photos. => House Model", err);
      result(null, err);
    } else {
      console.log("House's photos fetched successfully.");
      result(null, {
        status: 200,
        success: true,
        photos: photos
      });
    }
  });
};

House.addHouse = (title, priceDaily, priceMonthly, latCoordinate, longCoordinate, hasInternet, hasHeater, hasTv, hasLaundry, hasKitchen, doubleBedCount, singleBedCount, singleSeatCount, doubleSeatCount, tripleSeatCount, peopleStayCount, countryId, cityId, districtId, userId, result) => {
  var houseValues = [title, priceDaily, priceMonthly, latCoordinate, longCoordinate, hasInternet, hasHeater, hasTv, hasLaundry, hasKitchen, doubleBedCount, singleBedCount, singleSeatCount, doubleSeatCount, tripleSeatCount, peopleStayCount, countryId, cityId, districtId];
  dbConn.query("INSERT INTO houses (title, priceDaily, priceMonthly, latCoordinate, longCoordinate, hasInternet, hasHeater, hasTv, hasLaundry, hasKitchen, doubleBedCount, singleBedCount, singleSeatCount, doubleSeatCount, tripleSeatCount, peopleStayCount, countryId, cityId, districtId) VALUES ?", [[houseValues]], (err, res) => {
    if (err) {
      console.log("Error occured while adding house. => House Model", err);
      result(null, err);
    } else {
      console.log("House saved successfully.");
      House.addOwner(res.insertId, userId, (err, ownRes) => {
        if(err) {
          console.log("Error occured while adding house. (owner add)=> House Model", err);
          result(null, err);
        }else {
          result(null,{
            status: 200,
            success: true,
            houseId: res.insertId,
            ownershipId: ownRes.insertId,
            userId: userId
          })
        }
      });
    }
  });
};

House.addOwner = (houseId, ownerId, result) => {
  dbConn.query("INSERT INTO owns (houseId, userId) VALUES (?,?)", [houseId, ownerId], (err, res) => {
    if (err) {
      console.log("Error occured while adding owner. => House Model", err);
      result(null, err);
    } else {
      console.log("Owner saved successfully.");
      result(null,{
        status: 200,
        success: true,
        insertId: res.insertId
      });
    }
  });
};

House.addPhoto = (houseId, photo, type, result) => {
  dbConn.query("INSERT INTO housephotos (houseId, photo, type) VALUES (?, ?, ?)", [houseId, photo, type], (err, res) => {
    if (err) {
      console.log("Error occured while adding photos for a house. => House Model", err);
      result(null, err);
    } else {
      console.log("House photos saved successfully.");
      result(null,{
        status: 200,
        success: true
      });
    }
  });
};

House.deleteHouse = (id, result) => {
  dbConn.query("SELECT * FROM rents WHERE houseId = ? AND endsAt > now()", id, (err, res) => {
    if (err) {
      console.log("Error occured while deleting house. (tenant control)() => House Model", err);
      result(null, err);
    }else {
      if(res.length > 0){
        console.log("House can not delete, because there is a tenant.");
        result(null,{
          status: 200,
          success: false
        });
      }else {
        dbConn.query("DELETE FROM houses WHERE id = ?", id, (err, res) => {
          if (err) {
            console.log("Error occured while deleting house. => House Model", err);
            result(null, err);
          } else {
            console.log("House deleted successfully.");
            result(null,{
              status: 200,
              success: true
            });
          }
        });
      }
    }
  });
};

House.deletePhoto = (id, result) => {
  dbConn.query("DELETE FROM housephotos WHERE id = ?", id, (err, res) => {
    if (err) {
      console.log("Error occured while deleting photo of a house. => House Model", err);
      result(null, err);
    } else {
      console.log("House's photo deleted successfully.");
      result(null,{
        status: 200,
        success: true
      });
    }
  });
};

House.searchHouse = (searchQueries, result) => {
  var queryString = "SELECT * FROM houses WHERE status = 'active'";
  var keys = Object.keys(searchQueries);
  keys.forEach((key) => {
    if(key == "maxPriceDaily"){
      queryString += " AND priceDaily <= " + searchQueries.maxPriceDaily;
    }else if(key == "maxPriceMonthly"){
      queryString += " AND priceMonthly <= " + searchQueries.maxPriceMonthly;
    }else if(key == "minPriceDaily"){
      queryString += " AND priceDaily >= " + searchQueries.minPriceDaily;
    }else if(key == "minPriceMonthly"){
      queryString += " AND priceMonthly >= " + searchQueries.minPriceMonthly;
    }else if(key == "hasInternet"){
      queryString += " AND hasInternet = " + searchQueries.hasInternet;
    }else if(key == "hasHeater"){
      queryString += " AND hasHeater = " + searchQueries.hasHeater;
    }else if(key == "hasTv"){
      queryString += " AND hasTv = " + searchQueries.hasTv;
    }else if(key == "hasLaundry"){
      queryString += " AND hasLaundry = " + searchQueries.hasLaundry;
    }else if(key == "hasKitchen"){
      queryString += " AND hasKitchen = " + searchQueries.hasKitchen;
    }else if(key == "singleBedCount"){
      queryString += " AND singleBedCount >= " + searchQueries.singleBedCount;
    }else if(key == "doubleBedCount"){
      queryString += " AND doubleBedCount >= " + searchQueries.doubleBedCount;
    }else if(key == "singleSeatCount"){
      queryString += " AND singleSeatCount >= " + searchQueries.singleSeatCount;
    }else if(key == "doubleSeatCount"){
      queryString += " AND doubleSeatCount >= " + searchQueries.doubleSeatCount;
    }else if(key == "tripleSeatCount"){
      queryString += " AND tripleSeatCount >= " + searchQueries.tripleSeatCount;
    }else if(key == "minPeopleStay"){
      queryString += " AND peopleStayCount >= " + searchQueries.minPeopleStay;
    }else if(key == "countryId"){
      queryString += " AND countryId = " + searchQueries.countryId;
    }else if(key == "cityId"){
      queryString += " AND cityId = " + searchQueries.cityId;
    }else if(key == "districtId"){
      queryString += " AND districtId = " + searchQueries.districtId;
    }else if(key == "title"){
      queryString += " AND title = '%" + searchQueries.title + "%'";
    }
  })
  dbConn.query(queryString, (err, houses) => {
    if (err) {
      console.log("Error occured while fetching searching houses. => House Model", err);
      result(null, err);
    } else {
      console.log("Houses searched successfully.");
      result(null, {
        status: 200,
        success: true,
        houses: houses
      });
    }
  });
};

House.changeLockStatus = (id, isLocked, result) => {
  var client = mqtt.connect('mqtt://localhost:1883');
  client.on('connect', function() {
    client.subscribe(id + '-house', (err) => {
      if(err){
        console.log("Error occured while updating lock status of a house. (mqtt subscribe) => House Model", err);
      }else {
        client.publish(id + '-house', (isLocked == 1 ? 'lock' : 'open'));
        dbConn.query("UPDATE houses SET isLocked = ? WHERE id = ?", [isLocked, id], (err, res) => {
          if (err) {
            console.log("Error occured while updating lock status of a house. => House Model", err);
            result(null, err);
          } else {
            console.log("House's lock status updated successfully.");
            result(null,{
              status: 200,
              success: true
            });
          }
        });
      }
    })
  });
};

House.getOwnerHouses = (userId, result) => {
  dbConn.query("SELECT houses.* FROM owns LEFT JOIN houses ON owns.houseId = houses.id WHERE owns.userId = ?", userId, (err, houses) => {
    if (err) {
      console.log("Error occured while fetching user's owned houses. => House Model", err);
      result(null, err);
    } else {
      console.log("User's owned houses fetched successfully.");
      result(null, {
        status: 200,
        success: true,
        houses: houses
      });
    }
  });
};

House.getHouseMessages = (houseId, result) => {
  dbConn.query("SELECT * FROM housemessages WHERE houseId = ?", houseId, (err, messages) => {
    if (err) {
      console.log("Error occured while fetching house messages. => House Model", err);
      result(null, err);
    } else {
      console.log("House messages fetched successfully.");
      result(null, {
        status: 200,
        success: true,
        messages: messages
      });
    }
  });
};


module.exports = House;
