### Get available system memory (GB)

function get_available_memory()
    # Find available memory dependent on OS being used
    if Sys.iswindows() # User is on Windows
        # Get available memory in KB
        mem_info = read(`wmic OS get FreePhysicalMemory /Value`, String)
        mem_kb = parse(Int, split(mem_info, '=')[2])
        
        # Math simplified for efficiency
        # / 1024^2 for KB to GB, * 0.95 for a buffer
        return mem_kb / 1103764

    elseif Sys.islinux() # User is on Linux !!!NEEDS TESTING!!!
        mem_info = read(`free -m`, String)
        mem_lines = split(mem_info, '\n')
        mem_parts = split(mem_lines[2])
        return parse(Int, mem_parts[4]) / 1024

    elseif Sys.isapple() # User is on an Apple product !!!NEEDS TESTING!!!
        mem_info = read(`vm_stat`, String)
        mem_lines = split(mem_info, '\n')
        free_line = filter(s -> occursin("Pages free", s), mem_lines)[1]
        mem_free = parse(Int, split(free_line)[3])
        page_size = 4096  # macOS uses 4096 bytes per memory page
        mem_bytes = mem_free * page_size
        # Math simplified for efficiency
        return mem_bytes / 1073741824

    end

    # Unknown OS; return flag
    return -1

end