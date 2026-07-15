local WeatherService = {}
WeatherService.__index = WeatherService

local WEATHER = {
    clear = {
        displayName = "Clear",
        warmthDrainMultiplier = 1.0,
        nightVisionPenalty = 0,
    },
    rain = {
        displayName = "Rain",
        warmthDrainMultiplier = 1.35,
        campfireFuelMultiplier = 1.3,
        nightVisionPenalty = 80,
    },
    winter = {
        displayName = "Winter Is Coming",
        warmthDrainMultiplier = 2.0,
        campfireFuelMultiplier = 1.5,
        nightVisionPenalty = 120,
    },
    ghouls = {
        displayName = "Night of the Ghouls",
        warmthDrainMultiplier = 1.2,
        forceNight = true,
        nightVisionPenalty = 120,
    },
    darkness = {
        displayName = "Ancient Shrine Curse",
        warmthDrainMultiplier = 1.0,
        nightVisionPenalty = 260,
    },
}

function WeatherService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        weatherId = "clear",
        remainingSeconds = 0,
        elapsedSeconds = 0,
    }, WeatherService)
end

function WeatherService:StartWeather(weatherId, duration)
    if WEATHER[weatherId] == nil then
        weatherId = "clear"
    end

    self.weatherId = weatherId
    self.remainingSeconds = math.max(0, duration or 0)
    self.elapsedSeconds = 0

    if WEATHER[weatherId].forceNight and GameRules ~= nil and GameRules.SetTimeOfDay ~= nil then
        GameRules:SetTimeOfDay(0.85)
    end

    self:Push()
    return true
end

function WeatherService:Clear()
    return self:StartWeather("clear", 0)
end

function WeatherService:Think(deltaTime)
    deltaTime = deltaTime or 1
    self.elapsedSeconds = self.elapsedSeconds + deltaTime

    if self.weatherId ~= "clear" and self.remainingSeconds > 0 then
        self.remainingSeconds = math.max(0, self.remainingSeconds - deltaTime)
        if self.remainingSeconds <= 0 then
            self:Clear()
            return
        end
    end

    self:Push()
end

function WeatherService:GetDefinition()
    return WEATHER[self.weatherId] or WEATHER.clear
end

function WeatherService:AdjustWarmthDrain(drain)
    if drain <= 0 then
        return drain
    end

    return drain * (self:GetDefinition().warmthDrainMultiplier or 1.0)
end

function WeatherService:GetCampfireFuelMultiplier()
    return self:GetDefinition().campfireFuelMultiplier or 1.0
end

function WeatherService:GetNightVisionPenalty()
    return self:GetDefinition().nightVisionPenalty or 0
end

function WeatherService:GetSnapshot()
    local definition = self:GetDefinition()
    return {
        weatherId = self.weatherId,
        displayName = definition.displayName,
        remainingSeconds = math.floor(self.remainingSeconds),
        warmthDrainMultiplier = definition.warmthDrainMultiplier or 1.0,
        campfireFuelMultiplier = definition.campfireFuelMultiplier or 1.0,
        nightVisionPenalty = definition.nightVisionPenalty or 0,
    }
end

function WeatherService:Push()
    if CustomNetTables == nil then
        return
    end

    CustomNetTables:SetTableValue("kobold_weather", "state", self:GetSnapshot())
end

return WeatherService
