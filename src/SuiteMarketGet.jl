### This file contains all packages used as well as the basic structure to import as a package.

#module SuiteMarketGet

    # Import packages used across all files
    using CodecZlib
    using HTTP
    using MatrixMarket
    using SparseArrays

    # Import helper files
    include("smget.jl")

    # Export functions
    export smget

#end # module


# Test code
smget("https://math.nist.gov/pub/MatrixMarket2/Harwell-Boeing/psadmit/494_bus.haha.lol")