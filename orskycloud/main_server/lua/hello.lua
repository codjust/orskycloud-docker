
ngx.say("Hello OR_SYS");

ngx.req.read_body()
local data = ngx.req.get_body_data();
ngx.say("Hello",data);
