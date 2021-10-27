const cds = require('@sap/cds')
const cors = require("cors")

cds.on('bootstrap', async (app) => {

    // just allow any origin...
    // see https://www.npmjs.com/package/cors#configuration-options
    // for available options
    app.use(cors()) 
})

module.exports = cds.server