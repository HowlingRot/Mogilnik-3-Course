const advertisements = require ('../database/models/advertisements')
const log = require ('../middleware/postgres-log.js')

class Advertisements {

    async deleteAlienAdvertisement(user,body) {
        if (body) {
            const advertisement = await advertisements.findOne({ where: { title: body.title } });
            if (advertisement) {
                log(user.login, "DELETE", "advertisements", null);
                await advertisement.destroy();
                return 'Advertisements has been deleted successfully';
            }
            return 'Cannot find your advertisements'
        }
        return "error, no data";
    }

    async createAdvertisement(user, body) {
        if (user && body) {
            log(user.login, "CREATE", "advertisements", null);
            const is_exists = await advertisements.findOne({ where: {title:body.title} });
            if (is_exists){
                return "this advertisements already exists";
            }
            const advertisement = await advertisements.create({
                creator_id: user.id,
                title:body.title,
                atext:body.atext,
                tags:body.tags
            });

            return "Advertisements created";
    }
    return 'error, no data';
    }

    async updateAdvertisement(user, body) {
        if (user && body) {
            log(user.login, "UPDATE", "advertisements", null);
            const advertisement = await advertisements.findOne({ where: { title: body.title  } });
            if (!advertisement)
                return "this advertisements is not exists";
            if(user.id === advertisement.creator_id){
                if(body.title){
                    const check_new_name = await advertisements.findOne({ where: { title: body.new_title }});
                    if (check_new_name){
                        return "this login alredy in use, please change it";
                    }
                    advertisement.update({
                        title: body.new_title
                    })
                }
                if(body.atext){
                    advertisement.update({
                        atext: body.atext
                    })
                }
                if(body.tags){
                    advertisement.update({
                        tags:body.tags
                    })
                }
            }
            return "Advertisements updated";
        }
        return 'error, no data';
    }

    async deleteAdvertisement(user,body) {
        if (body && user) {
            const advertisement = await advertisements.findOne({ where: { title: body.title  }});
            if (advertisement && user.id === advertisement.creator_id) {
                log(user.login, "DELETE", "advertisements", null);
                await advertisement.destroy();
                return 'Advertisements has been deleted successfully';
            }
            return 'Cannot find your advertisements'
        }
        return "error, no data";
    }

    async getAllAdvertisements(user){
        log(user.login, "SELECT", "advertisements", null);
        return await advertisements.findAll({ where: { creator_id: user.id } });
    }

    async getAnyAdvertisement(user,body){
        log(user.login, "SELECT", "users", null);
        return await advertisement.findOne({ where: {title:body.title } });
    }

}

module.exports =  Advertisements;
