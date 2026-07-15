local RuntimeContext = {}
RuntimeContext.__index = RuntimeContext

function RuntimeContext.New(options)
    options = options or {}

    return setmetatable({
        services = options.services or {},
        settings = options.settings or {},
        eventBus = options.eventBus,
    }, RuntimeContext)
end

function RuntimeContext:GetService(serviceName)
    return self.services[serviceName]
end

function RuntimeContext:SetService(serviceName, service)
    assert(type(serviceName) == "string" and serviceName ~= "", "serviceName is required")
    self.services[serviceName] = service
    return service
end

function RuntimeContext:HasService(serviceName)
    return self.services[serviceName] ~= nil
end

function RuntimeContext:GetEventBus()
    return self.eventBus
end

function RuntimeContext:Publish(eventName, payload)
    if self.eventBus ~= nil then
        self.eventBus:Publish(eventName, payload)
    end
end

function RuntimeContext:GetSetting(key, fallback)
    local value = self.settings[key]
    if value == nil then
        return fallback
    end

    return value
end

return RuntimeContext
