GF_Config = GF_Config or { printEnabled = true }

-- 1. Default List
local germanKeywords = {
    "aber", "alle", "als", "auf", "dann", "das", "der", 
    "ein", "für", "geht", "gibt", "gilde", "gilden", "gruppe", "günstig", 
    "haben", "heute", "ich", "ist", "jemand", "kann", "kaufe", "keine", "kleine", "lern", "mit", "nein", 
    "netten", "nicht", "nur", "preis", "rekrutiert", "sicheren", "suche", "suchen", "über", "und", 
    "unter", "von", "vorhanden", "waffe", "weiter", "würg", "ß"
}

local lastProcessedLineID = 0

-- In 2026 Classic Era (1.15.x), the filter function arguments are:
-- (self, event, message, sender, language, channelString, target, flags, zoneID, channelIndex, channelBaseName, lineID, guid)
local function GermanChatFilter(self, event, message, sender, _, _, _, _, _, _, lineID, ...)
    
    -- Safety check: ensure message and sender exist
    --if not message or not sender then return false end
    
    local msgLower = message:lower()
    
    for _, word in ipairs(germanKeywords) do
        -- %f[%a] is the frontier pattern for whole word matching
        if msgLower:find("%f[%a]" .. word .. "%f[%A]") then
            
            if lineID ~= lastProcessedLineID then
                lastProcessedLineID = lineID
                
                -- Only print if the toggle is ON
                if GF_Config.printEnabled then
                   print("|cFFFF0000[Filter]|r |cFF00FFFF" .. sender .. "|r blocked for: |cFFFFD100" .. word .. "|r")
                end
            end
            
            return true -- Hide message
        end
    end
    return false -- Show the message
end

-- Common chat events for Classic Era
local channels = {
    "CHAT_MSG_CHANNEL", 
    "CHAT_MSG_SAY", 
    "CHAT_MSG_YELL", 
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_GUILD"
}

for _, event in ipairs(channels) do
    ChatFrame_AddMessageEventFilter(event, GermanChatFilter)
end

-- Slash Command /gf print
SLASH_GERMANFILTER1 = "/gf"
SlashCmdList["GERMANFILTER"] = function(msg)
    if msg:lower() == "print" then
        GF_Config.printEnabled = not GF_Config.printEnabled
        local status = GF_Config.printEnabled and "|cff00ff00ENABLED|r" or "|cffff0000DISABLED|r"
        print("|cFFFF0000[Filter]|r Printing is now: " .. status)
    else
        print("|cFFFF0000[Filter]|r Use |cFFFFD100/gf print|r to toggle notifications.")
    end

end
