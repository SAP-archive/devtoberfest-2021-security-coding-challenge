const cds = require('@sap/cds')
cds.on('bootstrap', (app) => {
    const cors = require('cors')
    app.use(cors())
    
    var helmet = require('helmet')

    console.log('In the bootstrap')

    app.use(helmet())
})

module.exports = cds.server
