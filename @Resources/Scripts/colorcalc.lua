PROPERTIES ={}

function Initialize()

	tColor={}
    tColorInverse={}

end

function Update()

	return 1
	
end

local function hslToRgb(h, s, l)
    if s == 0 then return l, l, l end
    local function to(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < .16667 then return p + (q - p) * 6 * t end
        if t < .5 then return q end
        if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
        return p
    end
    local q = l < .5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function rgbToHsl(r, g, b)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local b = max + min
    local h = b / 2
    if max == min then return 0, 0, h end
    local s, l = h, h
    local d = max - min
    s = l > .5 and d / (2 - b) or d / b
    if max == r then h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    return h * .16667, s, l
end

function RmLog(...)

    if debug == nil then debug = true end
    if printIndent == nil then printIndent = '' end
      
    if type(arg[1]) == 'table' then
        if arg[3] == nil then arg[3] = 'Debug' end
        if arg[3] == 'Debug' and debug == false then return end

        RmLog(printIndent .. arg[2] .. ' = {')
        local pI = printIndent
        printIndent = printIndent .. '    '
        for k,v in pairs(arg[1]) do
            if type(v) == 'table' then
                RmLog(v, k, arg[3])
            else
                RmLog(printIndent .. tostring(k) .. ' = ' .. tostring(v), arg[3])
            end
        end
        printIndent = pI
        RmLog(printIndent .. '}', arg[3])
    else
        if arg[2] == nil then arg[2] = 'Debug' end
        if arg[2] == 'Debug' and debug == false then return end
        SKIN:Bang("!Log", tostring(arg[1]), arg[2])
    end
      
end

-- function rgbToInverse(r,g,b)
--     tColorInverse.r = 255 - r;
--     tColorInverse.g = 255 - g;
--     tColorInverse.b = 255 - b;

--     return tColorInverse.r, tColorInverse.g, tColorInverse.b
-- end

function ColorLuminance(mBackground)
   
    meterHandle = SKIN:GetMeter(mBackground)
    solidcolor =  meterHandle:GetOption('SolidColor')
    tColor.r, tColor.g, tColor.b, tColor.a = string.match(solidcolor, '^(.+),(.+),(.+),(.+)$')
    
    tColor.h, tColor.s, tColor.l = rgbToHsl(tColor.r, tColor.g, tColor.b)

    fLuminance = tColor.l / 255

    -- RmLog(fLuminance, 'Notice')

    
    return fLuminance
end

