function sysCall_init()
         
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('transformerUI')
    workTime=sim.getScriptSimulationParameter(sim.handle_self,"workTime")
    simSetUIButtonLabel(uiH,6,workTime)
    newColor=sim.getScriptSimulationParameter(sim.handle_self,"newColor")
    simSetUIButtonLabel(uiH,9,newColor)
    sens=-1
    output=-1
    sens=sim.getObjectHandle('Transformer_sensOut')
    buffer={}
    paused=false
    st=0
    
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
 
 
scanOutput=function()
    r,dist,pt,obj=sim.handleProximitySensor(sens)
    if (r==1) then
        output=sim.getObjectParent(obj)
    else
        output=-1
    end
end


function sysCall_cleanup() 
    if sim.isHandleValid(model)==1 then
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    end
end 

function sysCall_actuation() 
    workTime=tonumber(simGetUIButtonLabel(uiH,6))
    if (workTime<0.1) then workTime=0.1 end
    simSetUIButtonLabel(uiH,6,workTime)
    
    newColor=simGetUIButtonLabel(uiH,9)
    col={0,0,0}
    i=1
    for token in string.gmatch(newColor,"[^%s]+") do
        col[i]=token
        i=i+1
    end
    
    paused=sim.boolAnd32(simGetUIButtonProperty(uiH,11),sim.buttonproperty_isdown)~=0
    scanOutput() -- allow dynamic reconfiguration
    if (workTime~=0) then
        v=1/workTime
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
            table.insert(buffer,st)
            if #buffer==2 then
                r,rawCol=sim.getShapeColor(h,nil,0)
            end
        end
    end
    
    if not paused then
        if #buffer>0 then
            h=buffer[1]
            kt=buffer[2]
            p=sim.getObjectPosition(h,model)
            p[1]=p[1]+v*dt
            if (p[1]>0.5) then p[1]=0.5 end
            sim.setObjectPosition(h,model,p)
    
            t=(st-kt)/workTime
            if t>1 then t=1 end
            cc={rawCol[1]*(1-t)+col[1]*t,rawCol[2]*(1-t)+col[2]*t,rawCol[3]*(1-t)+col[3]*t}
            sim.setShapeColor(colorCorrectionFunction(h),nil,0,cc)
    
    
            if st>=kt+workTime then
                sim.setShapeColor(colorCorrectionFunction(h),nil,0,col)
                s=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
                s=s..sim.packInt32Table({h})
                sim.setScriptSimulationParameter(sim.handle_self,'outBuffer',s)
                table.remove(buffer,1)
                table.remove(buffer,1)
                if #buffer>0 then
                    buffer[2]=st
                    r,rawCol=sim.getShapeColor(buffer[1],nil,0)
                end
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
    
    
    if (paused) then
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.8,0.1,0.1})
    else
        st=st+dt
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    end
end 

