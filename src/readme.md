
<a id="kosmoroot--pathstring"></a>
###### kosmo.root() : pathString

* pathString : root path for the project

<a id="kosmoconfigname--conftable"></a>
###### kosmo.config(name) : confTable

* name : name of config scope, as found in kosmo cfg folder
* confTable : table returned with the properties set on file

<a id="kosmodb-module"></a>
##### kosmo.db module

This module encapsulates lsqlite3 module <http://lua.sqlite.org>.
The main benefits are:

* Use of default path and file extension for all db files, just making the db name match with filename
* Shortcuts to operations that otherwise would need tree or mor function calls
* Error flags and handlings

<a id="kosmodbopendatabasename-extraconf--db"></a>
###### kosmo.db.open(databaseName, extraConf) : Db

* `databaseName` : database name, to be found in database path config
* `extraConf` : a table with extra paramenters to affect use of database
* `Db` : instance of kosmo.db encapsulating Lsqlite3

The `extraConf` table can have these optional keys:

* `errorfn` : function to handle errors. Default is the global assert.
* `flags` : as defined in <http://www.sqlite.org/c3ref/open.html> but prefixed with Lua object. Ex: `kosmo.db.sqlite3.OPEN_READWRITE + kosmo.db.sqlite3.OPEN_CREATE`

<a id="db-instance-properties"></a>
###### Db instance properties

* `Db.SQLite3Db` : Lsqlite3 instance
* `Db.SQLite3Dbfile` = opened database filename with path

<a id="dbclose"></a>
###### Db:close()

Database instance handler closer

<a id="dberrormessage--sqlitecode-text"></a>
###### Db:errorMessage() : sqliteCode, text

* `sqliteCode` : [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)
* `text` : Text information about last error

<a id="dbgetrowsstatementstring--namedvaluetable--iteratorfn"></a>
###### Db:getRows(statementString [, namedValueTable]) : iteratorFn

* `statementString` : string with statement as if passed to kosmo.db.Database:prepare(statement)
* `namedValueTable` : optional, a `{n1=v1, nN=vN}` table with values for the statememt
* `iteratorFn` : iterator function, as used in `for` loops

Example:

```
for row in Db:nrows("SELECT * FROM test WHERE id=:id", {id=1}) do
    print(row.fieldName)
end
```

<a id="dbpreparestatementstring--stmt"></a>
###### Db:prepare(statementString) : Stmt

* `statement`: string
* `Stmt`: returns a statement instance

<a id="stmtrunnamedvaluetable--stmt"></a>
###### Stmt:run(namedValueTable) : Stmt

* `namedValueTable` : table dictionary or values for positional "?" in statements
* `Stmt` : returned table with lsqlite3 kosmo extended methods

<a id="stmtends--sqlitecode"></a>
###### Stmt:ends() : sqliteCode

* `sqliteCode` : [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)

<a id="stmtgetrowsnamedvaluetable--iteratorfn"></a>
###### Stmt:getRows(namedValueTable) : iteratorFn

* `namedValueTable` : a `{n1=v1, nN=vN}` values to be used with the statement
* `iteratorFn` : returns a iterator function, as used in `for` loops

Example:

```
local stmt = kosmo.db.open('somedb'):prepare('SELECT * FROM test WHERE id > :id1 AND id < :id2')
for row in Stmt:nrows{id1 = 10, id2 = 20} do
    print(row.fieldName)
end
```

----------
Last update: 2019-08-11 04:28:31 -0300