const { Router } = require('express')
const { json }  = require('body-parser')
const cookie_parser = require( 'cookie-parser')

const isAuthenticated = require('../middleware/rools/isAuthenticated.js')
const isAdmin = require('../middleware/rools/isAdmin.js')
const isManager = require('../middleware/rools/isManager.js')

const UserController = require('../controllers/UserController.js')
const Controller = require('../controllers/profileController.js')
const PassportController = require('../controllers/PassportController.js')
const AdvertisementController = require('../controllers/advertisementController.js')

const log = require('../middleware/http-log.js')

const router = Router();
router.use(json());
router.use(cookie_parser());

const userController = new UserController();
const controller = new Controller();
const passportController = new PassportController();
const advertisementController = new AdvertisementController();

async function router_setup() {
    try {

        router.use(log)

        router.get('/registration_page', (req, res) => res.render('registration_page',
        {
            title: 'Registration',
            isNavbar: false,
            isFooter: false
        }))

        router.get('/login_page', (req, res) => res.render('login_page',
        {
            title: 'Login',
            isNavbar: false,
            isFooter: false
        }))

        router.get('/',isAuthenticated, (req, res) => {
            let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            res.render('main',
            {
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Main',
            isNavbar: true,
            isFooter: true
            })
        })

        router.get('/profile',isAuthenticated, (req, res) =>  {
            let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('profile',
            {
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Profile',
            isNavbar: true,
            isFooter: true
            })
        })

        router.get('/user_change_page',isAuthenticated, (req, res) =>  {
            let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('user_change_page',
            {
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'User_change_page',
            isNavbar: true,
            isFooter: true
            })
        })

        router.get('/admin_page',isAdmin, (req, res) => res.render('admin_page',
        {
            title: 'Admin_page',
            viewManager:false,
            viewAdmin:true,
            isNavbar: true,
            isFooter: true
        }))

        router.get('/manager_page',isManager, (req, res) => res.render('manager_page',
        {
            title: 'Manager_page',
            viewAdmin:false,
            viewManager:true,
            isNavbar: true,
            isFooter: true
        }))

        router.get('/create_advertisement_page',isAuthenticated, (req, res) =>
        {let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('create_advertisement_page',{
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Create_advertisement_page',
            isNavbar: true,
            isFooter: true
        })} )

        router.get('/update_advertisement_page',isAuthenticated, (req, res) =>
        {let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('update_advertisement_page',{
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Update_advertisement_page',
            isNavbar: true,
            isFooter: true
        })} )

        router.get('/update_profile_page',isAuthenticated, (req, res) =>
        {let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('update_profile_page',{
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Update_profile_page',
            isNavbar: true,
            isFooter: true
        })} )

        router.get('/notice',isAuthenticated, (req, res) =>
        {let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('notice',{
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Notice',
            isNavbar: true,
            isFooter: true
        })} )

        router.get('/about_us',isAuthenticated, (req, res) =>{
            let buttonAdmin = false;
            let buttonManager = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('about_us',
            {
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'About us',
            isNavbar: true,
            isFooter: true
            })
        })

        router.get('/contacts',isAuthenticated, (req, res) => {
            let buttonManager = false;
            let buttonAdmin = false;
            if(req.user.role_id === 2){
                buttonManager = true;
            };
            if(req.user.role_id === 3){
                buttonAdmin = true;
            };
            res.render('contacts',
            {
            viewManager:buttonManager,
            viewAdmin:buttonAdmin,
            title: 'Contacts',
            isNavbar: true,
            isFooter: true
            })
        })
        
        router.post('/login', passportController.login)
        router.post('/register', passportController.register)
        router.get('/logout', isAuthenticated, passportController.logout)


        router.post('/changeOfAccessLevel',isAdmin,userController.changeOfAccessLevel);
        router.post('/deleteAlienAccount',isAdmin, userController.deleteAlienAccount);
        router.post('/getAllUsers',isAdmin, userController.getAllUsers);
        router.post('/getOneUsers',isAdmin, userController.getOneUsers);   


        router.post('/deleteAlienAdvertisement', isManager, advertisementController.deleteAlienAdvertisement);


        router.get('/deleteOwnAccount',isAuthenticated, userController.deleteOwnAccount);
        router.post('/updateOwnAccount', isAuthenticated, userController.updateOwnAccount);
        router.post('/createAdvertisement', isAuthenticated, advertisementController.createAdvertisement);
        router.post('/updateAdvertisement', isAuthenticated, advertisementController.updateAdvertisement);
        router.post('/deleteAdvertisement', isAuthenticated, advertisementController.deleteAdvertisement);
        router.get('/getAllAdvertisements',isAuthenticated, advertisementController.getAllAdvertisements);
        router.get('/getAnyAdvertisement',isAuthenticated, advertisementController.getAnyAdvertisement);
        router.post('/updateOwnProfile', isAuthenticated, controller.updateOwnProfile);
        


        return 0;
    } catch (error) {   
        console.log(error);
        return 1;
    }
}
router_setup();

module.exports = router;
