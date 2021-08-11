const districts = require('./districts.json');
const fs = require("fs")

const newDistricts = []

Object.values(districts).forEach(s => {
    const n = s.name
s.districts.forEach(d => {
        const newDistrict = {
            name: `${d.district_name}, ${n}`,
            id: d.district_id
        }
        newDistricts.push(newDistrict)
    })
});

console.log(newDistricts)

fs.writeFileSync("./districtsNew.json", JSON.stringify(newDistricts))