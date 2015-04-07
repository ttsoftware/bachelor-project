class Token

    attr_accessor :type, :value

    def initialize(type, value)
        @type = type
        @value = value
    end
end

module T
    ASSIGNMENT = :t_assignment
    VARIABLE = :t_variable
    SEQUENCE = :t_sequence
    SEQUENCE_PERMUTATION = :t_sequence_permutation
    RANGE = :t_range
end