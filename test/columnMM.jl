using Test, isoTNS, OMEinsum

@testset "columnMM" begin
	t1 = rand(ComplexF64, 2, 2, 2, 1, 2)
	t2 = rand(ComplexF64, 2, 2, 2, 2, 2)
	t3 = rand(ComplexF64, 2, 2, 1, 2, 2)
	C = TNS([t1, t2, t3],3,1)
	A, Q = columnMM(C)
	
	ori = ein"ijkmn,abckd,efgch->jbfndhmg"(t1,t2,t3)
	dec = ein"ijkmo,abckp,efgcq,osnr,ptds,quht->jbfndhmrgu"(A[1],A[2],A[3],Q[1],Q[2],Q[3])
	dec = reshape(dec,2,2,2,2,2,2,1,1)
	
	@test dec ≈ ori
end
