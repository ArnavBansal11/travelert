const pincodes = require("./pincodes.json");
const fs = require('fs')

const newPincodes = [];

pincodes.forEach(p => {
    if(p.districtName.includes("Delhi")){
        const newP = p
        newP.districtName = "Delhi"
        newPincodes.push(newP)
    }else{
        newPincodes.push(p);
    }
});

fs.writeFileSync("./pincodesNew.json", JSON.stringify(newPincodes))
