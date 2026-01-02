module SimpleOptimization

import SciMLBase
import SciMLBase: _unwrap_val
using SimpleNonlinearSolve
using ADTypes

# Source: https://github.com/SciML/Optimization.jl/blob/9c5070b3db838e05794ded348b8b17df0f9e38c1/src/function.jl#L104
function instantiate_gradient(f, adtype::ADTypes.AbstractADType)
    adtypestr = string(adtype)
    _strtind = findfirst('.', adtypestr)
    strtind = isnothing(_strtind) ? 5 : _strtind + 5
    open_nrmlbrkt_ind = findfirst('(', adtypestr)
    open_squigllybrkt_ind = findfirst('{', adtypestr)
    # Handle cases where one or both indices are nothing
    # Use something to convert Nothing to a fallback value for type stability
    nrml = something(open_nrmlbrkt_ind, length(adtypestr) + 1)
    squiggly = something(open_squigllybrkt_ind, length(adtypestr) + 1)
    open_brkt_ind = min(nrml, squiggly)
    adpkg = adtypestr[strtind:(open_brkt_ind - 1)]
    throw(ArgumentError("The passed automatic differentiation backend choice is not available. Please load the corresponding AD package $adpkg."))
end

include("./algorithms.jl")
include("./solve.jl")

export SimpleBFGS, SimpleLBFGS

end
