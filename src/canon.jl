function Base.isless(a::Symbolic, b::Symbolic)
    # First compare class keys
    TA = a.head
    TB = b.head
    if TA !== TB
        return TA < TB
    end
    if TA == SYM || TA == CONST
        # Sort syms and consts by name
        return isless(name(a), name(b))
    elseif TA == NUM
        # Sort nums by value
        return isless(value(a), value(b))
    else
        args_a = args(a)
        args_b = args(b)
        la = length(args_a)
        lb = length(args_b)
        if la !== lb
            # Sort mismatched arg lengths by length
            return la < lb
        end
    end
    # At this point, they have the same length args
    for i=1:la
        if isless(args_a[i], args_b[i])
            return true
        end
    end
    return false
end

function Base.hash(a::Symbolic, h::Uint64)
    if a.head == SYM || a.head == NUM || a.head == CONST
        return hash(object_id(a), h)
    else
        h = hash(a.head, h)
        return hash(args(a), h)
    end
end

function Base.(:(==))(a::Symbolic, b::Symbolic)
    if a.head != b.head
        return false
    elseif a.head == SYM || a.head == CONST
        return name(a) == name(b)
    elseif a.head == NUM
        return value(a) == value(b)
    else
        return args(a) == args(b)
    end
end
