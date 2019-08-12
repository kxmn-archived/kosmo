1. [```Introduction```](#reference_introduction)
1. [```Kosmo configuration methods```](#reference_kosmo-configuration-methods)
    1. [```kosmo.root() : pathString```](#reference_kosmo-root-pathstring)
    1. [```kosmo.config(name) : confTable```](#reference_kosmo-config-name-conftable)
    1. [```kosmo.run()```](#reference_kosmo-run)
1. [```Database: kosmo.db```](#reference_database-kosmo-db)
    1. [```kosmo.db.open(databaseName, extraConf) : Db```](#reference_kosmo-db-open-databasename-extraconf-db)
    1. [```Db instance```](#reference_db-instance)
        * [```Db properties```](#reference_db-properties)
        * [```Db:close()```](#reference_db-close)
        * [```Db:errorMessage() : sqliteCode, text```](#reference_db-errormessage-sqlitecode-text)
        * [```Db:getRows(statementString [, namedValueTable]) : iteratorFn```](#reference_db-getrows-statementstring-namedvaluetable-iteratorfn)
        * [```Db:prepare(statementString) : Stmt```](#reference_db-prepare-statementstring-stmt)
    1. [```Stmt Instance```](#reference_stmt-instance)
        * [```Stmt:run(namedValueTable) : Stmt```](#reference_stmt-run-namedvaluetable-stmt)
        * [```Stmt:ends() : sqliteCode```](#reference_stmt-ends-sqlitecode)
        * [```Stmt:getRows(namedValueTable) : iteratorFn```](#reference_stmt-getrows-namedvaluetable-iteratorfn)
1. [```First steps:```](#reference_first-steps)
1. [```Templating```](#reference_templating)



# ``Introduction`` {#reference_introduction}

Kosmo is a framework and, as the greek name says, will help you
to develop in a MVC, minimum organized environment and provide
some useful integrations.

The main objective is not be exhaustively complete, but provide
some easy to go patterns to start and handle projects with less
efforts.

# ``Kosmo configuration methods`` {#reference_kosmo-configuration-methods}

The following methods are used to configure path settings,
command line execution control, etc

## ``kosmo.root() : pathString`` {#reference_kosmo-root-pathstring}

Get the project pathstring to use building path for other resources
* `pathString` root path for the project

## ``kosmo.config(name) : confTable`` {#reference_kosmo-config-name-conftable}

Get configuration from files stored in kosmo file hierarchy
* `name` name of config scope, as found in kosmo cfg folder
* `confTable` table returned with the properties set on file

## ``kosmo.run()`` {#reference_kosmo-run}

Helper to load and run special lua files from the the lib project folder.

The choosen file will be load calling from command line in the same notation
as modules, i.e. `./run a.b` will dofile the project `./lib/a/b.lua`.

This lua file is not a module, so shouldn't return a object (table) or function,
but autoexecute.

# ``Database: kosmo.db`` {#reference_database-kosmo-db}

This module encapsulates lsqlite3 module <http://lua.sqlite.org>.
The main benefits are:

* Use of default path and file extension for all db files, just making the db name match with filename
* Shortcuts to operations that otherwise would need tree or mor function calls
* Error flags and handlings

## ``kosmo.db.open(databaseName, extraConf) : Db`` {#reference_kosmo-db-open-databasename-extraconf-db}

* `databaseName` : database name, to be found in database path config
* `extraConf` : a table with extra paramenters to affect use of database
* `Db` : instance of kosmo.db encapsulating Lsqlite3

The `extraConf` table can have these optional keys:

* `errorfn` : function to handle errors. Default is the global assert.
* `flags` : as defined in <http://www.sqlite.org/c3ref/open.html> but prefixed with Lua object. Ex: `kosmo.db.sqlite3.OPEN_READWRITE + kosmo.db.sqlite3.OPEN_CREATE`

## ``Db instance`` {#reference_db-instance}

Handles actions in a single data/base

### ``Db properties`` {#reference_db-properties}

Properties on table returned by `kosmo.db.open()`
* `Db.SQLite3Db` Lsqlite3 instance
* `Db.SQLite3Dbfile` opened database filename with path

### ``Db:close()`` {#reference_db-close}

Database instance handler closer

### ``Db:errorMessage() : sqliteCode, text`` {#reference_db-errormessage-sqlitecode-text}

Get last database message and code error.
* `sqliteCode` [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)
* `text` Text information about last error

### ``Db:getRows(statementString [, namedValueTable]) : iteratorFn`` {#reference_db-getrows-statementstring-namedvaluetable-iteratorfn}

Shorthand to get direct data passing statement and variables, returning a iterator for use with loops
* `statementString` string with statement as if passed to `kosmo.db.Database:prepare(statement)`
* `namedValueTable` optional, a `{n1=v1, nN=vN}` table with values for the statememt
* `iteratorFn` iterator function, as used in `for` loops

Example:
```
for row in Db:getRows("SELECT * FROM test WHERE id=:id", {id=1}) do
    print(row.fieldName)
end
```

### ``Db:prepare(statementString) : Stmt`` {#reference_db-prepare-statementstring-stmt}

Prepare statement to receive values before processing
* `statement` string
* `Stmt` returns a statement instance

## ``Stmt Instance`` {#reference_stmt-instance}

Provides methods to run the statement with values and get results

### ``Stmt:run(namedValueTable) : Stmt`` {#reference_stmt-run-namedvaluetable-stmt}

Reset statement, bind named values and executes, checking if result
is ok. Named values are passed with a dictionary table.
* `namedValueTable` : dictionary table, where indexes are the variables of statement without the ":" or "$" prefixing it.
* `Stmt` : Returns the self, so you can call run multiple times with different values.

### ``Stmt:ends() : sqliteCode`` {#reference_stmt-ends-sqlitecode}

Ends the execution for the statement. Internal call for sqlite3 `stmt:finalize()`
* `sqliteCode` [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)

### ``Stmt:getRows(namedValueTable) : iteratorFn`` {#reference_stmt-getrows-namedvaluetable-iteratorfn}

Run statement with name values returning a iterator for successive calls on results
* `namedValueTable` values to use with statement ex: `{n1=v1, nN=vN}`
* `iteratorFn` : returns a iterator function, as used in `for` loops

Example:

```
local Stmt = kosmo.db.open('somedb')
Stmt:prepare[[SELECT * FROM test WHERE id > :id1 AND id < :id2']]
for row in Stmt:nrows{id1 = 10, id2 = 20} do
    print(row.fieldName)
end
```

# ``First steps:`` {#reference_first-steps}

* Download using luarocks or downloading source from GitHub
* Once download and right placed on your Lua path...
* Run `./run kosmo.install`

Doing this it will create the project structure and basic file
configurations. So you can explore configurations and adapt to your needs.

# ``Templating`` {#reference_templating}

Kosmo provides a shorthand to access Aurora templates.
requiring `kosmo.template` it automatically will create a aurora.template
instance passing the configuration from your Kosmo configuration folder
and returns the new instance.

----------
Last update: 2019-08-11 22:36:30 -0300