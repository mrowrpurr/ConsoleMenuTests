scriptName ConsoleMenuTest extends SkyUnitTest hidden
{Base script for all ConsoleMenu tests}

function BeforeAll()
    ConsoleHelper.Open(force = true)
    Utility.WaitMenuMode(0.2)
endFunction

function AfterAll()
    ConsoleHelper.Close(force = true)
endFunction

function BeforeEach()
    ConsoleHelper.ClearAllText()
endFunction
