using isoTNS
using Test

@testset "siteMM" begin
    include("siteMM.jl")
end

@testset "columnMM" begin
	include("columnMM.jl")
end
