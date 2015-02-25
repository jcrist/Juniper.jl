immutable ExtendableIter{T}
    orig::Vector{T}
    extra::Vector{T}

    ExtendableIter{T}(a::Vector{T}) = new(a, T[])
end

exiter{T}(a::Vector{T}) = ExtendableIter{T}(a)

function Base.start(it::ExtendableIter)
    i = 1
    xs_state = start(it.orig)

    if done(it.orig, xs_state)
        i = 2
        xs_state = start(it.extra)
    end
    return i, xs_state
end

function Base.next(it::ExtendableIter, state)
    i, xs_state = state
    vec = i == 1 ? it.orig : it.extra
    v, xs_state = next(vec, xs_state)
    if done(vec, xs_state)
        i += 1
        xs_state = 1
    end
    return v, (i, xs_state)
end

function Base.done(it::ExtendableIter, state)
    i, xs_state = state
    if i > 2
        return true
    end
    vec = i == 1 ? it.orig : it.extra
    return done(vec, xs_state)
end

Base.append!{T}(it::ExtendableIter{T}, items::Vector{T}) = append!(it.extra, items)
