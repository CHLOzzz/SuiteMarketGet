using HTTP
using CodecZlib
using SparseArrays

# ASSUMPTION:
# ALL MATRIX MARKET URLs FOR .mtx.gz ARE SINGLE FILE

# Works for Matrix Market single file .mtx.gz matrices
url = "https://math.nist.gov/pub/MatrixMarket2/Harwell-Boeing/airtfc/zenios.mtx.gz"
url = "https://math.nist.gov/MatrixMarket/data/Harwell-Boeing/psadmit/1138_bus.mtx.gz"
url = "https://math.nist.gov/pub/MatrixMarket2/Harwell-Boeing/smtape/arc130.mtx.gz"

# Working on Matrix Market single file .mtx.gz vectors
#url = "https://math.nist.gov/pub/MatrixMarket2/misc/hamm/add20_rhs1.mtx.gz"
url = "https://math.nist.gov/pub/MatrixMarket2/SPARSKIT/fidap/fidap008_rhs1.mtx.gz"

data = HTTP.get(url).body
buffer = IOBuffer(data)
data = nothing
stream = GzipDecompressorStream(buffer)
matrix_string = read(stream, String)
close(buffer)
close(stream)
matrix_string = split(matrix_string, '\n')

V = Float64[]

for line in matrix_string
    length(line) == 0 && continue
    length(split(line)) == 2 && continue
    line[1] == '%' && continue

    local v = parse(Float64, line)
    push!(V, v)
    
end

sparse(V)

"""
Is this safe?
"""