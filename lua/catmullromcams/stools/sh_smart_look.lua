local STool = {}

CatmullRomCams.SToolMethods.SmartLook = STool

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	local camera = trace.Entity
	---@cast camera CatmullRomCamera
	
	camera:SetSmartLook(true)
	camera:SetSmartLookPerc(self:GetClientNumber("percent"))
	camera:SetSmartLookRange(self:GetClientNumber("range") or 512)
	camera:SetSmartLookTraceFilter(self:GetClientNumber("block") or 0)
	camera:SetSmartLookTargetFilter(self:GetClientNumber("target") or 1)
	camera:SetSmartLookClosest(self:GetClientNumber("closest") == 1)
	
	return true
end

---@param self TOOL
---@param trace TraceResult
function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return end
	
	--return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	local camera = trace.Entity
	---@cast camera CatmullRomCamera

	camera:SetSmartLook(false)
	camera:SetSmartLookPerc(1)
	camera:SetSmartLookRange(512)
	camera:SetSmartLookTraceFilter(2)
	camera:SetSmartLookTargetFilter(1)
	
	return true
end

function STool.Think(self)
end

---@param panel ControlPanel | DForm
function STool.BuildCPanel(panel)
	local block_filter_listbox = {}
	block_filter_listbox.Label = "Filters For LOS: "
	block_filter_listbox.Options = {
		["NPC Static"]      = {catmullrom_camera_looker_block = MASK_NPCWORLDSTATIC},
		["Solid-To-NPC"]    = {catmullrom_camera_looker_block = MASK_NPCSOLID_BRUSHONLY},
		["Solid-To-Player"] = {catmullrom_camera_looker_block = MASK_PLAYERSOLID_BRUSHONLY},
		["Solid Brush"]     = {catmullrom_camera_looker_block = MASK_SOLID_BRUSHONLY},
		["Shot Hull"]       = {catmullrom_camera_looker_block = MASK_SHOT_HULL},
		["Shot"]            = {catmullrom_camera_looker_block = MASK_SHOT},
		["Opaque"]          = {catmullrom_camera_looker_block = MASK_OPAQUE},
		["Water"]           = {catmullrom_camera_looker_block = MASK_WATER},
		["NPC Solid"]       = {catmullrom_camera_looker_block = MASK_NPCSOLID},
		["Player Solid"]    = {catmullrom_camera_looker_block = MASK_PLAYERSOLID},
		["Solid"]           = {catmullrom_camera_looker_block = MASK_SOLID},
		["Everything"]      = {catmullrom_camera_looker_block = MASK_ALL},
		["Nothing"]         = {catmullrom_camera_looker_block = 0},
	}
	local target_filter_listbox = {}
	target_filter_listbox.Label = "Filters For Potential Targets: "
	target_filter_listbox.Options = {
		["Anything"]             = {catmullrom_camera_looker_target = 1},
		["Fire + Ignited Stuff"] = {catmullrom_camera_looker_target = 2},
		["Props"]                = {catmullrom_camera_looker_target = 3},
		["Has Physics Object"]   = {catmullrom_camera_looker_target = 4},
		["NPCs"]                 = {catmullrom_camera_looker_target = 5},
		["Players"]              = {catmullrom_camera_looker_target = 6},
		["Light Entities"]       = {catmullrom_camera_looker_target = 7},
		["Particle Systems"]     = {catmullrom_camera_looker_target = 8},
	}
	
	local filterHelp = panel:Help("Filters For LOS: ")
	filterHelp:SetTooltip("What should block our line of sight check?")
	panel:AddControl("listbox", block_filter_listbox) 
	
	local targetHelp = panel:Help("Filters For Potential Targets: ")
	targetHelp:SetTooltip("What sort of things should we look for?")
	panel:AddControl("listbox", target_filter_listbox) 
	
	local lookPercent = panel:NumSlider("Percent: ", "catmullrom_camera_looker_percent", .01, 1)
	lookPercent:SetTooltip("How much should we apply the look?")
	local lookRange = panel:NumSlider("Range: ", "catmullrom_camera_looker_range", 32, 4096)
	lookRange:SetTooltip("How far should we look?")
	local closestTarget = panel:CheckBox("Closest Target", "catmullrom_camera_looker_closest")
	closestTarget:SetTooltip("Do I NEEED to look for the closest target? Or can I just pick the first one I find?")
end



