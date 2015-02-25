function Base.diff(expr::Symbolic, var::Symbolic)
    if expr.head == SYM
        if expr == var
            return One
        else
            return Zero
        end
    elseif expr.head == NUM || expr.head == CONST
        return Zero
    end
    # At this point, expr must be a function
    terms = args(expr)
    if expr.head == ADD
        return Add([diff(i, var) for i in terms])
    elseif expr.head == MUL
        res = Symbolic[]
        for i=1:length(terms)
            d = diff(terms[i], var)
            if d != Zero
                push!(res, Mul([terms[1:i-1], d, terms[i+1:end]]))
            end
        end
        return Add(res)
    elseif expr.head == POW
        b, ex = terms
        return expr * (diff(ex, var) * log(b) + diff(b, var) * ex/b)
    end
    # At this point, expr must be a function with arity 1
    x = terms[1]
    if expr.head == SIN
        return Cos(terms) * diff(terms[1], var)
    elseif expr.head == COS
        return -Sin(terms) * diff(terms[1], var)
    elseif expr.head == TAN
        return (One + expr^2) * diff(terms[1], var)
    elseif expr.head == ASIN
        return inv(sqrt(1 - x^2)) * diff(x, var)
    elseif expr.head == ACOS
        return -inv(sqrt(1 - x^2)) * diff(x, var)
    elseif expr.head == ATAN
        return inv(1 + x^2) * diff(x, var)
    elseif expr.head == ABS
        return x * diff(x, var) / expr
    else
        error("NOT IMPLEMENTED :(")
    end
end
