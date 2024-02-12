module SimpleOptimizationEnzymeExt

import SimpleOptimization
import SimpleOptimization.ADTypes: AutoEnzyme

isdefined(Base, :get_extension) ? (using Enzyme) : (using ..Enzyme)

#inlining helps GPU compilation
@inline function SimpleOptimization.instantiate_gradient(f, ::AutoEnzyme)
    (θ, p) -> autodiff_deferred(Reverse, f, Active, Active(θ))[1][1]
end
end
