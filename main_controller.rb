class MainController < NSWindowController
  attr_writer :main_view
  
  def applicationWillFinishLaunching(notification)
    MIDIUtility.setup
  end
  
  def awakeFromNib
    NSNotificationCenter.defaultCenter.addObserver(self, selector: "midiKeyDown:", name: "MIDIKeyDownNotification", object: nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector: "midiKeyUp:", name: "MIDIKeyUpNotification", object: nil)
  end
  
  def midiKeyDown(notification)
	key = notification.object
    NSLog("MIDI key down #{notification.object}")
    if key == 60 # middle C
	  @main_view.start_playing = true
	  @main_view.setNeedsDisplay(true)
    end
  end
  
  def midiKeyUp(notification)
    NSLog("MIDI key up #{notification.object}")
  end
end
