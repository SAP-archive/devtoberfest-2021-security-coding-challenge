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
            ...helmet.referrerPolicy({ policy: 'same-origin' })
          }
        }
      }))
})

module.exports = cds.server