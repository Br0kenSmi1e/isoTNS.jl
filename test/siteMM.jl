using Test, isoTNS, OMEinsum

@testset "siteMM" begin
	P = rand(ComplexF64,2,2,2,2,2,2)
	u, v, s = siteMM(P,2)
	P_deco = einsum(EinCode( ( ('i','j','k','a','b') , ('b','l','n','t') ,  ('t','a','m') ), ('i','j','k','l','m','n') ),(u,v,s))
	@test P_deco ≈ P
end
