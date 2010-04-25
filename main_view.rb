class MainView < NSView
  attr_writer :start_playing
  
  def drawRect(rect)
    NSColor.whiteColor.set
    NSRectFill(rect)
    if @start_playing
      draw_title("Starting to play! (not yet implemented)")
	else
      draw_title("Welcome to Maestro. Play middle C to continue.")
    end
  end
  
  def draw_title(title)
    font = NSFont.fontWithName("Helvetica", size:22.0)
    string = NSAttributedString.alloc.initWithString(title, attributes:{NSFontAttributeName => font})
	x = bounds.size.width/2 - string.size.width/2
	y = bounds.size.height/2
    string.drawAtPoint(NSMakePoint(x, y))
  end
end
