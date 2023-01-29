#! /usr/bin/env julia
using Electron

win = Window()

result = run(win, "sendMessageToJulia('foo')")

ch = msgchannel(win)

msg = take!(ch)

println(msg)

