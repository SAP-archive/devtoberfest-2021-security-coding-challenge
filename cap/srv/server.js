const cds = require('@sap/cds')
const passport = require("passport")
const xssec = require("@sap/xssec")
const xsenv = require("@sap/xsenv")
const cors = require('cors')

passport.use("JWT", new xssec.JWTStrategy(xsenv.getServices({
    uaa: {
        tag: "xsuaa"
    }
}).uaa))


cds.on('bootstrap', (app) => {
    app.use(passport.initialize())
    app.use(
        passport.authenticate("JWT", {
            session: false
        })
    )
    app.use(cors())
})

module.exports = cds.server