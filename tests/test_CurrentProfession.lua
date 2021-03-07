_G['test'] = {}
local test = _G['test']

local lu = require('luaunit')

loadfile('wow_functions.lua')()
loadfile('version_select.lua')()

loadfile('build_utils/utils/load_toc.lua')('../LibProfessions.toc')

local lib = _G['CurrentProfession']
local is_classic = select(4, _G.GetBuildInfo()) < 20000

function test:testGetReagents()
    local reagents = lib:GetReagents(3447)
    lu.assertNotNil(reagents)
end

function test:testGetRecipes()
    local recipes = lib:GetRecipes()
    lu.assertNotNil(recipes)
    local key

    if is_classic then
        key = 1
    else
        key = 3447
    end

    lu.assertNotNil(recipes[key])
    lu.assertEquals('Healing Potion', recipes[key]['name'])
end

os.exit(lu.LuaUnit.run())