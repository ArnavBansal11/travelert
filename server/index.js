const dotenv = require('dotenv');
dotenv.config();

const places = require('./agra-delhi.json');

const express = require('express');

const app = express();

app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, x-auth-token'
  );
  next();
});

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/api/touristSites/:districtID', (req, res) => {
  const districtID = req.params.districtID;
  const touristSites = places[districtID].touristSights;
  res.json(touristSites);
});

app.get('/api/utilities/:districtID', (req, res) => {
  const districtID = req.params.districtID;
  const utilities = places[districtID].utils;
  res.json(utilities);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server Listening on port ${port}`);
});
