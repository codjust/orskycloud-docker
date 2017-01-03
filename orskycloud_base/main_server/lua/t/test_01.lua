local tb=(require "lua.test_base").new({unit_name = "api_test"})

function tb:test_nornal()
local res = ngx.location.capture(
  '/test',
  {method = ngx.HTTP_POST,args={a=3,b="4"}}
)

  if 200 ~= res.status then
    error("failed code:"..res.status)
  end

  if "7" ~= res.body then
    error("failed return"..res.body)
  end

end

tb:run()
