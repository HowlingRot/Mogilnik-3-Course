const advertisements = require( '../repositories/Advertisements.js');

const advertisement = new advertisements();

class aController {

    async deleteAlienAdvertisement(req, res) {
        try {
            await advertisement.deleteAlienAdvertisement(req.user,req.body);
            return res.render('manager_page',
            {
                title: 'Manager_page',
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

    async createAdvertisement(req, res) {
        try {
            await advertisement.createAdvertisement(req.user, req.body);
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

    async updateAdvertisement(req, res) {
        try {
            await advertisement.updateAdvertisement(req.user, req.body);
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

    async deleteAdvertisement(req, res) {
        try {
            await advertisement.deleteAdvertisement(req.user,req.body);
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

    async getAllAdvertisements(req, res) {
        try {
            return res.status(200).json(await advertisement.getAllAdvertisements(req.user));
        } catch (error) {
            console.log(error);
            return res.status(404).json(error);
        }
    }

    async getAnyAdvertisement(req, res) {
        try {
            return res.status(200).json(await advertisement.getAnyAdvertisement(req.user,req.body));
        } catch (error) {
            console.log(error);
            return res.status(404).json(error);
        }
    }

}

module.exports = aController;