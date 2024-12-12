local MODEL_DISPENSER = models.dispenser
:setParentType("SKULL")
:setPrimaryRenderType("TRANSLUCENT_CULL")

local skullWorld = models:newPart("skullWorld","SKULL")
skullWorld:newBlock("test"):block("minecraft:grass_block")
local face2dir = {
   south = vec(0,0,1),
   west = vec(-1,0,0),
   north = vec(0,0,-1),
   east = vec(1,0,0)
}

local UP = vec(0,1,0)

local cacheColor = {}

local time = 0
events.WORLD_RENDER:register(function (delta)
	time = client:getSystemTime()/1000
end)

events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	skullWorld:setVisible(false)
	if block then
		local dir
		local pos = block:getPos()
		local id = tostring(pos)
		if block.id == "minecraft:player_wall_head" then
			dir = face2dir[block.properties.facing]
		else
			dir = UP
		end

		local color = cacheColor[id]
		if color and color.time > time-2 then
			color = cacheColor[id]
		else
			local data = {color = world.getBlockState(pos-dir):getMapColor(), time = time}
			cacheColor[id] = data
			color = data
		end
		MODEL_DISPENSER.base.container:setColor(color.color)
	end
	MODEL_DISPENSER:setVisible(block and true or false)
end)