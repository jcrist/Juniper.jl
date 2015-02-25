# A private module to hold the generated compiled functions so the names don't
# pollute the global namespace.
#
# Note that this design will result in a buildup of functions over-time.  This
# *probably* won't cause problems, but may if compile is called many times.
# To remedy this, an optional kwarg `name` is allowed. Using the same `name`
# for each call will overwrite the old function of that name, preventing
# endless incrementation.
module CompiledFuncs end

type NumIter
    current::Integer
end

const FUNC_NUM = NumIter(1)

function get_func_name()
    global FUNC_NUM
    res = FUNC_NUM.current
    FUNC_NUM.current += 1
    return "compiled_func_$res"
end

function compile(args::Vector{Symbolic}, expr::Symbolic;
        name::String=get_func_name())
    header = string(name, "(", join(args, ", "), ") = ")
    return CompiledFuncs.eval(parse(header * string(expr)))
end
