require "System\\ScriptCore"
require "System\\ScriptDefines"

BridgeFunctionAttach("LuaEntryProc", "Console")

Console = function()
    LogText("Console.lua started")
    ConsoleOn(1)
end

