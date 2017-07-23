----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()

-- Class definition
Logger = {}
Logger.__index = Logger

--- appender
local function appender(logger, level, message, exception)
    local ChatFrame = _G.DEFAULT_CHAT_FRAME
    for _, frameName in pairs(_G.CHAT_FRAMES) do
        local cf = _G[frameName]
        if cf.name:upper() == "DEBUG" then
            ChatFrame = cf
            break
        end
    end
    ChatFrame:AddMessage(logger:FormatMessage(Logger.pattern, level, message, exception), nil, nil, nil, nil, nil, nil, true)
    if ChatFrame ~= _G.SELECTED_CHAT_FRAME then _G["FCF_StartAlertFlash"](ChatFrame) end
end

--- Convert the given table to a string.
-- @param maxDepth until this depth all tables contained as values in the table will be resolved.
-- @param valueDelimiter (optional) default is " = "
-- @param lineDelimiter (optional) default is "\n"
-- @param indent (optional) initial indentiation of sub tables
local function convertTableToString(tab, maxDepth, valueDelimiter, lineDelimiter, indent)
    local result = ""
    if (indent == nil) then
        indent = 0
    end
    if (valueDelimiter == nil) then
        valueDelimiter = " = "
    end
    if (lineDelimiter == nil) then
        lineDelimiter = "\n"
    end
    for k, v in pairs(tab) do
        if (result ~= "") then
            result = result .. lineDelimiter
        end
        -- result = result .. string.rep(" ", indent) .. tostring(k) .. valueDelimiter
        if (type(k) ~= "number") then
            result = result .. string.rep("", indent) .. tostring(k) .. valueDelimiter
        end
        if (type(v) == "table") then
            if (maxDepth > 0) then
                -- result = result .. "{\n" .. convertTableToString(v, maxDepth - 1, valueDelimiter, lineDelimiter, indent + 2) .. "\n"
                result = result .. "{ " .. convertTableToString(v, maxDepth - 1, valueDelimiter, lineDelimiter, indent + 2) .. " "
                result = result .. string.rep(" ", indent) .. "}"
            else
                result = result .. "[... more table data ...]"
            end
        elseif (type(v) == "function") then
            result = result .. "[function]"
        else
            result = result .. tostring(v)
        end
    end
    return result
end

--- Level constants.
Logger.DEBUG = "DEBUG"
--- Level constants.
Logger.INFO = "INFO"
--- Level constants.
Logger.WARN = "WARN"
--- Level constants.
Logger.ERROR = "ERROR"
--- Level constants.
Logger.FATAL = "FATAL"
--- Level constants.
Logger.OFF = "OFF"
--- Default Level
Logger._level = Logger.OFF

Logger.LOG_LEVELS = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    FATAL = 5,
    OFF = 6
}

Logger.LOG_COLORS = {
    DEBUG = "|cff00ffff",
    INFO = "|cff0080ff",
    WARN = "|cffffff00",
    ERROR = "|cffff0000",
    FATAL = "|cffff00ff"
}

-- Default pattern.
--[[
%DATE, %TIME, %LEVEL, %PATH, %LINE, %METHOD, %MESSAGE, %STACKTRACE, %ERROR，%COLOR
--]]
-- Logger.DEFAULT_PATTERN = "%COLOR[%LEVEL %TIME]|r %FILE:%LINE: %MESSAGE"
Logger.DEFAULT_PATTERN = "%COLOR[%LEVEL %TIME]|r %FILE:%LINE: %MESSAGE"

-- Map containing all configured loggers (key is category).
local _loggers = nil

-- Load default configuration found in environment variable.
local function initConfig()
    if (_loggers == nil) then
        -- We need at least a root logger.
        _loggers = {}
        _loggers["ROOT"] = Logger.New("ROOT")
    end
end

--- Main method that returns a fully configured logger for the given category.
-- @param category the category of the desired logger.
function Logger:GetLogger(category)
    assert(category, "category cannot be empty.")
    initConfig()
    local log = _loggers[category]
    if (log == nil) then
        _loggers[category] = Logger.New(category)
        log = _loggers[category]
    end
    assert(log, "Logger cannot be empty. Check your configuration!")
    return log
end

--- Main method that returns a table contains all loggers.
function Logger:GetAllLoggers()
    return _loggers
