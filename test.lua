package.path = '/tmp/?.lua;'..package.path
print(package.path)
local nada = require('nada')


print(nada.location('oi'))
