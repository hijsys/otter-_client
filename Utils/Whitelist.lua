-- Whitelist Utility
-- Supports local list and optional remote JSON (array of userIds or names)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Whitelist = {}

-- Configuration (can be overridden by caller)
Whitelist.RemoteURL = nil
Whitelist.LocalUserIds = {}
Whitelist.LocalUsernames = {}
Whitelist.CacheTtlSeconds = 60

local lastFetchAt = 0
local cachedRemote = {
    userIds = {},
    usernames = {}
}

local function toSet(list)
    local set = {}
    for _, v in ipairs(list or {}) do
        set[v] = true
    end
    return set
end

local function fetchRemote(url)
    if not url or url == "" then
        return { userIds = {}, usernames = {} }
    end
    if tick() - lastFetchAt < Whitelist.CacheTtlSeconds then
        return cachedRemote
    end
    local success, data = pcall(function()
        local resp = game:HttpGet(url)
        return HttpService:JSONDecode(resp)
    end)
    if success and type(data) == "table" then
        local userIds = {}
        local usernames = {}
        for _, item in ipairs(data) do
            if type(item) == "number" then
                table.insert(userIds, item)
            elseif type(item) == "string" then
                table.insert(usernames, item)
            elseif type(item) == "table" then
                if type(item.userId) == "number" then table.insert(userIds, item.userId) end
                if type(item.username) == "string" then table.insert(usernames, item.username) end
            end
        end
        cachedRemote = { userIds = toSet(userIds), usernames = toSet(usernames) }
        lastFetchAt = tick()
        return cachedRemote
    else
        -- On error, keep previous cache
        return cachedRemote
    end
end

function Whitelist:IsWhitelisted(options)
    options = options or {}
    local localUser = Players.LocalPlayer
    if not localUser then return false end

    local targetUserId = localUser.UserId
    local targetUsername = localUser.Name

    -- Build local sets
    local localIdsSet = toSet(self.LocalUserIds)
    local localNamesSet = toSet(self.LocalUsernames)

    -- Check local allow list first
    if localIdsSet[targetUserId] or localNamesSet[targetUsername] then
        return true
    end

    -- Check remote allow list (if configured)
    local remote = fetchRemote(options.remoteUrl or self.RemoteURL)
    if remote.userIds[targetUserId] or remote.usernames[targetUsername] then
        return true
    end

    return false
end

return Whitelist


