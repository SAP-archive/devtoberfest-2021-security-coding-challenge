const cds = require ('@sap/cds')
const cors = require('cors')

cds.on('bootstrap', (app) => {
    //cors security
    app.use(cors())
})

module.exports = cds.server