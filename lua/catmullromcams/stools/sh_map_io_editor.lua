local STool = {}

CatmullRomCams.SToolMethods.MapIOEditor = STool

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	
	local dur = self:GetClientNumber("duration") or 2
	
	trace.Entity:SetNWFloat("Duration", (dur > 0.001) and dur or 0.001)
	
	return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
	
	local dur = trace.Entity:GetNWFloat("Duration") or 2
	
	self:GetOwner():ConCommand("catmullrom_camera_duration_duration " .. ((dur > 0.001) and dur or 0.001) .. "\n")
	
	return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	
	trace.Entity.MapIOData ={}
	
	return true
end

---@param self TOOL
function STool.Think(self)
	if SERVER then return end
	
	local ply = LocalPlayer()
	local trace = ply:GetEyeTrace()
	
	if not self:ValidTrace(trace) then return end
	if not trace.Entity.MapIOData then return end
	
	local msg = "OnUser1: " .. (trace.Entity.MapIOData.User1 and "ACTIVE" or "INACTIVE") .. "\n" .. "OnUser2: " .. (trace.Entity.MapIOData.User2 and "ACTIVE" or "INACTIVE") .. "\n" .. "OnUser3: " .. (trace.Entity.MapIOData.User3 and "ACTIVE" or "INACTIVE") .. "\n" .. "OnUser4: " .. (trace.Entity.MapIOData.User4 and "ACTIVE" or "INACTIVE")
	
	AddWorldTip(trace.Entity:EntIndex(), msg, 0.5, trace.Entity:GetPos(), trace.Entity )
end

---@param panel ControlPanel | DForm
function STool.BuildCPanel(panel)
	panel:CheckBox("OnUser1", "catmullrom_camera_map_io_user1")
	panel:CheckBox("OnUser2", "catmullrom_camera_map_io_user2")
	panel:CheckBox("OnUser3", "catmullrom_camera_map_io_user3")
	panel:CheckBox("OnUser4", "catmullrom_camera_map_io_user4")
end