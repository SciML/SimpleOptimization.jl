using Optimization, StaticArrays, SimpleOptimization

N = 2

function rosenbrock(x, p)
    sum(p[2] * (x[i + 1] - x[i]^2)^2 + (p[1] - x[i])^2 for i in 1:(length(x) - 1))
end

x0 = @SArray zeros(Float32, N)
p = @SArray Float32[1.0, 100.0]

using ForwardDiff
optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(optf, x0, p)

sol = solve(prob, SimpleLBFGS())
sol = solve(prob, SimpleBFGS())

using Enzyme
optf = OptimizationFunction(rosenbrock, Optimization.AutoEnzyme())
prob = OptimizationProblem(optf, x0, p)

sol = solve(prob, SimpleLBFGS())
sol = solve(prob, SimpleBFGS())
