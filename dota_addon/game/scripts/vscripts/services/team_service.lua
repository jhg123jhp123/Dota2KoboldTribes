local TeamService = {}
TeamService.__index = TeamService

local function resolve_team(teamName)
    local teams = {
        DOTA_TEAM_GOODGUYS = DOTA_TEAM_GOODGUYS or 2,
        DOTA_TEAM_BADGUYS = DOTA_TEAM_BADGUYS or 3,
        DOTA_TEAM_CUSTOM_1 = DOTA_TEAM_CUSTOM_1 or 6,
        DOTA_TEAM_CUSTOM_2 = DOTA_TEAM_CUSTOM_2 or 7,
    }

    return teams[teamName]
end

function TeamService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        tribeRules = options.tribeRules or require("data/tribes/tribe_rules"),
        activeTribes = {},
        tribeByTeam = {},
        teamByTribe = {},
    }, TeamService)
end

function TeamService:Initialize()
    local count = self.tribeRules.defaultTribeCount or 2
    local maxPlayers = self.tribeRules.maxPlayersPerTribe
    if type(maxPlayers) ~= "number" then
        maxPlayers = 5
    end

    for _, tribe in ipairs(self.tribeRules.tribes or {}) do
        local team = resolve_team(tribe.dotaTeam)
        if team ~= nil and (#self.activeTribes < count or tribe.initialSupport) then
            local entry = {
                id = tribe.id,
                displayName = tribe.displayName,
                team = team,
                color = tribe.color or { r = 255, g = 255, b = 255 },
            }

            self.activeTribes[#self.activeTribes + 1] = entry
            self.tribeByTeam[team] = entry
            self.teamByTribe[tribe.id] = team

            if GameRules and GameRules.SetCustomGameTeamMaxPlayers then
                GameRules:SetCustomGameTeamMaxPlayers(team, maxPlayers)
            end
        end
    end

    self:PushNetTables()
end

function TeamService:GetActiveTribes()
    return self.activeTribes
end

function TeamService:GetPlayableTeams()
    local teams = {}
    for _, tribe in ipairs(self.activeTribes) do
        teams[#teams + 1] = tribe.team
    end

    return teams
end

function TeamService:GetTeamForTribe(tribeId)
    return self.teamByTribe[tribeId]
end

function TeamService:GetTribeForTeam(team)
    return self.tribeByTeam[team]
end

function TeamService:PushNetTables()
    if CustomNetTables == nil then
        return
    end

    for _, tribe in ipairs(self.activeTribes) do
        CustomNetTables:SetTableValue("kobold_tribes", tostring(tribe.team), {
            id = tribe.id,
            displayName = tribe.displayName,
            color = tribe.color,
        })
    end
end

return TeamService
