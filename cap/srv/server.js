const cds = require("@sap/cds");
const cors = require("cors");
const helmet = require("helmet");

cds.on("bootstrap", (app) => {
  var corsOptions = {
    origin: "http://localhost:4004",
    optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
  };

  app.use(cors(corsOptions));
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          ...helmet.contentSecurityPolicy.getDefaultDirectives(),
          // custom settings
        },
      },
    })
  );
});

module.exports = cds.server;
