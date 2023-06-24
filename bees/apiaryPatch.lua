
require "/bees/apiary.lua"

local beesOnShips_oldInit = init or function() end


-- apiary.init but with ship check removed
function letBeesOnShips_init()
	biome = world.type()
    
    -- Removed check for ship so bees work there

	-- Retrieve data
	maxStackDefault = root.assetJson("/items/defaultParameters.config").defaultMaxStack
	beeData = root.assetJson("/bees/beeData.config")
	slotCount = config.getParameter("slotCount")
	queenSlot = config.getParameter("queenSlot")
	droneSlots = config.getParameter("droneSlots")
	frameSlots = config.getParameter("frameSlots")
	firstInventorySlot = config.getParameter("firstInventorySlot")

	-- Get contents now because its needed in some functions which may get called before the first bee update tick
	contents = world.containerItems(entity.id())

	-- Init drone production table. Not in storage because it should reset every init
	droneProductionProgress = {}

	-- Init young queen and drone breeding progress
	youngQueenProgress = 0
	droneProgress = 0

	-- Init mite counter
	storage.mites = storage.mites or 0

	-- Init loading animation
	setAnimationStates(true, false, false)

	-- Init timer, and offset update delta to reduce potential lag spikes when they all update at the same time
	beeUpdateTimer = beeData.beeUpdateInterval



	local timerIncrement = config.getParameter("scriptDelta") * 0.01

	local sameTimers
	repeat
		beeUpdateTimer = beeUpdateTimer + timerIncrement
		sameTimers = world.objectQuery(entity.position(), 10, {withoutEntityId = entity.id(), callScript = "GetUpdateTimer", callScriptResult = beeUpdateTimer})
	until (not sameTimers or #sameTimers == 0)
end


-- Hook into apiary.init to avoid check that prevents bees on ship
function init()
    biome = world.type()
    
    if biome == "unknown" then
        letBeesOnShips_init()
    else
        beesOnShips_oldInit()
    end
end