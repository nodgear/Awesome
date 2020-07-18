function Initialize()
	ReadFile = SELF:GetOption('ReadFile', '')
	Interval = SELF:GetNumberOption('Interval', 10)
	Random = SELF:GetNumberOption('Random', 0)

	Meters = {}
	for a in string.gmatch(SELF:GetOption('MeterName',''), '[^%|]+') do
		table.insert(Meters, a)
	end

	Measures = {}
	for a in string.gmatch(SELF:GetOption('MeasureName',''), '[^%|]+') do
		table.insert(Measures, a)
	end

	Lines = {}
	local File = io.input(SKIN:MakePathAbsolute(ReadFile), 'r')
	for line in io.lines() do
		if line ~= '' then table.insert(Lines, line) end
	end
	io.close(File)	

	Description = table.remove(Lines, 1)
	SKIN:Bang('!SetOption', 'Description', 'Text', Description)

	NextMeter=0
	NextLine=0
	Advance()

	SKIN:Bang('!SetOption', Meters[1], 'Text', Lines[1])
	SKIN:Bang('!CommandMeasure', Measures[1], 'Activate()')

	Counter = 0
end

function Update()
	Counter = (Counter + 1) % Interval
	if Counter == 0 then
		Advance()
		
		SKIN:Bang('!SetOption', Meters[NextMeter], 'Text', Lines[NextLine])
		for i,v in ipairs(Measures) do
			SKIN:Bang('!CommandMeasure', v, 'Activate()')
		end
	end
	return Interval - Counter
end

function Advance()
	NextMeter = NextMeter + 1 > #Meters and 1 or NextMeter + 1
	if Random == 1 then
		NextLine = math.random(#Lines)
	else
		NextLine = (NextLine + 1) > #Lines and 1 or (NextLine + 1)
	end
end