Num(value::Real) = Symbolic(NUM, Rational{Int64}(value))
Const(name::Union(String, Char, Symbol)) = Symbolic(CONST, symbol(name))

# Numeric Constants
const Zero = Num(0)
const One = Num(1)
const NegOne = Num(-1)
const OneHalf = Num(1//2)
const PosInf = Num(Inf)
const NegInf = 
const Pi = Const(:π)
const E = Const(:E)    # Uppercase to remove confusion with variables named e

Base.one(::Symbolic) = One
Base.one(::Type{Symbolic}) = One
Base.zero(::Symbolic) = Zero
Base.zero(::Type{Symbolic}) = Zero

Base.promote_rule{T<:Real}(::Type{Symbolic}, ::Type{T}) = Symbolic
function Base.convert{T<:Real}(::Type{Symbolic}, val::T)
    if is(val, zero(T))
        return Zero
    elseif is(val, one(T))
        return One
    elseif is(val, -one(T))
        return NegOne
    else
        return Num(val)
    end
end

function Base.convert(::Type{Symbolic}, val::MathConst)
    if val == e
        return E
    elseif val == pi
        return Pi
    else
        error("MathConst: $val is not implemented")
    end
end
