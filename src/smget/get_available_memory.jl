### Get available system memory (GB)

function get_available_memory()
    # Find available memory dependent on OS being used
    if Sys.iswindows()
        # Get available memory in KB
        mem_info = read(`wmic OS get FreePhysicalMemory /Value`, String)
        mem_kb = parse(Int, split(mem_info, '=')[2])
        
        # Math simplified for efficiency
        # / 1024^2 for KB to GB, * 0.95 for a buffer
        return mem_kb / 1103764

    elseif Sys.islinux()
        # Get available memory in MB (including SWAP)
        mem_info = read(`free -m`, String)
        mem_lines = split(mem_info, '\n')
        mem_parts = split(mem_lines[2])

        # Math simplified for efficiency
        # / 1024 for MB to GB, * 0.95 for a buffer
        return parse(Int, mem_parts[7]) / 1077

    elseif Sys.isapple()
        # Get page size (B)
        page_size = read(`bash -c "vm_stat | grep 'page size of' | awk '{print \$8}'"`, String)[1:end-1]
        page_size = parse(Int, page_size)

        # Get available pages (free pages + inactive pages)
        available_pages = read(`bash -c "vm_stat | awk '/Pages free/ {free=\$3}/Pages inactive/ {inactive=\$3}END {print (free + inactive)}' | sed 's/\.//'"`, String)[1:end-1]
        available_pages = parse(Int, available_pages)

        # Math simplified for efficiency
        # page_size * available_pages for B, / 1024^3 for B to GB, * 0.95 for a buffer
        return page_size * available_pages / 1130254551

    end

    # Unknown OS; return flag
    return -1

end