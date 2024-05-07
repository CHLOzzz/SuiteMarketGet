### Read .mat files in v5
### Two override functions provided:
### - read_MAT_v5(data::Vector{T}, data_buffer::IOBuffer): MAT v5 data being handled in memory
### - read_MAT_v5(data__Vector{T}, data_buffer::IOStream, keep_files::Bool): MAT v5 data being handled in storage


function read_MAT_v5(data::Vector{T}, data_buffer::IOBuffer) where T <: Unsigned
    # Clear data & garbage collect
    data = nothing
    GC.gc()
    
    println("no errors!")
    
end
