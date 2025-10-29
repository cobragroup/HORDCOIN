# EntropyMaximisation.jl

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/B0B36JUL-FinalProjects-2023/Projekt_Kislinger/blob/main/LICENSE)

EntropyMaximisation provides methods for finding probability distributions with maximal Shannon entropy given a fixed marginal distribution or entropy up to a chosen order, and to compute the Connected Information. The package allows the selection of different optimisers.

This project was created as a part of the bachelor's thesis "Connected Information from Given Entropies" at the Faculty of Electrical Engineering, Czech Technical University in Prague, and of the paper "COIN: Connected Information Approximation Using Entropic Constraints". See the section [How to cite](#how-to-cite) to cite it appropriately.

The package implements the following methods to maximise the entropy with marginal constraints:
- Exponential Cone Programming (with different solvers)
- Iterative Proportional Fitting Procedure
- Projected Gradient Descent

To maximize entropy while satisfying entropic constraints, the package employs a polymatroid approximation; refer to the paper for details.
In case of undersampled distributions, it is possible to use a built-in small sample correction for the values of entropy instead of the plug-in estimator.


## Installation
The package is not registered, but can be installed in the following way:
```julia
pkg> add https://github.com/cobragroup/EntropyMaximisation.git
```

## Usage
The primary functionality of this package is to implement methods that maximize the Shannon entropy of a probability distribution with marginal distribution or entropic constraints.

The input data must satisfy the following requirements:
- The probability distributions are stored as multidimensional arrays;
- Probabilities are non-negative and sum up to 1 (triggers the fixed marginal distributions);
- OR are provided as non-normalised counts (triggers the fixed marginal entropy)
- The order of the fixed marginal distributions has to be in [2, n-1], where n is the number of dimensions of the probability distribution.

The two main functions are: `maximise_entropy` for marginal constraints and its sibling `max_ent_fixed_ent_unnormalized` for the entropic constraints. `maximise_entropy` takes as an input a probability distribution and the order of marginal distributions to constrain. The optimiser is an optional parameter that can have further specified parameters (such as the number of iterations, etc.). The function returns the probability distribution with maximal entropy in the form of `EMResult`.
`max_ent_fixed_ent_unnormalized` takes a multidimensional array of counts and the order up to which the marginal entropies must be fixed. It allows the selection of the plug-in estimator for the entropies or the corrected one. It's possible to pass a precomputed dictionary of entropies to speed up the computation.

Basic usage of the function is the following:
```julia
using EntropyMaximisation

probability_distribution = [1/16; 3/16;; 3/16; 1/16;;; 1/16; 3/16;; 3/16; 1/16]
marginal_size = 2
maximise_entropy(probability_distribution, marginal_size)
```
Running the code with the optional parameter `method`:
```julia
maximise_entropy(probability_distribution, marginal_size; method = Gradient(10, SCS.Optimizer()))
```

The third function is `connected_information` that uses the results from the previous two to compute the Connected Information. It takes as input the probability distribution or the counts (selecting which one of the previous functions to use under the hood), along with the desired orders of Connected Information. When computing multiple Connected Information values for the same probability distribution, it is possible to pass the sizes as an array. This will speed up the process by chaining the computations, thereby reducing the number of maximizations. Furthermore, the method used to compute the maximum entropy can also be selected.

Basic usage of `connected_information` is the following:
```julia
connected_information(probability_distribution, 2)
connected_information(probability_distribution, [2, 3])
```
With optional parameters:
```julia
connected_information(probability_distribution, 2; method = Ipfp(15))
connected_information(probability_distribution, [2, 3]; method = Cone(MosekTools.Optimizer()))
```

The package also contains two utility functions. `distribution_entropy` computes the information entropy of a probability distribution. `permutations_of_length` returns all permutations of a given size from elements from 1 to dims. 

Usage of the functions:
```julia
distribution_entropy(probability_distribution)
permutations_of_length(3, 4)
```


## Recommendations

The most efficient method when computing with fixed marginal distributions is the `Cone` method with `MosekTools.Optimizer()`. This requires a license to use the MOSEK solver. Without the license, it is possible to use `SCS.Optimizer()` instead, but it is less accurate and slower.

Without a MOSEK license, use the `Ipfp` method. It is accurate and not the slowest. It can also be parametrized with the number of iterations, but it is not necessary. The default value is 10.

The `Gradient` method is the slowest and may fail during execution due to limitations of Second Order Cone constraints in solvers.

When computing with fixed entropies and a small number of samples, the recommended method is the `GPolymatroid` with `MosekTools.Optimizer()`. When the distribution is sampled enough, you can use `RawPolymatroid` to estimate the entropy with the plug-in estimator. More information can be found in the paper.

## How to cite

If you use this code for a scientific publication, please cite:

> Tani Raffaelli G., Kislinger J., Kroupa T., and Hlinka J., "COIN: Connected Information Approximation Using Entropic Constraints"
