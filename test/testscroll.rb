@edialog = Gtk::Window.new
@edialog.signal_connect("delete-event") do
  @edialog.hide
  true
end
vbox = Gtk::VBox.new
@edialog.add(vbox)
@ebuffer = Gtk::TextBuffer.new
@ebuffer.create_tag("query", "family" => "monospace", "weight" =>
Pango::FontDescription::WEIGHT_BOLD)
@ebuffer.create_tag("result", "family" => "monospace", "wrap_mode"
=> Gtk::TextTag::WRAP_WORD)
@ebuffer.create_tag("backtrace", "family" => "monospace", "weight"
=> Pango::FontDescription::WEIGHT_BOLD, "foreground" => "blue")

textview = Gtk::TextView.new(@ebuffer)
textview.set_editable false
textview.cursor_visible = false
scroll = Gtk::ScrolledWindow.new
scroll.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
scroll.add(textview)
vbox.pack_start(scroll)
@eentry = Gtk::Entry.new
@ehistory = []
@ecurrent = 0
@eentry.signal_connect("key_press_event") do |widget, event|
  if event.state.control_mask? and event.keyval ==
Gdk::Keyval::GDK_p
    @ecurrent = (@ecurrent + @ehistory.length - 1) %
@ehistory.length
    @eentry.text = @ehistory[@ecurrent]
    true
  elsif event.state.control_mask? and event.keyval ==
Gdk::Keyval::GDK_n
    @ecurrent = (@ecurrent + @ehistory.length + 1) %
@ehistory.length
    @eentry.text = @ehistory[@ecurrent]
    true
  end
end
vbox.pack_start(@eentry, false, true, 0)
here = binding
@eentry.signal_connect("activate") do
  begin
    result = eval(@eentry.text, here)
    @ebuffer.insert(@ebuffer.end_iter, "#{@eentry.text}\n", "query")
    @ebuffer.insert(@ebuffer.end_iter, "#{result.inspect}\n",
"result")
  rescue Exception => e
    @ebuffer.insert(@ebuffer.end_iter, "#{e.message}\n",
"backtrace")
    e.backtrace.each do |line|
      @ebuffer.insert(@ebuffer.end_iter, "#{line}\n", "backtrace")
    end
  end
  @ehistory << @eentry.text
  @eacurrent = -1
  @eentry.text = ""
  scroll.vadjustment.value = scroll.vadjustment.upper -
scroll.vadjustment.page_size
end

@edialog.set_default_size(512, 384)
