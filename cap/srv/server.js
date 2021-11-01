const cds = require ('@sap/cds')
cds.on('bootstrap', (app) => {
    const cors = require('cors')
    app.use(cors())
})

module.exports = cds.server
