function Initialize()
    defaultVarsPath = SKIN:GetVariable("@") .. "default.inc"
    wwingUserFolder = os.getenv("USERPROFILE") .. "\\wwing\\"
    userVarsPath = wwingUserFolder .. "variables.inc"
    if fileExists(userVarsPath) == false then
        return createUserVars(userVarsPath)
    else
        return false
    end
end

function getFileContents(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function fileExists(pathToFile)
    local f = io.open(pathToFile, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function split(str)
    local tbl = {}
    for w in str:gmatch("%w+") do
        table.insert(tbl, w)
    end
    return tbl
end

function createUserVars(pathToFile)
    os.execute('MKDIR "' .. wwingUserFolder .. '"')
    userVars = io.open(pathToFile, "w")
    defaultVars = getFileContents(defaultVarsPath)
    userVars:write(defaultVars)
    userVars:close()
    return "File Write Successful"
end

function WriteUserKey(key, newValue)
    local fileIn = io.open(userVarsPath, "r")
    local fileTemp = {}
    for line in fileIn:lines() do
        if not line:match("^" .. key .. "=") then
            fileTemp[#fileTemp + 1] = line
        else
            fileTemp[#fileTemp + 1] = key .. "=" .. newValue
        end
    end
    fileIn:close()
    local fileOut = io.open(userVarsPath, "w")
    for i = 1, #fileTemp do
        fileOut:write(fileTemp[i] .. "\n")
    end
    fileOut:close()
end

function Update()
end
