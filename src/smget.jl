function smget(file_location::String; debug::Bool = false)
    # DEBUG #
    if debug println("Attempting to open as locally stored file...") end
    # DEBUG #

    # Initialize "data_stream" in this scope
    data_stream = nothing
    data = nothing
    
    # Assume location is a local path and attempt to open
    try
        data_stream = open(file_location)
        data = read(data_stream)
        close(data_stream)
        data_stream = nothing

    catch e1 # Not a valid local path: Attempt an online fetch
        return smget_online(file_location, debug, e1)

    end # try

    # Garbage collect
    GC.gc()

    return data

end # smget

function smget_online(file_location::String, debug::Bool, e1::SystemError)
    # DEBUG #
    if debug println("Not a local file, attempting to fetch from URL...") end
    # DEBUG #

    # Initialize "data" in this scope
    data = nothing

    # Assume location is an online path and attempt to fetch
    try
        data = HTTP.get(file_location).body

    catch e2 # Not a valid URL or local path: ERROR
        error("Inputted String for 'file_location' isn't detected to be a local path or a URL...\n\n", e1, e2)

    end # try

    # Clear SystemError; won't be necessary here
    e1 = nothing

    # Garbage collect
    GC.gc()

    return data

end # smget_online
