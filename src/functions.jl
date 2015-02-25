# EXP
Base.exp(a::Symbolic) = Pow([E, a])

for func in [:log, :sin, :cos, :tan, :asin, :acos, :atan, :abs]
    token = symbol(uppercase(string(func)))
    construct = symbol(string(uppercase(string(func)[1])) * string(func)[2:end])

    @eval function show_sym(io::IO, a::Symbolic, ::Type{Val{$token}})
        print(io, $func, "(", args(a)[1], ")")
    end

    @eval (Base.$func)(a::Symbolic) = ($construct)([a])

    @eval ($construct)(args::Vector{Symbolic}) = Symbolic($token, args)
end
