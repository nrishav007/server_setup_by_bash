#!/bin/bash

# Prompt the user for the port number
read -p "Enter the port number to kill processes (e.g., 80): " port_number

# Check if the port number is provided
if [ -z "$port_number" ]; then
    echo "Port number cannot be empty. Exiting."
    exit 1
fi

# Get the PID(s) using the specified port
pid_list=$(lsof -t -i :"$port_number")

# Check if any process is using the specified port
if [ -z "$pid_list" ]; then
    echo "No process found on port $port_number. Exiting."
    exit 1
fi

# Confirm with the user before killing the processes
echo "Processes found on port $port_number with PID(s): $pid_list"
read -p "Do you want to kill these processes? (y/n): " confirm

if [ "$confirm" == "y" ]; then
    # Loop through each PID and kill the processes
    for pid in $pid_list; do
        kill -9 $pid
        echo "Process with PID $pid killed successfully."
    done
else
    echo "No processes were killed. Exiting."
fi

exit 0

