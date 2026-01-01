# SimpleOptimization.jl

SimpleOptimization.jl provides lightweight loop-unrolled optimization algorithms for the SciML ecosystem. It is designed for small-scale optimization problems where low overhead is critical, such as in inner loops of other algorithms.

## Installation

To install SimpleOptimization.jl, use the Julia package manager:

```julia
using Pkg
Pkg.add("SimpleOptimization")
```

## Algorithms

The following algorithms are available:

- `SimpleBFGS`: A Broyden–Fletcher–Goldfarb–Shanno (BFGS) algorithm implementation.
- `SimpleLBFGS`: A Limited-memory BFGS (L-BFGS) algorithm implementation.

These algorithms are wrappers around solvers from [SimpleNonlinearSolve.jl](https://github.com/SciML/SimpleNonlinearSolve.jl), adapted for optimization problems.

## Usage

SimpleOptimization.jl is designed to be used with [Optimization.jl](https://github.com/SciML/Optimization.jl). You define an `OptimizationProblem` and pass one of the SimpleOptimization algorithms to `solve`.

### Example

Here is an example of minimizing the Rosenbrock function:

```julia
using SimpleOptimization, Optimization, ForwardDiff

# Define the Rosenbrock function
rosenbrock(x, p) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x0 = zeros(2)
p = nothing

# Create the OptimizationFunction using ForwardDiff for automatic differentiation
optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(optf, x0, p)

# Solve using SimpleBFGS
sol_bfgs = solve(prob, SimpleBFGS())
println("BFGS Solution: ", sol_bfgs.u)
println("BFGS Objective: ", sol_bfgs.objective)

# Solve using SimpleLBFGS
sol_lbfgs = solve(prob, SimpleLBFGS())
println("L-BFGS Solution: ", sol_lbfgs.u)
println("L-BFGS Objective: ", sol_lbfgs.objective)
```

## API Reference

```@index
```

```@autodocs
Modules = [SimpleOptimization]
```
