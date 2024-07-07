#!/bin/bash

mkdir -p /var/log /var/secure
touch /var/log/user_management.log
touch /var/secure/user_passwords.txt
chmod 600 /var/secure/user_passwords.txt

log_action() {
    echo "$(date) - $1" >> "/var/log/user_management.log"
}

create_user() {
    local username="$1"
    local groups="$2"
    local password

    if id "$username" &>/dev/null; then
        log_action "User $username already exists. Skipping."
        return
    fi

    groupadd "$username"

    IFS=' ' read -ra group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs)
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            log_action "Group $group created."
        fi
    done

    useradd -m -s /bin/bash -g "$username" "$username"
    if [ $? -eq 0 ]; then
        log_action "User $username created with primary group: $username"
    else
        log_action "Failed to create user $username."
        return
    fi

    for group in "${group_array[@]}"; do
        usermod -aG "$group" "$username"
    done
    log_action "User $username added to groups: ${group_array[*]}"

    password=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 12)
    echo "$username:$password" | chpasswd

    echo "$username,$password" >> "/var/secure/user_passwords.txt"

    chmod 700 "/home/$username"
    chown "$username:$username" "/home/$username"

    log_action "Password for user $username set and stored securely."
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <user_list_file>"
    exit 1
fi

filename="$1"

if [ ! -f "$filename" ]; then
    echo "Users list file $filename not found."
    exit 1
fi

while IFS=';' read -r username groups; do
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs | tr -d ' ')
    groups=$(echo "$groups" | tr ',' ' ')
    create_user "$username" "$groups"
done < "$filename"

echo "User creation process completed."
