# Linux User Creation- Bash Scripting

## Overview

This Bash script automates the creation of users on a Unix-like system. It handles the creation of user accounts, groups, and assigns users to specified groups. Additionally, it logs actions and stores user passwords securely.

## Features

- **User and Group Creation**: Creates users and their respective groups if they do not already exist.
- **Password Generation**: Automatically generates a secure random password for each user.
- **Logging**: Logs all actions performed by the script to `/var/log/user_management.log`.
- **Secure Password Storage**: Stores user passwords securely in `/var/secure/user_passwords.txt` with appropriate permissions.

## Prerequisites

- Ensure the script is run with appropriate permissions (e.g., as root or with sudo).
- Required directories and files:
  - `/var/log/user_management.log`
  - `/var/secure/user_passwords.txt`

## Usage

1. **Prepare User List File**:
   - Create a file with user details. Each line should contain a username and a list of groups separated by a semicolon (`;`). For example:
     ```
     john_doe;admin,developers
     jane_smith;users
     ```

2. **Run the Script**:
   - Make the script executable:
     ```bash
     chmod +x create_users.sh
     ```
   - Execute the script with the user list file as an argument:
     ```bash
     sudo ./create_users.sh user_list.txt
     ```

3. **Configuration**:
   - The script automatically creates the necessary directories and files. Ensure that `/var/log` and `/var/secure` are accessible.

## Script Breakdown

- **`log_action()`**: Logs actions with a timestamp to `/var/log/user_management.log`.
- **`create_user()`**: Handles user creation, group assignment, and password generation. Stores passwords in `/var/secure/user_passwords.txt`.
- **Main Execution**: Reads the user list file and calls `create_user()` for each entry.

## Security Considerations

- **Password Storage**: Passwords are stored in `/var/secure/user_passwords.txt` with restricted permissions (`chmod 600`). Ensure this file is secured.
- **Directory Permissions**: User home directories are set to `700` to ensure privacy.




**Article available at**: https://dev.to/lucy_76er/linux-user-creation-bash-scripting-kl1
