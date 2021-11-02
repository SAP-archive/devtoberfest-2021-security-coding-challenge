const cds = require("@sap/cds");
const cors = require("cors");
const helmet = require("helmet");
const cds_swagger = require("cds-swagger-ui-express");

cds.on("bootstrap", (app) => {
  app.use(cors());
  app.use(helmet());
  if (process.env.NODE_ENV !== "production") {
    app.use(cds_swagger());
  }
});

module.exports = cds.server;
