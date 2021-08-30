scriptName ConsoleMenuTests_ExecuteCommand extends ConsoleMenuTest
{Tests for ExecuteCommand}

function Tests()
    Example("Get the result from running command").Fn(GetResult_Test())
    Example("Don't get result from running command").Fn(DontGetResult_Test())
    Example("Print executed command to console").Fn(PrintCommandToConsole_Test())
    Example("Don't print executed command to console").Fn(DontPrintCommandToConsole_Test())
    Example("Add executed command to history").Fn(AddExecutedCommandToHistory_Test())
    Example("Don't add executed command to history").Fn(DontAddExecutedCommandToHistory_Test())

    Example("player.showinventory").Fn(Example_ShowInventory_Test())
endFunction

function GetResult_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("just some gibberish")

    string expectedOutput = "Script command \"just\" not found."
    ExpectString(output).To(ContainText(expectedOutput))
    ExpectString(Consolehelper.GetBodyText()).Not().To(BeEmpty())
    ExpectString(Consolehelper.GetBodyText()).To(ContainText(expectedOutput))
endFunction

function DontGetResult_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("just some gibberish", getResult = false)

    string expectedOutput = ""
    ExpectString(output).To(EqualString(expectedOutput))
    ExpectString(Consolehelper.GetBodyText()).Not().To(BeEmpty())
    ExpectString(Consolehelper.GetBodyText()).To(ContainText(expectedOutput))
endFunction

function PrintCommandToConsole_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    string output = ConsoleHelper.ExecuteCommand("foo bar baz", printCommand = false)

    string expectedOutput = "Script command \"foo\" not found."
    ExpectString(output).To(ContainText(expectedOutput))
    ExpectString(output).Not().To(ContainText("bar baz"))
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))
    ExpectString(ConsoleHelper.GetBodyText()).Not().To(ContainText("bar baz"))
endFunction

function DontPrintCommandToConsole_Test()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    ConsoleHelper.ExecuteCommand("foo bar baz", printCommand = true)

    string expectedOutput = "Script command \"foo\" not found."
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText(expectedOutput))
    ExpectString(ConsoleHelper.GetBodyText()).To(ContainText("bar baz"))
endFunction

function AddExecutedCommandToHistory_Test()
    int beforeHistoryLength = ConsoleHelper.GetCommandHistoryLength()

    ConsoleHelper.ExecuteCommand("foo bar baz", addToHistory = true)

    int afterHistoryLength = ConsoleHelper.GetCommandHistoryLength()
    ExpectInt(afterHistoryLength).To(EqualInt(beforeHistoryLength + 1))
    string mostRecentCommand = ConsoleHelper.GetMostRecentCommandHistoryItem()
    ExpectString(mostRecentCommand).To(EqualString("foo bar baz"))
endFunction

function DontAddExecutedCommandToHistory_Test()
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
