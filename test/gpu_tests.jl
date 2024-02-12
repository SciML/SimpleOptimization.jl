using StaticArrays, CUDA

CUDA.allowscalar(false)

N = 2

function rosenbrock(x, p)
    sum(p[2] * (x[i + 1] - x[i]^2)^2 + (p[1] - x[i])^2 for i in 1:(length(x) - 1))
end
x0 = @SArray zeros(Float32, N)
p = @SArray Float32[1.0, 100.0]
optf = OptimizationFunction(rosenbrock, Optimization.AutoEnzyme())
prob = OptimizationProblem(optf, x0, p)

function kernel_function(prob, alg)
    solve(prob, alg)
    return nothing
end

@testset "$(nameof(typeof(alg)))" for alg in (SimpleBFGS(), SimpleLBFGS())
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
