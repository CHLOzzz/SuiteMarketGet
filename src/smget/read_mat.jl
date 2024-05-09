### Code obtains matrix A when online source is a .mat file
### Much code is repurposed from the MAT.jl packages
### Code here is simply a sendoff 

function read_mat(data_http::HTTP.Messages.Response, debug::Bool, keep_data::Bool)
    # Open IOBuffer of data
    data_buffer = IOBuffer(data_http.body)

   # Send off to another file for proper copyright display
   return repurposed_MAT(data_http, data_buffer, debug, keep_data)

end # read_mat
