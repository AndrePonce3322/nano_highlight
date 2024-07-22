#! /bin/bash

BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

# User
user=$(getent group sudo | cut -d ':' -f 4)

# Go to the nanorc files
cd /usr/share/nano/

# Create file to store the directories
touch nano_dirsc.txt

# List all directories
ls | grep ".nanorc" > nano_dirs.txt

while read line; do
    copy+="include /usr/share/nano/$line"$"\n"
done < nano_dirs.txt

root_dir="/root/.nanorc"
user_dir="/home/$user/.nanorc"

echo -e "$copy" >> $root_dir
echo -e "$copy" >> $user_dir

echo -e "-------------------------------------------------------------------"
echo -e "[*] CONTENT COPIED IN $root_dir AND $user_dir: "
echo -e "[*] LINES COPIED: $(wc nano_dirs.txt | awk '{print $1}')"

echo -e "${BLUE}\n[!] SYNTAX HIGHLIGHTING ENABLED${NC}"
echo -e "-------------------------------------------------------------------"
