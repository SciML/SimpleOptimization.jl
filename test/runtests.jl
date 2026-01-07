const GROUP = get(ENV, "GROUP", "All")

if GROUP == "All"
    include("./regression.jl")
end

if GROUP == "GPU"
    include("./gpu_tests.jl")
end

if GROUP == "JET" || GROUP == "All"
    include("./jet_tests.jl")
end

# Allocation tests run in nopre group (not during precompilation)
if GROUP == "nopre" || GROUP == "All"
    include("./alloc_tests.jl")
end
