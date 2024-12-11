vanilla_model.OUTER_LAYER:setVisible(false)
vanilla_model.HAT:setVisible(true)

models.glasses:setPrimaryRenderType("TRANSLUCENT_CULL")

events.ENTITY_INIT:register(function ()
   if player:getModelType() == "SLIM" then
      models.player.LeftArm.LNormal:setVisible(false)
      models.player.RightArm.RNormal:setVisible(false)
   else
      models.player.LeftArm.LSlim:setVisible(false)
      models.player.RightArm.RSlim:setVisible(false)
   end
end)
