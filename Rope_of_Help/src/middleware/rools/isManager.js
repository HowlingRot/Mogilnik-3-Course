module.exports = async function (req, res, next) {
    try {
        const roles = await req.user.role_id;
        if (!roles){
            return res.status(404).json('Role not found')
        }           
        if (roles === 2){
            return next()
        } 
        return res.status(401).json('authAdminError, you are not manager')    
    } catch (error) {
        return res.status(404).json(error)
    }
};
