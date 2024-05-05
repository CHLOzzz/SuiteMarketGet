### Parse the URL to ensure it can be handled, and how it should be handled

function parse_url(url::String)
    # Initilize return variables in this scope
    is_matrix_market = false
    file_extension = nothing
    
    # Determine whether URL is Matrix Market or SuiteSparse
    if occursin("math.nist.gov/pub/MatrixMarket", url) # Matrix Market
        is_matrix_market = true

        # Matrix Market always has 2 part extensions: Get file extension
        string_array = split(url, '.')
        file_extension = string_array[end - 1] * "." * string_array[end]

    elseif occursin("suitesparse-collection-website.herokuapp.com", url) # Not Matrix Market nor SuiteSparse
        # Get file extension for SuireSparse URLs
        if endswith(url, ".mat") # MATLAB format
            file_extension = "mat"

        elseif endswith(url, ".tar.gz") # Rutherford Boeing or Matrix Market format
            file_extension = "tar.gz"

        end
         
    else # URL not detected to be Matrix Market or SuiteSparse: Throw error
        mm_url = "https://math.nist.gov/MatrixMarket/"
        ss_url = "https://sparse.tamu.edu"
        mm_name = "Matrix Market"
        ss_name = "SuiteSparse Matrix collection"
        readme_url = "https://github.com/CHLOzzz/SuiteMarketGet.jl/blob/main/README.md"
        readme_name = "README.md"
        error("ERROR: URL not detected to be from \e]8;;$mm_url\a$mm_name\e]8;;\a nor \e]8;;$ss_url\a$ss_name\e]8;;\a!
              Please see \e]8;;$readme_url\a$readme_name\e]8;;\a for instructions...")

    end

    # Return parsed information
    return (is_matrix_market, file_extension)

end # parse_url
