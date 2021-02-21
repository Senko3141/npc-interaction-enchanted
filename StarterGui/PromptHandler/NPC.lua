-- NPC Interaction

local WSP = game:GetService("Workspace")
local Storage = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")

local NPCs = WSP:WaitForChild("NPCs")
local Remotes = Storage:WaitForChild("Remotes")
local Modules = Storage:WaitForChild("Modules")
local NPC = require(Modules.Components.UI.NPC)

--[[
	add server checks
]]
local CanInteract = script:WaitForChild("CanInteract")

for _,v in pairs(NPCs:GetChildren()) do
	if v:FindFirstChild("Interact") then
		v.Interact.Attachment.Prompt.Triggered:Connect(function(plr)
			if CanInteract.Value == false then return end
			
			CanInteract.Value = false
			local object = NPC.new(v.Name)
			
			object.On:GetPropertyChangedSignal("Value"):Connect(function()
				object:update()
			end)
		end)
		
	end
end
