function Initialize()
	MeterName = SELF:GetOption('MeterName', '')
	Meter = SKIN:GetMeter(MeterName)
end

function Update()
	return Meter:GetW()
end