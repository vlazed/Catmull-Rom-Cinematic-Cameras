local STool = {}

CatmullRomCams.SToolMethods.DurationEditor = STool

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	
	local dur = self:GetClientNumber("duration") or 2
	
	local camera = trace.Entity
	---@cast camera CatmullRomCamera

	if self:GetOwner():KeyDown(IN_SPEED) and CatmullRomCams.Tracks[camera.UndoData.PID][camera.UndoData.Key][camera.UndoData.TrackIndex + 1] then
		dur = CatmullRomCams.SH.UnitsToMeters(camera:GetPos():Distance(CatmullRomCams.Tracks[camera.UndoData.PID][camera.UndoData.Key][camera.UndoData.TrackIndex + 1]:GetPos())) / self:GetClientNumber("duration_mps")
	end
	
	camera:SetNWFloat("Duration", (dur > 0.001) and dur or 0.001)
	
	return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
	
	local dur = trace.Entity:GetNWFloat("Duration") or 2
	
	self:GetOwner():ConCommand("catmullrom_camera_duration_duration " .. ((dur > 0) and dur or 2) .. "\n")
	
	return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	
	trace.Entity:SetNWFloat("Duration", 2)
	
	return true
end

---@param self TOOL
function STool.Think(self)
	if SERVER then return end
	
	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()
	
	if not self:ValidTrace(tr) then return end
	
	local dur = tr.Entity:GetNWFloat("Duration")
	dur = (dur ~= 0) and dur or 2
	
	AddWorldTip(tr.Entity:EntIndex(), "Duration: " .. dur, 0.5, tr.Entity:GetPos(), tr.Entity )
end

---@param panel ControlPanel | DForm
function STool.BuildCPanel(panel)
	panel:NumSlider("Node Duration: ", "catmullrom_camera_duration_duration", 0.001, 10)
	panel:NumSlider("Node Duration, Meters Per Seconds: ", "catmullrom_camera_duration_duration_mps", 0.001, 10)
end