module SimpleOptimizationForwardDiffExt

import SimpleOptimization
import SimpleOptimization.ADTypes: AutoForwardDiff

isdefined(Base, :get_extension) ? (using ForwardDiff) : (using ..ForwardDiff)

#inlining helps GPU compilation
@inline function SimpleOptimization.instantiate_gradient(f, ::AutoForwardDiff)
    (θ, p) -> ForwardDiff.gradient(f, θ)
end

end
