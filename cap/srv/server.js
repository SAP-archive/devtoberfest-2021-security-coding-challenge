const cds = require("@sap/cds");
const cors = require("cors");

cds.on("bootstrap", (app) => {
  var corsOptions = {
    origin: "http://localhost:4004",
    optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
  };

  app.use(cors(corsOptions));
});

module.exports = cds.server;
