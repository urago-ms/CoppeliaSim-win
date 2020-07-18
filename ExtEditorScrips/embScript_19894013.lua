function sysCall_threadmain()
    -- Initialization:
    sim.setThreadSwitchTiming(2) -- Default timing for automatic thread switching
    h=sim.getObjectAssociatedWithScript(sim.handle_self)

    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do
        sim.wait(27)
        sim.setIntegerSignal("pause",1)
        sim.wait(2)
        sim.rmlMoveToJointPositions({h},-1,{0},{0},{0.6},{0.6},{0.8},{0.5},{0})
        sim.clearIntegerSignal("pause")
        sim.wait(7)
        sim.setIntegerSignal("pause",1)
        sim.wait(2)
        sim.rmlMoveToJointPositions({h},-1,{0},{0},{0.6},{0.6},{0.8},{0},{0})
        sim.clearIntegerSignal("pause")
    end
end