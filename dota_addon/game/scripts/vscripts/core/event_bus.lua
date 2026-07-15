local EventBus = {}
EventBus.__index = EventBus

function EventBus.New()
    return setmetatable({
        listeners = {},
        nextToken = 1,
    }, EventBus)
end

function EventBus:Subscribe(eventName, handler, owner)
    assert(type(eventName) == "string" and eventName ~= "", "eventName is required")
    assert(type(handler) == "function", "handler must be a function")

    if self.listeners[eventName] == nil then
        self.listeners[eventName] = {}
    end

    local token = self.nextToken
    self.nextToken = self.nextToken + 1

    self.listeners[eventName][token] = {
        handler = handler,
        owner = owner,
    }

    return token
end

function EventBus:Unsubscribe(eventName, token)
    local listeners = self.listeners[eventName]
    if listeners == nil then
        return
    end

    listeners[token] = nil
end

function EventBus:Publish(eventName, payload)
    local listeners = self.listeners[eventName]
    if listeners == nil then
        return
    end

    local snapshot = {}
    for token, listener in pairs(listeners) do
        snapshot[#snapshot + 1] = {
            token = token,
            handler = listener.handler,
        }
    end

    for _, listener in ipairs(snapshot) do
        local ok, err = pcall(listener.handler, payload or {})
        if not ok then
            print("[Kobold Survival][EventBus] listener failed for " .. eventName .. ": " .. tostring(err))
        end
    end
end

function EventBus:ClearOwner(owner)
    for _, listeners in pairs(self.listeners) do
        for token, listener in pairs(listeners) do
            if listener.owner == owner then
                listeners[token] = nil
            end
        end
    end
end

return EventBus
