--[[md
	# Templating
	Kosmo provides a shorthand to access Aurora templates.
	requiring `kosmo.template` it automatically will create a aurora.template
	instance passing the configuration from your Kosmo configuration folder
	and returns the new instance.
]]

local ctpl = kosmo.config('template')
return require('aurora.template').new{
	conf = {
		templatePath = ctpl.path,
		compilePath = ctpl.compilePath,
		cached = ctpl.cached
	},
	env=ctpl.env
}
