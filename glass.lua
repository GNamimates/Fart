

local MODEL_GLASSWARE = models.glasses
:setParentType("SKULL")

local spring = require"lib.spring"
local sneakSpring = spring.new({
   f = 2,
   z = 0.3,
   r = -0.5,
})

---@alias Glass.Types "Delmonico"|"Wine"|"Shot"|"Mug"|"Stange"
---@class GlassRegistry
---@field types table<string, Glass>
local GlassRegistry = {types = {}}
GlassRegistry.__index = GlassRegistry

---@class Glass
---@field name string
---@field modelGlass ModelPart
---@field fluids Glass.FluidData[]


---@class Glass.FluidData
---@field model ModelPart
---@field expression function
---@field vertMovable Vector3[]
---@field vertPos Vector3[]


-- Scan the source model
for _, glass in pairs(MODEL_GLASSWARE:getChildren()) do
   -- Register a glass
   local glassType = {}
   
   local name = glass:getName()
   local modelGlass = glass
   
   -- Cache vertex position data for later use

   local fluid
   for key, child in pairs(modelGlass:getChildren()) do
      local childName = child:getName()
      if childName:find("^fluid") then
         local expression = loadstring("return "..child:getName())
         local vertMovable = {}
         local vertPos = {}
         
         -- Gather the vertices at the top of cubes
         if child:getType() == "CUBE" then
            local vertices = select(2,next(child:getAllVertices()))
            local function addVert(id)
               local i = #vertMovable+1
               vertMovable[i],vertPos[i] = vertices[id],vertices[id]:getPos()
            end
            -- Sides
            for i = 3, 15, 4 do
               addVert(i)
               addVert(i+1)
            end
            -- Top faces
            addVert(17)
            addVert(18)
            addVert(19)
            addVert(20)
         end
         
         -- Save the data to the fluid property
         fluid = {
            expression = expression,
            model = child,
            vertMovable = vertMovable,
            vertPos = vertPos
         }
         break
      end
   end
   glassType.name = name
   glassType.modelGlass = modelGlass
   glassType.fluid = fluid
   
   GlassRegistry.types[name] = glassType
end



events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
   if ctx:find("^FIRST") then
      if player:isLoaded() then
         local crot = client:getCameraRot()
         local left = ctx:find("LEFT_HAND$") and -1 or 1
         local state = math.clamp(crot.x/-45,0,1)
         sneakSpring.target = player:isSneaking() and 1 or 0
         MODEL_GLASSWARE:setScale()
         :setRot(
            math.lerp(
               math.lerp(vec(-20,45,-20),vec(-45,0,0),state),
               vec(-crot.x,0,0),
               sneakSpring.pos
            )
         )
         :setPos(math.lerp(
            math.lerp(vec(0,3,0),vec(9*left,7,4),state),
            vec(9*left,8+8*(1-math.cos(math.rad(crot.x))),10),
            sneakSpring.pos
         ))
      end
   elseif ctx:find("^THIRD") then
      MODEL_GLASSWARE
      :setScale(1.5)
      :setRot(-30,45,-40)
      :setPos(0,2,0)
   elseif ctx == "OTHER" then
      MODEL_GLASSWARE:setScale(1)
      :setRot():setPos()
   elseif block then
   end
   MODEL_GLASSWARE:setVisible(not block and true or false)
end)

return GlassRegistry