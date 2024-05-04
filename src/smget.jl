### This file simply contains the highest level logic to parse the URL and optional arguments.
### Comments are also provided on the higher level decision making.
### I decided to make each function its own file to make my life easier. Staring at 200 lines of code is confusing...

# Import helper files
include("parse_url.jl")

function smget(url::String; keep_files::Bool = false, want_vec_x::Bool = false, want_vec_b::Bool = false, debug::Bool = false)
    # DEBUG: Announce parsing URL
    if debug println("DEBUG: Parsing URL for source and file extension...") end
    
    # Check URL to determine whether it can be handled
    (is_matrix_market, file_extension) = parse_url(url)

    println(is_matrix_market)
    println(file_extension)

end # smget
