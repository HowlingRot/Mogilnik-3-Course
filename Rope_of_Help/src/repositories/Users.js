const users = require ( '../database/models/users.js');
const log = require ( '../middleware/postgres-log.js');

class Users {

    async changeOfAccessLevel(user,body) {
        if (body) {
            log(user.login, "UPDATE", "users", null);
            const old_user = await users.findOne({ where: { login: body.login } });
            if(!old_user){
                return 'error, user not exists'
            }
            else{
                old_user.update({
                    role_id: body.role_id})
                    return 'level change'             
            }
        }else{
            return 'error, no data';
        }
    }

    async deleteAlienAccount(user,body) {
        if (body){
            const old_user = await users.findOne({ where: { login: body.login } });
            if (!old_user){
                return 'Nothing to delete'
            }
            log(user.login, "DELETE", "users", null);
            await old_user.destroy();
        }else{
            return 'error, no data';
        }
        
    }

    async getAllUsers(user){
        log(user.login, "SELECT", "users", null);
        return await users.findAll();
     }

     async getOneUsers(user,body) {
            log(user.login, "SELECT", "users", null);
            return await users.findOne({ where: { login: body.login } });
    }

    async deleteOwnAccount(user) {
        if (!user)
            return 'Nothing to delete'
        log(user.login, "DELETE", "users", null);
        await user.destroy();
        return 'User has been deleted successfully'
    }

    async updateOwnAccount(user, body) {
        if (user && body) {
            log(user.login, "UPDATE", "users", null);
            const old_user = await users.findOne({ where: { id: user.id } });
            if (body.login){
                const check_new_name = await users.findOne({ where: { login: body.login } });
                if (check_new_name)
                    return "this login alredy in use, please change it";
                old_user.update({
                    login: body.login
                })
            }
            if (body.email)
                old_user.update({
                    email: body.email
                })
            if (body.password)
                old_user.update({
                    password: body.password
                })
            return "User updated";
        }
        return 'error, no data';
    }

}

module.exports = Users;
