Pow(args::Vector{Symbolic}, ::Type{Val{false}}) = Symbolic(POW, args)
Pow(args::Vector{Symbolic}) = Pow(args, Val{true})
function Pow(terms::Vector{Symbolic}, ::Type{Val{true}})
    b, ex = terms
    if ex == Zero
        return One
    elseif ex == One
        return b
    elseif ex.head == b.head == NUM
        if value(b) < 0
            return Num(1/Rational(value(b) ^ -value(ex)))
        else
            return Num(value(b) ^ value(ex))
        end
    elseif ex.head == NUM && b.head == MUL
        return Mul(Symbolic[i^ex for i in args(b)])
    elseif b.head == POW
        b2, ex2 = args(b)
        return Pow([b2, ex2*ex])
    else
        return Pow(terms, Val{false})
    end
end

^(b::Symbolic, ex::Symbolic) = Pow([b, ex])

Base.sqrt(a::Symbolic) = Pow([a, OneHalf])
