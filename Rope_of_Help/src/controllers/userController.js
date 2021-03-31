const Users = require( '../repositories/Users.js');

const users = new Users();

class UserController {

    async changeOfAccessLevel(req, res) {
        try {
            await users.changeOfAccessLevel(req.user,req.body);
            return res.render('admin_page',
            {
                title: 'Admin_page',
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

    async deleteAlienAccount(req, res) {
        try {
            await users.deleteAlienAccount(req.user,req.body);
            return res.render('admin_page',
            {
                title: 'Admin_page',
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

    async getAllUsers(req,res){
        try{
            return res.status(200).json(await users.getAllUsers(req.user));
        }catch(error){
            console.log(error);
            return res.status(404).json(error);
        }
    }

    async getOneUsers(req, res) {
        try {
            return res.status(200).json(await users.getOneUsers(req.user,req.body));
        } catch (error) {
            console.log(error);
            return res.status(404).json(error);
        }
    }

    async deleteOwnAccount(req, res) {
        try {
            await users.deleteOwnAccount(req.user);
            return res.render('registration_page',
        {
            title: 'Registration',
            isNavbar: false,
            isFooter: false
        })
        } catch (error) {
            console.log(error);
            return res.status(404).json(error);
        }
    }

    async updateOwnAccount(req, res) {
        try {
           await users.updateOwnAccount(req.user, req.body);
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

module.exports = UserController;
