#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# User
user=$(getent group sudo | cut -d ':' -f 4)

# Go to the nanorc files
cd /usr/share/nano/

# Create file to store the directories
if [ ! -e nano_dirs.txt ]; then
    touch nano_dirs.txt
fi

# List all directories
ls | grep ".nanorc" > nano_dirs.txt

root_dir="/root/.nanorc"
user_dir="/home/$user/.nanorc"

already_configured=false

while read -r line; do
    include_line="include /usr/share/nano/$line"
    if grep -qF "$include_line" "$root_dir" && grep -qF "$include_line" "$user_dir"; then
        already_configured=true
    else
        echo "$include_line" >> "$root_dir"
        echo "$include_line" >> "$user_dir"
    fi
done < nano_dirs.txt

if $already_configured; then
    echo "[*] ALREADY CONFIFURED"
    exit 1
fi

echo -e "-------------------------------------------------------------------"
echo -e "[*] CONTENT COPIED IN $root_dir AND $user_dir: "
echo -e "[*] LINES COPIED: $(wc -l < nano_dirs.txt)"

echo -e "${BLUE}\n[!] SYNTAX HIGHLIGHTING ENABLED${NC}"
echo -e "-------------------------------------------------------------------"
