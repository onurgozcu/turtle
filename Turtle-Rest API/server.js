const express = require('express');
const server = express();
const morgan = require('morgan');
const bodyParser = require('body-parser');

//routes
userRoutes = require('./api/routes/users');
locationRoutes = require('./api/routes/locations');
houseRoutes = require('./api/routes/houses');

//logging
server.use(morgan('dev'));

//parsing
server.use(bodyParser.urlencoded({
  limit: '50mb',
  extended: false
}));
server.use(bodyParser.json());

//handling CORS errors
server.use((req, res, next) => {
  //give access for every request
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  //browsers generally sends options request to check is it working
  if (req.method == 'OPTIONS') {
    res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
    return res.status(200).json({});
  }
  next();
});

//check bearer
server.use((req, res, next) => {
  if (req.headers.authorization == null || req.headers.authorization == undefined || req.headers.authorization != "Bearer xxx") {
    console.log(req.headers.authorization);
    return res.status(403).json({ error: 'Invalid credentials sent!' });
  }
  next();
});

//routes
server.use('/turtle/api/user', userRoutes);
server.use('/turtle/api/location', locationRoutes);
server.use('/turtle/api/house', houseRoutes);

//Error handling
server.use((req, res, next) => {
  const error = new Error('Not Found');
  error.status = 404;
  next(error);
});

server.use((error, req, res, next) => {
  res.status(error.status || 500);
  res.json({
    status: error.status,
    success: false,
    error: {
      message: error.message
    }
  });
});

module.exports = server;
