const pkg = require( 'mongodb');
const { MongoClient } = pkg;

module.exports = async function (name, op_type, table_name, data) {
    let postgres = {
        date: new Date(),
        user_name: name || 'unauthorized',
        op_type: op_type,  
        table_name: table_name,
        save_data: data || null 
    }
    const mongoClient = new MongoClient("mongodb://localhost:27017/", { useNewUrlParser: true, useUnifiedTopology: true });
    mongoClient.connect(async function (err, client) {
        if (err) {
            console.log(err);
            return 1;
        }
        const db = client.db("Rope_of_Help");
        const collection = db.collection("postgres");
        collection.insertOne(postgres, async function (err, result) {
            await client.close();
        });
    });
}