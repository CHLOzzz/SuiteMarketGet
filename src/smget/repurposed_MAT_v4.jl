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
function repurposed_MAT_v4(data_http::HTTP.Messages.Response, data_buffer::IOBuffer, debug::Bool, keep_data::Bool)
    println("v4 not supported yet...")
end # repurposed_MAT_v4

# Override function for MAT_v4.matopen
function repurposed_MAT_v4(data_http::HTTP.Messages.Response, data_buffer::IOBuffer, debug::Bool, keep_data::Bool, swap_bytes::Bool)
    println("v4 not supported yet...")
end # repurposed_MAT_v4
