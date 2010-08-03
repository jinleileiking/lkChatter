require 'java'
require "global"
#require "substance.jar"

#include_class org.jvnet.substance.skin.SubstanceModerateLookAndFeel
include_class javax.swing.UIManager;
include_class javax.swing.SwingUtilities

include_class java.awt.event.KeyListener
include_class java.awt.event.ActionEvent
include_class java.awt.event.ActionListener
include_class java.awt.event.KeyAdapter
include_class java.awt.event.KeyEvent
include_class java.awt.event.WindowAdapter
include_class java.awt.event.WindowEvent
include_class java.awt.event.WindowListener
include_class java.awt.event.WindowFocusListener

include_class javax.swing.DefaultListModel;
include_class javax.swing.JFrame
include_class javax.swing.JWindow
include_class javax.swing.JPanel
include_class java.awt.BorderLayout
include_class javax.swing.BoxLayout
include_class javax.swing.JTextArea
include_class javax.swing.JScrollPane
include_class java.awt.Dimension
include_class javax.swing.JList
include_class javax.swing.JTextField
include_class javax.swing.JMenuBar
include_class  javax.swing.JMenu
include_class  javax.swing.JMenuItem
include_class  javax.swing.JTextPane
include_class javax.swing.border.LineBorder
include_class  javax.swing.ScrollPaneConstants
include_class java.awt.Color
include_class javax.swing.border.BevelBorder
include_class  javax.swing.JLabel

include_class javax.swing.text.BadLocationException
include_class javax.swing.text.SimpleAttributeSet
include_class javax.swing.text.StyleConstants
include_class javax.swing.text.StyledDocument
include_class  javax.swing.JDialog
include_class javax.swing.border.EtchedBorder
include_class  javax.swing.JButton

include_class javax.swing.JOptionPane;


include_class java.awt.Image;
include_class java.awt.SystemTray;
include_class java.awt.TrayIcon;
include_class java.awt.event.MouseAdapter;
include_class java.awt.event.MouseEvent;
include_class java.awt.event.MouseListener
include_class java.awt.Toolkit;
include_class java.awt.TrayIcon
include_class java.awt.Frame;
include_class java.io.FileInputStream;
include_class java.io.BufferedInputStream;
include_class   java.net.URL;

class MsgBox
  def initialize(message, title="")
    JOptionPane.showMessageDialog(nil, message, title, JOptionPane::PLAIN_MESSAGE);
  end
end

class JList
  def add_list(string_array)
    dlm =  DefaultListModel.new
    self.setModel(dlm);

    string_array.each do |string|
      dlm.addElement(string);
    end
  end
end

class JTextPane
  def add_text(string, color=nil)

    if color == nil
      color = Color::BLACK
    end
    attr_set = SimpleAttributeSet.new
    StyleConstants.setForeground(attr_set, color);
    doc = self.getStyledDocument();
    doc.insertString(doc.getLength(), string, attr_set);
    self.setCaretPosition(self.getStyledDocument().getLength());
  end
end

