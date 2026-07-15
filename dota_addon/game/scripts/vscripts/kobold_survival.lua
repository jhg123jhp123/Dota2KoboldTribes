require("core/event_bus")
require("core/runtime_context")
require("world/world_builder")
require("world/tile_registry")
require("services/team_service")
require("services/resource_service")
require("services/progression_service")
require("services/survival_service")
require("services/building_service")
require("services/recipe_service")
require("services/inventory_service")
require("services/revival_service")
require("services/weather_service")
require("services/spawn_service")
require("services/ai_service")
require("services/fishing_service")
require("debug/debug_commands")

if KoboldSurvivalGameMode == nil then
    KoboldSurvivalGameMode = class({})
end

local STARTING_ABILITY_NAMES = {
    "ability_kobold_walk",
    "ability_kobold_run",
    "ability_kobold_stop",
    "ability_kobold_basic_attack",
    "ability_kobold_interact",
    "ability_kobold_gather_contextual",
    "ability_kobold_pickup_item",
    "ability_kobold_drop_item",
    "ability_kobold_consume_food",
    "ability_kobold_open_inventory",
    "ability_kobold_open_build_menu",
    "ability_kobold_open_cooking_menu",
    "ability_kobold_open_crafting_menu",
    "ability_kobold_allocate_skill_points",
    "ability_kobold_inspect_survival",
    "ability_kobold_plant_tree",
    "ability_kobold_build_campfire",
    "ability_kobold_build_tent",
    "ability_kobold_build_farm",
    "ability_kobold_build_workbench",
    "ability_kobold_build_smithy",
    "ability_kobold_build_storage",
    "ability_kobold_build_hunters_lodge",
    "ability_kobold_build_tavern",
    "ability_kobold_build_spike_trap",
    "ability_kobold_bait_farm",
    "ability_kobold_domesticate_farm_sheep",
    "ability_kobold_hire_murloc_slave",
    "ability_kobold_deposit_first_item",
    "ability_kobold_withdraw_roasted_lamb",
    "ability_kobold_revive_ally",
    "ability_kobold_fell_tree",
    "ability_kobold_mine_stone",
    "ability_kobold_pick_berries",
    "ability_kobold_cook_recipe",
    "ability_kobold_refuel_campfire",
    "ability_spell_shield",
    "ability_spell_siphon_life",
    "ability_spell_affliction",
    "passive_survival_hunger_drain",
    "passive_survival_warmth_drain",
    "passive_survival_running_drain",
}

local function safe_call(object, methodName, ...)
    if object ~= nil and object[methodName] ~= nil then
        object[methodName](object, ...)
    end
end

function KoboldSurvivalGameMode:InitGameMode()
    print("[Kobold Survival] Initializing game mode")

    self.initializedHeroes = {}
    self.gameInProgress = false
    self.lastWinCheck = 0

    local eventBus = EventBus.New()
    local context = RuntimeContext.New({
        eventBus = eventBus,
        settings = {
            gameMode = "tribal_warfare",
        },
    })

    self.context = context
    _G.KoboldRuntime = context

    local builder = WorldBuilder.New()
    local runtimeData = builder:LoadDefinitionTable(require("data/worlds/kobold_survival_default"))
    local tileRegistry = TileRegistry.New(runtimeData)
    context:SetService("worldBuilder", builder)
    context:SetService("tileRegistry", tileRegistry)

    local teamService = TeamService.New({ context = context })
    local resourceService = ResourceService.New({ context = context })
    local progressionService = ProgressionService.New({ context = context })
    local survivalService = SurvivalService.New({ context = context })
    local buildingService = BuildingService.New({ context = context })
    local recipeService = RecipeService.New({ context = context })
    local inventoryService = InventoryService.New({ context = context })
    local revivalService = RevivalService.New({ context = context })
    local weatherService = WeatherService.New({ context = context })
    local aiService = AIService.New({ context = context })
    local spawnService = SpawnService.New({ context = context, tileRegistry = tileRegistry })
    local fishingService = FishingService.New({ context = context, tileRegistry = tileRegistry })

    context:SetService("teams", teamService)
    context:SetService("resources", resourceService)
    context:SetService("progression", progressionService)
    context:SetService("survival", survivalService)
    context:SetService("buildings", buildingService)
    context:SetService("recipes", recipeService)
    context:SetService("inventory", inventoryService)
    context:SetService("revival", revivalService)
    context:SetService("weather", weatherService)
    context:SetService("ai", aiService)
    context:SetService("spawns", spawnService)
    context:SetService("fishing", fishingService)

    teamService:Initialize()
    resourceService:InitializeTeams(teamService:GetPlayableTeams())
    inventoryService:InitializeTeams(teamService:GetPlayableTeams())
    weatherService:Push()
    DebugCommands.Register(context)

    self:ConfigureRules()
    self:RegisterEvents()

    local modeEntity = GameRules:GetGameModeEntity()
    if modeEntity ~= nil then
        modeEntity:SetThink("OnThink", self, "KoboldSurvivalThink", 1.0)
    end
