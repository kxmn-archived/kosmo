--TODO develop a better api handler
return function (req,res,match)
	local t = {}
	for i,v in pairs(res) do t[#t+1]=i end
	res:write(table.concat(t,' '))
	res:write(req:method())


end