using Test, isoTNS, OMEinsum

@testset "columnMM" begin
	t1 = rand(ComplexF64, 2, 2, 2, 1, 2)
	t2 = rand(ComplexF64, 2, 2, 2, 2, 2)
	t3 = rand(ComplexF64, 2, 2, 1, 2, 2)
	C = TNS([t1, t2, t3],3,1)
	A, Q = columnMM(C)
	Psi = Vector{Array}(undef,0)
	for i in 1:3
		Phi = ein"ijkms,slnt->ijklmtn"(A[i],Q[i])
		Phi = reshape(Phi,size(Phi,1),size(Phi,2),size(Phi,3)*size(Phi,4),size(Phi,5)*size(Phi,6),size(Phi,7))
		push!(Psi,Phi)
	end
	@test TNS(Psi,3,1) ≈ C
end
