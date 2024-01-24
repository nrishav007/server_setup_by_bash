#!/bin/bash

folder_path_file="stored_path.txt"
url_path_file="url_path.txt"

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
open_url(){
    url=$(cat "$url_path_file")
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open "$url"
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        xdg-open "$url"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows with MSYS or Cygwin
        start "$url"
    else
        echo "Unsupported operating system"
        exit 1
    fi
}
display_menu() {
    stored_path=$(cat "$folder_path_file")
    url_path=$(cat "$url_path_file")
    clear
    echo -e "${GREEN}======${YELLOW} Git Menu${GREEN} ======${NC}"
    echo -e "${YELLOW}Current Folder: ${GREEN} $stored_path${NC}"
    echo -e "${YELLOW}Current Git URL: ${GREEN} $url_path${NC}"
    echo ""
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
        old_path="$(pwd)"
        cd $folder_path
        git_remote_output=$(git remote -v)
        url=$(echo "$git_remote_output" | awk '{print $2}' | head -n 1)
        cd $old_path
        echo "$url" > "$url_path_file"
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
            update_folder_path

        fi
    else
        echo -e "${RED}No folder path stored. Please store a folder path first.${NC}"
        update_folder_path
    fi
}

check_status() {
    folder_validation
    git status
}
create_branch(){
    folder_validation
    echo -en "${YELLOW}Enter Branch Name: "
    read branch_name
    if git show-ref --quiet --heads "$branch_name"; then
        echo "${RED}Error: Branch ${GREEN}'$branch_name'${RED} already exist.${NC}"
    else
        git branch $branch_name
        echo -en "${YELLOW} branch changed successfully to ${GREEN}$branch_name${NC}"
        return 1
    fi
}
change_branch() {
    folder_validation
    echo -en "${YELLOW}Enter Branch Name: "
    read branch_name
    if git show-ref --quiet --heads "$branch_name"; then
        git checkout $branch_name
        git pull origin $branch_name
        echo "Switched to branch: $branch_name"
    else
        echo "Error: Branch '$branch_name' does not exist."
        return 1
    fi
}

push_modified_code() {
    folder_validation
    main_branch=""
    echo -en "${YELLOW} Enter Commit Message:${NC}"
    read commit
    echo -en "${YELLOW} Enter Branch name:${NC}"
    read branch
    echo -en "${YELLOW}Are you currently on sub branch? (${GREEN}y${NC}/${RED}n${NC}):"
    read confirm
    if [ "$confirm" == "y" ]; then
        echo -en "${YELLOW} Enter Your Main Branch Name:${NC}"
        read main_branch
    fi
    if [ -z "$commit" ] || [ -z "$branch" ]; then
        echo -en "${RED}Error: commit message or branch name are blank.${NC}"
        echo ""
        return 0
    fi
    if git show-ref --quiet --heads "$branch"; then
        git add .
        git commit -m "$commit"
        if [$main_branch!=""]; then
            git pull origin $main_branch
        fi
        git push origin $branch
    else
        echo "Error: Branch '$branch' does not exist."
        return 1
    fi
    if [ $main_branch == "" ]; then
    return 0
    else
        open_url
    fi
    
}

while true; do
    display_menu
    echo ""
    echo -en "${YELLOW}Enter your choice: ${NC}"
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
            echo -e "${RED}Invalid choice.${NC}"
            ;;
    esac

    echo -en "${YELLOW}Press Enter to continue...${NC}"
    read
done