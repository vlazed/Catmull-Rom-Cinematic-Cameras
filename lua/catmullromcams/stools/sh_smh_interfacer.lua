---@class STool: TOOL
local STool = {}

CatmullRomCams.SToolMethods.SMH = STool

local cameraClasses = {
    gmod_cameraprop = true,
    hl_camera = true
}

---@param self STool
---@param trace TraceResult
---@return boolean
function STool.LeftClick(self, trace)	
	local ply   = self:GetOwner()
    local entity = trace.Entity
    if not IsValid(entity) or not cameraClasses[entity:GetClass()] then return false end

    ply:SetNWEntity("CatmullRomCams.Camera", entity)
    self:SetCamera(entity)

	return true
end

---@param self STool
---@param trace TraceResult
---@return boolean
function STool.RightClick(self, trace)
    if not IsValid(self:GetCamera()) then return false end
	local ply   = self:GetOwner()

    self:SetCamera(NULL)
    ply:SetNWEntity("CatmullRomCams.Camera", NULL)
    return true
end

function STool.Reload(self, trace)
end

local lastCamera = NULL
---@param self STool
function STool.Think(self)
    local currentCamera = self:GetCamera()
    if currentCamera ~= lastCamera then
        lastCamera = currentCamera
        if CLIENT then
            self.RebuildControlPanel(self, currentCamera)
        end
    end
end

local classMap = {
    hl_camera = "Advanced Camera",
    gmod_cameraprop = "Camera",
}

---@param panel ControlPanel
function STool.BuildCPanel(panel, camera)
    ---@diagnostic disable
    panel:Help(SMH and "Stop Motion Helper is installed. Select a camera entity to bake." or "Stop Motion Helper not installed")

    if not SMH then return end
    if not camera then return end

    panel:Help(("Camera selected: %s"):format(classMap[camera:GetClass()]))
    ---@diagnostic enable
end