scriptName ConsoleMenuTests_ExecuteCommand extends ConsoleMenuTest
{Tests for ExecuteCommand}

function Tests()
    ; TODO make the names more consistent plz :)
    Test("Can get the result from running command").Fn(UnknownScript_GetResult_Test())
    Test("Can explicitly not get result from running command").Fn(UnknownScript_DontGetResult_Test())
    Test("Can have the executed command printed to console").Fn(PrintingCommandOutToConsoleTest())
    Test("Can have the executed command not printed to console").Fn(NotPrintingCommandOutToConsoleTest())
    Test("Can add executed command to history").Fn(AddExecutedCommandToHistoryTest())
    Test("Can explicitly not executed command to history").Fn(NotAddExecutedCommandToHistoryTest())

    Example("player.showinventory").Fn(Example_ShowInventory_Test())
endFunction

function UnknownScript_GetResult_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("just some gibberish")

    string expectedOutput = "Script command \"just\" not found."
    ExpectString(output).To(ContainText(expectedOutput))
    ExpectString(Consolehelper.GetBodyText()).Not().To(BeEmpty())
    ExpectString(Consolehelper.GetBodyText()).To(ContainText(expectedOutput))
endFunction

function UnknownScript_DontGetResult_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("just some gibberish", getResult = false)

    string expectedOutput = ""
    ExpectString(output).To(EqualString(expectedOutput))
    ExpectString(Consolehelper.GetBodyText()).Not().To(BeEmpty())
    ExpectString(Consolehelper.GetBodyText()).To(ContainText(expectedOutput))
endFunction

function PrintingCommandOutToConsoleTest()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("foo bar baz", printCommand = false)

    string expectedOutput = "Script command \"foo\" not found."
    ExpectString(output).To(ContainText(expectedOutput))
    ExpectString(output).Not().To(ContainText("bar baz"))
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))
    ExpectString(ConsoleHelper.GetBodyText()).Not().To(ContainText("bar baz"))
endFunction

function NotPrintingCommandOutToConsoleTest()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    ConsoleHelper.ExecuteCommand("foo bar baz", printCommand = true)

    string expectedOutput = "Script command \"foo\" not found."
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText("bar baz"))
endFunction

function AddExecutedCommandToHistoryTest()
    int beforeHistoryLength = ConsoleHelper.GetCommandHistoryLength()

    ConsoleHelper.ExecuteCommand("foo bar baz", addToHistory = true)

    int afterHistoryLength = ConsoleHelper.GetCommandHistoryLength()
    ExpectInt(afterHistoryLength).To(EqualInt(beforeHistoryLength + 1))
    string mostRecentCommand = ConsoleHelper.GetMostRecentCommandHistoryItem()
    ExpectString(mostRecentCommand).To(EqualString("foo bar baz"))
endFunction

function NotAddExecutedCommandToHistoryTest()
    int beforeHistoryLength = ConsoleHelper.GetCommandHistoryLength()

    ConsoleHelper.ExecuteCommand("foo bar baz", addToHistory = false)

    int afterHistoryLength = ConsoleHelper.GetCommandHistoryLength()
    ExpectInt(afterHistoryLength).To(EqualInt(beforeHistoryLength))
endFunction

function Example_ShowInventory_Test()
    Form goblet = Game.GetForm(0x98620) ; "Goblet"

    Actor player = Game.GetPlayer()
    player.RemoveItem(goblet, player.GetItemCount(goblet))

    string output = ConsoleHelper.ExecuteCommand("player.showinventory")
    ExpectString(output).Not().To(ContainText("98620"))

    player.AddItem(goblet)

    output = ConsoleHelper.ExecuteCommand("player.showinventory")
    ExpectString(output).To(ContainText("98620"))

    player.RemoveItem(goblet)

    output = ConsoleHelper.ExecuteCommand("player.showinventory")
    ExpectString(output).Not().To(ContainText("98620"))
endFunction
