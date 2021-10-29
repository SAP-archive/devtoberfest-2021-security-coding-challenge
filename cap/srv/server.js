const cds = require("@sap/cds");
const cors = require("cors");
const helmet = require("helmet");
cds.on('bootstrap', (app) => {
    
    app.use(cors())
    app.use(
        helmet({
          contentSecurityPolicy: {
            directives: {
              ...helmet.contentSecurityPolicy.getDefaultDirectives(),
            },
          },
        })
      );
   
})

module.exports = cds.server
