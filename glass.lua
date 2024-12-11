
local GLASS_SCALE_WORLD = 0.8
local GLASS_SCALE_1ST_PERSON = 1
local GLASS_SCALE_ITEM = 1
local GLASS_SCALE_3RD_PERSON = 1.5

local SOURCE_MODEL = models.glasses
:setParentType("SKULL")


---@alias Glass.Types "Delmonico"
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
for _, glass in pairs(SOURCE_MODEL:getChildren()) do
   -- Register a glass
   local glassType = {}
   
   local name = glass:getName()
   local modelGlass = glass
   local modelFluid = modelGlass[name.."Fluid"]
   
   -- Cache vertex position data for later use
   local fluids = {}
   for key, child in pairs(modelFluid:getChildren()) do
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
      fluids[#fluids+1] = {
         expression = expression,
         model = child,
         vertMovable = vertMovable,
         vertPos = vertPos
      }
   end
   glassType.name = name
   glassType.modelGlass = modelGlass
   glassType.fluids = fluids
   
   GlassRegistry.types[name] = glassType
end



events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
   if ctx:find("^FIRST") then
      local name = item:getName()   
      SOURCE_MODEL
      :setScale(GLASS_SCALE_1ST_PERSON)
      :setRot()
   elseif ctx:find("^THIRD") then
      SOURCE_MODEL
      :setScale(GLASS_SCALE_3RD_PERSON)
      :setRot(-30,45,-40)
   elseif ctx == "OTHER" then
   SOURCE_MODEL:setScale(GLASS_SCALE_ITEM)
   elseif block then
      SOURCE_MODEL:setScale(GLASS_SCALE_WORLD)
   end
end)

return GlassRegistry