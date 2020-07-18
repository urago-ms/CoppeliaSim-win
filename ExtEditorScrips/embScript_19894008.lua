function sysCall_init()
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    e1=sim.getObjectHandle('ResizableFloor_5_25_element')
    e2=sim.getObjectHandle('ResizableFloor_5_25_visibleElement')
end

function sysCall_cleanup()
    hideDlg()
end

function sysCall_nonSimulation()
    local s=sim.getObjectSelection()
    if s and #s>=1 and s[1]==model then
        showDlg()
    else
        hideDlg()
    end
end

function sysCall_beforeSimulation()
    hideDlg()
end

function sysCall_beforeSimulation()
    hideDlg()
end

function updateFloor()
    local c=readInfo()
    local sx=c['sizes'][1]/5
    local sy=c['sizes'][2]/5
    local sizeFact=sim.getObjectSizeFactor(model)
    sim.setObjectParent(e1,-1,true)
    local child=sim.getObjectChild(model,0)
    while child~=-1 do
        sim.removeObject(child)
        child=sim.getObjectChild(model,0)
    end
    local xPosInit=(sx-1)*-2.5*sizeFact
    local yPosInit=(sy-1)*-2.5*sizeFact
    local f1,f2
    for x=1,sx,1 do
        for y=1,sy,1 do
            if (x==1)and(y==1) then
                sim.setObjectParent(e1,model,true)
                f1=e1
            else
                f1=sim.copyPasteObjects({e1},0)[1]
                f2=sim.copyPasteObjects({e2},0)[1]
                sim.setObjectParent(f1,model,true)
                sim.setObjectParent(f2,f1,true)
            end
            local p=sim.getObjectPosition(f1,sim.handle_parent)
            p[1]=xPosInit+(x-1)*5*sizeFact
            p[2]=yPosInit+(y-1)*5*sizeFact
            sim.setObjectPosition(f1,sim.handle_parent,p)
        end
    end
end

function getDefaultInfoForNonExistingFields(info)
    if not info['version'] then
        info['version']=0
    end
    if not info['sizes'] then
        info['sizes']={1,1}
    end
end

function readInfo()
    local data=sim.readCustomDataBlock(model,'XYZ_FLOOR_INFO')
    if data then
        data=sim.unpackTable(data)
    else
        data={}
    end
    getDefaultInfoForNonExistingFields(data)
    return data
end

function writeInfo(data)
    if data then
        sim.writeCustomDataBlock(model,'XYZ_FLOOR_INFO',sim.packTable(data))
    else
        sim.writeCustomDataBlock(model,'XYZ_FLOOR_INFO','')
    end
end

function updateUi()
    local c=readInfo()
    local sizeFact=sim.getObjectSizeFactor(model)
    simUI.setLabelText(ui,1,'X-size (m): '..string.format("%.2f",c['sizes'][1]*sizeFact),true)
    simUI.setSliderValue(ui,2,c['sizes'][1]/5,true)
    simUI.setLabelText(ui,3,'Y-size (m): '..string.format("%.2f",c['sizes'][2]*sizeFact),true)
    simUI.setSliderValue(ui,4,c['sizes'][2]/5,true)
end

function sliderXChange(ui,id,newVal)
    local c=readInfo()
    c['sizes'][1]=newVal*5
    writeInfo(c)
    updateUi()
    updateFloor()
end

function sliderYChange(ui,id,newVal)
    local c=readInfo()
    c['sizes'][2]=newVal*5
    writeInfo(c)
    updateUi()
    updateFloor()
end

function closeEventHandler(h)
    sim.removeScript(sim.handle_self)
end

function showDlg()
    if not ui then
    xml = [[
<ui title="Floor Customizer" closeable="true" on-close="closeEventHandler" resizable="false" activate="false">
    <group layout="form" flat="true">
        <label text="X-size (m): 1" id="1"/>
        <hslider tick-position="above" tick-interval="1" minimum="1" maximum="5" on-change="sliderXChange" id="2"/>
        <label text="Y-size (m): 1" id="3"/>
        <hslider tick-position="above" tick-interval="1" minimum="1" maximum="5" on-change="sliderYChange" id="4"/>
    </group>
    <label text="" style="* {margin-left: 400px;}"/>
</ui>
]]
        ui=simUI.create(xml)
        if 2==sim.getInt32Parameter(sim.intparam_platform) then
            -- To fix a Qt bug on Linux
            sim.auxFunc('activateMainWindow')
        end
        updateUi()
    end
end

function hideDlg()
    if ui then
        simUI.destroy(ui)
        ui=nil
    end
end
