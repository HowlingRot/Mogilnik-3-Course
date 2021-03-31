const Profiles = require( '../repositories/Profiles.js');

const profiles = new Profiles();

class Controller {

    async updateOwnProfile(req, res) {
        try {
            await profiles.updateOwnProfile(req.user, req.body);
            return res.render('main',
            {
                title: 'Main',
                viewManager:false,
                viewAdmin:true,
                isNavbar: true,
                isFooter: true
            })
        } catch (error) {
            console.log(error);
            return res.status(404).json(error);
        }
    }

}

module.exports = Controller;