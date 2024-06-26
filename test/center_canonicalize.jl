using Test, isoTNS, OMEinsum

@testset "center_canonicalize" begin
	t1 = rand(ComplexF64,1,2,2)
	t2 = rand(ComplexF64,2,2,2)
	t3 = rand(ComplexF64,2,2,1)
	A = MPS([t1,t2,t3])
	C = center_canonicalize!(A,2)
	ori = ein"abc,cde,efg->abdfg"(t1,t2,t3)
	can = ein"abc,cde,efg->abdfg"(A.tensors[1],A.tensors[2],A.tensors[3])
	@test ori ≈ can
end
