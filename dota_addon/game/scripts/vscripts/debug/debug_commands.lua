local DebugCommands = {}
DebugCommands.__index = DebugCommands

function DebugCommands.Register(context)
    if Convars == nil then
        return
    end

    Convars:RegisterCommand("kobold_grant", function(commandName, resourceId, amountText)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local playerId = player:GetPlayerID()
        local hero = PlayerResource:GetSelectedHeroEntity(playerId)
        local resources = context:GetService("resources")
        if hero ~= nil and resources ~= nil then
            resources:AddResource(hero, resourceId or "resource_lumber", tonumber(amountText) or 1)
        end
    end, "Grant a tribal resource to your team: kobold_grant resource_lumber 5", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_dump", function()
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        if hero == nil then
            return
        end

        local resources = context:GetService("resources")
        if resources ~= nil then
            print("[Kobold Survival][Debug] resources for team " .. hero:GetTeamNumber())
            for resourceId, amount in pairs(resources:GetSnapshot(hero:GetTeamNumber())) do
                print("  " .. resourceId .. " = " .. amount)
            end
        end
    end, "Dump your tribe resource state.", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_spawn_ai", function(commandName, aiKind)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local spawns = context:GetService("spawns")
        if hero == nil or spawns == nil then
            return
        end

        local unitByKind = {
            sheep = "npc_kobold_animal_sheep",
            pheasant = "npc_kobold_animal_pheasant",
            stag = "npc_kobold_animal_stag",
            wolf = "npc_kobold_animal_wolf",
            dire_wolf = "npc_kobold_animal_dire_wolf",
            bear = "npc_kobold_animal_bear",
            murloc = "npc_kobold_murloc_slave",
            boss = "npc_kobold_boss_raging_arcane_beast",
        }

        local unitName = unitByKind[aiKind or "wolf"] or unitByKind.wolf
        if unitName == "npc_kobold_murloc_slave" then
            local buildings = context:GetService("buildings")
            if buildings ~= nil then
                buildings:SpawnMurlocSlave(hero, hero:GetAbsOrigin() + RandomVector(450), 300)
            end
            return
        end

        spawns:SpawnUnit(unitName, hero:GetAbsOrigin() + RandomVector(450), DOTA_TEAM_NEUTRALS)
    end, "Spawn a test AI unit: kobold_spawn_ai wolf|dire_wolf|bear|sheep|pheasant|stag|murloc|boss", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_item", function(commandName, itemName, countText)
        local player = Convars:GetCommandClient()
        if player == nil or CreateItem == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        if hero == nil then
            return
        end

        local count = math.max(1, tonumber(countText) or 1)
        for _ = 1, count do
            local item = CreateItem(itemName or "item_food_roasted_lamb", hero, hero)
            if item ~= nil then
                hero:AddItem(item)
            end
        end
    end, "Create a test item in your inventory: kobold_item item_tool_fishing_rod 1", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_recipe", function(commandName, recipeId)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local recipes = context:GetService("recipes")
        if hero ~= nil and recipes ~= nil then
            recipes:CompleteRecipe(hero, recipeId or "recipe_roasted_lamb")
        end
    end, "Complete a recipe using tribal resources: kobold_recipe recipe_stag_stew", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_stash_put", function(commandName, slotText)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local inventory = context:GetService("inventory")
        if hero ~= nil and inventory ~= nil then
            local ok, result = inventory:DepositSlot(hero, tonumber(slotText) or 0)
            print("[Kobold Survival][Debug] stash put: " .. tostring(ok) .. " " .. tostring(result))
        end
    end, "Deposit an item slot into tribe stash: kobold_stash_put 0", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_stash_take", function(commandName, itemName, countText)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local inventory = context:GetService("inventory")
        if hero ~= nil and inventory ~= nil then
            local ok, result = inventory:WithdrawItem(hero, itemName or "item_food_roasted_lamb", tonumber(countText) or 1)
            print("[Kobold Survival][Debug] stash take: " .. tostring(ok) .. " " .. tostring(result))
        end
    end, "Withdraw an item from tribe stash: kobold_stash_take item_food_roasted_lamb 1", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_weather", function(commandName, weatherId, durationText)
        local weather = context:GetService("weather")
        if weather ~= nil then
            weather:StartWeather(weatherId or "clear", tonumber(durationText) or 120)
        end
    end, "Force weather: kobold_weather rain|winter|ghouls|darkness|clear 120", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_xp", function(commandName, amountText)
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local progression = context:GetService("progression")
        if hero ~= nil and progression ~= nil then
            progression:AwardXp(hero, tonumber(amountText) or 100, "debug")
        end
    end, "Grant custom XP: kobold_xp 250", FCVAR_CHEAT)

    Convars:RegisterCommand("kobold_revive", function()
        local player = Convars:GetCommandClient()
        if player == nil then
            return
        end

        local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        local revival = context:GetService("revival")
        if hero == nil or revival == nil then
            return
        end

        local shrine = nil
        local bestDistance = nil
        if Entities ~= nil and Entities.FindAllByClassname ~= nil then
            for _, entity in pairs(Entities:FindAllByClassname("npc_dota_creature") or {}) do
                if entity ~= nil and not entity:IsNull() and entity.GetUnitName ~= nil and entity:GetUnitName() == "npc_kobold_building_revival_shrine" then
                    local distance = (entity:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D()
                    if distance <= 900 and (bestDistance == nil or distance < bestDistance) then
                        shrine = entity
                        bestDistance = distance
                    end
                end
            end
        end

        if shrine == nil then
            print("[Kobold Survival][Debug] Stand near a revival shrine or use the shrine-targeted ability.")
            return
        end

        local ok, result = revival:ReviveNearestDeadAlly(hero, shrine)
        print("[Kobold Survival][Debug] revive: " .. tostring(ok) .. " " .. tostring(result))
    end, "Revive nearest dead ally through a nearby shrine.", FCVAR_CHEAT)
end

return DebugCommands
