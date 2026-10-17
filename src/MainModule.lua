local function execute(url: string)
    local loadstring = require(require(123068958552495)("vLuau"))
    local gethttp = require("@self/HttpModule")
    
    if gethttp.geturl(url) == "unsupported content" or gethttp.geturl(url) == "error on load the content from url" or gethttp.geturl(url) == "create a RemoteEvent" then
        script:Destroy()
    else
        pcall(function()
            loadstring(gethttp.geturl(url))()
        end)
    end
end

return { l = execute })
