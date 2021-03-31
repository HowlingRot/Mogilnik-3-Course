const pkg = require('sequelize')
const { Model, INTEGER, STRING } = pkg

const sequelize = require( '../sequelize.js')
const advertisements =  require( './advertisements.js')
const profiles = require( './profiles.js')

class users extends Model { }

users.init(
    {
        login: { type: STRING},
        password: { type: STRING},
        email: { type: STRING},
        role_id: { type: INTEGER},
    },
    {
        sequelize: sequelize,
        modelName: 'users',
    },
);

users.hasOne(profiles, { foreignKey: 'user_id' })
users.hasMany(advertisements, { foreignKey: 'creator_id' })

console.log('Users =', users === sequelize.models.users)

module.exports = users
