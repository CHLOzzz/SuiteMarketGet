# MAT_v5.jl
# Tools for reading MATLAB v5 files in Julia
#
# Copyright (C) 2012   Simon Kornblith
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# MATLAB's file format documentation can be found at
# http://www.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf

mutable struct RepurposedMatlabv5File <: HDF5.H5DataStore
    ios::IOStream
    swap_bytes::Bool
    varnames::Dict{String, Int64}

    RepurposedMatlabv5File(ios, swap_bytes) = new(ios, swap_bytes)
end

function repurposed_MAT_v5(data_http::HTTP.Messages.Response, data_buffer::IOBuffer, debug::Bool, keep_files::Bool, endian_indicator::UInt16)
    # Obtain Matlabv5File stream
    mat_v5_file = Matlabv5File(data_buffer, endian_indicator == 0x494D)

    # Read matfile
    mat_v5_contents = mat_v5_read(mat_v5_file)

    # Return for troubleshooting
    return mat_v5_contents

end # repurposed_MAT_v5

read_v5_bswap(f::IO, swap_bytes::Bool, ::Type{T}) where T =
    swap_bytes ? bswap(read(f, T)) : read(f, T)
function read_v5_bswap(f::IO, swap_bytes::Bool, ::Type{T}, dim::Union{Int, Tuple{Vararg{Int}}}) where T
    d = read!(f, Array{T}(undef, dim))
    if swap_bytes
        for i = 1:length(d)
            @inbounds d[i] = bswap(d[i])
        end
    end
    d
end

skip_v5_padding(f::IO, nbytes::Int, hbytes::Int) = if nbytes % hbytes != 0
    skip(f, hbytes-(nbytes % hbytes))
end

# Read data type and number of bytes at the start of a data element
function read_v5_header(f::IO, swap_bytes::Bool)
    dtype = read_v5_bswap(f, swap_bytes, UInt32)

    if (dtype & 0xFFFF0000) != 0
        # Small Data Element Format
        (dtype & 0x0000FFFF, convert(Int, dtype >> 16), 4)
    else
        # Data Element Format
        (dtype, convert(Int, read_v5_bswap(f, swap_bytes, UInt32)), 8)
    end
end

# Read data element as a vector of a given type
function read_v5_element(f::IO, swap_bytes::Bool, ::Type{T}) where T
    (dtype, nbytes, hbytes) = read_v5_header(f, swap_bytes)
    data = read_v5_bswap(f, swap_bytes, T, Int(div(nbytes, sizeof(T))))
    skip_v5_padding(f, nbytes, hbytes)
    data
end

# Read data element as encoded type
function read_v5_data(f::IO, swap_bytes::Bool)
    (dtype, nbytes, hbytes) = read_v5_header(f, swap_bytes)
    read_type = READ_TYPES[dtype]
    data = read_v5_bswap(f, swap_bytes, read_type, Int(div(nbytes, sizeof(read_type))))
    skip_v5_padding(f, nbytes, hbytes)
    data
end

# Read data element as encoded type with given dimensions, converting
# to another type if necessary and collapsing one-element matrices to
# scalars
function read_v5_data(f::IO, swap_bytes::Bool, ::Type{T}, dimensions::Vector{Int32}) where T
    (dtype, nbytes, hbytes) = read_v5_header(f, swap_bytes)
    read_type = READ_TYPES[dtype]
    if (read_type === UInt8) && (T === Bool)
        read_type = Bool
    end

    read_array = any(dimensions .!= 1)
    if sizeof(read_type)*prod(dimensions) != nbytes
        error("Invalid element length")
    end
    if read_array
        data = read_v5_bswap(f, swap_bytes, read_type, tuple(convert(Vector{Int}, dimensions)...))
    else
        data = read_v5_bswap(f, swap_bytes, read_type)
    end
    skip_v5_padding(f, nbytes, hbytes)

    read_array ? convert(Array{T}, data) : convert(T, data)
end

function read_v5_cell(f::IO, swap_bytes::Bool, dimensions::Vector{Int32})
    data = Array{Any}(undef, convert(Vector{Int}, dimensions)...)
    for i = 1:length(data)
        (ignored_name, data[i]) = read_v5_matrix(f, swap_bytes)
    end
    data
end

# Read matrix data
function read_v5_matrix(f::IO, swap_bytes::Bool)
    (dtype, nbytes) = read_v5_header(f, swap_bytes)
    if dtype == miCOMPRESSED
        return read_v5_matrix(ZlibDecompressorStream(IOBuffer(read!(f, Vector{UInt8}(undef, nbytes)))), swap_bytes)
    elseif dtype != miMATRIX
        error("Unexpected data type")
    elseif nbytes == 0
        # If one creates a cell array using
        #     y = cell(m, n)
        # then MATLAB will save the empty cells as zero-byte matrices. If one creates a
        # empty cells using
        #     a = {[], [], []}
        # then MATLAB does not save the empty cells as zero-byte matrices. To avoid
        # surprises, we produce an empty array in both cases.
        return ("", Matrix{Union{}}(undef, 0, 0))
    end

    flags = read_v5_element(f, swap_bytes, UInt32)
    class = flags[1] & 0xFF

    if class == mxOPAQUE_CLASS
        s0 = read_v5_data(f, swap_bytes)
        s1 = read_v5_data(f, swap_bytes)
        s2 = read_v5_data(f, swap_bytes)
        arr = read_v5_matrix(f, swap_bytes)
        return ("__opaque__", Dict("s0"=>s0, "s1"=>s1, "s2"=>s2, "arr"=>arr))
    end

    dimensions = read_v5_element(f, swap_bytes, Int32)
    name = String(read_v5_element(f, swap_bytes, UInt8))

    local data
    if class == mxCELL_CLASS
        data = read_v5_cell(f, swap_bytes, dimensions)
    elseif class == mxSTRUCT_CLASS || class == mxOBJECT_CLASS
        data = read_struct(f, swap_bytes, dimensions, class == mxOBJECT_CLASS)
    elseif class == mxSPARSE_CLASS
        data = read_sparse(f, swap_bytes, dimensions, flags)
    elseif class == mxCHAR_CLASS && length(dimensions) <= 2
        data = read_string(f, swap_bytes, dimensions)
    elseif class == mxFUNCTION_CLASS
        data = read_v5_matrix(f, swap_bytes)
    else
        if (flags[1] & (1 << 9)) != 0 # logical
            data = read_v5_data(f, swap_bytes, Bool, dimensions)
        else
            convert_type = CONVERT_TYPES[class]
            data = read_v5_data(f, swap_bytes, convert_type, dimensions)
            if (flags[1] & (1 << 11)) != 0 # complex
                data = complex_array(data, read_v5_data(f, swap_bytes, convert_type, dimensions))
            end
        end
    end

    return (name, data)
end

# Read whole MAT file
function mat_v5_read(matfile::RepurposedMatlabv5File)
    seek(matfile.ios, 128)
    vars = Dict{String, Any}()
    while !eof(matfile.ios)
        (name, data) = read_v5_matrix(matfile.ios, matfile.swap_bytes)
        vars[name] = data
    end
    vars
end
