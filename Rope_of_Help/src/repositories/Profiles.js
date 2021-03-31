const profiles = require ( '../database/models/profiles')
const log = require ( '../middleware/postgres-log.js')

class Profiles {
 
    async updateOwnProfile(user, body) {
        if (user && body) {
           log(user.login, "UPDATE", "profiles", null);
            const profile = await profiles.findOne({ where: { user_id: user.id  } });
                if(body.nickname){
                    profile.update({
                        nickname: body.nickname
                    })
                }
                if(body.foto){
                    profile.update({
                        foto: body.foto
                    })
                }
                if(body.sex){
                    profile.update({
                        sex: body.sex
                    })
                }
                if(body.birth_day){
                    profile.update({
                        birth_day: body.birth_day
                    })
                }
                if(body.hobbies){
                    profile.update({
                        hobbies: body.hobbies
                    })
                }
                if(body.dossier){
                    profile.update({
                        hobbies: body.dossier
                    })
                }
                if(body.profession){
                    profile.update({
                        hobbies: body.profession
                    })
                }
            
            return "Profile updated";
        }
        return 'error, no data';
    }

}

module.exports = Profiles;
