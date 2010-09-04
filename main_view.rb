class MainView < NSView
  attr_writer :game

  def drawRect(rect)
    NSColor.whiteColor.set
    NSRectFill(rect)
    if @game
      draw_title("Play #{@game.target_note.sharp_tone}")
    else
      draw_title("Loading...")
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
