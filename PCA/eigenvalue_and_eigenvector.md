## Key Concepts

### ```Av = λv```

- ```A``` is a square matrix, ```v``` is an eigenvector, and ```λ``` is an eigenvalue.
- ```Av``` is pronounced as: multiplying ```v``` by ```A```.
- Almost all vectors change direction when they are multiplied by ```A```. However, certain exceptional vectors ```v``` that does not change direction when multiplied by ```A``` (a linear transformation), and the vector ```Av``` is a number (```λ```) times the original ```v```.
- "eigen" means "own", "proper", "characteristic"
- Reference: <a href="https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix">Eigendecomposition of a matrix</a>

<hr>

### ```AQ = QΛ``` and ```A = QΛQ^-1```

- ```Q``` is the square n × n matrix whose ith column is the eigenvector ```v_i``` of ```A```
- ```Λ``` is the diagonal matrix whose diagonal elements are the corresponding eigenvalues, ```Λ_ii = λ_i```
- This can be used to reconstruct the original matrix

<hr>

### ```A``` can be viewed as a linear transformation

Importantly, ```Q``` and ```Λ``` <b>can be viewed as the characteristics of such a transformation</b> in terms of vectors/directions and stretch/shrink magnitudes, respectively.

For example: after <b><i>Ax</i></b>, the original dashed box <b><i>x</i></b> is transformed (a) along the direction of ```v1``` by a magnitude of ```λ1```, and also (b) along the direction of ```v2``` by a magnitude of ```λ2```.

<p align="center"><img src="./images/eigenvalue_eigenvector_as_characteristics_of_A.png" width="800px"><br/></p>

<hr>

### To find eigenvalues and eigenvectors of a matrix <a href="http://math.mit.edu/~gs/linearalgebra/ila0601.pdf">by hand</a>

To derive ```v``` and ```λ```, given ```A```:
```
Av - λv = 0
(A - λ·I)v = 0
If v is non-zero, the equation will only have a solution if |A - λ·I| = 0
By solving |A - λ·I| = 0, we can obtain λ
Finally, using λ, we can obtain the corresponding v
```

For example:
<p align="center"><img src="./images/eigenvalue_eigenvector_by_hand.png" width="700px"></p>

<hr>

## Code Examples

### Clojure:
```Clojure
user=> (def A (matrix [[-6 3] [4 5]]))
#'user/A

user=> (decomp-eigenvalue A)
{:values (-7.0 6.0), :vectors [-0.9487 -0.2433
 0.3162 -0.9730]
}

;; Av = λv
user=> (mmult X (sel (:vectors (decomp-eigenvalue X)) :cols 1)) ;; Av
[-1.4595
-5.8381]

user=> (mult 6 (sel (:vectors (decomp-eigenvalue X)) :cols 1)) ;; λv, λ = 6
[-1.4595
-5.8381]
```

<hr>

### Python:
```Python
>>> import numpy as np
>>> from scipy.linalg import eig
>>> from numpy import diag
>>> A = np.array([[-6,3],[4,5]])
>>> eigenvalues, eigenvectors = eig(A)
>>> eigenvalues  ;; λ
array([-7.+0.j,  6.+0.j])

>>> eigenvectors  ;; v
array([[-0.9486833 , -0.24253563],
       [ 0.31622777, -0.9701425 ]])
       
>>> Q = eigenvectors
>>> L = diag(eigenvalues)
>>> Q.dot(L).dot(inv(Q))  ;; reconstruct A = QΛQ^-1
array([[-6.+0.j,  3.+0.j],
       [ 4.+0.j,  5.+0.j]])
```

<hr>

### R:
```R
> A <- matrix(c(-6, 3, 4, 5), 2, 2, byrow = T)

> A
     [,1] [,2]
[1,]   -6    3
[2,]    4    5

> eigen(A)
eigen() decomposition
$values
[1] -7  6

$vectors
           [,1]       [,2]
[1,] -0.9486833 -0.2425356
[2,]  0.3162278 -0.9701425
```
