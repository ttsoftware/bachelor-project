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
    SEQUENCE_COMBINATION = :t_sequence_combination
    RANGE = :t_range
end