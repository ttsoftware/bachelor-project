class Leaf

    attr_accessor :mismatches, :insertions, :deletions, :value

    def initialize(value, mismatches = 0, insertions = 0, deletions = 0)
        @value = value
        @mismatches = mismatches
        @insertions = insertions
        @deletions = deletions
    end
end