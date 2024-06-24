

# isoTNS

## Canonical Matrix Product State (MPS)

Isometric Tensor Network State (isoTNS) is a generalization of canonical Matrix Product State (MPS).
For one-dimensional systems, their states can be written into an one-dimensional tensor network, namely, MPS.

<!-- a figure of MPS -->

Through SVD decomposition, any MPS can be turned to its canonical form with center $\ell$,
which is convenient for us to calculate site- $\ell$ expectation value.
Also, the center of canonical MPS can be moved to any site through a series of SVD decomposition.

## Isometry
Isometry is a property of maps.
Consider a map $A$ from Hilbert space $\mathcal{H}_1$ to Hilbert space $\mathcal{H}_2$ and its Hermitian conjugation $A^\dagger$.
$$
A:\mathcal{H}_1\to\mathcal{H}_2,\quad A^\dagger:\mathcal{H}_2\to\mathcal{H}_1
$$
If $A$ satisfies the following two conditions
$$
A^\dagger A=I_2,
$$
$$
AA^\dagger=P_1,
$$
then $A$ is a left isometric map,
where $I_2$ is the identity of Hilbert space $\mathcal{H}_2$ and $P_1$ is a projection operator of Hilbert space $\mathcal{H}_1$.




[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LongliZheng.github.io/isoTNS.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LongliZheng.github.io/isoTNS.jl/dev/)
[![Build Status](https://github.com/LongliZheng/isoTNS.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LongliZheng/isoTNS.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LongliZheng/isoTNS.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LongliZheng/isoTNS.jl)

