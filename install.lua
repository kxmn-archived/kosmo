local aurora = require 'aurora'
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
	"log", -- where the program writes some useful info
	"tpl", -- templates not compiled
	"web", -- webserver statically served
		"assets/css", 
		"assets/fonts", 
		"assets/img", 
		"assets/js",  
	"dat", -- place for models
}

local files = {
	"cfg/template.lua" = [[return {
		conf = {
			templatePath = 
			compilePath =
			cache = false

		}, 
		env = {
			-- default functions and variables accessible
			-- direct from template, creating a sandboxed environment
		}
	}]],
	"cfg/webserver.lua" = [[return {
		compress = true,
		port = 8080,
		location = "]]..cwd..[[web",
		rules = {
			{ '/api/', 'kosmo.web.api', ''  },
			{ '/test',             302, '/' }
		},
		error = { 404, '/404.html' },
	}]],
	"run" = [[
		require 'kosmo'
		kosmo.configure() -- set paths
		kosmo.run() -- run command
	]]
	"web/index.html" = [[<!DOCTYPE html><html><head><title>Kosmo</title><body><h1>Hello Kosmos</h1></body></html>]]

}


--------------------------------------------

-- Create directory structure
for i,v in ipairs(subdir) do
	fs.mkdir(cwd..subdir)
end

-- Create default files
for i,v in pairs(files) do 
	if not fs.isFile(cwd..i) then fs.setFileContents(cwd..i,v) end
end

os.exit()
