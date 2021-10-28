const cds = require("@sap/cds");
const cors = require("cors");
const helmet = require("helmet");

cds.on("bootstrap", (app) => {
  //cors security
  app.use(cors());
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

