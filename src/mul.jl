using DataStructures

Mul(args::Vector{Symbolic}, ::Type{Val{false}}) = Symbolic(MUL, args)
Mul(args::Vector{Symbolic}) = Mul(args, Val{true})
# Canonlicalizes a Vector of terms for an Mul
function Mul(terms::Vector{Symbolic}, ::Type{Val{true}})
    term_exps = DefaultDict(Symbolic, Symbolic, Zero)
    coeff = One

    # Collect coefficients
    iter = exiter(terms)
    for term in iter
        if term.head == MUL
            append!(iter, args(term))
        elseif term.head == NUM
            # Fast return if 0 is present
            if term == Zero
                return Zero
            end
            coeff *= term
        else
            b, ex = to_baseexp(term)
            term_exps[b] += ex
        end
    end

    # Rebuild the expression
    if coeff == One 
        res = Symbolic[]
    else
        res = Symbolic[coeff]
    end
    sizehint!(res, length(term_exps))
    for (b::Symbolic, ex::Symbolic) in term_exps
        if ex == Zero
            continue
        elseif ex == One
            push!(res, b)
        else
            push!(res, Pow([b,ex], Val{true}))
        end
    end

    # Determine type of resulting Symbolic
    n = length(res)
    if n == 0
        return One
    elseif n == 1
        return res[1]
    else
        return Mul(sort!(res), Val{false})
    end
end


# Convert an expression into `base^exp` form
function to_baseexp(a::Symbolic)
    if a.head == POW
        return tuple(args(a)...)
    else
        return (a, One)
    end
end

# Fast methods for adding specific cases
function *(a::Symbolic, b::Symbolic)
    TA = a.head
    TB = b.head
    if TA == TB == NUM
        return Num(value(a) * value(b))
    else
        return Mul([a, b], Val{true})
    end
end
*(a::Symbolic, args::Symbolic...) = Mul([a, args...], Val{true})
