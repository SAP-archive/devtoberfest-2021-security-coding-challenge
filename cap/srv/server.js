const cds = require("@sap/cds");
const cors = require("cors");
const helmet = require("helmet");

//cap.cloud.sap/docs/node.js/best-practices#cross-origin-resource-sharing-cors

cds.on("bootstrap", async (app) => {

    // default configuration
    //   {
    //   "origin": "*",
    //   "methods": "GET,HEAD,PUT,PATCH,POST,DELETE",
    //   "preflightContinue": false,
    //   "optionsSuccessStatus": 204
    // }

    // Add CORS
    app.use(cors())

    // Add A Content Security Policy
    app.use(helmet({
        contentSecurityPolicy: {
            directives: {
                ...helmet.contentSecurityPolicy.getDefaultDirectives(),
                // custom settings
            }
        }
    }))

    // app.get("/simple-cors", cors(), (req, res) => {
    //   console.info("GET /simple-cors");
    //   res.json({
    //     text: "Simple CORS requests are working. [GET]"
    //   });
    // });
});
module.exports = cds.server;