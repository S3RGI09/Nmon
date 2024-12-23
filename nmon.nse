description = [[
  Monitors devices in the network using ping and performs a quick scan on active devices.
  Compares the current state with a reference file and logs changes.
]]

author = "S3RGI09"
license = "Apache 2.0"
categories = {"discovery"}

local reference_file = "network_state.txt"

local function read_previous_state()
    local previous_state = {}
    local file = io.open(reference_file, "r")
    if file then
        for line in file:lines() do
            previous_state[line] = true
        end
        file:close()
    end
    return previous_state
end

local function save_current_state(current_state)
    local file = io.open(reference_file, "w")
    for _, ip in ipairs(current_state) do
        file:write(ip .. "\n")
    end
    file:close()
end

local function display_header()
    local header = "----- Nmon -----"
    local subtitle = "Nmap Monitor  |  By S3RGI09"
    local term_width = 80

    print(string.rep(" ", (term_width - #header) // 2) .. header)
    print(string.rep(" ", (term_width - #subtitle) // 2) .. subtitle)
    print("")
end

local function ping_sweep(range)
    local active_devices = {}
    for ip in nmap.target_ip_list(range) do
        if nmap.ping_host(ip) then
            table.insert(active_devices, ip)
        end
    end
    return active_devices
end

local function quick_scan(ip)
    local scan_results = {}
    for _, port in ipairs(nmap.ports(ip)) do
        if port.state == "open" then
            table.insert(scan_results, port.number)
        end
    end
    return scan_results
end

action = function(host)
    display_header()
    local range = "192.168.1.0/24"
    local active_devices = ping_sweep(range)
    if #active_devices == 0 then
        nmap.log("No active devices found on the network.", 6)
        return
    end
    local previous_state = read_previous_state()
    local current_state = {}
    for _, ip in ipairs(active_devices) do
        table.insert(current_state, ip)
        local scan_results = quick_scan(ip)
        nmap.log("Device " .. ip .. " has open ports: " .. table.concat(scan_results, ", "), 6)
        if not previous_state[ip] then
            nmap.log("New device found: " .. ip, 6)
        end
    end
    for ip in pairs(previous_state) do
        if not current_state[ip] then
            nmap.log("Device disconnected: " .. ip, 6)
        end
    end
    save_current_state(current_state)
end
