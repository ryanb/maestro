class Game
  attr_reader :target_note

  def initialize
    new_target
  end

  def new_target
    @target_note = Note.random
  end

  def key_down(key)
    if @target_note.equal_tone?(key)
      new_target
    end
  end

  def key_up(key)
  end
end
