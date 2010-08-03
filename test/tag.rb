#!/usr/bin/env ruby
require 'gtk2'

# Retrieve the tag from the "tag" object data and apply it
# to the selection.
def format(b, txtvu)
  s, e = txtvu.buffer.selection_bounds

  # Our buttons contain Gtk::Stock#Items. Their label values
  # begin with "gtk-", ie: gtk-bold, gtk-italic, ... We need
  # the word after "gtk-" ie.: bold, italic ... which are used
  # as tag property names; Hence Ruby's gsub (sub-string)
  # extracts the 2nd string
  tag_property_name = b.label.gsub(/(gtk-)([a-z]+)/, '\2')

  txtvu.buffer.apply_tag(tag_property_name, s, e)
end

# Apply the selected text size property as the tag.
def scale_changed(combo, txtvu)
  return if combo.active == -1
  s, e = txtvu.buffer.selection_bounds
  txtvu.buffer.apply_tag(combo.active_text, s, e)
  combo.active = -1
end

# Remove all of the tags from the selected text.
def clear_clicked(txtvu)
  s, e = txtvu.buffer.selection_bounds
  txtvu.buffer.remove_all_tags(s, e)
end

class TextToDouble
  attr_accessor :str, :scale
  def initialize(str, scale)
    @str, @scale = str, scale
  end
end

ts = Array.new
ts[0] = TextToDouble.new("Quarter Sized",      0.25)
ts[1] = TextToDouble.new("Double Extra Small", Pango::SCALE_XX_SMALL)
ts[2] = TextToDouble.new("Extra Small",        Pango::SCALE_X_SMALL)
ts[3] = TextToDouble.new("Small",              Pango::SCALE_SMALL)
ts[4] = TextToDouble.new("Medium",             Pango::SCALE_MEDIUM)
ts[5] = TextToDouble.new("Large",              Pango::SCALE_LARGE)
ts[6] = TextToDouble.new("Extra Large",        Pango::SCALE_X_LARGE)
ts[7] = TextToDouble.new("Double Extra Large", Pango::SCALE_XX_LARGE)
ts[8] = TextToDouble.new("Double Sized",       2.0)

window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
window.resizable = true
window.title = "Text Tags"
window.border_width = 10
window.signal_connect('delete_event') { Gtk.main_quit }
window.set_size_request(500, -1)

textview = Gtk::TextView.new

buffer = textview.buffer

# Note: the tag names are stored with buttons in their labels, where
# each label has string form "gtk-bold", "gtk-italic", ...
buffer.create_tag("bold",          {"weight"        => Pango::WEIGHT_BOLD})
buffer.create_tag("italic",        {"style"         => Pango::STYLE_ITALIC})
buffer.create_tag("strikethrough", {"strikethrough" => true})
buffer.create_tag("underline",     {"underline"     => Pango::UNDERLINE_SINGLE})

bold      = Gtk::Button.new(Gtk::Stock::BOLD)
italic    = Gtk::Button.new(Gtk::Stock::ITALIC)
underline = Gtk::Button.new(Gtk::Stock::UNDERLINE)
strike    = Gtk::Button.new(Gtk::Stock::STRIKETHROUGH)
clear     = Gtk::Button.new(Gtk::Stock::CLEAR)
scale     = Gtk::ComboBox.new      # (text=true)

# Add choices to the GtkComboBox widget.
ts.each do |e|
  scale.append_text(e.str)
  buffer.create_tag(e.str, { "scale" => e.scale } )
end

# Connect each of the buttons and the combo box to the necessary signals.
bold.signal_connect("clicked")      { |w| format(w, textview) }
italic.signal_connect("clicked")    { |w| format(w, textview) }
underline.signal_connect("clicked") { |w| format(w, textview) }
strike.signal_connect("clicked")    { |w| format(w, textview) }
scale.signal_connect("changed")     { |w| scale_changed(w, textview) }
clear.signal_connect("clicked")     {     clear_clicked(textview) }

# Pack the widgets into a GtkVBox, GtkHBox, and then into the window. */
vbox = Gtk::VBox.new(true, 5)
vbox.pack_start(bold,      false, false, 0)
vbox.pack_start(italic,    false, false, 0)
vbox.pack_start(underline, false, false, 0)
vbox.pack_start(strike,    false, false, 0)
vbox.pack_start(scale,     false, false, 0)
vbox.pack_start(clear,     false, false, 0)

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.border_width = 5
scrolled_win.add(textview)
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

hbox = Gtk::HBox.new(false, 5)
hbox.pack_start(scrolled_win, true,  true, 0)
hbox.pack_start(vbox,         false, true, 0)

window.add(hbox)
window.show_all
Gtk.main