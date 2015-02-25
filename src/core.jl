# Tokens
const NUM   = Int8(1)
const CONST = Int8(2)
const SYM   = Int8(3)
const ADD   = Int8(4)
const MUL   = Int8(5)
const POW   = Int8(6)
const LOG   = Int8(7)
const SIN   = Int8(8)
const COS   = Int8(9)
const TAN   = Int8(10)
const ASIN  = Int8(11)
const ACOS  = Int8(12)
const ATAN  = Int8(13)
const ABS   = Int8(14)

immutable Symbolic
    head::Int8
    args::Union(Symbol, Rational{Int64}, Vector{Symbolic})
end

# Data accessors:
# Note that these *don't* verify that the head token matches the value type.
# This is just a shorthand for quick type annotations on accessors, correctness
# must be verified by the caller.
name(a::Symbolic) = a.args::Symbol
value(a::Symbolic) = a.args::Rational{Int64}
args(a::Symbolic) = a.args::Vector{Symbolic}
