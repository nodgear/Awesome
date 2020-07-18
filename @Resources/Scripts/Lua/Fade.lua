function Initialize()
	MeterName = SELF:GetOption('MeterName', '')
	--The name of the meter or meters that will be faded.

	Meters = {}
	for a in string.gmatch(MeterName, '[^%|]+') do
		table.insert(Meters, a)
	end

	Max = SELF:GetNumberOption('Max', 255)
	Min = SELF:GetNumberOption('Min', 0)
	--The upper and lower bounds of the alpha range. Default to 255 and 0, respectively.

	Alpha = SELF:GetNumberOption('Start', Max)
	--The original alpha of the meter.

	Step = SELF:GetNumberOption('Step', 1)
	--The amount by which the meter alpha will increase or decrease each update. Defaults to 1.

	Activated = 0
	--When this variable is changed to 1 from the skin, the animation will begin.
end

function Activate(ForceType)
	if ForceType == 'In' then
		Direction = 1
		Target = Max
		if Alpha > Max then Alpha = Max end
	elseif ForceType == 'Out' then
		Direction = -1
		Target = Min
		if Alpha < Min then Alpha = Min end
	elseif math.abs(Min - Alpha) < math.abs(Max - Alpha) then
		Direction = 1
		Target = Max
	else
		Direction = -1
		Target = Min
	end

	Activated = 1
end

function Update()
	if Activated == 1 then
		Alpha = Alpha + Step * Direction
		if Alpha < Min or Alpha > Max then
			Alpha = Target
			Activated=2
		end
		for i,v in ipairs(Meters) do SKIN:Bang('!UpdateMeter', v) end
	elseif Activated == 2 then
		for i,v in ipairs(Meters) do SKIN:Bang('!UpdateMeter', v) end
		Deactivate()
		-- The "Activated == 2" case makes sure that the meter is updated one more time after the transition is deactivated.
	end
	return Alpha
end

function Deactivate()
	Activated = 0
end