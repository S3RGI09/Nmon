# ![Nmon Logo](https://raw.githubusercontent.com/S3RGI09/imagenes/refs/heads/main/pixelcut-export%20(1).png?token=GHSAT0AAAAAAC34LOKBMVNAFVZVMHVW6OI2Z3JYLDQ)

## Nmap Monitor

Nmon is a simple Nmap script that monitors devices on a network and compares the current state with a previously saved reference state. It detects newly connected devices and devices that have been disconnected.

### Author

**S3RGI09**

### License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

### Features

- Monitors devices in the network.
- Detects new and disconnected devices.
- Saves the current state of devices in a reference file for future comparisons.
- Simple and easy to use.

### Requirements

- Nmap installed on your system.

### Usage

1. **Save the Script:** Save the script as `nmon.nse`.

2. **Move the script to this path** /usr/share/nmap/scripts/,
```
mv nmon.nse /usr/share/nmap/scripts/
```

3. **Run the Script:** Use the following command in your terminal:
```
   nmap --script nmon.nse -sn <IP_address_or_range>
```
   Replace `<IP_address_or_range>` with the IP address or range of the network you want to scan (e.g., `192.168.1.0/24`).

### Reference File

The script creates a reference file named `network_state.txt` in the same directory. This file is used to store the current state of devices in the network. Ensure that the script has permission to read from and write to this file.

### Example Output

When you run the script, you will see an output similar to the following:
```
----- Nmon -----
Nmap Monitor  |  By S3RGI09

New device found: 192.168.1.10
Device disconnected: 192.168.1.5
```

>[!caution]
>Use this script on your own networks or where you have explicit consent.

>[!important]
>The script is not perfect, the information may be inaccurate, if a device is configured not to respond to Pings, it cannot be detected.

>[!tip]
>Complement this script with more tools like **Netdiscover**

### Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to submit a pull request or open an issue.

### Disclaimer

This script is for educational purposes only. Use it responsibly and ensure you have permission to scan the networks you are monitoring.
