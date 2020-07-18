function Initialize()
    -- Defining the default variables path
    defaultVarsPath = SKIN:GetVariable("@") .. "default.inc"
    -- -- Getting the user folder from Operating System env and appending awesome to the end
    -- awesomeUserFolder = os.getenv("USERPROFILE") .. "\\awesome\\"
    -- Definethe user variables from the previous folder
    userVarsPath = SKIN:GetVariable("@")  .. "overrides.inc"

    -- SKIN:Bang("!SetVariable", "oUserDir", awesomeUserFolder)

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

function getFirstRun()
    if fileExists(userVarsPath) == true then
        return 0
    else 
        return 1
    end
end

function createUserOverrides()       
    createUserVars(userVarsPath)
    return 1
end

function createUserVars(pathToFile)
    -- Running MKDIR on O.S console with the awesome folder from line 5
    -- os.execute('MKDIR "' .. awesomeUserFolder .. '"')
    userVars = io.open(pathToFile, "w")
    defaultVars = getFileContents(defaultVarsPath)
    userVars:write(defaultVars)
    userVars:close()
    return "[Awesome] User variables created."
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