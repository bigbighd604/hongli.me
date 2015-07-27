local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.log(ngx.ERR, msg)
  ngx.say(msg)
  ngx.exit(0)
end

local discount = require("discount")
if discount == nil then
        return_not_found("discount is nil")
end

--local path = string.sub(ngx.var.uri, 2)
-- ngx.var.path is a group regex matching in nginx.conf
local path = ngx.var.path
local file_path = path .. ".md"
--local cur_dir = (...):match("(.+)%.[^%.]+$")
--[[
relative path to nginx current working directory which is
different from nginx prefix directory. prefix directory can be
changed by passing "-p $dir" to nginx during start up.
current working directory is from which directory you run the
start up command. CWD and nginx prefix directory are totally
separated directories.
--]]
local file = io.open("html/" .. file_path, "rb")

if not file then
--	os.execute("touch ttttt")
        return_not_found(file_path .. " file not found")
end

local content = file:read("*all")
file:close()

if content == nil then
        return_not_found("no content read")
end
local html_string = discount(content)
if html_string == nil then
        return_not_found("no html string generated")
end

ngx.header["Content-type"] = "text/html"
ngx.say(html_string)
