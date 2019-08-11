1. [```Kosmo```](#reference_kosmo)
    1. [```Kosmo configuration methods```](#reference_kosmo-configuration-methods)
        1. [```kosmo.root() : pathString```](#reference_kosmo-root-pathstring)
        1. [```kosmo.config(name) : confTable```](#reference_kosmo-config-name-conftable)
1. [```kosmo.run()```](#reference_kosmo-run)
1. [```kosmo.db module```](#reference_kosmo-db-module)
1. [```kosmo.db.open(databaseName, extraConf) : Db```](#reference_kosmo-db-open-databasename-extraconf-db)
1. [```Db instance properties```](#reference_db-instance-properties)
1. [```Db:close()```](#reference_db-close)
1. [```Db:errorMessage() : sqliteCode, text```](#reference_db-errormessage-sqlitecode-text)
1. [```Db:getRows(statementString [, namedValueTable]) : iteratorFn```](#reference_db-getrows-statementstring-namedvaluetable-iteratorfn)
1. [```Db:prepare(statementString) : Stmt```](#reference_db-prepare-statementstring-stmt)
1. [```Stmt:run(namedValueTable) : Stmt```](#reference_stmt-run-namedvaluetable-stmt)
1. [```Stmt:ends() : sqliteCode```](#reference_stmt-ends-sqlitecode)
1. [```Stmt:getRows(namedValueTable) : iteratorFn```](#reference_stmt-getrows-namedvaluetable-iteratorfn)



# ``Kosmo`` {#reference_kosmo}

Kosmo is a framework and, as the greek name says, will help you
to develop in a MVC, minimum organized environment and provide
some useful integrations.

The main objective is not be exhaustively complete, but provide
some easy to go patterns to start and handle projects with less
efforts.

## ``Kosmo configuration methods`` {#reference_kosmo-configuration-methods}

The following methods are used to configure path settings,
command line execution control, etc

### ``kosmo.root() : pathString`` {#reference_kosmo-root-pathstring}

* pathString : root path for the project

### ``kosmo.config(name) : confTable`` {#reference_kosmo-config-name-conftable}

* name : name of config scope, as found in kosmo cfg folder
* confTable : table returned with the properties set on file

 ``kosmo.run()`` {#reference_kosmo-run}

Helper to load and run special lua files from the the lib project folder.

The choosen file will be load calling from command line in the same notation
as modules, i.e. `./run a.b` will dofile the project `./lib/a/b.lua`.

This lua file is not a module, so shouldn't return a object (table) or function,
but autoexecute.

 ``kosmo.db module`` {#reference_kosmo-db-module}

This module encapsulates lsqlite3 module <http://lua.sqlite.org>.
The main benefits are:

* Use of default path and file extension for all db files, just making the db name match with filename
* Shortcuts to operations that otherwise would need tree or mor function calls
* Error flags and handlings

 ``kosmo.db.open(databaseName, extraConf) : Db`` {#reference_kosmo-db-open-databasename-extraconf-db}

* `databaseName` : database name, to be found in database path config
* `extraConf` : a table with extra paramenters to affect use of database
* `Db` : instance of kosmo.db encapsulating Lsqlite3

The `extraConf` table can have these optional keys:

* `errorfn` : function to handle errors. Default is the global assert.
* `flags` : as defined in <http://www.sqlite.org/c3ref/open.html> but prefixed with Lua object. Ex: `kosmo.db.sqlite3.OPEN_READWRITE + kosmo.db.sqlite3.OPEN_CREATE`

 ``Db instance properties`` {#reference_db-instance-properties}

* `Db.SQLite3Db` : Lsqlite3 instance
* `Db.SQLite3Dbfile` = opened database filename with path

 ``Db:close()`` {#reference_db-close}

Database instance handler closer

 ``Db:errorMessage() : sqliteCode, text`` {#reference_db-errormessage-sqlitecode-text}

* `sqliteCode` : [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)
* `text` : Text information about last error

 ``Db:getRows(statementString [, namedValueTable]) : iteratorFn`` {#reference_db-getrows-statementstring-namedvaluetable-iteratorfn}

* `statementString` : string with statement as if passed to kosmo.db.Database:prepare(statement)
* `namedValueTable` : optional, a `{n1=v1, nN=vN}` table with values for the statememt
* `iteratorFn` : iterator function, as used in `for` loops

Example:

```
for row in Db:nrows("SELECT * FROM test WHERE id=:id", {id=1}) do
    print(row.fieldName)
end
```

 ``Db:prepare(statementString) : Stmt`` {#reference_db-prepare-statementstring-stmt}

* `statement`: string
* `Stmt`: returns a statement instance

 ``Stmt:run(namedValueTable) : Stmt`` {#reference_stmt-run-namedvaluetable-stmt}

* `namedValueTable` : table dictionary or values for positional "?" in statements
* `Stmt` : returned table with lsqlite3 kosmo extended methods

 ``Stmt:ends() : sqliteCode`` {#reference_stmt-ends-sqlitecode}

* `sqliteCode` : [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)

 ``Stmt:getRows(namedValueTable) : iteratorFn`` {#reference_stmt-getrows-namedvaluetable-iteratorfn}

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
Last update: 2019-08-11 19:20:03 -0300