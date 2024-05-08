### Read .mat files in HDF5 format

## Override for when input is IOBuffer; handling in memory
function read_MAT_HDF5(data::Vector{T}, data_buffer::IOBuffer) where T <: Unsigned
    # Close the data buffer: HDF5 provides a better buffer
    close(data_buffer)
    data_buffer = nothing

    # Garbage collect
    GC.gc()

    # Open HDF5 buffer of data
    h5_buffer = h5open(data)["Problem/A"]

    # Extract data for sparse construction
    data = read(h5_buffer["data"])
    ir = read(h5_buffer["ir"]) .+ 1
    jc = read(h5_buffer["jc"]) .+ 1

    # Close h5 buffer
    close(h5_buffer)
    h5_buffer = nothing

    # Garbage collect
    GC.gc()

    # Get number of rows and columns
    m = maximum(ir)
    n = length(jc) - 1

    # Initialize rows & columns indices
    row_inds = Int[]
    col_inds = Int[]

    # Occupy index arrays
    for col in 1:n
        for idx in jc[col]:jc[col + 1] - 1
            push!(row_inds, ir[idx])
            push!(col_inds, col)
        end
    end

    # Clear unused variables & garbage collect
    ir = nothing
    jc = nothing
    GC.gc()

    # Return constructed SparseArray
    return sparse(row_inds, col_inds, data, m, n)

end
