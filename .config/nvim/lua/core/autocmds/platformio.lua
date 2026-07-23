local script = [[



]]

local function setupPlatformio() end

local function platformioCheck() end

local function pio()
	if platformioCheck() then
		setupPlatformio()
	end
end

return pio
