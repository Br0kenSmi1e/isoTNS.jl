module isoTNS

using LinearAlgebra, OMEinsum

export TNS, siteMM, left_columnMM

struct TNS{T} # construction:e.g. TNS(tns,3,3), a 3x3 tensor network state
    tensors::Vector{Array{T,5}}
    rows::Int
    columns::Int
end


function siteMM(tensor::Array{ComplexF64, 6}, chi::Int)
    # one prepared tensor ready for MM in 2 2D-TNS has 6 legs, 1 physical leg & 5 ancilla legs, to be specific
    # for the order of these legs, [i,j,k,l,m,n], 
    # *i* is the physical leg, *j* is the ancilla leg connecting to the left neighbour, *k* is the leg denoted *a*
    # these three legs all connected to tensor *A* after decomposition
    # *l* and *m* stands for *b* and *c*
    # *n* is the ancilla leg connecting the right neighbour
    #       m
    #       |
    # j---(Psi)---n
    #      / \
    #     k   l
    # *i* is the physical leg, **Psi:[i,j,k,l,m,n]**

    # *chi* is the bond dim of s_L and s_R.

    # this part is to decompose *Psi* to *A* and *Theta*
    Psi = reshape(tensor,size(tensor,1)*size(tensor,2)*size(tensor,3),:) # (ijk),(lmn)
    A, s, Theta = LinearAlgebra.svd(Psi)

    A = reshape(A, size(tensor,1),size(tensor,2),size(tensor,3),:,chi) # i,j,k,s_L,s_R
    Theta = reshape(Diagonal(s)*Theta', :,chi, size(tensor, 4), size(tensor, 5), size(tensor, 6)) # sL sR l m n
    Theta = permutedims(Theta,(1,4,2,3,5)) # sL m sR l n

    T = reshape(Theta,size(Theta,1)*size(Theta,2),:) # reshape to (s_L,m),(S_R,l,n)
    T = permutedims(T,(2,1)) # reshape to (S_R,l,n),(s_L,m)
    Q,t,Phi = LinearAlgebra.svd(T)
    Q = reshape(Q,chi,size(tensor,4),size(tensor,6),:) # s_R, l, n, t
    Phi = reshape(Diagonal(t)*Phi',:,size(Theta,1),size(tensor,5)) # t, s_L, m
    #             m
    #             |
    #           (Phi)
    #          sL/ \t
    #           /   \
    #     j---(A)---(Q)---n
    #          |  sR |
    #          k     l
    #
    # **A:[i,j,k,sL,sR]**, *i* is the physical leg, attached to tensor *A*
    # **Q:[sR,l,n,t]**
    # **Phi:[t,sL,m]**

    return A,Q,Phi

end

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

function upperrightMM!(tns::TNS)
    for i in 1:tns.columns-1
        iCOL = TNS(tns.tensors[tns.rows*(i-1)+1:tns.rows*i],tns.rows,1)
        A, L = left_columnMM(iCOL)
        for j in 1:tns.rows
            tns.tensors[tns.rows*(i-1)+j] = A[j]
            
            Psi = ein"sljt,ijkmn->islktmn"(L[j],tns.tensors[tns.rows*(i)+j])
            Psi = reshape(Psi,size(Psi,1),size(Psi,2),size(Psi,3)*size(Psi,4),size(Psi,5)*size(Psi,6),size(Psi,7))
            tns.tensors[tns.rows*(i)+j] = Psi
        end
    end
    return tns
end

end
