const pkg = require( 'sequelize')
const { Model, INTEGER, STRING, DATE } = pkg

const sequelize = require( '../sequelize.js')

class profiles extends Model { }

profiles.init(
    {
        user_id: {
            type: INTEGER,
            primaryKey: true,
        },
        nickname: { type: STRING},
        foto: { type: STRING},
        sex: { type: STRING},
        birth_day:{ type: DATE},
        hobbies: { type: STRING},
        dossier: { type: STRING},
        profession: { type: STRING},
    },
    {
        sequelize: sequelize,
        modelName: 'profiles',
    },
);

console.log('Profiles =', profiles === sequelize.models.profiles)

module.exports = profiles