end

function KoboldSurvivalGameMode:ConfigureRules()
    safe_call(GameRules, "SetHeroSelectionTime", 0)
    safe_call(GameRules, "SetPreGameTime", 8)
    safe_call(GameRules, "SetPostGameTime", 45)
    safe_call(GameRules, "SetShowcaseTime", 0)
    safe_call(GameRules, "SetStrategyTime", 0)
    safe_call(GameRules, "SetStartingGold", 0)
    safe_call(GameRules, "SetGoldPerTick", 0)
    safe_call(GameRules, "SetUseUniversalShopMode", false)
    safe_call(GameRules, "SetSameHeroSelectionEnabled", true)
    safe_call(GameRules, "SetCustomGameAllowHeroPickMusic", false)
    safe_call(GameRules, "SetCustomGameAllowMusicAtGameStart", false)
    safe_call(GameRules, "SetCustomGameAllowBattleMusic", true)
    safe_call(GameRules, "SetTimeOfDay", 0.25)

    if GameRules.SetCustomGameForceHero ~= nil then
        GameRules:SetCustomGameForceHero("npc_dota_hero_kobold_survivor")
    end

    local modeEntity = GameRules:GetGameModeEntity()
    if modeEntity ~= nil then
        safe_call(modeEntity, "SetRecommendedItemsDisabled", true)
        safe_call(modeEntity, "SetBuybackEnabled", false)
        safe_call(modeEntity, "SetCustomHeroMaxLevel", 30)
        safe_call(modeEntity, "SetFixedRespawnTime", -1)
        safe_call(modeEntity, "SetUseCustomHeroLevels", true)
        safe_call(modeEntity, "SetLoseGoldOnDeath", false)
        safe_call(modeEntity, "SetRemoveIllusionsOnDeath", true)
        safe_call(modeEntity, "SetCameraDistanceOverride", 1350)
        safe_call(modeEntity, "SetAnnouncerDisabled", true)
        safe_call(modeEntity, "SetKillingSpreeAnnouncerDisabled", true)
    end
end

function KoboldSurvivalGameMode:RegisterEvents()
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(KoboldSurvivalGameMode, "OnGameRulesStateChange"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(KoboldSurvivalGameMode, "OnNPCSpawned"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(KoboldSurvivalGameMode, "OnEntityKilled"), self)
    ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(KoboldSurvivalGameMode, "OnAbilityUsed"), self)
end

function KoboldSurvivalGameMode:OnGameRulesStateChange()
    local state = GameRules:State_Get()
    if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:OnGameInProgress()
    end
end

function KoboldSurvivalGameMode:OnGameInProgress()
    if self.gameInProgress then
        return
    end

    self.gameInProgress = true
    self.context:GetService("spawns"):SpawnInitialWorld()
    print("[Kobold Survival] Game in progress")
end

function KoboldSurvivalGameMode:OnNPCSpawned(event)
    local unit = EntIndexToHScript(event.entindex)
    if unit == nil or unit:IsNull() then
        return
    end

    if not unit:IsRealHero() then
        self.context:GetService("ai"):RegisterUnit(unit)
        return
    end

    local entityIndex = unit:GetEntityIndex()
    if self.initializedHeroes[entityIndex] then
        return
    end

    self.initializedHeroes[entityIndex] = true
    self:InitializeHero(unit)
end

