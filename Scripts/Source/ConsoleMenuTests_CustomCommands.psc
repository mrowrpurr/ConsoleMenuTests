scriptName ConsoleMenuTests_CustomCommands extends ConsoleMenuTest
{Tests for the custom console command support in ConsoleMenu}

function Tests()
    Test("Custom console commands disabled").Fn(CustomConsoleCommands_Disabled_Test())
    Test("Custom console commands enabled").Fn(CustomConsoleCommands_Enabled_Test())
endFunction

function CustomConsoleCommands_Disabled_Test()
    ConsoleHelper.SetTextInputText("foo bar baz")
    Input.TapKey(28) ; Enter
    Utility.WaitMenuMode(0.1)

    string expectedOutput = "Script command \"foo\" not found."
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))
    ExpectString(ConsoleHelper.GetTextInputText()).To(BeEmpty())
endFunction

function CustomConsoleCommands_Enabled_Test()
    ConsoleHelper.RegisterForCustomCommands("MyCustomCommand")
    RegisterForModEvent("MyCustomCommand", "OnMyCustomCommand")

    ConsoleHelper.SetTextInputText("foo bar baz")
    Input.TapKey(28) ; Enter
    ConsoleHelper.Print("We pushed the button...")

    string expectedOutput = "Hi, you tried to run: foo bar baz"
    string unexpectedOutput = "Script command \"foo\" not found."
    ExpectString(ConsoleHelper.GetBodyText()).Not().To(ContainText(unexpectedOutput))
    ExpectString(ConsoleHelper.GetTextInputText()).To(BeEmpty())
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))

    ConsoleHelper.UnregisterForCustomCommands("MyCustomCommand")
    UnregisterForModEvent("MyCustomCommand")
endFunction

event OnMyCustomCommand(string eventName, string command, float _, Form sender)
    ConsoleHelper.Print("Hi, you tried to run: " + command)
endEvent
