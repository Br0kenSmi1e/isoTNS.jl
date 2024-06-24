using Test, isoTNS, OMEinsum

@testset "columnMM" begin
	t1 = rand(ComplexF64, 2, 2, 2, 1, 2)
	t2 = rand(ComplexF64, 2, 2, 2, 2, 2)
	t3 = rand(ComplexF64, 2, 2, 1, 2, 2)
	C = TNS([t1, t2, t3],3,1)
	A, Q = columnMM(C)
	
	ori = ein"ijkmn,abckd,efgch->iaejbfndhmg"(t1,t2,t3)
	dec = ein"ijkmo,abckp,efgcq,osnr,ptds,quht->iaejbfndhmgru"(A[3],A[2],A[1],Q[3],Q[2],Q[1])
	dec = reshape(dec,size(dec,1),size(dec,2),size(dec,3),size(dec,4),size(dec,5),size(dec,6),size(dec,7),size(dec,8),size(dec,9),1,1)
	
	@test dec ≈ ori
end
