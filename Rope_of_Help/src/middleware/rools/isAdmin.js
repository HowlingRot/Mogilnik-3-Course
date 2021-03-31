module.exports = async function (req, res, next) {
    try {
        const roles = await req.user.role_id
        if (!roles){
            return res.status(404).json('role not found')
        }      
        if (roles === 3){
            return next()
        }
        return res.status(401).json('authAdminError, you are not admin')
    } catch (error) {
        return res.status(404).json(error)
    }
};
