const dotenv = require("dotenv");
dotenv.config();

const places = require("./data/agra-delhi.json");
const pincodes = require("./data/pincodes.json");
const districts = require("./data/data.json");

const express = require("express");

const app = express();

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "http://localhost:3000");
  res.header("Access-Control-Allow-Credentials", "true");
  res.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, x-auth-token"
  );
  next();
});

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/api/touristSites/:districtID", (req, res) => {
  const districtID = req.params.districtID;
  const touristSites = places[districtID].touristSights;
  res.json(touristSites);
});

app.get("/api/utilities/:districtID", (req, res) => {
  const districtID = req.params.districtID;
  const utilities = places[districtID].utils;
  res.json(utilities);
});

app.get("/api/toDistrict/:pincode", (req, res) => {
  const p = req.params.pincode;

  let pincode;
  pincodes.forEach((pin) => {
    if (pin.pincode == p) {
      pincode = pin;
    }
  });

  let district;
  Object.values(districts).forEach((s) => {
    s.districts.forEach((d) => {
      if (d.district_name == pincode.districtName) {
        console.log(d);
        district = d;
      }
    });
  });

  res.send(district);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server Listening on port ${port}`);
});
