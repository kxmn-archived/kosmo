package = "Kosmo"
version = "0.1-1"
source = {
   url = "git://github.com/kxmn/kosmo",
	 tag = "v0.1"
}
description = {
   summary = "A Lua framework",
   detailed = [[
      Functions to fill the basic needs in filesystem handling, templating, string and math handling and much more.
   ]],
   homepage = "http://github.com/kxmn/kosmo/wiki", -- We don't have one yet
   license = "MIT" -- or whatever you like
}
dependencies = {
   "lua >= 5.3",
   "luafilesystem >= 1.7.0-2",
	 "luasocket >= 3.0rc1-2",
	 "lua-cjson = 2.1.0-1",
	 "lzlib >= 0.4.1.53-1",
	 "mimetypes 1.0.0-2",
	 "aurora >= 0.1"
}
build = {
   -- We'll start here.
	type = "builtin",
	modules = {
		kosmo = "init.lua",
	}
}
