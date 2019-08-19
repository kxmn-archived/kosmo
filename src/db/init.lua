--[[md
	# Database: kosmo.db
	This module encapsulates lsqlite3 module <http://lua.sqlite.org>.
	The main benefits are:

	* Use of default path and file extension for all db files, just making the db name match with filename
	* Shortcuts to operations that otherwise would need tree or mor function calls
	* Error flags and handlings
]]

local sqlite = require 'lsqlite3' -- lsqlite3 module

local M, Db, Stmt, _ = {}, {}, {}, {}
local syscfg = kosmo.config('db')

---- DB OPENER / CONSTRUCTOR ------------------------------

--[[md
	## kosmo.db.open(databaseName, extraConf) : Db

	* `databaseName` : database name, to be found in database path config
	* `extraConf` : a table with extra paramenters to affect use of database
	* `Db` : instance of kosmo.db encapsulating Lsqlite3

	The `extraConf` table can have these optional keys:

	* `errorfn` : function to handle errors. Default is the global assert.
	* `flags` : as defined in <http://www.sqlite.org/c3ref/open.html> but prefixed with Lua object. Ex: `kosmo.db.sqlite3.OPEN_READWRITE + kosmo.db.sqlite3.OPEN_CREATE`

]]
function M.open(name, cfg)
	local name = table.concat({syscfg.path,'/',name,'.',syscfg.fileext})
	cfg = cfg or {}
	return setmetatable({
		SQLite3Db = assert(sqlite.open(name, cfg.flags or nil)),
		SQLite3Dbfile = name,
		_error = cfg.errorfn or assert
	},{
		__index = function(t,k)
			return Db[k] or function(self,...)
				return t.SQLite3Db[k](t.SQLite3Db,...)
			end
		end}
	)
end

---- DB HANDLER -------------------------------------------
--[[md
	## Db instance
	Handles actions in a single data/base
--]]

--[[md
	### Db properties
	Properties on table returned by `kosmo.db.open()`
	* `Db.SQLite3Db` Lsqlite3 instance
	* `Db.SQLite3Dbfile` opened database filename with path
]]

--[[md
	### Db:close()
	Database instance handler closer
]]
function Db:close() return self._error(self.SQLite3Db:close()) end

--[[md
	### Db:execute(query)
]]

--[[md
	### Db:errorMessage() : sqliteCode, text
	Get last database message and code error.
	* `sqliteCode` [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)
	* `text` Text information about last error
]]
function Db:getError()
	return self.SQLite3Db:errcode(), self.SQLite3Db:errmsg()
end

--[[md
	### Db:getRows(statementString [, namedValueTable]) : iteratorFn
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
]]
function Db:getRows(stmt,val)
	if val then
		assert(type(val) ~= 'table' , 'bad argument #2..N to db:nrows (expected table or list)')
		return self:prepare(stmt):nrows(val)
	else
		return self.SQLite3Db:nrows(stmt)
	end
end

--[[md
	### Db:prepare(statementString) : Stmt
	Prepare statement to receive values before processing
	* `statement` string
	* `Stmt` returns a statement instance
]]
function Db:prepare(stmt)
	local s,err = self.SQLite3Db:prepare(stmt)
	err = err and self.SQLite3Db:error_message()
	print('stmt',s)
	return setmetatable({
		SQLite3Db = self.SQLite3Db,
		SQLite3Stmt = assert(s,err)
	},{
		__index = function(t,k)
			return Stmt[k] or function(self,...)
				return t.SQLite3Stmt[k](t.SQLite3Stmt,...)
			end
		end
	})
end

---- STATEMENT --------------------------------------------

--[[md
	## Stmt Instance
	Provides methods to run the statement with values and get results
]]

--[[md
	### Stmt:run(namedValueTable) : Stmt
	Reset statement, bind named values and executes, checking if result
	is ok. Named values are passed with a dictionary table.
	* `namedValueTable` : dictionary table, where indexes are the variables of statement without the ":" or "$" prefixing it.
	* `Stmt` : Returns the self, so you can call run multiple times with different values.
]]
function Stmt:run(v)
	assert(self.SQLite3Stmt:reset())
	assert(self.SQLite3Stmt:bind_names(v))
	if self.SQLite3Stmt:step() ~= sqlite.DONE then
		assert(false, self.SQLite3Db:errmsg())
	end
	return self
end

--[[md
	### Stmt:ends() : sqliteCode
	Ends the execution for the statement. Internal call for sqlite3 `stmt:finalize()`
	* `sqliteCode` [Sqlite error code](https://www.sqlite.org/rescode.html#primary_result_code_list)
]]
function Stmt:ends()
	return self.SQLite3Stmt:finalize()
end

--[[md
	### Stmt:getRows(namedValueTable) : iteratorFn
	Run statement with name values returning a iterator for successive calls on results
	* `namedValueTable` values to use with statement ex: `{n1=v1, nN=vN}`
	* `iteratorFn` : returns a iterator function, as used in `for` loops

	Example:

	```
	local Stmt = kosmo.db.open('somedb')
	Stmt:prepare"SELECT * FROM test WHERE id > :id1 AND id < :id2'"
	for row in Stmt:nrows{id1 = 10, id2 = 20} do
		print(row.fieldName)
	end
	```
]]
function Stmt:getRows(v)
	self.SQLite3Stmt:reset();
	self.SQLite3Stmt:bind_names(v)
	return self.SQLite3Stmt:nrows()
end

return M
