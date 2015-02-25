function /(a::Symbolic, b::Symbolic)
    if a.head == b.head == NUM
        return Num(value(a)//value(b))
    else
        return a * b ^ NegOne
    end
end

-(a::Symbolic) = NegOne * a

function -(a::Symbolic, b::Symbolic)
    if a.head == b.head == NUM
        return Num(value(a) - value(b))
    else
        return a + -b
    end
end

# Override the int_pow in Base for symbolics
^(base::Symbolic, ex::Integer) = ^(promote(base, ex)...)
# Ensure ops automatically promote real numbers to Num
for op in (:+, :-, :*, :/, :^)
    @eval ($op)(a::Symbolic, b::Real) = ($op)(promote(a, b)...)
    @eval ($op)(a::Real, b::Symbolic) = ($op)(promote(a, b)...)
end

# Define `<`, so that the behavior of `isless` used for sorting is not
# confused with actual symbolic relationals. This can be redefined later
# if relationals are ever implemented
Base.(:<)(a::Symbolic, b::Symbolic) = error("Relationals not implemented")

# Some operators/operations to allow for working with matrices
Base.(:\)(a::Symbolic, b::Symbolic) = b/a

Base.inv(a::Symbolic) = Pow([a, NegOne])
Base.inv(m::Matrix{Symbolic}) = inv(lufact(m, Val{false}))
