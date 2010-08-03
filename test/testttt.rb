include Java

include_class javax.sound.midi.MidiSystem
include_class javax.swing.JFrame
include_class java.awt.event.KeyListener

# 准备合成
hecheng = MidiSystem.synthesizer
hecheng.open
channel = hecheng.channels[0]

# 接收按键的frame
midi_frame = JFrame.new("Music Frame")
midi_frame.set_size 200, 200
midi_frame.default_close_operation = JFrame::EXIT_ON_CLOSE

# 监听键盘
midi_frame.add_key_listener KeyListener.impl { |name, event|
  case name
  when :keyPressed
    channel.note_on event.key_char, 64
  when :keyReleased
    channel.note_off event.key_char
  end
}

# 显示 midi_frame
midi_frame.visible = true