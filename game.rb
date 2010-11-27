class Game
  attr_reader :target_note

  def initialize
    @notes = []
    new_target
  end

  def new_target
    if @notes.empty?
      @notes = Chord.new(Note.random, 4, 7).notes
    end
    @target_note = @notes.shift
  end

  def key_down(key)
    if @target_note.equal_tone?(key)
      new_target
    end
  end

  def key_up(key)
  end
end
