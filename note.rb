class Note
  attr_reader :value

  def self.value_from_tone(tone)
    (sharp_tones.index(tone) || flat_tones.index(tone)) + 60 # default to 4th octive
  end

  def self.sharp_tones
    %w[C C# D D# E F F# G G# A A# B]
  end

  def self.flat_tones
    %w[C Db D Eb E F Gb G Ab A Bb B]
  end

  def self.random
    new(rand(12))
  end

  def initialize(value)
    if value.kind_of? String
      @value = self.class.value_from_tone(value)
    else
      @value = value
    end
  end

  def equal_tone?(note)
    note = Note.new(note) unless note.kind_of? Note
    note.tone_value == tone_value
  end

  def tone_value
    @value % 12
  end

  def sharp_tone
    self.class.sharp_tones[tone_value]
  end

  def flat_tone
    self.class.flat_tones[tone_value]
  end
end
