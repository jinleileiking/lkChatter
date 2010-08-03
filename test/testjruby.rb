require 'java'

include_class java.awt.event.KeyListener
include_class java.awt.event.ActionEvent
include_class java.awt.event.ActionListener
include_class java.awt.event.KeyAdapter
include_class java.awt.event.KeyEvent
include_class java.awt.event.WindowAdapter
include_class java.awt.event.WindowEvent
include_class java.awt.event.WindowFocusListener

include_class javax.swing.JFrame
include_class javax.swing.JPanel
include_class java.awt.BorderLayout
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


#main frame
mainframe = JFrame.new("chatter")
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
friends_scroll_pane.setPreferredSize(Dimension.new(100, 0))
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

mainframe.addWindowFocusListener WindowFocusListener.impl { |name, event|
  case name
    when :windowGainedFocus
      puts "focus!"
#          setFocused(true)
#  SysTray.GetInstance().setFlash(false)

    when :windowLostFocus
      puts "focus lose!!"
    #    setFocused(false)
  end
}

send_text_field.addKeyListener KeyListener.impl { |name, event|
  case name
    when :keyTyped
      if event.getKeyChar == 0x0A
        #send text
        puts "send"
      end
  end
}

menu_item_config.addActionListener  ActionListener.impl { |name, event|
  case name
    when :actionPerformed

#      SettingDialog SettingDiag = new SettingDialog();
#      SettingDiag.setVisible(true);
#      trdSnd.SetOwnerName(setOwnerSetting.GetNickName());
#      nickname_label.setText(setOwnerSetting.GetNickName());
  end
}

mainframe.show



