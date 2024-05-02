# SuiteMarketGet
The successor to [MMGet](https://github.com/CHLOzzz/MMGet); extends MatrixMarket's mmread into fetching from URLs. Meant to work with SuiteSparse Matrix Collection and Matrix Market's links.

# Early Stages
The reason I am updating [MMGet](https://github.com/CHLOzzz/MMGet) is I want to incorporate a memory only feature. Though not significant for small resources and matrices, this has been observed to speed up the time it takes from input (URL) to output (sparse matrix and possible RHS and solution vectors).
Regarding SuiteSparse providing RHS and solution vectors, I also want to offer the option to not require the matrix A.

# TODO
- Start the project
