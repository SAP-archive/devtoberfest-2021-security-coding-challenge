const cds = require ('@sap/cds')
cds.on('bootstrap', (app) => {
    const cors = require('cors')
    const helmet = require('helmet')

    app.use(cors())
    app.use(helmet({
        contentSecurityPolicy: {
          directives: {
            ...helmet.contentSecurityPolicy.getDefaultDirectives(),
          }
        }
    }))
})

module.exports = cds.server