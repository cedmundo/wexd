require 'enemy'

return {
   {
      time = 3.0,
      does = function(t, mm, em)
         local e = SmallEnemy(mm)
         e:addPathTarget({x = 10, y = 20})
         e:addShootOrder({x = 10, y = 20})
         em:addEnemy(e)
      end
   },
}
