const cds = require('@sap/cds')
const helmet = require('helmet');
const cors = require('cors');

cds.on('bootstrap', (app) => {
    app.use(
        cors()
    );
    app.use(helmet({
        contentSecurityPolicy: {
            directives: {
                ...helmet.contentSecurityPolicy.getDefaultDirectives(),
                // custom settings
            }
        }
    }));
})

module.exports = cds.server;