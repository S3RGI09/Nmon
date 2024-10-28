description = [[
  Monitors devices in the network and compares the current state with a reference file.
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

action = function(host)
    display_header()

    local current_state = {}

    for _, port in ipairs(host.ports) do
        if port.state == "open" then
            table.insert(current_state, host.ip)
            break
        end
    end

    local previous_state = read_previous_state()

    if #current_state > 0 then
        for _, ip in ipairs(current_state) do
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
    else
        nmap.log("No devices found on the network.", 6)
    end
end
