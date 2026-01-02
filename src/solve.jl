
# By Pass the highlevel checks for OptimizationProblem for Simple Algorithms
function SciMLBase.solve(prob::SciMLBase.OptimizationProblem,
        opt::SimpleLBFGS,
        args...;
        abstol = nothing,
        reltol = nothing,
        termination_condition = nothing,
        maxiters = 100,
        kwargs...)
    f = Base.Fix2(prob.f.f, prob.p)
    ∇f = instantiate_gradient(f, prob.f.adtype)

    nlprob = NonlinearProblem{false}(∇f, prob.u0)
    nlsol = solve(nlprob,
        SimpleLimitedMemoryBroyden(;
            threshold = __get_threshold(opt),
            linesearch = Val(false));
        maxiters,
        abstol,
        reltol, termination_condition)
    θ = nlsol.u

    SciMLBase.build_solution(SciMLBase.DefaultOptimizationCache(prob.f, prob.p),
        opt,
        θ,
        prob.f(θ, prob.p), original = nlsol, retcode = nlsol.retcode)
end

function SciMLBase.solve(prob::SciMLBase.OptimizationProblem,
        opt::SimpleBFGS,
        args...;
        abstol = nothing,
        reltol = nothing,
        termination_condition = nothing,
        maxiters = 100,
        kwargs...)
    f = Base.Fix2(prob.f.f, prob.p)
    ∇f = instantiate_gradient(f, prob.f.adtype)

    nlprob = NonlinearProblem{false}(∇f, prob.u0)
    nlsol = solve(nlprob,
        SimpleBroyden(; linesearch = Val(true));
        maxiters,
        abstol,
        reltol, termination_condition)
    θ = nlsol.u

    SciMLBase.build_solution(SciMLBase.DefaultOptimizationCache(prob.f, prob.p),
        opt,
        θ,
        prob.f(θ, prob.p), original = nlsol, retcode = nlsol.retcode)
end
