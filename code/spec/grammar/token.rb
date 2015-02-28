class Token

    attr_accessor :type, :pattern

    def initialize(type, pattern)
        @type = type
        @pattern = pattern
    end
end

module T
    ASSIGNMENT = :t_assignment
    VARIABLE = :t_variable
    SEQUENCE = :t_sequence
    SEQUENCE_PERMUTATION = :t_sequence_permutation
    DELIMITER = :t_delimiter
end