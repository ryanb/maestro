class Game
  attr_reader :goal

  def initialize
    new_goal
  end

  def new_goal
    @goal = notes[rand(notes.size)]
  end

  def notes
    %w[C C# D Eb E F F# G G# A Bb B]
  end

  def key_down(key)
    if notes[key % 12] == @goal
      new_goal
    end
  end

  def key_up(key)
  end
end
