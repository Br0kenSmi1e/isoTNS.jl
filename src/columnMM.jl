function left_columnMM(col::TNS)
    # from bottom to the top
    # 
    #        m
    #        ^
    #        |
    #  j--->(A)--->n
    #        ^
    #        |
    #        k
    #
    # **A:[i,j,k,m,n]**, *i* is the physical leg

    isoCOL = Vector{Array}(undef,0)
    anciCOL = Vector{Array}(undef,0)
    Psi = reshape(col.tensors[col.rows],size(col.tensors[col.rows],1),size(col.tensors[col.rows],2),1,size(col.tensors[col.rows],3),size(col.tensors[col.rows],4),size(col.tensors[col.rows],5))
    for i = col.rows:-1:2
        A, Q, Phi = siteMM(Psi,size(col.tensors[i],2))
        Psi = einsum(EinCode((('i','j','k','m','n'),('t','s','k')),('i','j','s','t','m','n')),(col.tensors[i-1],Phi))
        push!(isoCOL,A)
        push!(anciCOL,Q)
    end
    Psi = permutedims(Psi,(1,2,3,5,4,6)) # i j s m , t n
    PsiM = reshape(Psi,size(Psi,1)*size(Psi,2)*size(Psi,3)*size(Psi,4),:)
    A, S, V = LinearAlgebra.svd(PsiM)
    A = reshape(A,size(Psi,1),size(Psi,2),size(Psi,3),size(Psi,4),:)
    push!(isoCOL,A)
    Q = reshape(Diagonal(S)*V',:,size(Psi,5),size(Psi,6),1)
    push!(anciCOL,Q)
    return isoCOL, anciCOL
end
