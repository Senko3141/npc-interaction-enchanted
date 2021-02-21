-- NPC Module
--[[

	> Holds E for 2 seconds to activate interaction.
	
	>> Create interaction object.
		- Clone NPC ui, and tween.
		- Whenever player presses button, update interaction based on choice.
		- When ends, :term();
]]

local module = {};

local info = require(script:WaitForChild("Info"))
local template = script:WaitForChild("NPCUI")
local writer = require(script:WaitForChild("Typewriter"))

module.__index = module

function module.new(name)
	if not info[name] then
		-- not in module
		return nil
	end
	
	local char_info = info[name]
	
	local clone = template:Clone()
	clone.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local self = setmetatable({}, module)
	self["Name"] = name
	self.Object = clone
	self.On = Instance.new("IntValue")
	self.On.Value = 1
	
	self.CanClick = false
	self.Functions = {
		["Terminate"] = function()
			self.Object.Holder.Responses.Yes.Text = ""
			self.Object.Holder.Responses.No.Text = ""
			self.Object.Holder.Body.Desc.Text = ""
			
			if #self.Connections > 0 then
				-- more than 0 connections
				for _,connection in pairs(self.Connections) do
					connection:Disconnect()
				end
			end

			--self.On.Value = 1
			self.Object.Holder:TweenPosition(UDim2.new(0.5,0,1.1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)

			coroutine.resume(coroutine.create(function()
				wait(1)
				self.Object:Destroy()
				self.On:Destroy()
				self.Object = nil

				self = nil
				
				game.Players.LocalPlayer:WaitForChild("PlayerGui").PromptHandler.NPC.CanInteract.Value = true
			end))
		end
	};
	
	self.Connections = {
		[1] = self.Object.Holder.Responses.Yes.MouseButton1Click:Connect(function()
			if self.CanClick == false then
				return;
			end
			
			self.CanClick = false
			
			-- resetting text
			
			self.Object.Holder.Responses.Yes.Text = ""
			self.Object.Holder.Responses.No.Text = ""
		--	warn"bruh"
			local max = #char_info
			if self.On.Value == max then -- max dialogues
				-- end dialogue
				self.Functions.Terminate()
				
				-- TODO: give quest if neccessary
				
				
				return;
			else
			--	warn'hm?'
			end
			
			self.On.Value = self.On.Value + 1
		end),
		[2] = self.Object.Holder.Responses.No.MouseButton1Click:Connect(function()
			if self.CanClick == false then
				return;
			end
			
			self.CanClick = false
			
			-- resetting text

			self.Object.Holder.Responses.Yes.Text = ""
			self.Object.Holder.Responses.No.Text = ""
			--warn'bruh'
			local max = #char_info
			if self.On.Value <= max then -- clicked no
				self.Functions.Terminate()
			--	warn"test"
			else
				--warn(#char_info.." | ".. self.On.Value)
			--	warn'hmm'
				return;
			end
		end),
	};
	
	self.Object.Holder:TweenPosition(UDim2.new(0.5,0,0.906,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
	coroutine.resume(coroutine.create(function()
		wait(.5)
		writer.typeWrite(self.Object.Holder.Body.Desc, char_info[self.On.Value].Desc)
		
		-- creating responses
		local responses = char_info[self.On.Value].Responses
		--[[
			[1] is yes
			[2] is no
		]]
		
		writer.typeWrite(self.Object.Holder.Responses.Yes, responses[1])
		writer.typeWrite(self.Object.Holder.Responses.No, responses[2])
		
		self.CanClick = true
	end))
	
	warn("[NPC] Successfully created dialogue info for ".. name..".")
	
	return self
end

function module:update()
	warn"update"
	local char_info = info[self.Name]
	
	--[[
		local new = char_info[self.On.Value].Desc
		string.format(new, "Randomized_NPC")
	]]
	
	writer.typeWrite(self.Object.Holder.Body.Desc, char_info[self.On.Value].Desc) -- add string.format() stuff here


	-- creating responses
	local responses = char_info[self.On.Value].Responses
		--[[
			[1] is yes
			[2] is no
		]]

	writer.typeWrite(self.Object.Holder.Responses.Yes, responses[1])
	writer.typeWrite(self.Object.Holder.Responses.No, responses[2])

	self.CanClick = true
end

function module:term()
	warn(self.On.Value)
	
	self.Object.Holder.Responses.Yes.Text = ""
	self.Object.Holder.Responses.No.Text = ""
	self.Object.Holder.Body.Desc.Text = ""
	
	if #self.Connections > 0 then
		-- more than 0 connections
		for _,connection in pairs(self.Connections) do
			connection:Disconnect()
		end
	end
	
	--self.On.Value = 1
	self.Object.Holder:TweenPosition(UDim2.new(0.5,0,1.1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
	
	coroutine.resume(coroutine.create(function()
		wait(1)
		self.Object:Destroy()
		self.On:Destroy()
		self.Object = nil
		
		game.Players.LocalPlayer:WaitForChild("PlayerGui").PromptHandler.NPC.CanInteract.Value = true
		self = nil
	end))
end


return module
