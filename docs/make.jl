using isoTNS
using Documenter

DocMeta.setdocmeta!(isoTNS, :DocTestSetup, :(using isoTNS); recursive=true)

makedocs(;
    modules=[isoTNS],
    authors="LongliZheng",
    sitename="isoTNS.jl",
    format=Documenter.HTML(;
        canonical="https://LongliZheng.github.io/isoTNS.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LongliZheng/isoTNS.jl",
    devbranch="main",
)
