### Package to allow for reading matrices both locally and from online repositories
### The repositories that will be targeted are:
### - SuiteSparse Matrix Collection
### - Matrix Market
# Before uploading to GitHub...
# Pkg mode "activate ."
# Pkg mode "instantiate"

module SuiteMarketGet
    # Import package dependencies
    using HTTP
    using MAT

    # Import helper files
    include("smget.jl")

    export smget

end # SuiteMarketGet