end

--- Constructor.
-- @param category the category (== name) of this logger
-- @param level the threshold level. Only messages for equal or higher levels will be logged.
function Logger.New(category)
    local self = {}
    self.logs = {}
    setmetatable(self, Logger)
    assert(category ~= nil, "Category not set.")
    self._category = category

    return self
end

--- Set the log level threshold.
function Logger:SetLevel(level)
    assert(Logger.LOG_LEVELS[level] ~= nil, "Unknown log level '" .. level .. "'")
    self._level = level
end

--- Log the given message at the given level.
function Logger:Log(level, message, exception)
    assert(Logger.LOG_LEVELS[level] ~= nil, "Unknown log level '" .. level .. "'")
    if (Logger.LOG_LEVELS[level] >= Logger.LOG_LEVELS[self._level] and level ~= Logger.OFF) then
        appender(self, level, message, exception)
    end
end

--- Test whether the given level is enabled.
-- @return true if messages of the given level will be logged.
function Logger:IsLevel(level)
    local levelPos = Logger.LOG_LEVELS[level]
    assert(levelPos, "Invalid level '" .. tostring(level) .. "'")
    return levelPos >= Logger.LOG_LEVELS[self._level]
end

--- Log message at DEBUG level.
function Logger:Debug(message, exception)
    self:Log(Logger.DEBUG, message, exception)
end

--- Log message at INFO level.
function Logger:Info(message, exception)
    self:Log(Logger.INFO, message, exception)
end

--- Log message at WARN level.
function Logger:Warn(message, exception)
    self:Log(Logger.WARN, message, exception)
end

--- Log message at ERROR level.
function Logger:Error(message, exception)
    self:Log(Logger.ERROR, message, exception)
end

--- Log message at FATAL level.
function Logger:Fatal(message, exception)
    self:Log(Logger.FATAL, message, exception)
end

function Logger:FormatMessage(pattern, level, message, exception)
    local result = pattern or Logger.DEFAULT_PATTERN
    local date_string = date("%m-%d")
    local time_string = date("%H:%M:%S")

    if (type(message) == "table") then
        message = convertTableToString(message, 5, nil, ", ")
    end
    message = string.gsub(tostring(message), "%%", "%%%%")

    -- If the pattern contains any traceback relevant placeholders process them.
    if (
        string.match(result, "%%PATH")
        or string.match(result, "%%FILE")
        or string.match(result, "%%LINE")
        or string.match(result, "%%METHOD")
        or string.match(result, "%%STACKTRACE")
    ) then
        -- Take no risk - format the stacktrace using pcall to prevent ugly errors.
        _, result, stackTrace = pcall(Logger._FormatStackTrace, self, result)
    end

    result = string.gsub(result, "%%DATE", date_string)
    result = string.gsub(result, "%%TIME", time_string)
    result = string.gsub(result, "%%LEVEL", string.format("%-5s", level))
    result = string.gsub(result, "%%MESSAGE", message)
    result = string.gsub(result, "%%COLOR", Logger.LOG_COLORS[level])
    -- tweak for AIIP (log4lua is bugged)
    if exception ~= nil then
        result = string.gsub(result, "%%ERROR", exception)
    end

    table.insert(self.logs, { date = date_string, time = time_string, level = Logger.LOG_LEVELS[level], levelText = level , message = message , stackTrace = stackTrace })

    return result
end

-- Format stack trace.
function Logger:_FormatStackTrace(pattern)
    local result = pattern

    -- Handle stack trace and method.
    local stackTrace = debugstack(7)

    for line in string.gmatch(stackTrace, "[^\n]-\.lua:%d+: in [^\n]+") do
        local _, _, sourcePath, sourceLine, sourceMethod = string.find(line, "(.-):(%d+): in (.*)")
        local _, _, sourceFile = string.find(sourcePath or "n/a", ".*\\(.*)")

        result = string.gsub(result, "%%PATH", sourcePath or "n/a")
        result = string.gsub(result, "%%FILE", sourceFile or "n/a")
        result = string.gsub(result, "%%LINE", sourceLine or "n/a")
        result = string.gsub(result, "%%METHOD", sourceMethod or "n/a")
        break
    end

    result = string.gsub(result, "%%STACKTRACE", stackTrace)

    return result, stackTrace
end
