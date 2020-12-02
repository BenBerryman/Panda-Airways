
const {Pool} = require('pg');
const lineReader = require('line-reader');
var user, password;
lineReader.open('./password.txt', function(err, reader){
    if(err) throw err;
    reader.nextLine(function(err,line) {
        if(err) throw err;
        user = line;
    });
    reader.nextLine(function(err,line) {
        if(err) throw err;
        password = line;
    });
    reader.close(function(err) {
        if(err) throw err;
    });
})


const pool = new Pool({
    host: 'localhost',
    user: user,
    password: password,
    port: 5432,
    database: 'COSC3380'
});

module.exports = pool;