const sequelize = require('sequelize')

module.exports = new sequelize(
    'Rope_of_Help',
    'postgres',
    '1111',
    {
        dialect: 'postgres',
        host: 'localhost',
        dialectOptions: {
            connectTimeout: 1500,
        },
        logging: false,
        define: {
            timestamps: false,
        }
    }
);