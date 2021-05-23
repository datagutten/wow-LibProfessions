local lu = require('luaunit')
loadfile('load.lua')()

_G['test'] = {}
local test = _G['test']
---@type LibProfessions
local lib = _G['LibProfessions-@project-version@']
local is_classic = lib.is_classic
if not is_classic then
    os.exit(0)
end

_G.C_Spell = {}
function  _G.C_Spell.DoesSpellExist()
    return true
end

function test:testVersion()
    if os.getenv('GAME_VERSION') == 'retail' then
        lu.assertEquals(lib.is_classic, false)
        lu.assertEquals(lib.is_classic_era, false)
        lu.assertEquals(lib.is_bcc, false)
    elseif os.getenv('GAME_VERSION') == 'bcc' then
        lu.assertEquals(lib.is_classic, true)
        lu.assertEquals(lib.is_classic_era, false)
        lu.assertEquals(lib.is_bcc, true)
    elseif os.getenv('GAME_VERSION') == 'classic' then
        lu.assertEquals(lib.is_classic, true)
        lu.assertEquals(lib.is_classic_era, true)
        lu.assertEquals(lib.is_bcc, false)
    else
        error('Invalid value for GAME_VERSION: ' .. os.getenv('GAME_VERSION'))
    end
end

function test:testLibraries()
    lu.assertNotNil(lib.version)
    lu.assertNotNil(lib.api)
    lu.assertNotNil(lib.currentProfession)
end

function test:testIcon()
    lu.assertEquals(lib:icon('Blacksmithing'), 'trade_blacksmithing')
end

function test:testProfessionId()
    lu.assertEquals(lib:profession_id('Alchemy', 1), 2259)
    lu.assertEquals(lib:profession_id('Alchemy', 9), nil)
end

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