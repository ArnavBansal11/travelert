const dotenv = require("dotenv");
dotenv.config();

const places = require("./data/agra-delhi.json");
const pincodes = require("./data/pincodes.json");
const districts = require("./data/data.json");
const music = require("./data/music.json");

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
app.use("/cdn", express.static(__dirname + "/public"));

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/api/touristSites/:districtID", (req, res) => {
  const districtID = req.params.districtID;
  const touristSites = places[districtID]?.touristSights;
  if (!touristSites) return res.json([]);
  res.json(touristSites);
});

app.get("/api/utilities/:districtID", (req, res) => {
  const districtID = req.params.districtID;
  const utilities = places[districtID]?.utils;
  if (!utilities) return res.json([]);
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
        district = {
          district_id: d.district_id,
          district_name: `${d.district_name}, ${s.name}`,
        };
      }
    });
  });

  res.send(district);
});

app.get("/api/music/popular", (req, res) => {
  const musicSend = [];
  Object.values(music).forEach((s) => {
    s.forEach((m) => musicSend.push(m));
  });

  res.send(musicSend);
});

app.get("/api/music/:id", (req, res) => {
  res.send(music[req.params.id]);
});

app.get("/api/getNearby/:lat/:long/:pin", (req, res) => {
  const p = req.params.pin;

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
        district = {
          district_id: d.district_id,
          district_name: `${d.district_name}, ${s.name}`,
        };
      }
    });
  });

  const dId = district.district_id;

  res.send(places[dId][0]);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server Listening on port ${port}`);
});