function KoboldSurvivalGameMode:InitializeHero(hero)
    hero:SetGold(0, false)
    hero:SetGold(0, true)

    self:EnsureHeroAbilities(hero)
    self:MoveHeroToTribeStart(hero)

    self.context:GetService("survival"):RegisterHero(hero)
    self.context:GetService("progression"):RegisterHero(hero)
    self.context:GetService("resources"):InitializeTeam(hero:GetTeamNumber())
    self.context:GetService("inventory"):InitializeTeam(hero:GetTeamNumber())
    self.context:GetService("revival"):OnHeroRegistered(hero)

    if CreateItem ~= nil then
        local lantern = CreateItem("item_utility_lantern", hero, hero)
        if lantern ~= nil then
            hero:AddItem(lantern)
        end

        local food = CreateItem("item_food_roasted_lamb", hero, hero)
        if food ~= nil then
            hero:AddItem(food)
        end

        local fishingRod = CreateItem("item_tool_fishing_rod", hero, hero)
        if fishingRod ~= nil then
            hero:AddItem(fishingRod)
        end
    end
end

function KoboldSurvivalGameMode:EnsureHeroAbilities(hero)
    for _, abilityName in ipairs(STARTING_ABILITY_NAMES) do
        local ability = hero:FindAbilityByName(abilityName)
        if ability == nil then
            ability = hero:AddAbility(abilityName)
        end

        if ability ~= nil then
            ability:SetLevel(1)
        end
    end

    if hero.SetAbilityPoints then
        hero:SetAbilityPoints(0)
    end
end

function KoboldSurvivalGameMode:MoveHeroToTribeStart(hero)
    local teamService = self.context:GetService("teams")
    local tileRegistry = self.context:GetService("tileRegistry")
    local tribe = teamService:GetTribeForTeam(hero:GetTeamNumber())
    if tribe == nil then
        return
    end

    local starts = tileRegistry:GetSpawnPoints({ teamHint = tribe.id })
    if starts[1] == nil then
        return
    end

    local point = tileRegistry:GridToWorld(starts[1].position.x, starts[1].position.y)
    if FindClearSpaceForUnit ~= nil then
        FindClearSpaceForUnit(hero, point, true)
    end
end

function KoboldSurvivalGameMode:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    local attacker = nil
    if event.entindex_attacker ~= nil then
        attacker = EntIndexToHScript(event.entindex_attacker)
    end

    if killed ~= nil and not killed:IsNull() and killed.koboldResourceNodeId ~= nil then
        print("[Kobold Survival] resource node depleted: " .. killed.koboldResourceNodeId)
    end

    self.context:GetService("ai"):OnEntityKilled(killed, attacker)
    self.context:GetService("revival"):OnEntityKilled(killed, attacker)
    self:CheckWinCondition()
end

function KoboldSurvivalGameMode:OnAbilityUsed(event)
    if event.PlayerID == nil then
        return
    end

    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if hero ~= nil then
        self.context:GetService("survival"):RegisterHero(hero)
    end
end

function KoboldSurvivalGameMode:OnThink()
    local deltaTime = 1.0

    self.context:GetService("survival"):Think(deltaTime)
    self.context:GetService("buildings"):Think(deltaTime)
    self.context:GetService("ai"):Think(deltaTime)
    self.context:GetService("weather"):Think(deltaTime)

    if self.gameInProgress then
        self.lastWinCheck = self.lastWinCheck + deltaTime
        if self.lastWinCheck >= 3.0 then
            self.lastWinCheck = 0
            self:CheckWinCondition()
        end
    end

    return deltaTime
end

function KoboldSurvivalGameMode:CheckWinCondition()
    if not self.gameInProgress or PlayerResource == nil then
        return
    end

    local teamService = self.context:GetService("teams")
    local aliveByTeam = {}
    local activeTeams = 0
    local livingTeams = 0
    local winner = nil

    for _, team in ipairs(teamService:GetPlayableTeams()) do
        local hasPlayer = false
        local hasLivingHero = false

        local maxPlayers = DOTA_MAX_TEAM_PLAYERS or 24
        for playerId = 0, maxPlayers - 1 do
            if PlayerResource:IsValidPlayerID(playerId) and PlayerResource:GetTeam(playerId) == team then
                hasPlayer = true
                local hero = PlayerResource:GetSelectedHeroEntity(playerId)
                if hero ~= nil and not hero:IsNull() and hero:IsAlive() then
                    hasLivingHero = true
                end
            end
        end

        if hasPlayer then
            activeTeams = activeTeams + 1
            if hasLivingHero then
                aliveByTeam[team] = true
                livingTeams = livingTeams + 1
                winner = team
            end
        end
    end

    if activeTeams > 1 and livingTeams == 1 and winner ~= nil then
        GameRules:SetGameWinner(winner)
    end
end

return KoboldSurvivalGameMode
