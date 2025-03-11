local STool = {}

CatmullRomCams.SToolMethods.Layout  = STool
CatmullRomCams.SToolMethods.ToolObj = nil

---@param self TOOL
---@param trace TraceResult | Trace
---@return boolean?
---@return CatmullRomCamera?
function STool.LeftClick(self, trace)
	local ply   = self:GetOwner()
	
	local start = ply:GetShootPos()
	local traceConfig = {
		start = start,
		endpos = start + (ply:GetAimVector() * 99999999),
		filter = ply
	}
	
	trace = util.TraceLine(traceConfig)
	
	local key = self:GetClientNumber("key")
	
	if key == -1 then ply:ChatPrint("You must assign a key to the camera before spawning it!") return false end
	if CLIENT then    return true  end -- what's the point, I never seem to be able to get the client to call n STool func :crying:
	
	local plyID = ply:SteamID64()
	
	local facetraveldir   = (self:GetClientNumber("facetraveldir") == 1)
	
	local bank_on_turn    = (self:GetClientNumber("bankonturn") == 1)
	local bank_delta_max  =  self:GetClientNumber("bankdelta_max")
	local bank_multiplyer =  self:GetClientNumber("bank_multi")
	
	local zoom = self:GetClientNumber("zoom")
	
	local roll_enabled = (self:GetClientNumber("enable_roll") == 1)
	local roll         =  self:GetClientNumber("roll")
	
	if trace.Entity then
		if trace.Entity:IsPlayer() then return end
		
		if (trace.Entity:GetClass() == "sent_catmullrom_camera") and (ply:GetShootPos():Distance(trace.HitPos) < 512) then
			---@type CatmullRomCamera
			local camera = trace.Entity
			
			camera:SetFaceTravelDir(facetraveldir)
			print(bank_on_turn)
			
			camera:SetBankOnTurn(bank_on_turn)
			camera:SetBankDeltaMax(bank_delta_max)
			camera:SetBankMultiplier(bank_multiplyer)
			print(camera.BankOnTurn)
			camera:SetZoom(zoom or 75)
			
			camera:SetEnableRoll(roll_enabled)
			camera:SetRoll(roll)
			
			return true
		end
	end
	
	CatmullRomCams.Tracks[plyID]      = CatmullRomCams.Tracks[plyID]      or {}
	CatmullRomCams.Tracks[plyID][key] = CatmullRomCams.Tracks[plyID][key] or {}
	
	local track_index = #CatmullRomCams.Tracks[plyID][key] + 1
	print(track_index)
	---@type CatmullRomCamera
	local camera = ents.Create("sent_catmullrom_camera") ---@diagnostic disable-line: assign-type-mismatch
	if not (camera and camera.IsValid and camera:IsValid()) then return end
	
	local ang = ply:EyeAngles()
	ang.r = (self:GetClientNumber("enable_roll") == 1) and roll or 0
	
	camera:SetAngles(ang)
	camera:SetPos(trace.StartPos)
	camera:Spawn()
	
	camera:SetPlayer(ply)
	
	if CatmullRomCams.Tracks[plyID][key][track_index - 1] and CatmullRomCams.Tracks[plyID][key][track_index - 1]:IsValid() then
		CatmullRomCams.Tracks[plyID][key][track_index - 1]:DeleteOnRemove(camera) -- Because we don't want to have broken chains let's daisy chain them to self destruct
		CatmullRomCams.Tracks[plyID][key][track_index - 1]:SetNWEntity("ChildCamera", camera)
	else
		camera:SetNWBool("IsMasterController", true)
		camera:SetNWEntity("ControllingPlayer", ply)
		
		camera:SetKey(key)
		
		numpad.OnDown(ply, key, "CatmullRomCamera_Toggle", camera)
	end
	
	CatmullRomCams.Tracks[plyID][key][track_index] = camera
	
	camera:SetFaceTravelDir(facetraveldir)
	
	camera:SetBankOnTurn(bank_on_turn)
	camera:SetBankDeltaMax(bank_delta_max)
	camera:SetBankMultiplier(bank_multiplyer)
	
	camera:SetZoom(zoom or 75)
	camera:SetEnableRoll(roll_enabled)
	camera:SetRoll(roll)
	
	camera:SetNWEntity("MasterController", CatmullRomCams.Tracks[plyID][key][1])
	
	camera.UndoData = {}
	camera.UndoData.PID = plyID
	camera.UndoData.Key = key
	camera.UndoData.TrackIndex = track_index
	
	undo.Create("CatmullRomCamera")
		undo.AddEntity(camera)
		
		if track_index ~= 1 then
			undo.AddEntity(constraint.NoCollide(camera, CatmullRomCams.Tracks[plyID][key][1], 0, 0)) -- so the adv dup grabs everything
		end
		
		undo.SetPlayer(ply)
	undo.Finish()
	
	ply:AddCleanup("catmullrom_cameras", camera)
	
	return true, camera
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.RightClick(self, trace)
	-- Fun Fact: If you check the _G table on the server for the key 'camera' you can find the last camera
	--           requested by the camera STool's Rightclick method because Garry, in his omniscience, declared
	--           that it would be best if he didn't add a local in front of the variable declaration. :loleyes:
	
	if CLIENT then return true end
	
	local ply = self:GetOwner()
	
	if ply:KeyDown(IN_SPEED) and self:ValidTrace(trace) then -- COPY!
		local camera = trace.Entity
		---@cast camera CatmullRomCamera
		
		ply:ConCommand("catmullrom_camera_facetraveldir " .. (camera.FaceTravelDir and 1 or 0) .. "\n")
		
		ply:ConCommand("catmullrom_camera_bankonturn "    .. (camera.BankOnTurn and 1 or 0) .. "\n")
		ply:ConCommand("catmullrom_camera_bankdelta_max " .. (camera.DeltaBankMax or 1) .. "\n")
		ply:ConCommand("catmullrom_camera_bank_multi "    .. (camera.DeltaBankMulti or 1) .. "\n")
		
		ply:ConCommand("catmullrom_camera_zoom "        .. (camera.Zoom or 75) .. "\n")
		
		ply:ConCommand("catmullrom_camera_enable_roll " .. (camera.EnableRoll and 1 or 0) .. "\n")
		ply:ConCommand("catmullrom_camera_roll "        .. (camera.Roll or 0) .. "\n")
		
		return true
	end
	
	local _, camera = self:LeftClick(trace)
	if not (camera and camera.IsValid and camera:IsValid()) then return end

	if trace.Entity:IsWorld() then
		camera:SetTracking(ply, trace.Entity:WorldToLocal(trace.HitPos))
	else
		camera:SetTracking(trace.Entity, trace.Entity:WorldToLocal(trace.HitPos))
	end
	
	return true
