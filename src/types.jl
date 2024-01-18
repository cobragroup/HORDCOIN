# types.jl:

struct EMResult
    entropy::Float64
    joined_probability::Array{T} where T <: Real
end
EMResult(joined_probability::Array{T}) where T <: Real = 
    EMResult(distribution_entropy(joined_probability), joined_probability)
Base.show(io::IO, result::EMResult) = 
    print(io, "Entropy: ", result.entropy, "\nDistribution:\n", result.joined_probability)


abstract type AbstractMethod end

struct Cone <: AbstractMethod
    optimizer::MathOptInterface.AbstractOptimizer
end
Cone() = Cone(SCS.Optimizer())

struct Gradient <: AbstractMethod
    iterations::Int
    optimizer::MathOptInterface.AbstractOptimizer
end
Gradient() = Gradient(10, SCS.Optimizer())
Gradient(iterations::Int) = Gradient(iterations, SCS.Optimizer())

struct Ipfp <: AbstractMethod
    iterations::Int
end
Ipfp() = Ipfp(10)    
