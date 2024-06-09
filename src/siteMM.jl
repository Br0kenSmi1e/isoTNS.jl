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
