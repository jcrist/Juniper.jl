Sym(name::Union(String, Char, Symbol)) = Symbolic(SYM, symbol(name))

macro syms(names...)
    d = Expr(:block)
    for i in names
        n = string(i)
        push!(d.args, :($(esc(i)) = Juniper.Sym($n)))
    end
    return d
end

syms(args::Vector) = Symbolic[Sym(i) for i in args]
syms(args::String) = syms(split(args, ", "))
