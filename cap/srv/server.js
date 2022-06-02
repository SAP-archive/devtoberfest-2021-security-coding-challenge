const cds = require('@sap/cds')
const cors = require("cors")
const helmet = require("helmet")

cds.on('bootstrap', async (app) => {

    // just allow any origin...
    // see https://www.npmjs.com/package/cors#configuration-options
    // for available options
    app.use(cors()) 

    // add CSP
    app.use(helmet({
        contentSecurityPolicy: {
          directives: {
            ...helmet.contentSecurityPolicy.getDefaultDirectives(),
            // custom settings
          }
        }
      }))
})

module.exports = cds.server