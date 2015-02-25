using DataStructures

Add(args::Vector{Symbolic}, ::Type{Val{false}}) = Symbolic(ADD, args)
Add(args::Vector{Symbolic}) = Add(args, Val{true})
# Canonicalizer for Add
# ---------------------
# 1. Combines like terms with different *numeric* coefficients
#    (i.e. `b + 3*b = 4*b`, but `a*b + 3*b != (a + 3)*b`)
# 2. Sorts args in canonical order
function Add(terms::Vector{Symbolic}, ::Type{Val{true}})
    term_coeffs = DefaultDict(Symbolic, Symbolic, Zero)

    # Collect coefficients
    iter = exiter(terms)
    for term in iter
        if term.head == ADD
            append!(iter, args(term))
        else
            c, t = to_coeff(term)
            term_coeffs[t] += c
        end
    end

    # Rebuild the expression
    res = Symbolic[]
    sizehint!(res, length(term_coeffs))
    for (t, c) in term_coeffs
        if c == Zero
            continue
        elseif c == One
            push!(res, t)
        else
            push!(res, c*t)
        end
    end

    # Determine type of resulting Symbolic
    n = length(res)
    if n == 0
        return Zero
    elseif n == 1
        return res[1]
    else
        return Add(sort!(res), Val{false})
    end
end


# Convert an expression into `coefficient*term` form
function to_coeff(a::Symbolic)
    if a.head == NUM
        return a, One
    elseif a.head == MUL
        terms = args(a)
        c = terms[1]
        if c.head == NUM
            if length(terms) == 2
                return c, terms[2]
            else
                # Mul is already sorted, just strip the first term
                return c, Mul(terms[2:end], Val{false})
            end
        end
        return One, a
    else
        return One, a
    end
end


# Fast methods for adding specific cases
function +(a::Symbolic, b::Symbolic)
    TA = a.head
    TB = b.head
    if TA == TB == NUM
        return Num(value(a) + value(b))
    else
        return Add([a, b], Val{true})
    end
end
+(a::Symbolic, args::Symbolic...) = Add([a, args...], Val{true})
