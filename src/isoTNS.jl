module isoTNS

using LinearAlgebra, OMEinsum

export TNS, siteMM, columnMM

struct TNS{T} # construction:e.g. TNS(tns,3,3), a 3x3 tensor network state
    tensors::Vector{Array{T,5}}
    rows::Int
    columns::Int
end

include("siteMM.jl")
#include("columnMM.jl")


end
