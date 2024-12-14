
local gmodToolMode = GetConVar("gmod_toolmode")

function CatmullRomCams.CL.CalcViewOverride(ply, origin, angles, fov)
	gmodToolMode = gmodToolMode or GetConVar("gmod_toolmode")
	local weap = ply:GetActiveWeapon()
	
	local toolmode_active = (CatmullRomCams.SToolMethods.ToolObj and (gmodToolMode:GetString() == "catmullrom_camera") and weap and weap:IsValid() and (weap:GetClass() == "gmod_tool"))
	local playing_track   = ply:GetNWEntity("UnderControlCatmullRomCamera") and ply:GetNWEntity("UnderControlCatmullRomCamera"):IsValid()
	
	if not (toolmode_active or playing_track) then return end
	
	local overrides = {}
	overrides.origin = origin
	overrides.angles = angles
	overrides.fov    = fov
	
	if toolmode_active then
		overrides.fov      =  CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("zoom") or 75
		overrides.angles.r = (CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("enable_roll") == 1) and CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("roll") or angles.r
	else
		overrides.fov = ply.CatmullRomCamsTrackZoom or fov
	end
	
	return overrides
end
hook.Add("CalcView", "CatmullRomCams.CL.CalcViewOverride", CatmullRomCams.CL.CalcViewOverride)
