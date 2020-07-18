function sysCall_init()
    simRemoteApi.start(19999)
end


function sysCall_threadmain()
    -- Put some initialization code here


    -- Put your main loop here, e.g.:
    --
    -- while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do
    --     local p=sim.getObjectPosition(objHandle,-1)
    --     p[1]=p[1]+0.001
    --     sim.setObjectPosition(objHandle,-1,p)
    --     sim.switchThread() -- resume in next simulation step
    -- end
end

function sysCall_cleanup()
    -- Put some clean-up code here
end


--local objectHandle = 0
--local objectHandle_con = 0
--local objectHandle_tab = 0

function spawn_function(inInts,inFloats,inStrings,inBuffer)
    print(inFloats[1])
    print(inFloats[2])
    local objectHandle = sim.loadModel("UR10_non_move.ttm")
    sim.setObjectPosition(objectHandle,-1,inFloats)

    return {},{},{},'' -- return the handle of the created dummy
end


function spawn_function_con(inInts,inFloats_con,inStrings,inBuffer)
    print(inFloats_con[1])
   -- print(inFloats2[2])

    local objectHandle_con = sim.loadModel("customizable conveyor belt.ttm")
    sim.setObjectPosition(objectHandle_con,-1,inFloats_con)
    --sim.setObjectOrientation(objectHandle_con,-1,inInts)
    return {},{},{},'' -- return the handle of the created dummy

    
end

function spawn_function_tab(inInts,inFloats_tab,inStrings,inBuffer)
    print(inFloats_tab[1])
   -- print(inFloats2[2])

    local objectHandle_tab = sim.loadModel("customizable table.ttm")
    sim.setObjectPosition(objectHandle_tab,-1,inFloats_tab)
    return {},{},{},'' -- return the handle of the created dummy


end

--function remove_function_rob(inInts,inFloats_rob,inStrings,inBuffer)
 --   print(inFloats_rob[1])
   -- print(inFloats2[2])

   -- local objectHandle_tab = sim.loadModel("customizable table.ttm")
  -- sim.removeModel(objectHandle);
    --sim.simxRemoveModel(clientID,rob,sim.simx_opmode_blocking);
 --   return {},{},{},'' -- return the handle of the created dummy


--end

local VISIBLE_EDGES=2
local RESPONDABLE_SHAPE=8
local tblSize={0.06,0.06,0.06}  --cube size
-- while true do


if (sim.getSimulationState()~=sim.simulation_advancing_abouttostop) then
    -- sec
    --t=sim.wait(5)
    --sim.wait(3)

    t=sim.getSimulationTime()
    print(t)

    local hndShape=sim.createPureShape(0,VISIBLE_EDGES+RESPONDABLE_SHAPE,tblSize,0.01,NULL)
    sim.setObjectPosition(hndShape,-1,{5.35,-1.05,0.5})
    --sim.setShapeColor(hndShape,NULL,sim.colorcomponent_specular,NULL)
    --make cube detectable
    sim.setObjectSpecialProperty(hndShape,sim.objectspecialproperty_detectable_all)
    sim.wait(1005)

   -- objectHandle = sim.loadModel("UR10_non_move.ttm")
   -- objectHandle = sim.loadModel("C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\models\equipment\conveyor belts\"customizable conveyor belt.ttm"")

    --print(objectHandle)

    --require "socket"
    -- print("Milliseconds: " .. socket.gettime()*1000)
    --print("".. socket.gettime()*1000)
--sim.wait(5)


   --modelBase = simx.getObjectHandle("UR10_non_move.ttm")
   -- floor = sim.getObjectHandle("ResizableFloor_5_25")
local pos = {tblSize[1], tblSize[2]}

end



function executeCode_function(inInts,inFloats,inStrings,inBuffer)
    -- Execute the code stored in inStrings[1]:
    if #inStrings>=1 then
        return {},{},{loadstring(inStrings[1])()},'' -- return a string that contains the return value of the code execution
    end
end

resetScene=function(inInts,inFloats,inStrings,inBuffer)
    modelBase = sim.getObjectHandle('UR10_non_move.ttm')
    floor = sim.getObjectHandle('ResizableFloor_5_25')
    local pos = {inFloats[1], inFloats[2], inFloats[3]}
    local orig_orient = sim.getObjectOrientation(modelBase, -1)
    sim.displayDialog('Setting theta', inFloats[4], sim.dlgstyle_ok, false)
    local orient = {orig_orient[1], orig_orient[2], orig_orient[3]}
    sim.setObjectPosition(modelBase, -1, pos)
    sim.setObjectOrientation(modelBase, -1, orient)
end
-- See the user manual or the available code snippets for additional callback functions and details
