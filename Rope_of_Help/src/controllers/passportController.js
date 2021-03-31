const passport = require( 'passport');
const profiles = require( '../database/models/profiles.js');
const users = require( '../database/models/users.js');
const log = require( '../middleware/postgres-log.js');

class PassportController {

    async login(req, res, next) {
        await passport.authenticate('local', async function (err, users, info) {
            if (err) {
                console.log(err);
                return next(err);
            }
            if (!users)
                return res
                    .status(404)
                    .json('Incorrect username or password');
                    await req.logIn(users, err => {
                        return err
                            ? res.status(404).json(err)
                            : res.redirect('/');
                    });
        })(req, res, next);

    }
    
    async logout(req, res) {
        try {
            await req.logout();
            return res.redirect('/login_page');
        } catch (error) {
            return res.status(404).json(error);
        }
    }

    async register(req, res) {
        try {
            const old_user = await users.findOne({ where: { login: req.body.login } });
            if (old_user)
                return res.status(409).json("This username is alredy in use, please, use anouther");
            log(null, "INSERT", "users", req.body);
            const user = await users.create({
                login: req.body.login,
                password: req.body.password,
                email:  req.body.email,
                role_id: "1"
            });
            const profile = await profiles.create({
                user_id: user.id
            });    
            await req.logIn(user, err => {
                return err
                    ? res.status(404).json(err)
                    : res.redirect('/');
            });
        } catch (error) {
            console.log(error)
            return res.status(404).json(error);
        }
    }
}

module.exports = PassportController;
