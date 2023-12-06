
module EntropyMaximisation

    using Pkg
    using SCS

    export foo3
    export foo2

    include("Utils.jl")
    include("IPFN.jl")
    include("Cone.jl")
    include("MatlabParser.jl")
    include("Gradient.jl")


    # we need exports everywhere

    #using Utils
    #using .IPFN
    #using .Cone
    #using MatlabParser


    foo3() = "geel"

    foo2() = permutations_of_length(2, 5)

    foo4() = distribution_entropy([0.1, 0.2, 0.3, 0.4])



end
