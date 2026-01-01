using SimpleOptimization
using Documenter

DocMeta.setdocmeta!(SimpleOptimization, :DocTestSetup, :(using SimpleOptimization); recursive = true)

makedocs(;
    modules = [SimpleOptimization],
    authors = "Utkarsh <rajpututkarsh530@gmail.com>",
    repo = "https://github.com/SciML/SimpleOptimization.jl/blob/{commit}{path}#{line}",
    sitename = "SimpleOptimization.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://SciML.github.io/SimpleOptimization.jl",
        edit_link = "main",
        assets = String[]
    ),
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(;
    repo = "github.com/SciML/SimpleOptimization.jl",
    devbranch = "main"
)
