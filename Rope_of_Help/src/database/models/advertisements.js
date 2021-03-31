const pkg = require( 'sequelize')
const { Model, INTEGER, STRING } = pkg

const sequelize = require( '../sequelize.js')

class advertisements extends Model { }

advertisements.init(
    {
        creator_id: { type: INTEGER },
        title: { type: STRING},
        atext: { type: STRING},
        tags: { type: STRING},
    },
    {
        sequelize: sequelize,
        modelName: 'advertisements',
    },
);

console.log('Advertisements =', advertisements === sequelize.models.advertisements)

module.exports = advertisements