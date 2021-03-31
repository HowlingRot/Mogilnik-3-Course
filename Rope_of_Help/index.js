const express = require('express')
const session =  require( 'express-session')
const exphbs = require('express-handlebars')
const path = require('path')

const router =  require( './src/routes/router.js')
const passport =  require( './src/middleware/passport-index.js')
const connect =  require( './src/database/connect.js')

const PORT = 3000

const app = express()
module.exports = app

const hbs = exphbs.create({
    defaultLayout: 'index',
    extname: 'hbs'
  })
  
app.engine('hbs', hbs.engine)
app.set('view engine', 'hbs')
app.set('views', 'views')

app.use(express.static(path.join(__dirname, 'public')))

async function start(){
    try{
        await connect();
        app.listen(PORT, ()=> console.log('Server has been started'))
        app.use(express.json())
        app.use(express.urlencoded({ extended: false }))
        app.use(session({ 
            secret: 'Rope_of_Help',
            resave: true,
            saveUninitialized: false }))
        app.use(passport.initialize())
        app.use(passport.session())
        app.use(router)
    }
    catch(e){
        console.log(e)
    }
}

start()
