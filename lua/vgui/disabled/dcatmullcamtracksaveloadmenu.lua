-- Based off of the Duplicator GUI

PANEL.VoteName     = "none"
PANEL.MaterialName = "exclamation"

local refreshMaterial = Material("gui/silkicons/arrow_refresh")
local saveMaterial = Material("gui/silkicons/camera_add")

function PANEL:Init()
	self.RefreshBtn = vgui.Create("DImageButton", self)
	self.RefreshBtn:SetMaterial(refreshMaterial)
	self.RefreshBtn:SetTooltip("Refresh List")
	self.RefreshBtn.DoClick = function() return self:Populate() end
	
	self.SaveBtn = vgui.Create("DImageButton", self)
	self.SaveBtn:SetMaterial(saveMaterial)
	self.SaveBtn:SetTooltip("Save Track")
	self.SaveBtn.DoClick = function() self:Save() end
	
	self.SaveFileName = vgui.Create("DTextEntry", self)
	self.SaveFileName:SetKeyboardInputEnabled(true)
	self.SaveFileName:SetEnabled(true)
	
	self.List = vgui.Create("PanelList", self)
	self.List:SetSpacing(1)
	
	self.SaveList = {}
end

function PANEL:Save()
	--RunConsoleCommand("tool_duplicator_store", self.SaveFileName:GetValue())
end

function PANEL:PerformLayout()
	self:SetTall(500)
	
	self.RefreshBtn:SizeToContents()
	self.RefreshBtn:AlignRight(5)
	self.RefreshBtn:AlignBottom()
	
	self.SaveBtn:SizeToContents()
	self.SaveBtn:AlignRight(self.RefreshBtn:GetWide() + 9)
	self.SaveBtn:AlignBottom()
	
	self.SaveFileName:SetTall(self.SaveBtn:GetTall())
	self.SaveFileName:AlignLeft(5)
	self.SaveFileName:AlignBottom()
	self.SaveFileName:StretchRightTo(self.SaveBtn, 4)
	
	self.List:StretchToParent(0, 0, 0, 0)
	self.List:StretchBottomTo(self.SaveBtn, 4)
end

function PANEL:Clear()
	self.SaveList = {}
	
	return self.List:Clear()
end

function PANEL:Add(id, name)
	self.SaveList[id] = name
end

function PANEL:Populate()
	self.List:Clear()
	
	self.SaveList = file.Find(CatmullRomCams.FilePath .. "*.txt", "DATA")
	
	for k, v in pairs(self.SaveList) do
		local btn = vgui.Create("DCatmullCamTrackSaveLoadButton", self)
		btn:SetFile(v)
		btn:SetID(k)
		self.List:AddItem(btn)
	end
end

derma.DefineControl("DCatmullCamTrackSaveLoadMenu", "Its time to kick ass and chew bubble-gum, and I'm all outa' gum...", PANEL, "DPanel")

