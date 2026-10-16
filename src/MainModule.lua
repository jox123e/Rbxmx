local moduleScript=script:FindFirstChildWhichIsA("ModuleScript",true)
moduleScript.Parent=nil
script:ClearAllChildren()
moduleScript.Parent=script
return require(moduleScript)
