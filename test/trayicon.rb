require 'gtk2'

si=Gtk::StatusIcon.new
si.stock=Gtk::Stock::YES
p Gtk::Stock::YES
p Gtk::Stock::NO
p Gtk::Stock::YES.to_s
Thread.new do
  while true


    if si.blinking?
#      si.blinking = false
      p "f"
    else
      si.blinking = true
      p "t"
    end
    sleep(5)
#    si.stock=Gtk::Stock::NO if si.stock == Gtk::Stock::YES.to_s
#    si.stock=Gtk::Stock::YES if si.stock == Gtk::Stock::NO.to_s

  end
end

si.signal_connect("activate") do
      si.blinking = false
end


Gtk.main