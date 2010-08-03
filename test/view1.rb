require "global"


Gtk::TextView.class_eval {
  def append_text(string, color=nil)
    self.buffer.insert self.buffer.end_iter, string
    if color
      iter_start = self.buffer.get_iter_at_line(self.buffer.line_count)
      b, iter_end = self.buffer.bounds
      self.buffer.apply_tag(color, iter_start, iter_end)
    end
    eob_mark = self.buffer.create_mark(nil, self.buffer.start_iter.forward_to_end, false)
    self.scroll_mark_onscreen(eob_mark)
  end
}
window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
#window = Gtk::Window.new( Gtk::Window::POPUP)
window.modal = true
window.type_hint =  Gdk::Window::TYPE_HINT_UTILITY
window.skip_taskbar_hint=true
window.skip_pager_hint=true

window.set_title  "群聊工具--By 伟大的leiking"
#window.set_title  "群聊工具"

window.border_width = 10
window.signal_connect('delete_event') { Gtk.main_quit }
window.set_default_size(600, 200)
window.resizable=true
window.window_position=Gtk::Window::POS_CENTER
window.destroy_with_parent=true
#window.modal = true

status_icon = Gtk::StatusIcon.new
status_icon.stock=Gtk::Stock::YES


window.signal_connect("window-state-event") do |widget, event|
#  p event.changed_mask
#  if event.changed_mask == Gdk::EventWindowState::ICONIFIED
#    p widget.visible?
#    window.iconify
#    window.hide
#  end
end



window.signal_connect("focus-in-event") do  |widget, event|
  status_icon.blinking = false
end

window.signal_connect("destroy") {
  Gtk.main_quit
}



status_icon.signal_connect("activate") do

  #maximize the window
#  window.deiconify
#  window.present
#  window.stick
  window.present
end




menubar = Gtk::MenuBar.new
filemenu = Gtk::Menu.new
file = Gtk::MenuItem.new("配置")
file.submenu = filemenu
menubar.append(file)
filemenu.append(menuitem_config = Gtk::MenuItem.new("配置"))


notebook = Gtk::Notebook.new
#prev_pg = Gtk::Button.new("_Previous Tab")
#close   = Gtk::Button.new("_Close")
#prev_pg.signal_connect( "clicked" ) { prev_tab(notebook) }
#close.signal_connect( "clicked" ) { Gtk.main_quit }




textview = Gtk::TextView.new
textview.editable = false
textview.wrap_mode = Gtk::TextTag::WRAP_CHAR
textview.buffer.create_tag("gray", { "foreground" => "gray"})
textview.buffer.create_tag("blue", { "foreground" => "blue"})
textview.buffer.create_tag("red", { "foreground" => "red"})
textview.cursor_visible = false

#textview.signal_connect("move-cursor") do
#  puts "a"
#end


scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.border_width = 5
scrolled_win.add(textview)
scrolled_win.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)

notebook.append_page(scrolled_win, Gtk::Label.new("聊天信息"))

#Gtk::Widget.flags = Gtk::Widget::CAN_DEFAULT
say =  Gtk::Entry.new
say.text = ""

say.signal_connect("activate") do
  $send_queue.enq "nickname=#{$user_info.nickname}&message=#{say.text}\r\n"

  textview.append_text "#{Time.new.strftime("[%H:%M:%S]")}我: ", "gray"
  textview.append_text "#{say.text}\r\n"
  say.text = ''
end


renderer = Gtk::CellRendererText.new
column = Gtk::TreeViewColumn.new("在线用户", renderer, "text" => 0)
treeview = Gtk::TreeView.new
treeview.append_column(column)

store = Gtk::ListStore.new(String)



# Add the tree model to the tree view
treeview.model = store

userinfo_win = Gtk::ScrolledWindow.new
userinfo_win.add(treeview)
userinfo_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
userinfo_win.set_size_request(200, 0)

hbox = Gtk::HBox.new(false, 1)
hbox.pack_start(notebook, true, true, 0)
hbox.pack_start(userinfo_win, false, false, 1)

vbox = Gtk::VBox.new(false, 5)
vbox.pack_start(menubar, false, false, 0)
vbox.pack_start(hbox, true, true, 0)
vbox.pack_start(say, false, false, 0)



window.add(vbox)
window.show_all








Thread.new do
  while true
    if message = $tray_icon_queue.deq
      if message == "flash"
        p window.has_toplevel_focus?
        unless window.has_toplevel_focus?
          status_icon.blinking = true
        end
#      else
#        status_icon.blinking = false
      end
    end
  end
end



Thread.new do
  while true
    if message = $nickname_queue.deq
      #clear the nickname
      store.clear
      $log.debug "get message #{message.inspect}"
      message.each do |nickname|
        iter = store.append
        store.set_value(iter, 0, nickname)
      end
    end
  end
end

