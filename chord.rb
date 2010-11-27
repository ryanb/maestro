class Chord
  attr_reader :root_note

  def initialize(root_note, *intervals)
    @root_note = root_note
    @intervals = intervals
  end
  
  def notes
    [@root_note, *interval_notes]
  end
  
  def interval_notes
    @intervals.map do |interval|
      Note.new(@root_note.value + interval)
    end
  end
end
