description = [[
  Monitors devices in the network using ping and performs a quick scan on active devices.
  Compares the current state with a reference file and logs changes.
]]

author = "S3RGI09"
license = "Apache 2.0"
categories = {"discovery"}

local reference_file = "network_state.txt"

-- Leer el estado de referencia
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

-- Guardar el estado actual
local function save_current_state(current_state)
    local file = io.open(reference_file, "w")
    for _, ip in ipairs(current_state) do
        file:write(ip .. "\n")
    end
    file:close()
end

-- Mostrar encabezado decorativo
local function display_header()
    local header = "----- Nmon -----"
    local subtitle = "Nmap Monitor  |  By S3RGI09"
    local term_width = 80

    print(string.rep(" ", (term_width - #header) // 2) .. header)
    print(string.rep(" ", (term_width - #subtitle) // 2) .. subtitle)
    print("")
end

-- Realizar un ping a la red para detectar dispositivos activos
local function ping_sweep(range)
    local active_devices = {}
    for ip in nmap.target_ip_list(range) do
        if nmap.ping_host(ip) then
            table.insert(active_devices, ip)
        end
    end
    return active_devices
end

-- Escanear rápidamente dispositivos detectados
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

    -- Definir rango de IPs (puede ser configurado)
    local range = "192.168.1.0/24"  -- Cambia esto según tu red

    -- Detectar dispositivos activos usando ping
    local active_devices = ping_sweep(range)
    if #active_devices == 0 then
        nmap.log("No active devices found on the network.", 6)
        return
    end

    -- Leer estado anterior
    local previous_state = read_previous_state()

    -- Escanear dispositivos activos y registrar cambios
    local current_state = {}
    for _, ip in ipairs(active_devices) do
        table.insert(current_state, ip)
        local scan_results = quick_scan(ip)
        nmap.log("Device " .. ip .. " has open ports: " .. table.concat(scan_results, ", "), 6)

        if not previous_state[ip] then
            nmap.log("New device found: " .. ip, 6)
        end
    end

    -- Detectar dispositivos desconectados
    for ip in pairs(previous_state) do
        if not current_state[ip] then
            nmap.log("Device disconnected: " .. ip, 6)
        end
    end

    -- Guardar el estado actual
    save_current_state(current_state)
end
