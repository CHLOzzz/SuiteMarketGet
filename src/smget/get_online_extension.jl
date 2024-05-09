### Code attempts to pull a file extension from the URL to determine how to handle reading the data

function get_online_extension(data_http::HTTP.Messages.Response, file_location::String)
    # First attempt to pull extension from URL
    # Due to potential false positives, will only search at the end
    extensions = [".gz", ".mat"]
    file_extension = "." * split(file_location, ".")[end]
    if file_extension[end] == '/'
        file_extension = file_extension[1:end-1]

    end # if

    # Return file extension if valid
    if file_extension in extensions
        return file_extension

    end # if

    # URL Extraction failed; attempt to pull from response headers
 
    
    # Use known content types to guess file type
    # I would like a more efficient way to do this, but can't figure out how to search by key...
    for header in data_http.headers
        if lowercase(header[1]) == "content-type"
            # Define haystack, and search for needle
            haystack = lowercase(header[2])

            if contains(haystack, "application/x-gzip") || contains(haystack, "application/x-tar")
                return ".gz"

            elseif contains(haystack, "binary/octet-stream")
                return ".mat"

            end # if

        end # if

    end # for

    # Something should have returned...
    error("Either URL does not download a matrix or cannot be handled yet!")

end # get_online_extension