end

---@param self TOOL
---@param trace TraceResult
---@return boolean?
function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	
	local ply = self:GetOwner()
	
	if ply:KeyDown(IN_SPEED) then
		ply:ConCommand("catmullrom_camera_facetraveldir 0\n")
		
		ply:ConCommand("catmullrom_camera_bankonturn 0\n")
		ply:ConCommand("catmullrom_camera_bankdelta_max 1\n")
		ply:ConCommand("catmullrom_camera_bank_multi 1\n")
		
		ply:ConCommand("catmullrom_camera_zoom 75\n")
		
		ply:ConCommand("catmullrom_camera_enable_roll 0\n")
		ply:ConCommand("catmullrom_camera_roll 0\n")
	else
		local camera = trace.Entity
		---@cast camera CatmullRomCamera
		
		camera:SetFaceTravelDir(false)
		
		camera:SetBankOnTurn(false)
		camera:SetBankDeltaMax(1)
		camera:SetBankMultiplier(1)
		
		camera:SetZoom(75)
		
		camera:SetEnableRoll(false)
		camera:SetRoll(0)
	end
	
	return true
end

function STool.Think(self)
	if SERVER then return end
	
	CatmullRomCams.SToolMethods.ToolObj = self -- Hackz
end

if SERVER then
	return
end
include("catmullromcams/derma/presetsaver.lua")

---@param panel ControlPanel | DForm
function STool.BuildCPanel(panel)
	--panel:AddControl("Header", {Text = "Catmull-Rom Cinematic Cameras: Track Layout Creator", Description = "Use this to create your track's layout!"})
	local presetSaver = vgui.Create("crc_presetsaver", panel)
	presetSaver:SetDirectory("catmullromcams/tracks")
	panel:AddItem(presetSaver)

	local keybinder = panel:KeyBinder("Track Trigger Key: ", "catmullrom_camera_key")
	-- panel:AddControl("Numpad",   {Label = "Track Trigger Key: ", Command = "catmullrom_camera_key", ButtonSize = 22})
	
	local faceDirection = panel:CheckBox("Face Direction Of Travel: ", "catmullrom_camera_facetraveldir")
	faceDirection:SetTooltip("Should the cameras face the direction in which they are moving?")

	local bankWhileTurning = panel:CheckBox("Bank While Turning: ", "catmullrom_camera_bankonturn")
	bankWhileTurning:SetTooltip("(Requires Face-Direction-Of-Travel) Should the cameras bank/roll when they turn?")
	local bankDelta = panel:NumSlider("Bank Delta: ", "catmullrom_camera_bankdelta_max", 0.01, 1)
	bankDelta:SetTooltip("(Change Speed Max) How fast is the maximum we should be able to bank in one frame? (1 = As much as we want.)")
	local bankMultiplier = panel:NumSlider("Bank Multiplier: ", "catmullrom_camera_bank_multi", 0.01, 5)
	bankMultiplier:SetTooltip("(Magnify Banking Effect) How much should we multiply the amount we bank in one frame? (1 = No change.)")

	local zoom = panel:NumSlider("Zoom: ", "catmullrom_camera_zoom", .1, 110)
	zoom:SetTooltip("Default is 75. Press 'USE' (typically 'e' on your keyboard) to reset Zoom & Roll.")
	
	local enableRoll = panel:CheckBox("Enable Roll: ", "catmullrom_camera_enable_roll")
	enableRoll:SetTooltip("ROLL-UP-THE-RIM-TO-WIN! Caution! This overrides bank-on-turn.")

	local roll = panel:NumSlider("Enable Roll: ", "catmullrom_camera_roll", -180, 180)
	roll:SetTooltip("DO A BARREL ROLL! Beware! Make sure you add a node with '0' if you just want to make part of the track rolling;\nOtherwise the camera will jump!")
	
	--panel:AddControl("CheckBox", {Label = "Don't Stop At Track End: ", Description = "(Requires to be on Control node.) Just stay at the last position at the end of the track.", Command = "catmullrom_camera_enable_stay_on_end"})
	--panel:AddControl("CheckBox", {Label = "Loop Track: ",              Description = "(Requires to be on Control node & that the option above is on.) But loop instead.", Command = "catmullrom_camera_enable_looping"})
end
