module.exports = async function (req, res, next) {
    try {
        return await req.isAuthenticated() ? next() : await res.status(404).json('Login to get access');
    } catch (error) {
        return await res.status(404).json(error);
    }
};
