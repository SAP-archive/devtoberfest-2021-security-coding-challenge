const cds = require ('@sap/cds')
const cors = require('cors')
const helmet = require("helmet")
cds.on('bootstrap', (app) => {
    app.use(cors())
    app.use(helmet({
        contentSecurityPolicy: {
          directives: {
            ...helmet.contentSecurityPolicy.getDefaultDirectives(),
            // custom settings
            "default-src": ["'self'"],
            "connect-src": ["'self'", "https://sapui5.hana.ondemand.com/"],
            "script-src": ["'self'", "'unsafe-inline'","'unsafe-eval'", "http://localhost:4004/", "https://sapui5.hana.ondemand.com/"],
            "img-src": ["'self'","https://sapui5.hana.ondemand.com/"]
          }
        }
      }))
})

module.exports = cds.server