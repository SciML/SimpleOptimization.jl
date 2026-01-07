using AllocCheck
using SimpleOptimization
using ForwardDiff
using StaticArrays
using Optimization
using BenchmarkTools
using Test

# Simple test function
function simple_quadratic(x, p)
    return x[1]^2 + x[2]^2
end

# Rosenbrock function
function rosenbrock(x, p)
    a = isnothing(p) ? 1.0f0 : p[1]
    b = isnothing(p) ? 100.0f0 : p[2]
    return (a - x[1])^2 + b * (x[2] - x[1]^2)^2
end

@testset "Allocation Tests" begin
    @testset "instantiate_gradient - ForwardDiff" begin
        # Test that instantiate_gradient doesn't allocate on the hot path
        p = @SArray Float32[1.0, 100.0]
        f = Base.Fix2(rosenbrock, p)

        # Warm up
        grad_fn = SimpleOptimization.instantiate_gradient(f, ADTypes.AutoForwardDiff())

        # Test that instantiate_gradient itself doesn't allocate much
        # (it creates a closure which has a small fixed allocation)
        allocs = @allocated SimpleOptimization.instantiate_gradient(f, ADTypes.AutoForwardDiff())
        @test allocs <= 64  # Allow small closure allocation
    end

    @testset "Gradient computation - Static Arrays" begin
        # Test that gradient computation with static arrays has minimal allocations
        p = @SArray Float32[1.0, 100.0]
        f = Base.Fix2(rosenbrock, p)
        grad_fn = SimpleOptimization.instantiate_gradient(f, ADTypes.AutoForwardDiff())

        x = @SArray Float32[2.0, 3.0]

        # Warm up
        grad_fn(x, nothing)

        # Test that gradient evaluation has minimal allocations with static arrays
        # ForwardDiff may have a small fixed allocation for static arrays
        allocs = @allocated grad_fn(x, nothing)
        @test allocs <= 32  # Allow small ForwardDiff overhead
    end

    @testset "Full solve - Static Arrays performance" begin
        x0 = @SArray ones(Float32, 2)
        p = @SArray Float32[1.0, 100.0]
        optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
        prob = OptimizationProblem(optf, x0, p)

        # Warm up
        solve(prob, SimpleLBFGS())
        solve(prob, SimpleBFGS())

        # Benchmark to ensure consistent performance
        # With static arrays, allocations should be minimal
        lbfgs_allocs = @allocated solve(prob, SimpleLBFGS())
        bfgs_allocs = @allocated solve(prob, SimpleBFGS())

        # These should be very low for static arrays
        # Allow up to 1KB for the solution object and any small temporaries
        @test lbfgs_allocs < 1024
        @test bfgs_allocs < 1024

        # Also test that solutions are correct
        sol_lbfgs = solve(prob, SimpleLBFGS())
        sol_bfgs = solve(prob, SimpleBFGS())
        @test sol_lbfgs.objective < 1.0e-6
        @test sol_bfgs.objective < 1.0e-6
    end

    @testset "Timing benchmark - Static Arrays" begin
        x0 = @SArray ones(Float32, 2)
        p = @SArray Float32[1.0, 100.0]
        optf = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
        prob = OptimizationProblem(optf, x0, p)

        # Warm up
        solve(prob, SimpleLBFGS())
        solve(prob, SimpleBFGS())

        # Benchmark with BenchmarkTools for more accurate timing
        lbfgs_bench = @benchmark solve($prob, SimpleLBFGS()) samples = 100
        bfgs_bench = @benchmark solve($prob, SimpleBFGS()) samples = 100

        # These should complete in microseconds or less
        @test median(lbfgs_bench.times) < 1_000_000  # Less than 1ms
        @test median(bfgs_bench.times) < 1_000_000   # Less than 1ms

        println("SimpleLBFGS median time: ", median(lbfgs_bench.times) / 1000, " μs")
        println("SimpleBFGS median time: ", median(bfgs_bench.times) / 1000, " μs")
    end
end
