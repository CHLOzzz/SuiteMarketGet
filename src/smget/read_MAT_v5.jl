### Read .mat files in v5
### Two override functions provided:
### - read_MAT_v5(data::Vector{T}, data_buffer::IOBuffer): MAT v5 data being handled in memory
### - read_MAT_v5(data__Vector{T}, data_buffer::IOStream, keep_files::Bool): MAT v5 data being handled in storage
### Code reappropriated from [MAT_v5.jl](https://github.com/JuliaIO/MAT.jl)
### Original Copyright:

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


function read_MAT_v5(data::Vector{T}, data_buffer::IOBuffer) where T <: Unsigned
    # Clear data & garbage collect
    data = nothing
    GC.gc()
    
    

end