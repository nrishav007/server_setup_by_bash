#!/bin/bash

folder_path_file="stored_path.txt"

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

display_menu() {
    clear
    echo -e "${GREEN}=== Git Menu ===${NC}"
    echo -e "1. ${YELLOW}Update Repository Folder Path${NC}"
    echo -e "2. ${YELLOW}Check Status${NC}"
    echo -e "3. ${YELLOW}Change Branch${NC}"
    echo -e "4. ${YELLOW}Create Branch${NC}"
    echo -e "5. ${YELLOW}Push Modified Code${NC}"
    echo -e "6. ${RED}Exit${NC}"
}

update_folder_path() {
    echo -en "${YELLOW}Enter the folder path: ${NC}"
    read folder_path
    if [ -d "$folder_path" ]; then
        echo "$folder_path" > "$folder_path_file"
        echo -e "${YELLOW}Folder path ${GREEN}'$folder_path'${YELLOW} stored successfully.${NC}"
    else
        echo -e "${RED}Invalid folder path. The folder does not exist.${NC}"
    fi
}

folder_validation(){
    if [ -e "$folder_path_file" ]; then
        stored_path=$(cat "$folder_path_file")
        if [ -n "$stored_path" ]; then
            echo -e "${YELLOW}Using stored folder path:${GREEN} $stored_path${NC}"
            cd "$stored_path" || exit
        else
            echo -e "${RED}No folder path stored in the file.${NC}"
        fi
    else
        echo -e "${RED}No folder path stored. Please store a folder path first.${NC}"
    fi
}

check_status() {
    folder_validation
    git status
}

change_branch() {
    folder_validation
    echo -en "${YELLOW}Enter Branch Name: ${NC}"
    read branch_name
    if git show-ref --quiet --heads "$branch_name"; then
        git checkout $branch_name
        echo -en "${YELLOW}Switched to branch:${GREEN} $branch_name ${NC}"
    else
        echo -en "${RED}Error: Branch '$branch_name' does not exist.${NC}"
        return 1
    fi
}
create_branch(){
    folder_validation
    echo -en "${YELLOW}Enter Branch Name: "
    read branch_name
    if git show-ref --quiet --heads "$branch_name"; then
        echo -en "${RED}Error: Branch '$branch_name' already exist.${NC}"
        
    else
        git branch $branch_name
        echo -en "${YELLOW}branch:${GREEN} $branch_name ${YELLOW}Created${NC}"
        return 1
    fi
}
push_modified_code() {
    folder_validation
    echo -en "${GREEN} Enter Commit Message:${NC}"
    read commit
    echo -en "${GREEN} Enter Branch name:${NC}"
    read branch
    if git show-ref --quiet --heads "$branch"; then
        git add .
        git commit -m "$commit"
        git push origin $branch
    else
        echo "Error: Branch '$branch' does not exist."
        return 1
    fi
    if [ -z "$commit" ] || [ -z "$branch" ]; then
        echo -en "${RED}Error: commit message or branch name are blank.${NC}"
        echo ""
    else
        echo -e "${YELLOW}Functionality for pushing modified code will be implemented here.${NC}"
    fi
}

while true; do
    display_menu
    echo ""
    echo -en "${YELLOW}Enter your choice : ${NC}"
    read choice

    case $choice in
        1)
            update_folder_path
            ;;
        2)
            check_status
            ;;
        3)
            change_branch
            ;;
        4)
            create_branch
            ;;
        5)
            push_modified_code
            ;;
        6)
            echo -e "${RED}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please enter a number between 1 and 5.${NC}"
            ;;
    esac

    echo -en "${YELLOW}Press Enter to continue...${NC}"
    read
done
