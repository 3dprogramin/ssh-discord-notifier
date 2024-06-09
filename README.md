# SSH Discord Notifier

Bash script that notifies a user through Discord when a new SSH connection is established on a machine. It sends a message containing details about the connection, including the username, IP address, location, time, and hostname.

## Setup Instructions

To get the script up and running, follow these steps:

### Step 1: Install `curl`

Ensure that `curl` is installed on your machine. You can install it using the package manager for your operating system:

```bash
# For Arch based systems
sudo pacman -S curl

# For Debian/Ubuntu-based systems
sudo apt-get install curl

# For Red Hat/CentOS-based systems
sudo yum install curl
```

### Step 2: Replace the `WEBHOOK_URL` variable

Edit the script to replace the placeholder URL with your actual Discord channel webhook URL.

```bash
WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/ABCDEFGHIJKLMN1234567890"
```

### Step 3: Place the script in /etc/profile.d

Copy the script to the /etc/profile.d directory to ensure it runs on every user login.

```bash
sudo cp ssh-discord-notifier.sh /etc/profile.d/ssh-discord-notifier.sh
sudo chmod +x /etc/profile.d/ssh-discord-notifier.sh
```

## How It Works

1. **Get location using IP address**: The script uses `ip-api.com` to retrieve the city, region, and country based on the IP address of the SSH client.
2. **Send a message to Discord**: A Discord message is formatted with the user details and sent to the specified webhook URL using `curl`.
3. **Run on SSH connection**: The script checks if an SSH connection is present and triggers the notification process.
4. **Runs in the background**: The script operates in the background, ensuring there is no delay or interruption to the user's session while it completes its tasks.