class ConfigDialog < JDialog
  attr_accessor(:nickname)
  attr_accessor(:ips)

  def set_init(nickname, ips)
    @nickname_text_field.text = nickname
    IP_NUMBER.times do |time|
      @ip_text_fields[time].text = ips[time]
    end
  end

  def initialize()

    @ips=[]

    super
    self.setUndecorated(true);
    self.setResizable(false);
    setModal(true);
    setAlwaysOnTop(true);
    setTitle("设置");
    setBounds(100, 100, 365, 400);
    setDefaultCloseOperation(JFrame::DO_NOTHING_ON_CLOSE);


    panel =  JPanel.new
    panel.setLayout(  BoxLayout.new(panel, BoxLayout::Y_AXIS));
    panel.setBorder(EtchedBorder.new(BevelBorder::RAISED, Color::GRAY, Color::BLACK));
    getContentPane().add(panel, BorderLayout::CENTER);

    #nickname
    nickname_panel = JPanel.new
    nickname_label = JLabel.new
    nickname_label.setText("　　　 昵称: ");
    nickname_panel.add(nickname_label);

    @nickname_text_field = JTextField.new
    @nickname_text_field.setPreferredSize(Dimension.new(200, 20));
    nickname_panel.add(@nickname_text_field);
    panel.add nickname_panel



    #ips
    @ip_text_fields = []
    IP_NUMBER.times do |time|
      ip_panel =  JPanel.new
      ip_label = JLabel.new
      ip_label.setText("其他网段IP#{time + 1}: ");
      ip_panel.add(ip_label);

      ip_text_field = JTextField.new
      @ip_text_fields << ip_text_field
      ip_text_field.setPreferredSize(Dimension.new(200, 20));
      ip_panel.add(ip_text_field);
      panel.add ip_panel

    end


    ok_button =  JButton.new
    ok_button.setText("确认");
    panel.add(ok_button);

    ok_button.addActionListener ActionListener.impl { |name, event|
      case name
        when :actionPerformed

          unless @nickname_text_field.text[/^([#{[0x4E00].pack("U")}-#{[0x9FA5].pack("U")}\w]+)$/u]
            MsgBox.new "请输入正确的昵称!"
            return
          end

          IP_NUMBER.times { |time|
            if @ip_text_fields[time].text == ""
              next
            end

            unless @ip_text_fields[time].text[/^\d+.\d+.\d+.\d+$/]
              MsgBox.new "请输入正确的IP!"
              return
            end
          }

          @nickname = @nickname_text_field.text
          IP_NUMBER.times {|time| @ips[time] = @ip_text_fields[time].text }

          dispose();
      end
    }

  end
end


class TrayIcon
  attr_accessor :blink
end










#main frame
#JFrame.setDefaultLookAndFeelDecorated(true);



#UIManager.setLookAndFeel(SubstanceModerateLookAndFeel.new)
mainframe = JFrame.new()
mainframe.setVisible(true)
mainframe.setBounds(100, 100, 500, 375)
mainframe.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
mainframe.setTitle("lkChatter---群聊工具--by 伟大的Leiking")


#message
north_panel = JPanel.new
north_panel.setLayout(BorderLayout.new)
mainframe.getContentPane().add(north_panel)

message_scroll_pane = JScrollPane.new
message_scroll_pane.setMinimumSize(Dimension.new(0, 0))
message_scroll_pane.setMaximumSize(Dimension.new(0, 0))
message_scroll_pane.setHorizontalScrollBarPolicy(ScrollPaneConstants::HORIZONTAL_SCROLLBAR_NEVER)
north_panel.add(message_scroll_pane)

message_text_pane = JTextPane.new
message_scroll_pane.setViewportView(message_text_pane)
message_text_pane.setBorder(LineBorder.new(Color::LIGHT_GRAY, 2, true))
message_text_pane.setEditable(false)


###friends
friends_scroll_pane = JScrollPane.new
friends_scroll_pane.setPreferredSize(Dimension.new(150, 0))
north_panel.add(friends_scroll_pane, BorderLayout::EAST)

friends_list = JList.new
friends_list.setBorder(BevelBorder.new(BevelBorder::RAISED))
friends_list.setPreferredSize(Dimension.new(0, 0))
friends_scroll_pane.setViewportView(friends_list)

south_panel = JPanel.new
mainframe.getContentPane().add(south_panel, BorderLayout::SOUTH)


#nickname
nickname_label = JLabel.new
south_panel.add(nickname_label)
nickname_label.text = $user_info.nickname

#send
send_scroll_pane = JScrollPane.new
south_panel.add(send_scroll_pane)

send_text_field = JTextField.new

send_scroll_pane.setViewportView(send_text_field)
send_text_field.setPreferredSize(Dimension.new(400, 25))



#### menu###
menubar = JMenuBar.new
mainframe.setJMenuBar(menubar)

menu_1 =  JMenu.new
menu_1.setText("设置")
menubar.add(menu_1)

menu_item_config =  JMenuItem.new
menu_item_config.setText("个人配置")
menu_1.add(menu_item_config)

#trayicon
if (SystemTray.isSupported())
  system_tray = SystemTray.getSystemTray();

  img_tray = Toolkit.getDefaultToolkit().getImage(URL.new( "file:.//trayicon.jpg"))
  img_null = Toolkit.getDefaultToolkit().getImage(URL.new( "file:.//null.jpg"))

  tray_icon = TrayIcon.new(img_tray);
  tray_icon.setImageAutoSize(true);
  tray_icon.setToolTip("群聊工具");
  tray_icon.blink = false

  system_tray.add(tray_icon);

  tray_icon.addMouseListener MouseListener.impl { |name, event|
    case name
      when :mouseClicked
        if event.getButton ==  MouseEvent::BUTTON1
          if mainframe.isVisible() == true
            mainframe.setVisible false
          else
            mainframe.setVisible(true);
            mainframe.setAlwaysOnTop(true);
            mainframe.setAlwaysOnTop(false);
            mainframe.requestFocus();

            bFlash = false;
          end
          mainframe.setExtendedState(Frame::NORMAL);

        end

    end
  }
end





#### Events
mainframe.addWindowFocusListener WindowFocusListener.impl { |name, event|
  case name
    when :windowGainedFocus
      tray_icon.blink = false
    when :windowLostFocus
  end
}

mainframe.addWindowListener WindowListener.impl { |name, event|
  case name
    when :windowIconified
      mainframe.setVisible(false)
  end
}

send_text_field.addKeyListener KeyListener.impl { |name, event|
  case name
    when :keyTyped
      if event.getKeyChar == 0x0A
        #send text
        $send_queue.enq "nickname=#{$user_info.nickname}&message=#{send_text_field.text}\r\n"
        message_text_pane.add_text "#{Time.new.strftime("[%H:%M:%S]")}我: ", Color::GRAY
        message_text_pane.add_text "#{send_text_field.text}\r\n"
        send_text_field.text = ''
      end
  end
}

config_dialog = ConfigDialog.new

menu_item_config.addActionListener  ActionListener.impl { |name, event|
  case name
    when :actionPerformed
      if File.exist?("config.yaml")
        config  =  YAML.load(File.open("config.yaml"))
        config_dialog.set_init(config[:nickname], config[:ips])
        config_dialog.setVisible true
      else
        config_dialog.setVisible true
      end

      #name changed?
      message_text_pane.add_text "昵称已改为:#{config_dialog.nickname}", Color::RED if $user_info.nickname != config_dialog.nickname
      message_text_pane.add_text "\r\n"
      $user_info.nickname = config_dialog.nickname
      nickname_label.text = $user_info.nickname

      IP_NUMBER.times do |time|
        $ips = $ips.concat get_addresses(config_dialog.ips[time]) unless  config_dialog.ips[time].empty?
      end
      $ips.uniq

      #save
      config = {:nickname => config_dialog.nickname,
                :ips =>config_dialog.ips}
      File.open("config.yaml", "w")  {|f|  YAML.dump(config, f)}
  end
}


#threads

# say texts
Thread.new do
  while true
    if message = $text_show_queue.deq


      if message[/\|message\|.+/]
        pattern = /\|message\|(.+:)(.+)/
        pattern =~ message.strip
        data = Regexp.last_match
        if data
          message_text_pane.add_text data[1], Color::BLUE
          message_text_pane.add_text "#{data[2]}\r\n"
        end

        unless mainframe.isFocused
          tray_icon.blink = true
        end
      else
        message_text_pane.add_text message
      end
    end
  end
end

# nick name friends list
Thread.new do
  while true
    if message = $nickname_queue.deq
      #clear the nickname
      $log.debug "get message #{message.inspect}"
#      message.each do |nickname|
      friends_list.add_list(message)
#      end
    end
  end
end

#tray icon flash
Thread.new do
  while true
    if tray_icon.blink
      tray_icon.setImage(img_null);
      sleep(0.5)
      tray_icon.setImage(img_tray);
    else
      tray_icon.setImage(img_tray);
    end
    sleep(0.5)
  end
end


#looks = UIManager::installed_look_and_feels
#UIManager::look_and_feel = looks[ 1 ].class_name
#SwingUtilities::update_component_tree_ui(mainframe)

mainframe.show



