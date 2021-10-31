const cds = require('@sap/cds')
cds.on('bootstrap', (app) => {

    var cors = require('cors')
    var helmet = require('helmet')


    app.use(cors())

    console.log('In the bootstrap')

    app.use(helmet())
})
module.exports = cds.server