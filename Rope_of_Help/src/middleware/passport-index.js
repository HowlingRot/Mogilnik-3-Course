const passport = require('passport')
const LocalStrategy = require('passport-local').Strategy

const users = require( '../database/models/users.js')

passport.use(
  new LocalStrategy(async function (username, password, done) {
      try {
          const user = await users.findOne({
              where: { login: username }
          })
          if (!user){
              return done(null, false)  
          }

          if (user.password === password) return done(null, user);
          return done(null, false);
      } catch (error) {
          console.log(error);
          return error;
      }
  }),
);
passport.serializeUser(async function (user, done) {
    done(null, user)
});

passport.deserializeUser(async function (user, done) {
    const findUser = await users.findOne({
        where: { id: user.id }
    })
    done(null, findUser);
});

module.exports = passport
