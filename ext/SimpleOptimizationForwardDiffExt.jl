module SimpleOptimizationForwardDiffExt

import SimpleOptimization
import SimpleOptimization.ADTypes: AutoForwardDiff

using ForwardDiff

#inlining helps GPU compilation
@inline function SimpleOptimization.instantiate_gradient(f, ::AutoForwardDiff)
    (θ, p) -> ForwardDiff.gradient(f, θ)
end

end
