const GROUP = get(ENV, "GROUP", "All")

if GROUP == "All"
    include("./regression.jl")
end

if GROUP == "GPU"
    include("./gpu_tests.jl")
end
