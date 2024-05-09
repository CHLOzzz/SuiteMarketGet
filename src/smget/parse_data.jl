function parse_data(data_stream::IOStream, file_location::String, debug::Bool)
    println("Local file!")

end

function parse_data(data_http::HTTP.Messages.Response, debug::Bool)
    println("Online file!")

end
