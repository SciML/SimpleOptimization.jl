using Optimization, StaticArrays, SimpleOptimization, Test

function objf(x, p)
    return x[1]^2 + x[2]^2
end

# Rosenbrock function: minimum at (1, 1) with value 0
function rosenbrock(x, p)
    a = isnothing(p) ? 1.0f0 : p[1]
    b = isnothing(p) ? 100.0f0 : p[2]
    return (a - x[1])^2 + b * (x[2] - x[1]^2)^2
end

using ForwardDiff

x0 = @SArray ones(Float32, 2)
l1 = objf(x0, nothing)

# Parameters for rosenbrock: a=1, b=100
p = @SArray Float32[1.0, 100.0]

optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(optf, x0, p)

sol = solve(prob, SimpleLBFGS())
@test 10 * sol.objective < l1

sol = solve(prob, SimpleBFGS())
@test 10 * sol.objective < l1

using Enzyme
optf = OptimizationFunction(rosenbrock, Optimization.AutoEnzyme())
prob = OptimizationProblem(optf, x0, p)

sol = solve(prob, SimpleLBFGS())
@test 10 * sol.objective < l1

sol = solve(prob, SimpleBFGS())
@test 10 * sol.objective < l1
