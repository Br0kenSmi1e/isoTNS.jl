module isoTNS

using LinearAlgebra, OMEinsum

export MPS, TNS, center_canonicalize!, siteMM, columnMM

struct MPS{T}
    tensors::Vector{Array{T, 3}}
end

struct TNS{T} # construction:e.g. TNS(tns,3,3), a 3x3 tensor network state
    tensors::Vector{Array{T,5}}
    rows::Int
    columns::Int
end

include("center_canonicalize.jl")
include("siteMM.jl")
include("columnMM.jl")


end
