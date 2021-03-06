local lu = require('luaunit')

loadfile('wow_functions.lua')()
loadfile('load_toc.lua')('../LibProfessions.toc')
_G['test'] = {}
local test = _G['test']
local lib = _G['LibProfessions']
lib = _G.LibStub("LibProfessions-0")


function test:testGetAllSkillsNoFilter()
    local skills = lib:GetAllSkills()
--[[    for key, value in pairs(skills) do
        print(key, value)
    end]]
    lu.assertNotNil(skills['Fishing'])
    lu.assertNotNil(skills['Herbalism'])
    lu.assertNotNil(skills['Feral Combat'])
end

function test:testGetSecondarySkills()
    local skills = lib:GetAllSkills('Secondary Skills')
    lu.assertNotNil(skills['Fishing'])
    lu.assertNil(skills['Herbalism'])
    lu.assertNil(skills['Feral Combat'])
end

function test:testGetAllProfessions()
    local skills = lib:GetAllSkills({'Professions', 'Secondary Skills'})
    lu.assertNotNil(skills['Fishing'])
    lu.assertNotNil(skills['Herbalism'])
    lu.assertNil(skills['Feral Combat'])
end

os.exit(lu.LuaUnit.run())