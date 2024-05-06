### This file contains all packages used as well as the basic structure to import as a package.

#module SuiteMarketGet

    # Import packages used across all files
    using CodecZlib
    using HDF5
    using HTTP
    using MatrixMarket
    using SparseArrays

    # Include files with exported functions
    include("smget.jl")

    # Export functions
    export smget

#end # module


# Test code
#smget("https://suitesparse-collection-website.herokuapp.com/mat/Mycielski/mycielskian2.mat")
#smget("https://suitesparse-collection-website.herokuapp.com/mat/ML_Graph/mnist_test_norm_10NN.mat")
#smget("https://suitesparse-collection-website.herokuapp.com/mat/Goodwin/Goodwin_095.mat")

# Cases of code not working for testing "get_suitesparse_memory.jl"
smget("https://suitesparse-collection-website.herokuapp.com/mat/HB/1138_bus.mat")
