class Game
  attr_reader :chord, :played_notes

  def initialize
    @played_notes = []
    new_chord
  end

  def new_chord
    @chord = Chord.new(Note.random, 4, 7)
  end

  def key_down(key)
    @played_notes << Note.new(key)
    if @chord.notes.all? { |n| @played_notes.any? { |o| o.equal_tone?(n) } } && @played_notes.all? { |n| @chord.notes.any? { |o| o.equal_tone?(n) } }
      new_chord
    end
  end

  def key_up(key)
    @played_notes.delete_if { |n| n.equal_tone?(key) }
  end
end
