scriptName ConsoleMenuTests_ExecuteCommand extends ConsoleMenuTest
{Tests for ExecuteCommand}

; Test that you can OPTIONALLY have the command:
; (a) print itself to the console
; (b) add the command to the command history

function Tests()
    Test("Unknown Script - Get Result").Fn(UnknownScript_GetResult_Test())
    Test("Unknown Script - Don't Wait for Result").Fn(UnknownScript_DontGetResult_Test())
    Test("Printing command out to console").Fn(PrintingCommandOutToConsoleTest())
    Test("Not printing command out to console").Fn(NotPrintingCommandOutToConsoleTest())
    Example("player.showinventory").Fn(ShowInventoryExampleTest())
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

    ConsoleHelper.ExecuteCommand("foo bar baz", printCommand = false)

    string expectedOutput = "Script command \"foo\" not found."
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

function ShowInventoryExampleTest()
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
