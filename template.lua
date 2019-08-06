return require('lunar.template').new{
	conf = {
		templatePath = _KOSMO.tpl,
		compilePath = _KOSMO.var..'compiledTemplate/',
		cache = false
	}
}
