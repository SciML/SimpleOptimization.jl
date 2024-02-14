using StaticArrays, CUDA, ForwardDiff, Enzyme
import Base.Iterators: product

CUDA.allowscalar(false)

function objf(x, p)
    return x[1]^2 + x[2]^2
end

x0 = @SArray ones(Float32, 2)

optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
fd_prob = OptimizationProblem(optf, x0, p)

optf = OptimizationFunction(rosenbrock, Optimization.AutoEnzyme())
enzyme_prob = OptimizationProblem(optf, x0, p)

x0 = @SArray zeros(Float32, N)
p = @SArray Float32[1.0, 100.0]
optf = OptimizationFunction(rosenbrock, Optimization.AutoEnzyme())
prob = OptimizationProblem(optf, x0, p)

function kernel_function(prob, alg)
    solve(prob, alg)
    return nothing
end

@testset "$(nameof(typeof(alg)))" for (alg, prob) in product((SimpleBFGS(), SimpleLBFGS()),
    (fd_prob, enzyme_prob))
    @test begin
        try
            @cuda kernel_function(prob, alg)
            @info "Successfully launched kernel for $(alg)."
            true
        catch err
            @error "Kernel Launch failed for $(alg)."
            false
        end
    end
end
