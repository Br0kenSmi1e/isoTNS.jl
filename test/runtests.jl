using isoTNS
using Test

@testset "center_canonicalize" begin
    include("center_canonicalize.jl")
end

@testset "siteMM" begin
    include("siteMM.jl")
end

@testset "columnMM" begin
	include("columnMM.jl")
end
