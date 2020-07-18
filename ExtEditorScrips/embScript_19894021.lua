function sysCall_init()
         
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('producerUI')
    col_=sim.getScriptSimulationParameter(sim.handle_self,'partColor')
    ft=sim.getScriptSimulationParameter(sim.handle_self,"fabricationTime")
    partType=sim.getScriptSimulationParameter(sim.handle_self,"partType")
    simSetUIButtonLabel(uiH,23,ft)
    simSetUIButtonLabel(uiH,24,col_)
    simSetUIButtonLabel(uiH,25,partType)
    output=-1
    sens=sim.getObjectHandle('Producer_sensOut')
    rawCol={0.8,0.8,0.8}
    fabStart=0
    produced=0
    pause=false
    nextPartType=partType
    if (partType==0) then
        nextPartType=nextPartType+1
        if (nextPartType==5) then nextPartType=1 end
    end
    h=sim.createPureShape(nextPartType-1,19+4,{0.1,0.1,0.1},1,nil)
    simAddObjectCustomData(h,125487,nextPartType)
    sim.setObjectParent(h,model,true)
    startPos={0,0,0.44}
    nextTargetPos={0.25,(math.random()-0.5)*0.4,0.55}
    sim.setObjectPosition(h,model,startPos)
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
 
 
updateUI=function(uiHandle,number)
    if (previousCounter~=number) then
        activeCol={0.1,1.0,0.1}
        passiveCol={0.1,0.1,0.1}
        c=math.fmod(number,1000)
        for i=0,2,1 do
            d=math.floor(c/(10^(2-i)))
            b=100+i*10
            if (d==0) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==1) then
                simSetUIButtonColor(uiHandle,b+0,passiveCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==2) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,passiveCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==3) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==4) then
                simSetUIButtonColor(uiHandle,b+0,passiveCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==5) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,passiveCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==6) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,passiveCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==7) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==8) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==9) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            c=c-d*(10^(2-i))
        end
    end
    previousCounter=number
end
    
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
    col_=simGetUIButtonLabel(uiH,24)
    col={0,0,0}
    i=1
    for token in string.gmatch(col_,"[^%s]+") do
        col[i]=token
        i=i+1
    end
    ft=tonumber(simGetUIButtonLabel(uiH,23))
    if (ft<0.1) then ft=0.1 end
    simSetUIButtonLabel(uiH,23,ft)
    partType=tonumber(simGetUIButtonLabel(uiH,25))
    if (partType~=0) then nextPartType=partType end
    paused=sim.boolAnd32(simGetUIButtonProperty(uiH,22),sim.buttonproperty_isdown)~=0
    scanOutput() -- allow dynamic reconfiguration
    
    
    -- Make a cube slowly appear:
    t=(st-fabStart)/ft
    if t>1 then t=1 end
    if (t<=0.5) then
        t=t/0.5
        pp={0,0,startPos[3]*(1-t)+nextTargetPos[3]*t}
        sim.setObjectPosition(h,model,pp)
        cc={rawCol[1]*(1-t)+col[1]*t,rawCol[2]*(1-t)+col[2]*t,rawCol[3]*(1-t)+col[3]*t}
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,cc)
    else
        t=(t-0.5)/0.5
        pp={startPos[1]*(1-t)+nextTargetPos[1]*t,startPos[2]*(1-t)+nextTargetPos[2]*t,nextTargetPos[3]}
        sim.setObjectPosition(h,model,pp)
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,col)
    end
    
    if (st>=fabStart+ft) then
        produced=produced+1
        fabStart=st
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,col)
        r=0.1+math.random()*0.15
        a=math.pi*2*math.random()
        sim.setObjectPosition(h,model,nextTargetPos)
        nextTargetPos={0.25,(math.random()-0.5)*0.4,0.55}
    
        s=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
        s=s..sim.packInt32Table({h})
        sim.setScriptSimulationParameter(sim.handle_self,'outBuffer',s)
        if (partType==0) then
            nextPartType=nextPartType+1
            if (nextPartType==5) then nextPartType=1 end
        end
        h=sim.createPureShape(nextPartType-1,19+4,{0.1,0.1,0.1},1,nil)
        
        simAddObjectCustomData(h,125487,nextPartType)
        sim.setObjectParent(h,model,true)
        sim.setObjectPosition(h,model,startPos)
    end
    
    if (output~=-1) then
        d=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
        sim.setScriptSimulationParameter(sim.handle_self,'outBuffer','')
        if (#d>0) then
            dat=sim.unpackInt32Table(d)
            for i=1,#dat,1 do
                h2=dat[i]
                sim.setObjectParent(h2,output,true)
                s=sim.getScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer')
                s=s..sim.packInt32Table({h2})
                sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer',s)
            end
        end
    end
    
    
    updateUI(uiH,produced)
    
    if not paused then
        st=st+sim.getSimulationTimeStep()
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    else
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.8,0.1,0.1})
    end
end 

