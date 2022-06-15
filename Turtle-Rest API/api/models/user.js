var dbConn = require('../config/dbConfig');
var House = require('./house');

var User = function(user) {
  this.id = user.id;
  this.firebaseId = user.firebaseId;
  this.name = user.name;
  this.userName = user.userName;
  this.email = user.email;
  this.phoneNumber = user.phoneNumber;
  this.isVerified = user.is_Verified;
  this.countryId = user.countryId;
  this.cityId = user.cityId;
  this.districtId = user.districtId;
  this.createdAt = user.createdAt;
  this.updatedAt = user.updatedAt;
};

User.getUserViaFirebaseId = (firebaseId, result) => {
  dbConn.query("SELECT * FROM users WHERE firebaseId = ?", firebaseId, (err, res) => {
    if (err) {
      console.log("Error occured while fetching user via firebaseId. => User Model", err);
      result(null, err);
    } else {
      var user = null;
      if(res.length > 0){
        console.log("User fetched succesfully.");
        user = res[0];
      }
      result(null,{
        status: 200,
        success: true,
        user: user
      });
    }
  });
};

User.getRentedHouse = (userId, result) => {
  dbConn.query("SELECT houses.*, rents.startsAt as rentStart, rents.endsAt as rentEnd FROM rents LEFT JOIN houses ON rents.houseId = houses.id WHERE rents.userId = ? AND rents.endsAt > now()", userId, (err, res) => {
    if (err) {
      console.log("Error occured while fetching user's rented house. => User Model", err);
      result(null, err);
    } else {
      var rentedHouse = null;
      if(res.length > 0){
        console.log("User's rented house fetched succesfully.");
        rentedHouse = res[0];
      }
      result(null,{
        status: 200,
        success: true,
        rentedHouse: rentedHouse
      });
    }
  });
}

User.login = (firebaseId, result) => {
  User.getUserViaFirebaseId(firebaseId, (err, res) => {
    if (err) {
      console.log("Error occured while login. (fetch user) => User Model", err);
      result(null, err);
    } else {
      if(res.user == null){
        console.log("User not found via login.");
        result(null,{
          status: 404,
          success: false,
          message: "User not found",
          user: null
        });
      }else {
        var user = res.user;
        User.getRentedHouse(user.id, (err, res) => {
          if (err) {
            console.log("Error occured while login. (fetch rented house) => User Model", err);
            result(null, err);
          } else {
            user.rentedHouse = res.rentedHouse;
            console.log("User logged in.");
            result(null,{
              status: 200,
              success: true,
              user: user
            });
          }
        });
      }
    }
  });
};

User.checkUserExistence = (userName, firebaseId, phoneNumber, result) => {
  dbConn.query("SELECT * FROM users WHERE userName LIKE ? OR firebaseId LIKE ? OR phoneNumber LIKE ?", [userName, firebaseId, phoneNumber], (err, res) => {
    if (err) {
      console.log("Error occured while checking user existence. => User Model", err);
      result(null, err);
    } else {
      if(res.length > 0){
        result(null, true);
      }else {
        result(null, false);
      }
    }
  });
};

User.createAccount = (firebaseId, name, userName, email, phoneNumber, countryId, cityId, districtId, result) => {
  User.checkUserExistence(userName, firebaseId, phoneNumber, (err, res) => {
    if (err) {
      console.log("Error occured while creating account. (checking existence) => User Model", err);
      result(null, err);
    } else {
      if(res === true){
        console.log("User already exists.");
        result(null, {
          status: 200,
          success: false,
          message: "This account is already in use."
        });
      }else {
        var userValues = [firebaseId, name, userName, email, phoneNumber, countryId, cityId, districtId];
        dbConn.query("INSERT INTO users (firebaseId, name, userName, email, phoneNumber, countryId, cityId, districtId) VALUES ?", [[userValues]], (err, res) => {
          if (err) {
            console.log("Error occured while creating account. (mysql insertion) => User Model", err);
            result(null, err);
          } else {
            console.log("User account succesfully created");
            User.login(firebaseId, (err, res) => {
              if (err) {
                console.log("Error occured while creating account. (login) => User Model", err);
                result(null, err);
              }else {
                result(null,{
                  status: 200,
                  success: true,
                  user: res.user
                });
              }
            });
          }
        });
      }
    }
  });
};

User.rentHouse = (houseId, userId, rentType, result) => {
  dbConn.query("UPDATE houses SET status = 'passive' WHERE id = ?", houseId, (err, res) => {
    if (err) {
      console.log("Error occured while renting a house. (update status) => User Model", err);
      result(null, err);
    } else {
      var endsAt = "current_timestamp() + INTERVAL 1 DAY";
      if(rentType == "monthly"){
        endsAt = "current_timestamp() + INTERVAL 1 MONTH";
      }
      dbConn.query("INSERT INTO rents (userId, houseId, endsAt) VALUES ("+ userId + ", " + houseId + ", " + endsAt +")", (err, res) => {
        if (err) {
          console.log("Error occured while renting a house. => User Model", err);
          result(null, err);
        } else {
          console.log("House rented successfully.");
          result(null, {
            status: 200,
            success: true,
            rentId: res.insertId
          });
        }
      });
    }
  });
};

User.leaveHouse = (houseId, userId, photo, result) => {
  House.addPhoto(houseId, photo, "lock", (err, res) => {
    if (err) {
      console.log("Error occured while leaving from a house. (adding photo) => User Model", err);
      result(null, err);
    }else {
      dbConn.query("UPDATE houses SET status = 'active' WHERE id = ?", houseId, (err, res) => {
        if (err) {
          console.log("Error occured while leaving from a house. (update status) => User Model", err);
          result(null, err);
        } else {
          House.changeLockStatus(houseId, 1, (err, res) => {
            if (err) {
              console.log("Error occured while leaving from a house. (lock door) (adding photo) => User Model", err);
              result(null, err);
            }else {
              dbConn.query("DELETE FROM rents WHERE userId = ? AND houseId = ?", [userId, houseId], (err, res) => {
                if (err) {
                  console.log("Error occured while leaving from a house. => User Model", err);
                  result(null, err);
                } else {
                  console.log("User left from house successfully.");
                  result(null, {
                    status: 200,
                    success: true
                  });
                }
              });
            }
          });
        }
      });
    }
  });
};

User.sendMessage = (senderId, houseId, message, result) => {
  dbConn.query("INSERT INTO housemessages (senderId, houseId, message) VALUES (?, ?, ?)", [senderId, houseId, message], (err, res) => {
    if (err) {
      console.log("Error occured while sending message for a house. => User Model", err);
      result(null, err);
    } else {
      console.log("Message sent successfully.");
      result(null,{
        status: 200,
        success: true
      });
    }
  });
};


module.exports = User;
