scriptName ConsoleMenuTests_ManagingText extends ConsoleMenuTest
{Tests for setting, getting, and clearing text inputs}

function Tests()
    Test("Get and Set Header Text").Fn(GetSetHeaderTextTest())
    Test("Get and Set Body Text").Fn(GetSetBodyTextTest())
    Test("Get and Set TextInput Text").Fn(GetSetTextInputTextTest())
endFunction

function GetSetHeaderTextTest()
    ExpectString(ConsoleHelper.GetHeaderText()).To(BeEmpty())

    ConsoleHelper.SetHeaderText("Hello, Header!")

    ExpectString(ConsoleHelper.GetHeaderText()).To(EqualString("Hello, Header!"))
endFunction

function GetSetBodyTextTest()
    ExpectString(ConsoleHelper.GetBodyText()).To(BeEmpty())

    ConsoleHelper.SetBodyText("Hello, Body!")

    ExpectString(ConsoleHelper.GetBodyText()).To(EqualString("Hello, Body!"))
endFunction

function GetSetTextInputTextTest()
    ExpectString(ConsoleHelper.GetTextInputText()).To(BeEmpty())

    ConsoleHelper.SetTextInputText("Hello, TextInput!")

    ExpectString(ConsoleHelper.GetTextInputText()).To(EqualString("Hello, TextInput!"))
endFunction
