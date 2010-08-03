#!/usr/bin/env ruby
require 'gtk2'

def make_tab_array(textview, tab_size, font_desc)
  raise "Tab size can't be more than 20" if tab_size > 20
  tab_string = " " * tab_size
  layout = textview.create_pango_layout(tab_string)
  layout.font_description = font_desc
  width, height = layout.pixel_size
  tab_array = Pango::TabArray.new(1, true)
  tab_array.set_tab(0, Pango::TAB_LEFT, width)
  textview.set_tabs(tab_array)
end

window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
window.resizable = true
window.title = "TABs in Text Views"
window.border_width = 10
window.signal_connect('delete_event') { Gtk.main_quit }
window.set_size_request(250, 150)

textview = Gtk::TextView.new
textview.buffer.text = "Tab is now set to 15!\n" +
                       "You can hit the TAB key\n" +
                       "and see for yourself:\n" +
                       "123456789012345678901234567890\n"

# For font styles "Italic", "Bold", "Bold Italic" and
# "Regular" currently, all except "Regular" work fine.
# However, this is really not a Ruby but general version
# "C" GTK+ problem!
font = Pango::FontDescription.new("Monospace Italic 8")
textview.modify_font(font)
make_tab_array(textview, 15, font)

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.border_width = 5
scrolled_win.add(textview)
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

window.add(scrolled_win)
window.show_all
Gtk.main