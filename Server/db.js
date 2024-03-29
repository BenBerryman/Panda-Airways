
const {Pool} = require('pg');
const fs = require('fs');
var dedent = require('dedent-js');

var file = fs.readFileSync('./password.txt', 'utf8');
var arg = file.split('\n');

fs.writeFile('query.sql', '', function (err) {if (err) throw err;});
fs.writeFile('transaction.sql', '', function (err) {if (err) throw err;});

const pool = new Pool({
    host: 'localhost',
    user: arg[0],
    password: arg[1],
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
