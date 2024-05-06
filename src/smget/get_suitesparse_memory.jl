### Get matrix from a SuiteSparse URL completely within system memory
### SuiteSparse is known to provide .tar.gz and .mat files
### SuiteSparse may provide multiple files (vec_x & vec_b)

function get_suitesparse_memory(url::String, want_vec_x::Bool, want_vec_b::Bool, file_extension::String, file_size)
    # Handle data depending on file extension
    if file_extension == "tar.gz"
        # TODO

    elseif file_extension == "mat"
        # Fetch download from URL and open an IOBuffer
        data = HTTP.get(url).body
        data_buffer = IOBuffer(data)

        # Handle here if HDF5 can be used
        if occursin("HDF5", read(data_buffer, String))
            # Close data_buffer
            close(data_buffer)

            # Get data for desired matrix
            # TODO Add support for x and b
            h5_file = h5open(HTTP.get(url).body)["Problem/A"]
        
            # Extract data for sparse construction
            data = read(h5_file["data"])
            ir = read(h5_file["ir"], Int) .+ 1
            jc = read(h5_file["jc"], Int) .+ 1

            # Close buffer
            close(h5_file)

            # Get number of rows and columns
            m = maximum(ir)  # Number of rows
            n = length(jc) - 1  # Number of columns

            # Create row index and column index arrays for the sparse matrix
            rows = Int[]
            cols = Int[]

            for col in 1:n
                for idx in jc[col]:jc[col + 1] - 1
                    push!(rows, ir[idx])
                    push!(cols, col)
                end
            end

            # Clear unused variables
            ir = nothing
            jc = nothing

            # Create the sparse matrix
            return sparse(rows, cols, data, m, n)

        end # HDF5 handling

        # TODO add file handling when not HDF5

    else # Unknown file extension...
        error("ERROR: SuiteSparse file extension '", file_extension, "' cannot be handled. A future update is needed...")

    end # File extensions

    # Something should have returned: Cannot handle this link
    error("ERROR: The data cannot be handled! A future update is needed...")

end # get_suitesparse_memory
