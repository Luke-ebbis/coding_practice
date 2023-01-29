#! /usr/bin/env julia
# This is a julia gui programme written with the help of max bakker
using Gtk

win = GtkWindow("My First Gtk.jl Program", 400, 200)

b = GtkButton("Click Me")
push!(win,b)

function on_button_clicked(w)
  println("The button has been clicked")
end
signal_connect(on_button_clicked, b, "clicked")

showall(win)

if !isinteractive()
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    @async Gtk.gtk_main()
    wait(c)
end#! /usr/bin/env julia

