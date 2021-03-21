---A library to get information about the current profession
_G['CurrentProfession'] = {}
_G['LibProfessionsCurrentProfession-@project-version@'] = _G['CurrentProfession']
local profession = _G['CurrentProfession']
local api = _G['ProfessionAPI']
local common = _G['LibProfessionsCommon-@project-version@']
local WoWClassic = common.is_classic

function profession:IdFromLink(link)
    local _, _, id = string.find(link, "item:(%d+)");
    return tonumber(id);
end

--/dump LibStub("LibCurrentProfession-1.0"):ProfessionIs("Cooking")
function profession:ProfessionIs(profession_name)
    local current_name = api:GetName()
    if current_name ~= profession_name then
        return false
    else
        return true
    end
end

--/dump LibStub("LibCurrentProfession-1.0"):GetReagents(2)
--/dump LibStub("LibCurrentProfession-1.0"):GetReagents(160962)
function profession:GetReagents(recipeID)
    local reagents = {}
    local numReagents = api:NumReagents(recipeID);
    if numReagents > 0 then
        for reagent_Index = 1, numReagents, 1 do
            local reagentLink = api:GetReagentItemLink(recipeID, reagent_Index);
            local reagentName, reagentTexture, reagentCount, playerReagentCount =
            api:GetReagentInfo(recipeID, reagent_Index);
            if reagentLink then
                local reagentItemID = self:IdFromLink(reagentLink)
                reagents[reagent_Index] = {["reagentItemID"]=reagentItemID, ["reagentName"]=reagentName,
                                           ["reagentTexture"]=reagentTexture, ["reagentCount"]=reagentCount,
                                           ["playerReagentCount"]=playerReagentCount, ["reagentLink"]=reagentLink}
            end
        end
        return reagents
    end
end

--/dump LibStub("LibCurrentProfession-1.0"):GetRecipes()
function profession:GetRecipes()
    local recipes = {}
    if WoWClassic then
        --@debug@
        print(string.format('Found %d recipes for %s', api:NumRecipes(), api:GetInfo()))
        --@end-debug@
        --In Classic the recipeID indicates the place of the recipe in the list
        for recipeID = 1, api:NumRecipes(), 1 do
            local skillName, skillType, numAvailable = _G.GetTradeSkillInfo(recipeID);
            if skillType == "header" or skillType == nil then -- skip header by increasing recipeID
                recipeID = recipeID +1
                skillName, skillType, numAvailable = _G.GetTradeSkillInfo(recipeID);
            end

            recipes[recipeID] = {}
            recipes[recipeID]['name'] = skillName
            recipes[recipeID]['difficulty'] = skillType
            recipes[recipeID]['numAvailable'] = numAvailable
            recipes[recipeID]['link'] = _G.GetTradeSkillItemLink(recipeID)
        end
    else
        --In BfA the recipeID is a real ID
        for _, recipeID in pairs(_G.C_TradeSkillUI.GetAllRecipeIDs()) do
            recipes[recipeID] = {}
            recipes[recipeID] = _G.C_TradeSkillUI.GetRecipeInfo(recipeID)
            recipes[recipeID]['link'] = _G.C_TradeSkillUI.GetRecipeItemLink(recipeID)
        end
    end
    return recipes
end
