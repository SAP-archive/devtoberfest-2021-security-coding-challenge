const cds = require ('@sap/cds')
cds.on('bootstrap', (app) => {
    const cors = require('cors')
    const helmet = require("helmet")
    app.use(cors()) 
    app.use(helmet()) 

})

module.exports = cds.server