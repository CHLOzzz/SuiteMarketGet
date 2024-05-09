# Before uploading to GitHub...
# Pkg mode "activate ."
# Pkg mode "instantiate"

module SuiteMarketGet
    # Import package dependencies
    using HTTP

    # Import helper files
    include("smget.jl")

    export smget

end # SuiteMarketGet
