const cds = require('@sap/cds');
const cors = require('cors');
const helmet = require('helmet');

cds.on('bootstrap', (app) => {
    // enable CORS in unproductive environments
    if (process.env.NODE_ENV !== 'production') {
        const options = {
            origin: 'http://localhost:4004',
            optionsSuccessStatus: 200,
            credentials: true,
        };
        app.use(cors(options));
    }

    app.use(
        helmet({
            contentSecurityPolicy: {
                directives: {
                    ...helmet.contentSecurityPolicy.getDefaultDirectives(),
                },
            },
        })
    );
});

module.exports = cds.server;
