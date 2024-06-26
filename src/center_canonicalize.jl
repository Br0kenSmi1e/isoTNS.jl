#
#        2
#        |
#   1---(M)---3
#

function center_canonicalize!(mps::MPS, l::Int) # l is the orthogonality center
    for i = 1:l-1 # canonicalize left part
        left, right = mps.tensors[i], mps.tensors[i+1]
        mleft, mright = reshape(left, :, size(left, 3)), reshape(right, size(right, 1), :)
        u, s, v = LinearAlgebra.svd(mleft * mright)
        mps.tensors[i] = reshape(u, size(left, 1), size(left, 2), size(u, 2))
        mps.tensors[i+1] = reshape(Diagonal(s) * v', size(v', 1), size(right, 2), size(right, 3))
    end

    for i = length(mps.tensors)-1:-1:l
        left, right = mps.tensors[i], mps.tensors[i+1]
        mleft, mright = reshape(left, :, size(left, 3)), reshape(right, size(right, 1), :)
        u, s, v = LinearAlgebra.svd(mleft * mright)
        mps.tensors[i] = reshape(u * Diagonal(s), size(left, 1), size(left, 2), size(u, 2))
        mps.tensors[i+1] = reshape(v', size(v', 1), size(right, 2), size(right, 3))
    end
    return mps
end
