function smget(file_location::String; debug::Bool = false)
    # DEBUG #
    if debug println("Attempting to open as locally stored file...") end
    
    # Assume location is a local path and attempt to open
    try
        data_stream = open(file_location)

    catch e1 # Not a valid local path: Attempt an online fetch
        return smget_online(file_location, e1)

    end # try

    return data_stream

end # smget

function smget_online(file_location::String, e1::SystemError)
    # DEBUG #
    if debug println("Not a local file, attempting to fetch from URL...") end

    # Assume location is an online path and attempt to fetch
    try
        data = HTTP.get(file_location).body

    catch e2 # Not a valid URL or local path: ERROR
        error("Inputted String for 'file_location' isn't detected to be a local path or a URL...", e1, e2)

    end # try

    return data

end # smget_online
