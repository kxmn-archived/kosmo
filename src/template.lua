local ctpl = kosmo.config('template')
return require('aurora.template').new{
	conf = {
		templatePath = ctpl.path,
		compilePath = ctpl.compilePath,
		cached = ctpl.cached
	},
	env=ctpl.env
}
