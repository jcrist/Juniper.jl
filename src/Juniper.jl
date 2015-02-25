module Juniper

export Symbolic,
       @syms,
       syms,
       compile


include("core.jl")
include("symbol.jl")
include("number.jl")
include("add.jl")
include("mul.jl")
include("pow.jl")
include("functions.jl")

include("operators.jl")

include("show.jl")
include("canon.jl")
include("util.jl")
include("codegen.jl")
include("diff.jl")

end # module
