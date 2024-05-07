### Get matrix from a SuiteSparse URL completely within system memory
### SuiteSparse is known to provide .tar.gz and .mat files
### SuiteSparse may provide multiple files (vec_x & vec_b)
### SuiteSparse's earliest file in 1970 runs on MAT version 5, more recent files are in HDF5

function get_suitesparse_memory(url::String, file_extension::String)
    # Handle data depending on file extension
    if file_extension == "tar.gz"
        # TODO

    elseif file_extension == "mat"
        # Clear variables no longer needed
        file_extension = nothing

        # Fetch download from URL and open an IOBuffer
        data = HTTP.get(url).body
        data_buffer = IOBuffer(data)

        # Handle here if HDF5 can be used
        if occursin("HDF5", read(data_buffer, String))
            return read_MAT_HDF5(data, data_buffer)

        end # HDF5 handling

        # If not HDF5, guaranteed to be MAT v5
        return read_MAT_v5(data, data_buffer)

    else # Unknown file extension...
        error("ERROR: SuiteSparse file extension '", file_extension, "' cannot be handled. A future update is needed...")

    end # File extensions

    # Something should have returned: Cannot handle this link
    error("ERROR: The data cannot be handled! A future update is needed...")

end # get_suitesparse_memory
