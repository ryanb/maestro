class MainView < NSView
  attr_writer :game

  def drawRect(rect)
    NSColor.whiteColor.set
    NSRectFill(rect)
    if @game
      if @game.done?
        draw_title("Got #{@game.results.select { |a| a }.size} out of #{@game.results.size} correct", 20)
        draw_title("Press D to play again", -5, 16)
      else
        draw_title("Play #{@game.chord.root_note.sharp_tone} Chord", 20)
        draw_title(@game.chord.notes.map(&:sharp_tone).join("   "), -5, 16)
        draw_title(@game.played_notes.map(&:sharp_tone).join("   "), -30, 16)
      end
    else
      draw_title("Loading...")
    end
  end

  def draw_title(title, y_offset = 0, size = 22.0)
    font = NSFont.fontWithName("Helvetica", size:size)
    string = NSAttributedString.alloc.initWithString(title, attributes:{NSFontAttributeName => font})
    x = bounds.size.width/2 - string.size.width/2
    y = bounds.size.height/2
    string.drawAtPoint(NSMakePoint(x, y + y_offset))
  end
end
