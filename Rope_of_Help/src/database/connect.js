const sequelize =  require( './sequelize.js')

module.exports = async function connect() {
    try {
        await sequelize;
        console.log('Sequelize connected.');
        await sequelize.sync();
        console.log('Sequelize synchronized.');
        return 0
    } catch (e) {
        console.log(e)
        return 1
    }
}
