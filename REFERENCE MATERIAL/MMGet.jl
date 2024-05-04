using CodecZlib
using HTTP

### Helper functions

## Get size of download and double it (for decompression)
## Used to determine whether or not to do all operations within memory
function fetch_file_size(url::String)
    
    # Try getting size of download
    try
        url_head = HTTP.head(url)

        # Find "content-length"
        for header in url_head.headers

            # Found "content-length" in KB; return doubled in GB
            if header.first == "content-length"
                # Math simplified for efficiency
                return parse(Int, header.second) / 500000

            end

        end

        # "content-length" not found & no errors
        # File could still be downloadable; handle with storage
        return -1

    catch e
        error("ERROR: HTTP failed to read URL; it may be invalid! Stacktrace given below:\n", e)

    end

end # fetch_file_size

## Get free memory in GB dependent on OS
## Used to determine whether or not to do all operations within memory
function get_free_memory()

    if Sys.iswindows() # User is on Windows
        mem_info = read(`wmic OS get FreePhysicalMemory /Value`, String)
        mem_kb = parse(Int, split(mem_info, '=')[2])
        # Math simplified for efficiency
        mem_gb = mem_kb / 1048576

    elseif Sys.islinux() # !!!NEEDS TESTING!!!
        mem_info = read(`free -m`, String)
        mem_lines = split(mem_info, '\n')
        mem_parts = split(mem_lines[2])
        mem_gb = parse(Int, mem_parts[4]) / 1024

    elseif Sys.isapple() # !!!NEEDS TESTING!!!
        mem_info = read(`vm_stat`, String)
        mem_lines = split(mem_info, '\n')
        free_line = filter(s -> occursin("Pages free", s), mem_lines)[1]
        mem_free = parse(Int, split(free_line)[3])
        page_size = 4096  # macOS uses 4096 bytes per memory page
        mem_bytes = mem_free * page_size
        # Math simplified for efficiency
        mem_gb = mem_bytes / 1073741824

    else # Unknown OS: Don't attempt memory only operations
        return -1

    end

    return mem_gb

end # get_free_memory

## Checks if URL can be handled
function is_url_valid(url::String)
    # File extensions known how to be handled
    known_extensions = [
        ".mtx.gz", ".rua.gz", ".cua.gz", ".tar.gz", ".mat", ".psa.gz", ".rsa.gz", ".pra.gz"
        ]

        # Check if URL is valid
        return any(endswith(url, ext) for ext in known_extensions)

end # is_url_valid

## Helper function to matrix_market_parse(url::String)
## Constructs sparse array from Matrix Market .mtx.gz URL
function matrix_market_mtxgz_memory(url::String)
    # Initialize matrix or vector Bool
    isMatrix = false

    # Initialize complex or real data type variable
    num_type = Float64

    # Obtain data & store into String array
    data = HTTP.get(url).body
    buffer = IOBuffer(data)
    data = nothing
    stream = GzipDecompressorStream(buffer)
    matrix_string = read(stream, String)
    close(buffer)
    close(stream)
    matrix_string = split(matrix_string, '\n')

    # Determine whether to treat as a "matrix" or a "vector", and "real" or "complex"
    for line in matrix_string
        # Skip junk lines
        length(line) == 0 && continue
        startswith(line, "% ") && continue

        # Determine whether matrix is real or complex
        if startswith(line, "%%")
            if "complex" in split(line)
                num_type = ComplexF64

            end

            continue

        end

        # Determine matrix or vector
        # First non-junk line should give sparse info...
        if length(split(line)) == 3
            isMatrix = true

        end

        break

    end

    # Parse matrix or vector, depending
    if isMatrix
        # Initialize sparse variables for SparseArrays.sparse(I,J,V)
        I = Int[]
        J = Int[]
        V = num_type[]

        # Construct I, J, V
        for line in matrix_string
            # Skip junk lines
            length(line) == 0 && continue
            line[1] == '%' && continue

            # Iterate through data
            (si,sj,sv) = split(line)
            local i = parse(Int, si)
            local j = parse(Int, sj)
            local v = parse(num_type, sv)
            push!(I, i)
            push!(J, j)
            push!(V, v)
        end

        # Return constructed sparse "matrix"
        return sparse(I, J, V)

    else
        # Initialize sparse variable for SparseArrays.sparse(V)
        V = num_type[]

        # Contrust V
        for line in matrix_string
            # Skip junk lines
            length(line) == 0 && continue
            length(split(line)) == 2 && continue
            line[1] == '%' && continue

            # Iterate through data
            local v = parse(num_type, line)
            push!(V, v)
        end

        # Return constructed sparse "vector"
        return sparse(V)

    end

end # matrix_market_mtxgz_memory

## Parses data from URL assumed to be in format similar to Matrix Market
function matrix_market_parse_memory(url::String)

    # Check format
    if endswith(url, ".mtx.gz")
        return matrix_market_mtxgz_memory(url)

    end

end # matrix_market_parse_memory

### Exported functions

## Given URL presumed to download a matrix, return the sparse data
function mmget(url::String; debug::Bool = false)

    # Check if URL is valid
    if !is_url_valid(url)

        # Weird indenting for aesthetic output
        error("ERROR: Provided URL suggests downloaded file cannot be handled with this code.
       Please provide a URL ending in one of the following:
       '.tar.gz', '.mtx.gz', '.rua.gz', '.cua.gz', '.mat', '.psa.gz', '.rsa.gz', '.pra.gz'")
    end

    # Get free memory
    free_mem_gb = get_free_memory()

    # Get size of download
    size_gb = fetch_file_size(url)

    # If statement determing how to handle matrix
    if free_mem_gb > 0 && size_gb > 0 && free_mem_gb > size_gb # In memory

        # Clear variables to maximize memory
        free_mem_gb = nothing
        size_gb = nothing

        url_vec = split(url, '/')

        # Handle suitesparse URL
        if "suitesparse-collection-website" in url_vec
            # 

        else # Handle format assumed to be similar to Matrix Market
            return matrix_market_parse_memory(url)

        end

    else # In storage
        # Handle in storage

    end

end # mmget

mmget("https://math.nist.gov/pub/MatrixMarket2/NEP/mhd/mhd1280a.mtx.gz")

### CHECKLIST TO KEEP TRACK OF PROGRESS
# Matrix Market URLs ending with ".mtx.gz" are fully handled in memory

### TODO
# Probably should plan to clean up the code into an official project before continuing...
# Handle Matrix Market URLs ending with ".mtx.gz" are fully handled in storage