class Token

    attr_accessor :type, :value, :assigned

    def initialize(type, value, assigned=nil)
        @type = type
        @value = value
        @assigned = assigned
    end
end

module T
    ASSIGNMENT = :t_assignment
    VARIABLE = :t_variable
    SEQUENCE = :t_sequence
    SEQUENCE_COMBINATION = :t_sequence_combination
    RANGE = :t_range
end