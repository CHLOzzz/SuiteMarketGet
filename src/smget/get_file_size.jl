### Get size of file to download (GB)

function get_file_size(url::String, is_matrix_market::Bool)
    # Get URL's header
    url_headers = HTTP.head(url).headers

    # Find "content-length"
    for header in url_headers
        # Found "content-length (Bytes)
        if lowercase(header.first) == "content-length"
            # Math simplified for efficiency
            # /1024^3 for B to GB, * 2 for decompression
            return parse(Int, header.second) / 536870912

        end

    end

    # "content-length" not found; return flag
    return -1

end