Base.show(io::IO, a::Symbolic) = show_sym(io, a, Val{a.head})

# SYMBOL
show_sym(io::IO, a::Symbolic, ::Type{Val{SYM}}) = print(io, name(a))

# NUMBER
function show_sym(io::IO, a::Symbolic, ::Type{Val{NUM}})
    val = value(a)
    if val.den == 1
        print(io, val.num)
    else
        print(io, val.num, "/", val.den)
    end
end

# CONST
show_sym(io::IO, a::Symbolic, ::Type{Val{CONST}}) = print(io, name(a))

# ADD
function show_sym(io::IO, a::Symbolic, ::Type{Val{ADD}})
    terms = args(a)
    print(io, terms[1])
    for i=2:length(terms)
        p_term = string(terms[i])
        if startswith(p_term, "-")
            print(io, " - ", p_term[2:end])
        else
            print(io, " + ", p_term)
        end
    end
end

# MUL
function show_sym(io::IO, a::Symbolic, ::Type{Val{MUL}})
    terms = args(a)
    # If first element is -1, just print a "-".
    (sign, el1) = terms[1] == NegOne ? ("-", 2) : ("", 1)

    # Gather arguments into numerator and denominator
    num = Symbolic[]
    den = Symbolic[]
    for i=el1:length(terms)
        term = terms[i]
        if term.head == POW
            b, ex = args(term)
            if ex.head == NUM && value(ex) < 0
                if ex == NegOne
                    push!(den, b)
                else
                    push!(den, Pow([b, -ex]))
                end
            else
                push!(num, term)
            end
        else
            push!(num, term)
        end
    end

    print(io, sign)
    if length(num) == 0
        print(io, "1")
    else
        print(io, join([parenthesize(i, MUL) for i in num], "*"))
    end

    if length(den) == 1
        print(io, "/", parenthesize(den[1], MUL))
    elseif length(den) > 1
        print(io, "/(", join([parenthesize(i, MUL) for i in den], "*"), ")")
    end
end

# POW
function show_sym(io::IO, a::Symbolic, ::Type{Val{POW}})
    b, ex = args(a)
    if ex == OneHalf
        print(io, "sqrt(", b, ")")
    elseif ex == NegOne
        print(io, "1/", parenthesize(b, POW))
    elseif ex == -OneHalf
        print(io, "1/sqrt(", b, ")")
    elseif b == E
        print(io, "exp(", ex, ")")
    else
        print(io, parenthesize(b, POW), "^", parenthesize(ex, POW))
    end
end

# PARENTHESIS

# Default case: no parenthesis
parenthesize(a::Symbolic, head, parent) = sprint(show_sym, a, head)
parenthesize(a::Symbolic, parent::Int8) = parenthesize(a, Val{a.head}, Val{parent})

# op1 inside of op2 gets parenthesized
for (op1, op2) in [(ADD, MUL), (MUL, POW), (ADD, POW)]
    @eval function parenthesize(a::Symbolic, ::Type{Val{$op1}}, ::Type{Val{$op2}})
                return sprint(print, "(", a, ")")
          end
end

function parenthesize(a::Symbolic, ::Type{Val{NUM}}, ::Type{Val{POW}})
    val = value(a)
    if val.den == 1
        return string(a)
    else
        return sprint(print, "(", a, ")")
    end
end
