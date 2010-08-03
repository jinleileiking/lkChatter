require 'gtk2'

hpaned = Gtk::HPaned.new
frame1 = Gtk::Frame.new
frame2 = Gtk::Frame.new
frame1.shadow_type = Gtk::SHADOW_IN
frame2.shadow_type = Gtk::SHADOW_IN

hpaned.set_size_request(200, -1)
hpaned.pack1(frame1, true, false)
hpaned.pack2(frame2, false, false)
frame1.set_size_request(50, -1)

Gtk::Window.new.add(hpaned).set_default_size(300, 100).show_all

Gtk.main