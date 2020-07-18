function sysCall_init()
         
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('sinkCounter')
    destroyedCount=0
    buffer={}
    destroyTime=1
    
end
updateUI=function(uiHandle,number)
    if (previousCounter~=number) then
        activeCol={0.1,1.0,1.0}
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


function sysCall_cleanup() 
 
end 

function sysCall_actuation() 
    st=sim.getSimulationTime()
    dt=sim.getSimulationTimeStep()
    inBuffer=sim.getScriptSimulationParameter(sim.handle_self,"inBuffer")
    if #inBuffer~=0 then
        d=sim.unpackInt32Table(inBuffer)
        for i=1,#d,1 do
            h=d[i]
            table.insert(buffer,h)
            table.insert(buffer,st)
            p=sim.getObjectPosition(h,model)
            table.insert(buffer,p[1])
            table.insert(buffer,p[2])
        end
    end
    sim.setScriptSimulationParameter(sim.handle_self,"inBuffer","")
    
    for i=(#buffer)/4,1,-1 do
        h=buffer[4*(i-1)+1]
        kt=buffer[4*(i-1)+2]
        po=buffer[4*(i-1)+3]
        pa=buffer[4*(i-1)+4]
        t=(st-kt)/destroyTime
        if t>1 then t=1 end
        if (t<=0.5) then
            t=t/0.5
            pp={po*(1-t),pa*(1-t),0.55}
        else
            t=(t-0.5)/0.5
            pp={0,0,0.55*(1-t)+0.44*t}
        end
        sim.setObjectPosition(h,model,pp)
    
        if st>=kt+destroyTime then
            table.remove(buffer,4*(i-1)+4)
            table.remove(buffer,4*(i-1)+3)
            table.remove(buffer,4*(i-1)+2)
            table.remove(buffer,4*(i-1)+1)
            t=sim.getObjectSelection()
            sim.removeObject(h)
            sim.removeObjectFromSelection(sim.handle_all)
            sim.addObjectToSelection(t)
            destroyedCount=destroyedCount+1
        end
    end
    updateUI(uiH,destroyedCount)
end 

