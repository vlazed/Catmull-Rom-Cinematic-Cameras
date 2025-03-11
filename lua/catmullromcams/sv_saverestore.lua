do return end -- BROKEN PIECE OF SHIT! :argh: GARRRRRYYYYYYYYYYYYYY!!!!!!!!!!!!

-- ---@alias CRCSaveData {CRCTrackKey: {Ent: integer, Data: CatmullRomCamera}[]}

-- function CatmullRomCams.SV.Save(save_data)
-- 	if not CatmullRomCams.Tracks[player.GetByID(1):SteamID64()] then return end
	
-- 	---@type CRCSaveData
-- 	local SaveGameData = {} -- I'm assuming here that you can only save games in singleplayer. Tell me if I'm wrong though! :V
	
-- 	for numpad_key, track in pairs(CatmullRomCams.Tracks[player.GetByID(1):SteamID64()]) do
-- 		SaveGameData[numpad_key] = 1--{}
-- 		for index, node in ipairs(track) do
-- 			SaveGameData[numpad_key][index] = {Ent = node:EntIndex(), Data = node:RequestSaveData()}
-- 		end
-- 	end
	
-- 	return saverestore.WriteTable(SaveGameData, save_data)
-- end

-- function CatmullRomCams.SV.Restore(restore_data)
-- 	---@type CRCSaveData
-- 	local SavedGameData = saverestore.ReadTable(restore_data)
-- 	local plyID = player.GetByID(1):SteamID64()
-- 	PrintTable(SavedGameData)
	
-- 	for numpad_key, track in pairs(SavedGameData) do
-- 		if false then
-- 			CatmullRomCams.Tracks[plyID][numpad_key] = {}
			
-- 			for index, node in ipairs(track) do
-- 				local camera = ents.GetByIndex(node.Ent)
-- 				---@cast camera CatmullRomCamera
-- 				CatmullRomCams.Tracks[plyID][numpad_key][index] = camera
-- 				CatmullRomCams.Tracks[plyID][numpad_key][index]:ApplyEngineSaveData(node.Data, index == 1)
				
-- 				print("Loaded ", CatmullRomCams.Tracks[plyID][numpad_key][index], "'s saverestore data.\nDumping:")
-- 				PrintTable(node.Data)
-- 			end
-- 		end
-- 	end
-- end

-- saverestore.AddSaveHook(   "CatmullRomCams_SaveRestore", CatmullRomCams.SV.Save)
-- saverestore.AddRestoreHook("CatmullRomCams_SaveRestore", CatmullRomCams.SV.Restore)
