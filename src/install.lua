--[[md
	# First steps:
	* Download using luarocks or downloading source from GitHub
	* Once download and right placed on your Lua path...
	* Run `./run kosmo.install`

	Doing this it will create the project structure and basic file
	configurations. So you can explore configurations and adapt to your needs.

]]



require 'aurora'
local lfs = require 'lfs'
local fs = aurora.fs

-- Get current working dir
local cwd = lfs.currentdir()..'/'

local subdir = {
	"bin", -- programs headless
	"var", -- caches (like compiled templates, or server cache)
		"var/tpl-cache",
		"var/web-cache",
	"cfg", -- configurations for templates, server, etc
	"lib", -- your lua code
		"lib/run", -- place for lua backends
	"log", -- where the program writes some useful info
	"tpl", -- templates not compiled
	"web", -- webserver statically served
		"web/assets/css",
		"web/assets/fonts",
		"web/assets/img",
		"web/assets/js",
	"dat", -- place for models
}

local files = {
	["cfg/template.lua"] =
	[[return {
			path        = kosmo.root()..'/tpl/',
			compilePath = kosmo.root()..'/var/tpl-cache/',
			cached      = false,
			env         = {}, -- default data accessible on template sandbox
		}
	]],

	["cfg/db.lua"] =
	[[return {
			path    = kosmo.root()..'/dat',
			fileext = 'sl3'
	}]],

	["cfg/ws.lua"] =
	[[return {
		compress = true,
		port = 8080,
		location = kosmo.root().."/web/",
		rules = {
			{ '/api/', 'kosmo.web.api', ''  },
			{ '/test',             302, '/' }
		},
		error = { 404, '/404.html' },
	}]],

	["run"] =
	[[require 'kosmo'; kosmo.config(); kosmo.run()]],

	["web/index.html"] =
	[[<!DOCTYPE html><html><head><title>Kosmo</title><body><h1>Hello Kosmos</h1></body></html>]]

}


--------------------------------------------

-- Create directory structure
for i,v in ipairs(subdir) do
	fs.mkdir(cwd..v)
end

-- Create default files
for i,v in pairs(files) do
	if not fs.isFile(cwd..i) then fs.setFileContents(cwd..i,v) end
end

os.exit()
