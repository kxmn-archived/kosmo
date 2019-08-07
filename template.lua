return require('aurora.template').new{
	conf = {
		templatePath = _KOSMO.tpl,
		compilePath = _KOSMO.var..'compiledTemplate/',
		cache = false
	}
}
