const cds = require('@sap/cds')
const cors = require('cors')
const helmet = require('helmet')

cds.on('bootstrap', (app) => {
    addcors(app)
    addcsp(app)
})

const addcors = (app) => {
    const whitelist = ['http://localhost:4004']
    const corsOptions = {
        origin: function (origin, callback) {
            if (whitelist.indexOf(origin) !== -1 || !origin) {
                callback(null, true)
            } else {
                callback(new Error('Not allowed by CORS'))
            }
        }
    }

    app.use(cors(corsOptions))
}

const addcsp = (app) => {
    app.use(helmet({
        contentSecurityPolicy: {
            directives: {
                ...helmet.contentSecurityPolicy.getDefaultDirectives(),
            }
        }
    }))
}

module.exports = cds.server