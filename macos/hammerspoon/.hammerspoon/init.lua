-- Spoons developed in local clones load straight from the clone, so edits
-- there take effect on reload without copying into ~/.hammerspoon/Spoons.
local spoonClones = os.getenv("HOME") .. "/Code/killallgit"
package.path = package.path .. ";" .. spoonClones .. "/?.spoon/init.lua"

if hs.fs.attributes(spoonClones .. "/HotTerm.spoon/init.lua") then
    hs.loadSpoon("HotTerm")
else
    hs.alert.show("HotTerm.spoon not found in " .. spoonClones)
end
