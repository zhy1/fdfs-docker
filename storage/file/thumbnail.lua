-- ######################################
-- # Nginx thumbnail module
-- ######################################

local gm_path = "gm convert"
local enabled_default_img = false
local default_img_url = "/default.jpg"
local default_url_reg = "([0-9]+)x([0-9]+)"

local file_exists = function(name)
    local f = io.open(name,"r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local area = nil
local originalUri = ngx.var.uri;
local originalFile = ngx.var.file;
local index = string.find(ngx.var.uri, default_url_reg);
if index then
    originalUri = string.sub(ngx.var.uri, 0, index-2);
    area = string.sub(ngx.var.uri, index);
    index = string.find(area, "([.])");
    area = string.sub(area, 0, index-1);

    local index = string.find(originalFile, default_url_reg);
    originalFile = string.sub(originalFile, 0, index-2)
end


if area and file_exists(originalFile) then
    local command = gm_path .. " " .. originalFile  .. " -thumbnail " .. area .. " " .. ngx.var.file;
    os.execute(command);
end

if file_exists(ngx.var.file) then
    ngx.exec(ngx.var.uri)
else
    if enabled_default_img then
        ngx.exec(default_img_url)
    else
        ngx.exit(404)
    end
end