### Code here determines how to read in the file
### Goal is to return SparseArray objects

## Data is already locally stored
function parse_data(data_stream::IOStream, file_location::String, debug::Bool)
    # Obtain file extension, made easy with guarenteed valid file path
    _, file_extension = splitext(file_location)
    file_extension = lowercase(file_extension)

    # If .mat file, use MAT package to return SparseArray
    if file_extension == ".mat"
        # DEBUG #
        if debug println("File is '.mat'. Garbage collect before obtaining matrix...") end
        # DEBUG #

        # Close stream, clear variables, garbage collect
        close(data_stream)
        data_stream = nothing
        file_extension = nothing
        GC.gc()

        # DEBUG #
        if debug println("Opening MAT stream...") end
        # DEBUG #

        # Open stream to mat file
        mat_stream = matopen(file_location)

        # DEBUG #
        if debug println("Reading MAT stream...") end
        # DEBUG #

        # Obtain matrix
        toReturn = read(mat_stream)["Problem"]["A"]

        # DEBUG #
        if debug println("Final garbage collection, then returning...") end
        # DEBUG #

        # Close stream, clear variables, garbage collect
        close(mat_stream)
        debug = nothing
        file_location = nothing
        mat_stream = nothing
        GC.gc()

        # Return matrix A
        return toReturn

    end # if

    error("Local file type not yet handleable...")

end

## Data was fetched from an online source
function parse_data(data_http::HTTP.Messages.Response, file_location::String, debug::Bool, keep_data::Bool)
    # DEBUG #
    if debug println("Attempting to determine file type from URL or response headers...") end
    # DEBUG #

    # Obtain file extension
    file_extension = get_online_extension(data_http, file_location)
    
    println(file_extension)

end
