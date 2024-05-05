### This file simply contains the highest level logic to parse the URL and optional arguments.
### Comments are also provided on the higher level decision making.
### I decided to make each function its own file to make my life easier. Staring at 200 lines of code is confusing...

# Import helper files
include("smget/parse_url.jl")
include("smget/get_available_memory.jl")
include("smget/get_file_size.jl")

function smget(url::String; keep_files::Bool = false, want_vec_x::Bool = false, want_vec_b::Bool = false, debug::Bool = false)
    # Initialize variables determining whether memory allows
    file_size = nothing
    available_memory = nothing
    
    # DEBUG: Announce parsing URL
    if debug println("DEBUG: Parsing URL for source and file extension...") end
    
    # Check URL to determine whether it can be handled
    (is_matrix_market, file_extension) = parse_url(url)


    # If user doesn't want to keep files, get file size & available memory (GB)
    if !keep_files
        file_size = get_file_size(url, is_matrix_market)
        available_memory = get_available_memory()

    end

    println(is_matrix_market)
    println(file_extension)
    println(file_size)
    println(available_memory)

end # smget