Thread.new do
  while true
    if message = $text_show_queue.deq

      if message[/\|message\|.+/]
        pattern = /\|message\|(.+:)(.+)/
        pattern =~ message.strip
        data = Regexp.last_match
        if data
          textview.append_text data[1], "blue"
          textview.append_text "#{data[2]}\r\n"
        end
      else
        textview.append_text message
      end
    end
  end
end

menuitem_config.signal_connect("activate") do
  dialog = Gtk::Dialog.new(
          "请输入参数",
          window,
          Gtk::Dialog::DESTROY_WITH_PARENT,
          [ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_OK ]
  )
  dialog.has_separator = false


  if File.exist?("config.yaml")
    config  =  YAML.load(File.open("config.yaml"))

    contents = []
    contents << {:name => "昵称", :para => "nickname", :default => config[:nickname]}
    contents << {:name => "其他网段1", :para => "other_net_1", :default => config[:ips][0]}
    contents << {:name => "其他网段2", :para => "other_net_2", :default => config[:ips][1]}
    contents << {:name => "其他网段3", :para => "other_net_3", :default => config[:ips][2]}
    contents << {:name => "其他网段4", :para => "other_net_4", :default => config[:ips][3]}
    contents << {:name => "其他网段5", :para => "other_net_5", :default => config[:ips][4]}
    contents << {:name => "其他网段6", :para => "other_net_6", :default => config[:ips][5]}
    contents << {:name => "其他网段7", :para => "other_net_7", :default => config[:ips][6]}
    contents << {:name => "其他网段8", :para => "other_net_8", :default => config[:ips][7]}
    contents << {:name => "其他网段9", :para => "other_net_9", :default => config[:ips][8]}
  else
    contents = []
    contents << {:name => "昵称", :para => "nickname", :default => ""}
    contents << {:name => "其他网段1", :para => "other_net_1", :default => ""}
    contents << {:name => "其他网段2", :para => "other_net_2", :default => ""}
    contents << {:name => "其他网段3", :para => "other_net_3", :default => ""}
    contents << {:name => "其他网段4", :para => "other_net_4", :default => ""}
    contents << {:name => "其他网段5", :para => "other_net_5", :default => ""}
    contents << {:name => "其他网段6", :para => "other_net_6", :default => ""}
    contents << {:name => "其他网段7", :para => "other_net_7", :default => ""}
    contents << {:name => "其他网段8", :para => "other_net_8", :default => ""}
    contents << {:name => "其他网段9", :para => "other_net_9", :default => ""}
  end



  contents.each do |content|
    label = Gtk::Label.new("#{content[:name]}: ")
    eval("@#{content[:para]} =  Gtk::Entry.new")
    eval("@#{content[:para]}.text = '#{content[:default]}' ") if  content[:default]

    hbox = Gtk::HBox.new(false, 1)
    hbox.border_width = 1
    hbox.pack_start_defaults(label);
    eval "hbox.pack_start_defaults(@#{content[:para]})"
    dialog.vbox.add(hbox)
  end

  dialog.show_all
  dialog.run do |response|
    case response
      when Gtk::Dialog::RESPONSE_OK

        unless @nickname.text[/^([#{[0x4E00].pack("U")}-#{[0x9FA5].pack("U")}\w]+)$/u]
          textview.append_text "请输入正确的昵称!", "red"
          textview.append_text "\r\n"
          break
        end

        textview.append_text "昵称已改为:#{@nickname.text}", "red" if $user_info.nickname != @nickname.text
        textview.append_text "\r\n"
        $user_info.nickname = @nickname.text

        $ips = $ips.concat get_addresses(@other_net_1.text) unless  @other_net_1.text.empty?
        $ips = $ips.concat get_addresses(@other_net_2.text)  unless @other_net_2.text.empty?
        $ips = $ips.concat get_addresses(@other_net_3.text) unless  @other_net_3.text.empty?
        $ips = $ips.concat get_addresses(@other_net_4.text) unless  @other_net_4.text.empty?
        $ips = $ips.concat get_addresses(@other_net_5.text) unless  @other_net_5.text.empty?
        $ips = $ips.concat get_addresses(@other_net_6.text) unless  @other_net_6.text.empty?
        $ips = $ips.concat get_addresses(@other_net_7.text) unless  @other_net_7.text.empty?
        $ips = $ips.concat get_addresses(@other_net_8.text) unless  @other_net_8.text.empty?
        $ips = $ips.concat get_addresses(@other_net_9.text) unless  @other_net_9.text.empty?
        $ips.uniq

        config = {:nickname => @nickname.text,
                  :ips => [@other_net_1.text,
                           @other_net_2.text,
                           @other_net_3.text,
                           @other_net_4.text,
                           @other_net_5.text,
                           @other_net_6.text,
                           @other_net_7.text,
                           @other_net_8.text,
                           @other_net_9.text]
        }

        File.open("config.yaml", "w")  {|f|  YAML.dump(config, f)}


      else

    end

  end
  dialog.destroy
end

unless defined? Ocra
  Gtk.main
end
