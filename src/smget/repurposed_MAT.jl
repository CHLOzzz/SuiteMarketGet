# MAT.jl
# Tools for reading MATLAB v5 files in Julia
#
# Copyright (C) 2012   Timothy E. Holy and Simon Kornblith
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

# Define HDF5 header constant
const MAT_HDF5_HEADER = UInt8[0x89, 0x48, 0x44, 0x46, 0x0d, 0x0a, 0x1a, 0x0a]

function repurposed_MAT(data_http::HTTP.Messages.Response, data_buffer::IOBuffer, debug::Bool, keep_data::Bool)
    # Check for MAT v4 file
    (isv4, swap_bytes) = repurposed_MAT_v4(data_http, data_buffer, debug, keep_data)
    if isv4
        return repurposed_MAT_v4(data_http, data_buffer, debug, keep_data, swap_bytes)

    end
    
    # Test whether this is a MAT file
    if sizeof(data_buffer) < 128
        close(data_buffer)
        data_http = nothing
        debug = nothing
        keep_data = nothing
        GC.gc()
        error("File is too small to be a supported MAT file!")

    end

    # Check for MAT v5 file
    seek(data_buffer, 124)
    version = read(data_buffer, UInt16)
    endian_indicator = read(data_buffer, UInt16)
    if (version == 0x0100 && endian_indicator == 0x4D49) ||
       (version == 0x0001 && endian_indicator == 0x494D)
        return repurposed_MAT_v5(data_http, data_buffer, debug, keep_data, endian_indicator)
        
    end

    # Check for HDF5 file
    for offset = 512:512:fs-8
        seek(data_buffer, offset)
        if read!(data_buffer, Vector{UInt8}(undef, 8)) == MAT_HDF5_HEADER
            close(data_buffer)
            return repurposed_MAT_HDF5(data_http, data_buffer, debug, keep_data)
        end
    end

    close(data_buffer)
    error("File is not a MAT file!")

end