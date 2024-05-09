### File containing the exported function "smget.jl"
### Code here determines how to fetch the data - local file or online source

# Include helper files
include("smget/get_online_extension.jl")
include("smget/parse_data.jl")
include("smget/read_mat.jl")
include("smget/repurposed_MAT.jl")
include("smget/repurposed_MAT_HDF5.jl")
include("smget/repurposed_MAT_v4.jl")
include("smget/repurposed_MAT_v5.jl")

function smget(file_location::String; debug::Bool = false, keep_files::Bool = false)
    # DEBUG #
    if debug println("Attempting to open as locally stored file...") end
    # DEBUG #

    # Initialize "data_stream" in this scope
    data_stream = nothing
    
    # Assume location is a local path and attempt to open
    try
        data_stream = open(file_location)

    catch e1 # Not a valid local path: Attempt an online fetch
        return smget_online(file_location, debug, keep_files, e1)

    end # try

    # Return sparse array after "deeper" files construct it
    return parse_data(data_stream, file_location, debug)

end # smget

function smget_online(file_location::String, debug::Bool, keep_files::Bool, e1::SystemError)
    # DEBUG #
    if debug println("Not a local file, attempting to fetch from URL...") end
    # DEBUG #

    # Initialize "data" in this scope
    data_http = nothing

    # Assume location is an online path and attempt to fetch
    try
        data_http = HTTP.get(file_location)

    catch e2 # Not a valid URL or local path: ERROR
        error("Inputted String for 'file_location' isn't detected to be a local path or a URL...\n\n", e1, e2)

    end # try

    # Clear SystemError; won't be necessary here
    e1 = nothing

    # Return sparse array after "deeper" files construct it
    return parse_data(data_http, file_location, debug, keep_files)

end # smget_online
