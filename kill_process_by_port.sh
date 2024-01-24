#!/bin/bash
# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Prompt the user for the port number
echo -en "${YELLOW}Enter the port number to kill processes (e.g., ${GREEN}80${NC},${GREEN}3000${NC},${GREEN}...${NC}): "
read port_number

# Check if the port number is provided
if [ -z "$port_number" ]; then
    echo -en "${RED}Port number cannot be empty. Exiting.${NC}"
    echo ""
    exit 1
fi

# Get the PID(s) using the specified port
pid_list=$(lsof -t -i :"$port_number") 

# Check if any process is using the specified port
if [ -z "$pid_list" ]; then
    echo -en "${RED}No process found on port ${GREEN} $port_number${RED} Exiting.${NC}"
    echo ""
    exit 1
fi

# Confirm with the user before killing the processes
echo -en "${YELLOW}Processes found on port ${GREEN} $port_number ${YELLOW} with PID(s):${GREEN} $pid_list${NC}"
echo -en "${YELLOW}Do you want to kill these processes? (${GREEN}y${NC}/${RED}n${NC}):"
read confirm

if [ "$confirm" == "y" ]; then
    # Loop through each PID and kill the processes
    for pid in $pid_list; do
        kill -9 $pid
        echo -en "${YELLOW}Process with PID ${GREEN}$pid ${YELLOW}killed successfully.${NC}"
        echo ""
    done
else
    echo -en "${GREEN}No processes were killed. Exiting.${NC}"
    echo ""
fi

exit 0

