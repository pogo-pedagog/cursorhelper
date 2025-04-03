# Cursorhelper

This simple script will download and install cursor server binaries based on version information pasted from "about" dialogue in cursor.
By default it reads from STDIN, so just run the script, paste the about info and press ctrl-d and it should download and install the cursor remote server.

If you want stuff like the links in Azure thingies to work, register cursor as a handler for vscode:// in your operating system, see below


## Windows setup for MS auth and OS handler

### Prerequisites
- Cursor installed on your system
- Visual Studio Code installed on your system
- Remote machine with Linux running and a console available somehow (terminal in azure works fine)

### Configure Microsoft Authentication
Navigate to Visual Studio Code's extensions folder:
```
C:\Users\[YourUsername]\AppData\Local\Programs\Microsoft VS Code\resources\app\extensions\microsoft-authentication
```

Copy the entire microsoft-authentication folder to Cursor's extensions directory:
```
C:\Users\[YourUsername]\AppData\Local\Programs\cursor\resources\app\extensions
```

### Configure URL Handling
Open Windows Settings, navigate to Default Apps, search for "URL" or scroll to URL protocol handlers. Find the vscode:// protocol and change it to use Cursor instead of VS Code.

### Install Cursor Server on Remote Machine
In Cursor, go to Help > About to view version information. Connect to your remote machine terminal, then download and run the cursorhelper.sh script:
```bash
curl -O https://github.com/pogo-pedagog/cursorhelper/raw/refs/heads/main/cursorhelper.sh
chmod +x cursorhelper.sh
./cursorhelper.sh
```

Then just paste the contents of Cursor's About dialog followed by pressing Ctrl+D. The script should automatically download and install the appropriate Cursor server binaries.

Cursor might pop up a button that asks you to "kill and restart the remote server" or something similar, do NOT let it do that, close cursor and restart it. If you by mistake let it do that, it'll nuke the server component and you'll have to re-run the installation as per above.

Congrats, now you should be able to connect just as in VS Code.

## macOS Setup

### Prerequisites
- Cursor installed on your system
- Visual Studio Code installed on your system
- Remote machine with Linux running
- SwiftDefaultApps installed (for URL handling)

### Configure Microsoft Authentication
Navigate to Visual Studio Code's extensions folder:
```
/Applications/Visual Studio Code.app/Contents/Resources/app/extensions/microsoft-authentication
```

Copy the entire microsoft-authentication folder to Cursor's extensions directory:
```
~/.cursor/extensions
```

### Configure URL Handling
Install SwiftDefaultApps:
```bash
brew install swiftdefaultapps
```

Open System Settings, scroll to the bottom and select "SwiftDefaultApps". Go to the "URI Schemes" tab, scroll down to find "vscode", and change the handler to Cursor.

### Install Cursor Server on Remote Machine
In Cursor, go to Help > About to view version information. Connect to your remote machine terminal, then download and run the cursorhelper.sh script:

```bash
curl -O https://github.com/pogo-pedagog/cursorhelper/raw/refs/heads/main/cursorhelper.sh
chmod +x cursorhelper.sh
./cursorhelper.sh
```

When prompted, paste the information from Cursor's About dialog and press Ctrl+D. The script will automatically download and install the appropriate Cursor server binaries.

Cursor might pop up a button that asks you to "kill and restart the remote server" or something similar, do NOT let it do that, close cursor and restart it. If you by mistake let it do that, it'll nuke the server component and you'll have to re-run the installation as per above.

Congrats, now you should be able to connect just as in VS Code.

## Troubleshooting

### Connection Issues
- Verify the Cursor server version matches your local Cursor version
- Try disabling HTTP2 requests in Cursor's User Settings
- Check if you can connect using VS Code - if not, it might be a permissions issue

### Authentication Issues
- If authentication fails, try restarting Cursor
- If MS auth complains, just do something on the compute instance from azure web, it'll hopefully ask you to reauth and after that things work fine (at least for me :D ).

### Manual Installation of Cursor Server Component
If the cursorhelper.sh script doesn't work, you can manually install the server:

In Cursor, go to Help > About and note the version number (e.g., 0.44.11) and commit hash (e.g., fe574d0820377383143b2ea26aa6ae28b3425220).

On your remote machine, run:
```bash
# Create URL using your version and commit hash
# Example URL for version 0.44.11 and commit fe574d0820377383143b2ea26aa6ae28b3425220:
# wget https://cursor.blob.core.windows.net/remote-releases/0.44.11-fe574d0820377383143b2ea26aa6ae28b3425220/vscode-reh-linux-x64.tar.gz
wget https://cursor.blob.core.windows.net/remote-releases/[VERSION-COMMIT]/vscode-reh-linux-x64.tar.gz

# Extract the archive
tar -zxvf vscode-reh-linux-x64.tar.gz

# Create the cursor server directory if it doesn't exist
mkdir -p ~/.cursor-server/bin/[VERSION-COMMIT]

# Copy files to the cursor server directory
# Example for commit fe574d0820377383143b2ea26aa6ae28b3425220:
# cp -r vscode-reh-linux-x64/* ~/.cursor-server/bin/fe574d0820377383143b2ea26aa6ae28b3425220/
cp -r vscode-reh-linux-x64/* ~/.cursor-server/bin/[VERSION-COMMIT]/
```


