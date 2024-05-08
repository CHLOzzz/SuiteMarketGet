### Read .mat files in v5

function read_MAT_v5(data::Vector{T}, data_buffer::IOBuffer) where T <: Unsigned
    # Clear data & garbage collect
    data = nothing
    GC.gc()

    # Determine whether bytes should be swapped
    
    println("Text is showing here.")
    
end
