class MainController < NSWindowController
  attr_writer :main_view

  def applicationWillFinishLaunching(notification)
    @game = Game.new
    @main_view.game = @game
    @main_view.setNeedsDisplay(true)
    MIDIUtility.setup
  end

  def awakeFromNib
    NSNotificationCenter.defaultCenter.addObserver(self, selector: "midiKeyDown:", name: "MIDIKeyDownNotification", object: nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector: "midiKeyUp:", name: "MIDIKeyUpNotification", object: nil)
  end

  def midiKeyDown(notification)
    @game.key_down(notification.object)
    @main_view.setNeedsDisplay(true)
  rescue Exception => e
    NSLog([e.message, *e.backtrace].join("\n"))
    NSRunAlertPanel("Ruby Exception", [e.message, *e.backtrace].join("\n"), "OK", nil, nil);
  end

  def midiKeyUp(notification)
    @game.key_up(notification.object)
    @main_view.setNeedsDisplay(true)
  rescue Exception => e
    NSLog([e.message, *e.backtrace].join("\n"))
    NSRunAlertPanel("Ruby Exception", [e.message, *e.backtrace].join("\n"), "OK", nil, nil);
  end
end
