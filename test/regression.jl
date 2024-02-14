using Optimization, StaticArrays, SimpleOptimization, Test

function objf(x, p)
    return x[1]^2 + x[2]^2
end

using ForwardDiff

x0 = @SArray ones(Float32, 2)
l1 = objf(x0, nothing)

using ForwardDiff
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
