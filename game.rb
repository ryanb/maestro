class Game
  attr_reader :chord, :played_notes, :results

  def initialize
    @played_notes = []
    @results = []
    new_chord
  end

  def new_chord
    @chord = Chord.new(Note.random, 4, 7)
  end

  def key_down(key)
    @played_notes << Note.new(key)
    if done?
      if @played_notes.all? { |note| note.equal_tone? Note.new("D") }
        @results = []
      end
    else
      if @played_notes.size >= 3
        @results << correct?
        new_chord unless done?
      end
    end
  end

  def key_up(key)
    @played_notes.delete_if { |n| n.equal_tone?(key) }
  end

  def correct?
    @chord.notes.all? { |n| @played_notes.any? { |o| o.equal_tone?(n) } } && @played_notes.all? { |n| @chord.notes.any? { |o| o.equal_tone?(n) } }
  end

  def done?
    @results.size >= 10
  end
end
