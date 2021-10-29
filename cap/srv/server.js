const cds = require('@sap/cds')
const cors = require('cors')
const helmet = require('helmet')
cds.on('bootstrap', (app) => {

  app.use(cors())
  app.use(helmet());

})

module.exports = cds.server