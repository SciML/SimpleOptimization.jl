# SimpleOptimization.jl

SimpleOptimization.jl provides lightweight loop-unrolled optimization algorithms for the SciML ecosystem. It is designed for small-scale optimization problems where low overhead is critical, such as in inner loops of other algorithms.

## Installation

```julia
using Pkg
Pkg.add("SimpleOptimization")
```

## Algorithms

- `SimpleBFGS`: A Broyden–Fletcher–Goldfarb–Shanno (BFGS) algorithm implementation.
- `SimpleLBFGS`: A Limited-memory BFGS (L-BFGS) algorithm implementation.

## Usage

SimpleOptimization.jl is compatible with [Optimization.jl](https://github.com/SciML/Optimization.jl).

```julia
using SimpleOptimization, Optimization, ForwardDiff

rosenbrock(x, p) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p = nothing

optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(optf, x0, p)

sol = solve(prob, SimpleBFGS())
println(sol.u)

sol = solve(prob, SimpleLBFGS())
println(sol.u)
```