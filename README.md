# SuiteMarketGet
The successor to [MMGet](https://github.com/CHLOzzz/MMGet); extends MatrixMarket's mmread into fetching from URLs. Meant to work with SuiteSparse Matrix Collection and Matrix Market's links.

# Early Stages
The reason I am updating [MMGet](https://github.com/CHLOzzz/MMGet) is I want to incorporate a memory only feature. Though not significant for small resources and matrices, this has been observed to speed up the time it takes from input (URL) to output (sparse matrix and possible RHS and solution vectors).
Regarding SuiteSparse providing RHS and solution vectors, I also want to offer the option to not require the matrix A.

# What's Currently Working
- Can handle .mat links from [SuiteSparse Matrix Collection](https://sparse.tamu.edu) in HDF5 format for matrix $A$ in memory.
    - Example working code:
        1. `smget("https://suitesparse-collection-website.herokuapp.com/mat/ML_Graph/mnist_test_norm_10NN.mat")`
        2. `smget("https://suitesparse-collection-website.herokuapp.com/mat/Mycielski/mycielskian2.mat")`
        3. `smget("https://suitesparse-collection-website.herokuapp.com/mat/Goodwin/Goodwin_095.mat")`
    - Example code not working:
        1. `smget("https://suitesparse-collection-website.herokuapp.com/mat/HB/1138_bus.mat")`
        2. `smget("https://suitesparse-collection-website.herokuapp.com/RB/TAMU_SmartGridCenter/ACTIVSg2000.tar.gz")`
        3. `smget("https://suitesparse-collection-website.herokuapp.com/MM/Mycielski/mycielskian11.tar.gz")`

# TODO
- Finish `get_suitesparse_memory.jl`
- Finish `get_suitesparse_storage.jl`
- Finish `get_matrix_market_memory.jl`
- Finish `get_matrix_market_storage.jl`