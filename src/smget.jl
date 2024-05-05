### This file simply contains the highest level logic to parse the URL and optional arguments.
### Comments are also provided on the higher level decision making.
### I decided to make each function its own file to make my life easier. Staring at 200 lines of code is confusing...

# Import helper files
include("smget/parse_url.jl")
include("smget/get_available_memory.jl")
include("smget/get_file_size.jl")

function smget(url::String; keep_files::Bool = false, want_vec_x::Bool = false, want_vec_b::Bool = false, debug::Bool = false)
    # Initialize variables determining whether memory allows
    file_size = -1
    available_memory = -1
    memory_allows = false
    
    # Check URL to determine whether it can be handled
    (is_matrix_market, file_extension) = parse_url(url)


    # If user doesn't want to keep files, get file size & available memory (GB)
    if !keep_files
        file_size = get_file_size(url)
        available_memory = get_available_memory()

        # Determine if working in memory is feasible
        if file_size > 0 && available_memory > 0 && available_memory - file_size > 0
            memory_allows = true

        end

    end

    # Get matrix / matrices
    if is_matrix_market
        if memory_allows # Matrix Market in memory
            #

        else # Matrix Market in storage
            #

        end

    else
        if memory_allows # SuiteSparse in memory
            #

        else # SuiteSparse in storage
            #

        end

    end



    println(is_matrix_market)
    println(file_extension)
    println(file_size)
    println(available_memory)
    println(memory_allows)

end # smget
