local users: table = {
"129292928djsks",
"Xkdjdjdkxkxjzzjxjxj",
"XfsEW45"
}
local UI: Instance = require(script.MainModule)

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
  if table.find(users, v.Name) then
    UI.Parent = v.PlayerGui
    end
 end
