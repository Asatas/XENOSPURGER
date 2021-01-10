local XPs = {
	". FOR THE EMPEROR!",
	". PURGE THE XENOS!",
	". CLEANSE THE FILTH!",
	". PURGE THE UNCLEAN!",
	". BY THE INQUISITION!",
	". SUFFER NOT THE XENO TO LIVE!",
	". BURN THE HERETIC!",
	". KILL THE MUTANT!",
	". IN THE EMPEROR'S NAME, LET NONE SURVIVE!"
}

local defaults = {
	db_version = 1,
	enabled = true,
}

local db
local hyperlinks = {}

local function OnEvent(self, event, addon)
	if addon == "XENOSPURGER" then
		if not XENOSPURGERDB or XENOSPURGERDB.db_version < defaults.db_version then
			XENOSPURGERDB = CopyTable(defaults)
		end
		db = XENOSPURGERDB
		self:UnregisterEvent("ADDON_LOADED")
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)

local function ReplaceLink(s)
	tinsert(hyperlinks, s)
	return "XP"..#hyperlinks
end

local function RestoreLink(s)
	local n = tonumber(s:match("%d"))
	return hyperlinks[n]
end

local makeXP = SendChatMessage

function SendChatMessage(msg, ...)
	if db.enabled then
		wipe(hyperlinks)
		local XP = XPs[random(#XPs)]
		local whatsthis = random(10)
		-- tempowawiwy wepwace winks wif XPs
		local s = msg:gsub("|c.-|r", ReplaceLink)
		s = string.upper(s)
		s = s .. XP

		-- y-you awe such a b-baka
		s = format(" %s ", s)
		for k in gmatch(s, "%a+") do
			if random(10) == 1 then
				local firstChar = k:sub(1, 1)
				s = s:gsub(format(" %s ", k), format(" %s-%s ", firstChar, k))
			end
		end
		s = s:trim()
		s = whatsthis == 1 and s.." "..XP or s:gsub("!$", " "..XP)
		-- pwease PURGE wesponsibwy
		s = #s <= 255 and s:gsub("XP%d", RestoreLink) or msg
		makeXP(s, ...)
	else
		makeXP(msg, ...)
	end
end

local EnabledMsg = {
	[true] = "|cffADFF2FPURGING|r",
	[false] = "|cffFF2424NOT PURGING|r",
}

SLASH_XENOSPURGER1 = "/XP"
SLASH_XENOSPURGER2 = "/XENOSPURGER"

SlashCmdList.XENOSPURGER = function()
	db.enabled = not db.enabled
	print("XENOSPURGER: "..EnabledMsg[db.enabled])
end
