-- --------------------------------------------------------------------------------
-- DYNAMIC RAINMETER SETTINGS SYSTEM
-- v1.0.0
-- By raiguard
-- --------------------------------------------------------------------------------
-- MIT License

function Toggle(variable, onState, offState, actionSet, ifLogic, oSettingsPath, oConfigPath)

	local value = SKIN:GetVariable(variable)
	local lSettingsPath = oSettingsPath or settingsPath
	local lConfigPath = oConfigPath or configPath

	if value == offState then
		SetVariable(variable, onState, lSettingsPath, lConfigPath)
		RmLog(variable .. '=' .. onState, 'Debug')
		value = onState
	else
		SetVariable(variable, offState, lSettingsPath, lConfigPath)
		RmLog(variable .. '=' .. offState, 'Debug')
		value = offState
	end

	UpdateMeters()
	ActionSet(actionSet, ifLogic, value)

end

-- sets the specified variable to the given input. For use with radio buttons
-- and input boxes.
function Set(variable, input, actionSet, ifLogic, oSettingsPath, oConfigPath, ignoreBlank)

	local lSettingsPath = oSettingsPath or settingsPath
	local lConfigPath = oConfigPath or configPath
	
	SetVariable(variable, input, lSettingsPath, lConfigPath)
	RmLog(variable .. '=' .. input, 'Debug')	
	UpdateMeters()
	ActionSet(actionSet, ifLogic, input)

end

function InputText(data, variable, actionSet, ifLogic, oSettingsPath, oConfigPath)

	local lSettingsPath = oSettingsPath or settingsPath
	local lConfigPath = oConfigPath or configPath

	data = type(data) == 'string' and loadstring('return ' .. SELF:GetOption(data) or nil)() or data

	if data and SKIN:GetVariable(variable) then
		-- RmLog('[!SetVariable _inputTextEscape \"$UserInput$\"][!CommandMeasure '.. SELF:GetName() .. ' \"Set(\'' .. variable .. '\', \'[' .. measureInputText .. ']\', ' .. (actionSet and ('\'' .. actionSet .. '\'') or 'nil') .. ', ' .. (ifLogic and ('\'' .. ifLogic .. '\'') or 'nil') .. ', \'' .. string.gsub(lSettingsPath, '\\', '\\\\') .. '\', \'' .. string.gsub(lConfigPath, '\\', '\\\\') .. '\')\"] DefaultValue=\"#*' .. variable .. '*#\" X=\"[' .. data.meterName .. ':X] - ' .. (data.padding[1] or 0) .. '\" Y=\"[' .. data.meterName .. ':Y] - ' .. (data.padding[2] or 0) .. '\" W=\"[' .. data.meterName .. ':W] + ' .. (data.padding[1] or 0) + (data.padding[3] or 0) .. '\" H=\"[' .. data.meterName .. ':H] + ' .. (data.padding[2] or 0) + (data.padding[4] or 0) .. '\" InputLimit=' .. data.inputLimit or 0)
		SKIN:Bang('!SetOption', measureInputText, 'Command1', '[!SetVariable _inputTextEscape \"$UserInput$\"][!CommandMeasure '.. SELF:GetName() .. ' \"Set(\'' .. variable .. '\', \'[' .. measureInputText .. ']\', ' .. (actionSet and ('\'' .. actionSet .. '\'') or 'nil') .. ', ' .. (ifLogic and ('\'' .. ifLogic .. '\'') or 'nil') .. ', \'' .. string.gsub(lSettingsPath, '\\', '\\\\') .. '\', \'' .. string.gsub(lConfigPath, '\\', '\\\\') .. '\')\"] DefaultValue=\"#*' .. variable .. '*#\" X=\"([' .. data.meterName .. ':X] - ' .. (data.padding[1] or 0) .. ')\" Y=\"([' .. data.meterName .. ':Y] - ' .. (data.padding[2] or 0) .. ')\" W=\"([' .. data.meterName .. ':W] + ' .. (data.padding[1] or 0) + (data.padding[3] or 0) .. ')\" H=\"([' .. data.meterName .. ':H] + ' .. (data.padding[2] or 0) + (data.padding[4] or 0) .. ')\" InputLimit=' .. data.inputLimit or 0)
		SKIN:Bang('!UpdateMeasure', measureInputText)
		SKIN:Bang('!CommandMeasure', measureInputText, 'Executebatch 1')
	else
		RmLog('Data table or variable name is invalid!', 'Error')
	end

end

-- sets the variable using both !SetVariable and !WriteKeyValue, updating the
-- value both in the settings skin and the primary skin
function SetVariable(name, parameter, filePath, configPath)

	-- -- handle any escaped variables
	-- while true do
	-- 	local v = string.match(parameter, '%#%*(.*)%*%#')
		

	-- enact the changes within the skin
	SKIN:Bang('!SetVariable', name, parameter)
	if filePath == nil then SKIN:Bang('!WriteKeyValue', 'Variables', name, parameter) 
		else SKIN:Bang('!WriteKeyValue', 'Variables', name, parameter, filePath) end
	if configPath ~= nil then SKIN:Bang('!SetVariable', name, parameter, configPath) end

end

function ActionSet(actionSet, ifLogic, input)

	local actionSetName = actionSet

	if actionSet == nil then
		SKIN:Bang(defaultAction)
	else
		if ifLogic == true then
			actionSetName = actionSet .. input
			actionSet = SELF:GetOption(actionSet .. input)
			else actionSet = SELF:GetOption(actionSet) end
		if actionSet == '' then RmLog('ActionSet \'' .. actionSetName .. '\' is empty or missing', 'Warning') end
		RmLog(actionSetName .. '=' .. actionSet)
		SKIN:Bang(actionSet)
	end

end


function UpdateMeters()

	SKIN:Bang('!UpdateMeterGroup', meterUpdateGroup)
	SKIN:Bang('!Redraw')

end

function table.length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function table.find(t, value)
	for _,v in pairs(t) do
		if (v == value) then
			return _
		end
	end
	return false
end
