const cds = require ('@sap/cds')
const cors = require ('cors')
const helmet = require ('helmet')

cds.on('bootstrap', (app) => {
    // cors seccurity
    app.use(cors())

    // helmet seccurity
    app.use(
        helmet({
            contentSecurityPolicy: {
                directives: {
                    ...helmet.contentSecurityPolicy.getDefaultDirectives(),
                },
            },
        }),
    );
});

module.exports = cds.server