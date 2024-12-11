if SERVER then return end

-- Let's safeguard against the difference between SMH not starting up in time and SMH not existing 
-- so other developers don't have a Think hook to worry about
local MAX_TRIES = 0

do
    -- UI doesn't sync with internal changes to the PhysRecord state, so we'll revert everything for the user
    local oldState = {
        FrameCount = 0,
        RecordInterval = 0,
        StartDelay = 0,
    }
    
    local tries = 0
    local wasActive = false
    hook.Remove("Think", "CatmullRomCams.SMH")
    hook.Add("Think", "CatmullRomCams.SMH", function()
        if not SMH then
            tries = tries + 1
            if tries > MAX_TRIES then
                hook.Remove("Think", "CatmullRomCams.SMH")
            end
            return
        end

        if not IsValid(LocalPlayer()) then return end
        local ply = LocalPlayer()

        local camera = ply:GetNWEntity("CatmullRomCams.Camera")
        local crcEnt = ply:GetNWEntity("UnderControlCatmullRomCamera")

        -- Check if we have a camera to interface, if we just triggered the track, if we have SMH installed, and if we are not baking
        if IsValid(camera) and crcEnt ~= NULL and SMH and not wasActive then
            local sum = 0
            for i = 2, #crcEnt.CatmullRomController.DurationList - 1 do
                sum = sum + crcEnt.CatmullRomController.DurationList[i]
            end
            oldState.FrameCount = SMH.PhysRecord.FrameCount
            oldState.RecordInterval = SMH.PhysRecord.RecordInterval
            oldState.StartDelay = SMH.PhysRecord.StartDelay

            SMH.PhysRecord.FrameCount = sum * SMH.State.PlaybackRate
            SMH.PhysRecord.RecordInterval = 0
            SMH.PhysRecord.StartDelay = 0
            SMH.PhysRecord.SelectedEntities = {[camera] = SMH.State.Timeline}
            SMH.PhysRecord.RecordToggle()
            wasActive = true
        elseif not IsValid(crcEnt) and wasActive then
            -- Stop recording when the track has stopped (i.e. your view returns)
            wasActive = false
            SMH.PhysRecord.FrameCount = oldState.FrameCount
            SMH.PhysRecord.RecordInterval = oldState.RecordInterval
            SMH.PhysRecord.StartDelay = oldState.StartDelay
            SMH.PhysRecord.RecordToggle()
        end
    end)
end