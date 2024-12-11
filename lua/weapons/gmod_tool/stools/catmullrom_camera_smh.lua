if not SMH then return end

TOOL.Category   = "Interfaces"
TOOL.Name       = "Stop Motion Helper"
TOOL.Command    = nil
TOOL.ConfigName	= nil
TOOL.Tab        = "CRCCams"

---@return Entity
function TOOL:GetCamera()
    return self:GetWeapon():GetNW2Entity("CatmullRomCams.Camera")
end

---@param entity Entity
function TOOL:SetCamera(entity)
    self:GetWeapon():SetNW2Entity("CatmullRomCams.Camera", entity)
end

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.SMH.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.SMH.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.SMH.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.SMH.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.SMH.BuildCPanel(panel)
end

