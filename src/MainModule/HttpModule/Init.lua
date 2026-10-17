local function getsource(url: string)
    local H = game:GetService("HttpService")
    local s, r = pcall(H.GetAsync, H, url)
    if s or r then
        local ss, rr = pcall(function()
            return H:GetAsync(url)
        end)
        
        if ss or rr then
            if typeof(rr) == "table" or typeof(rr) == "number" then
                return "unsupported content"
            elseif typeof(rr) == "string" then
                return H:GetAsync(url)
            end
        else
            return "error on load the content from url"
        end
    else
        return "create a RemoteEvent"
    end
end
 
return { geturl = getsource }
