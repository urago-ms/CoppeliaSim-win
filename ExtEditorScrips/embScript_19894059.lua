function sysCall_init()
         
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('conveyorSortUI')
    travelTime=sim.getScriptSimulationParameter(sim.handle_self,"travelTime")
    everyN=sim.getScriptSimulationParameter(sim.handle_self,"everyN")
    partType=sim.getScriptSimulationParameter(sim.handle_self,"partType")
    simSetUIButtonLabel(uiH,6,travelTime)
    simSetUIButtonLabel(uiH,9,everyN)
    simSetUIButtonLabel(uiH,10,partType)
    sens=-1
    output=-1
    outputS=-1
    sens=sim.getObjectHandle('ConveyorSort_sensOut')
    sensS=sim.getObjectHandle('ConveyorSort_sensOutS')
    buffer={}
    paused=false
    st=0
    cnt=0
    
end
------------------------------------------------------------------------------ 
-- Following few lines automatically added by CoppeliaSim to guarantee compatibility 
-- with CoppeliaSim 3.1.3 and earlier: 
colorCorrectionFunction=function(_aShapeHandle_) 
    local version=sim.getInt32Parameter(sim.intparam_program_version) 
    local revision=sim.getInt32Parameter(sim.intparam_program_revision) 
    if (version<30104)and(revision<3) then 
        return _aShapeHandle_ 
    end 
    return '@backCompatibility1:'.._aShapeHandle_ 
end 
------------------------------------------------------------------------------ 
 
 
scanOutputs=function()
    r,dist,pt,obj=sim.handleProximitySensor(sens)
    if (r==1) then
        output=sim.getObjectParent(obj)
    else
        output=-1
    end
    r,dist,pt,obj=sim.handleProximitySensor(sensS)
    if (r==1) then
        outputS=sim.getObjectParent(obj)
    else
        outputS=-1
    end
end


function sysCall_cleanup() 
    if sim.isHandleValid(model)==1 then
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    end
end 

function sysCall_actuation() 
    travelTime=tonumber(simGetUIButtonLabel(uiH,6))
    if (travelTime<0.1) then travelTime=0.1 end
    simSetUIButtonLabel(uiH,6,travelTime)
    
    everyN=tonumber(simGetUIButtonLabel(uiH,9))
    partType=simGetUIButtonLabel(uiH,10)
    paused=sim.boolAnd32(simGetUIButtonProperty(uiH,7),sim.buttonproperty_isdown)~=0
    scanOutputs() -- allow dynamic reconfiguration
    if (travelTime~=0) then
        vl=0.5/travelTime
        va=0.5*math.pi/travelTime
    end
    
    dt=sim.getSimulationTimeStep()
    if (paused) then
        dt=0
    end
    inBuffer=sim.getScriptSimulationParameter(sim.handle_self,"inBuffer")
    sim.setScriptSimulationParameter(sim.handle_self,"inBuffer","")
    if #inBuffer~=0 then
        d=sim.unpackInt32Table(inBuffer)
        for i=1,#d,1 do
            h=d[i]
            table.insert(buffer,h)
            table.insert(buffer,st+travelTime)
            isOut=false
            cnt=cnt+1
            if (everyN~=0)and(cnt>=everyN) then
                isOut=true
                cnt=0
            end
            dat=simGetObjectCustomData(h,125487)
            if (dat==partType) then
                isOut=true
            end
            table.insert(buffer,isOut)
        end
    end
    
    if not paused then
        for i=(#buffer)/3,1,-1 do
            h=buffer[3*(i-1)+1]
            kt=buffer[3*(i-1)+2]
            isOut=buffer[3*(i-1)+3]
            p=sim.getObjectPosition(h,model)
            if (isOut) then
                p[1]=p[1]+0.25
                p[2]=p[2]+0.25
                a=math.atan2(p[2],p[1])
                r=math.sqrt(p[1]*p[1]+p[2]*p[2])
                a=a-va*dt    
                p[1]=r*math.cos(a)
                p[2]=r*math.sin(a)
                p[1]=p[1]-0.25
                p[2]=p[2]-0.25
                if (p[2]<-0.25) then p[2]=-0.25 end
            else
                p[1]=p[1]+vl*dt
                if (p[1]>0.25) then p[1]=0.25 end
            end
    
            sim.setObjectPosition(h,model,p)
            if st>=kt then
                if (isOut) then
                    s=sim.getScriptSimulationParameter(sim.handle_self,'outBufferS')
                    s=s..sim.packInt32Table({h})
                    sim.setScriptSimulationParameter(sim.handle_self,'outBufferS',s)
                else
                    s=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
                    s=s..sim.packInt32Table({h})
                    sim.setScriptSimulationParameter(sim.handle_self,'outBuffer',s)
                end
                table.remove(buffer,3*(i-1)+3)
                table.remove(buffer,3*(i-1)+2)
                table.remove(buffer,3*(i-1)+1)
            end
        end
    end
    
    if (output~=-1) then
        d=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
        sim.setScriptSimulationParameter(sim.handle_self,'outBuffer','')
        if #d>0 then
            dat=sim.unpackInt32Table(d)
            for i=1,#dat,1 do
                h=dat[i]
                sim.setObjectParent(h,output,true)
                s=sim.getScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer')
                s=s..sim.packInt32Table({h})
                sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer',s)
            end
        end
    end
    if (outputS~=-1) then
        d=sim.getScriptSimulationParameter(sim.handle_self,'outBufferS')
        sim.setScriptSimulationParameter(sim.handle_self,'outBufferS','')
        if #d>0 then
            dat=sim.unpackInt32Table(d)
            for i=1,#dat,1 do
                h=dat[i]
                sim.setObjectParent(h,outputS,true)
                s=sim.getScriptSimulationParameter(sim.getScriptAssociatedWithObject(outputS),'inBuffer')
                s=s..sim.packInt32Table({h})
                sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(outputS),'inBuffer',s)
            end
        end
    end
    
    
    if (paused) then
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.8,0.1,0.1})
    else
        st=st+dt
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    end
end 

