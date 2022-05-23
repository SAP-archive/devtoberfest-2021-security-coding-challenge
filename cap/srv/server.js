const cds = require('@sap/cds');
const cors = require('cors');
const helmet = require('helmet');

cds.on('bootstrap', (app) => {
  // If not in production, the default server is now CORS-enabled for all origins by default we would like to change it
  if (process.env.NODE_ENV !== 'production') {
    var corsOptions = {
      origin: 'http://localhost:4004',
      optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
      credentials: true,
    };
    app.use(cors(corsOptions));
  }

  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          ...helmet.contentSecurityPolicy.getDefaultDirectives(),
          // custom settings
        },
      },
    })
  );
});

module.exports = cds.server;
