
const {Pool} = require('pg');
const lineReader = require('line-reader');
const fs = require('fs');
var user, password;
var dedent = require('dedent-js');

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
});
fs.writeFile('query.sql', '', function (err) {if (err) throw err;});
fs.writeFile('transaction.sql', '', function (err) {if (err) throw err;});


const pool = new Pool({
    host: 'localhost',
    user: user,
    password: password,
    port: 5432,
    database: 'COSC3380'
});


var isTransaction = false;
const Query = require('pg').Query;
const submit = Query.prototype.submit;
Query.prototype.submit = function () {
    const text = this.text;
    const values = this.values || [];
    const query = text.replace(/\$([0-9]+)/g, (m, v) => JSON.stringify(values[parseInt(v) - 1]));
    if(text.search("BEGIN")>-1)
        isTransaction = true;
    if(isTransaction)
    {
        fs.appendFile('transaction.sql', dedent(query)+"\n\n", function(err) {
            if (err) throw err;
        });
    }
    else
    {
        fs.appendFile('query.sql', dedent(query)+"\n\n", function(err) {
            if (err) throw err;
        });
    }
    if(text.search("COMMIT")>-1)
        isTransaction = false;

    submit.apply(this, arguments);
};

module.exports = pool;