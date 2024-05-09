# MAT_v4.jl
# Tools for reading MATLAB v4 files in Julia
#
# Copyright (C) 2012   Simon Kornblith
# Copyright (C) 2019   Victor Saase (modified from MAT_v5.jl)
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

# Override function for MAT_v4.checkv4
function repurposed_MAT_v4(data_buffer::IOBuffer)
    M, O, P, T, mrows, ncols, imagf, namlen = read_v4_header(data_buffer, false)
    if 0<=M<=4 && O == 0 && 0<=P<=5 && 0<=T<=2 && mrows>=0 && ncols>=0 && 0<=imagf<=1 && namlen>0
        swap_bytes = false
        return (true, swap_bytes)
    else
        seek(f, 0)   
        M, O, P, T, mrows, ncols, imagf, namlen = read_v4_header(data_buffer, true)
        if 0<=M<=4 && O == 0 && 0<=P<=5 && 0<=T<=2 && mrows>=0 && ncols>=0 && 0<=imagf<=1 && namlen>0
            swap_bytes = true
            return (true, swap_bytes)
        end
    end
    return (false, false)

end # repurposed_MAT_v4

# Override function for MAT_v4.matopen
function repurposed_MAT_v4(data_http::HTTP.Messages.Response, data_buffer::IOBuffer, debug::Bool, keep_data::Bool, swap_bytes::Bool)
    println("v4 not supported yet...")

end # repurposed_MAT_v4

read_v4_bswap(f::IO, swap_bytes::Bool, ::Type{T}) where T =
    swap_bytes ? bswap(read(f, T)) : read(f, T)

# Read data type and number of bytes at the start of a data element
function read_v4_header(f::IO, swap_bytes::Bool)
    dtype = read_v4_bswap(f, swap_bytes, Int32)

    M = div(rem(dtype, 10000), 1000)
    O = div(rem(dtype, 1000), 100)
    P = div(rem(dtype, 100), 10)
    T = div(rem(dtype, 10), 1)

    mrows = read_v4_bswap(f, swap_bytes, Int32)
    ncols = read_v4_bswap(f, swap_bytes, Int32)
    imagf = read_v4_bswap(f, swap_bytes, Int32)
    namlen = read_v4_bswap(f, swap_bytes, Int32)
    
    M, O, P, T, mrows, ncols, imagf, namlen
end
