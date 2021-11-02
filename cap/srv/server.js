const cds = require("@sap/cds");
const helmet = require("helmet");
const cors = require("cors");

cds.on("bootstrap", (app) => {
  if (process.env.NODE_ENV !== "production") {
    app.use(cors()); // skiping more configuration for simplicity
  }

  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          ...helmet.contentSecurityPolicy.getDefaultDirectives(),
          // some custom ones
        },
      },
    })
  );
});

module.exports = cds.server;
