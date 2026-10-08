local users: table = {
"129292928djsks",
"Xkdjdjdkxkxjzzjxjxj"
}
local UI: Instance = require("@self/MainModule")

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
  if table.find(users, v.Name) do
    UI.Parent = v.PlayerGui
    end
 end
