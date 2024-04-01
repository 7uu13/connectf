#!/bin/bash 

echo "
 _______                              _______  __     ___ 
|   _   |.-----..-----..-----..-----.|   _   ||  |_ .'  _|
|.  1___||  _  ||     ||     ||  -__||.  1___||   _||   _|
|.  |___ |_____||__|__||__|__||_____||.  |___ |____||__|  
|:  1   |                            |:  1   |            
|::.. . |                            |::.. . |            
`-------'                            `-------'            
Automate your vpn connections!
Please choose a VPN configuration file.
"

# Directory conatining vpn conf. files 
conf_path=~/Downloads

# Make sure that openvpn is installed, if not, do so

if ! command -v openvpn &> /dev/null; then
    echo "OpenVpn is not installed."
    echo "Would you like to insall openvpn? (Y\N)"
        read -r response
        # Convert the input to uppercase
        response=$(echo "$response" | tr '[:lower:]' '[:upper:]')

        # Check the response
        if [ "$response" == "Y" ]; then
            echo "User chose Yes."
        elif [ "$response" == "N" ]; then
            echo "User chose No."
        else
            echo "Invalid input."
        fi
    exit 1 
fi

# Check if the configuration directory exists
if [ ! -d "$conf_path" ]; then
    echo "Vpn configuration directory not found."
    exit 1
fi

# Display all of the available configuration files.
echo "Available Vpn configuration files."

conf_files=("$conf_path"/*.ovpn)
length=${#conf_files[@]}

for (( i=0; i<$length; i++ )); do
    file_name=$(basename "${conf_files[$i]}")
    echo "$((i+1)). $file_name"
done

# Get the input on which conf file to choose 
read -p "Please enter a number for a corresponding configuration: " selection 

# Validate user input.
if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
    echo "Invalid input." 
else 
    selected_configuration_file="${conf_files[$((selection-1))]}"
    sudo openvpn "$selected_configuration_file"
fi


