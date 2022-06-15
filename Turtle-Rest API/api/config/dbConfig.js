const mysql = require("mysql");

var config = {
  connectionLimit : 60,
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '',
  database: 'turtle_db',
  charset : 'utf8mb4',
  multipleStatements: true
}

//create database connection
var dbConn;

function handleDisconnect() {
  dbConn = mysql.createPool(config);

  dbConn.getConnection((err) => {
    if(err !== null){
      console.log('Error when connecting to db:', err);
      setTimeout(handleDisconnect, 2000);
    }else {
      console.log('Database succesfully connected');
    }
  });

  dbConn.on('error', (err) => {
    console.log('db error', err);
    if(err.code === 'PROTOCOL_CONNECTION_LOST') {
      handleDisconnect();
    }else {
      throw err;
    }
  });
}

handleDisconnect();

module.exports = dbConn;
