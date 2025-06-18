#!/bin/bash

# Function to display usage instructions
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [FILE]

Download and install Cursor server binaries based on version information.
If FILE is not provided, reads from standard input.

Options:
  -h, --help    Show this help message and exit

Input format example:
  Version: 0.45.10
  Commit: 15746f716efa868ebac16b1675bad2714d6c27d0
  ...

The script will extract version and commit information, download the appropriate
binary package, and install it to ~/.cursor-server/bin/
EOF
}

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check for help flag
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_help
    exit 0
fi

# Read input from file or stdin
if [[ -n "$1" ]]; then
    if [[ ! -f "$1" ]]; then
        error_exit "Input file '$1' does not exist"
    fi
    input=$(cat "$1")
else
    input=$(cat)
fi

# Check if input is empty
if [[ -z "$input" ]]; then
    show_help
    exit 1
fi

# Extract version and commit, stripping whitespace
version=$(echo "$input" | grep "^Version:" | sed -E 's/^Version:[[:space:]]*([0-9.]+)[[:space:]]*$/\1/')
commit=$(echo "$input" | grep "^Commit:" | sed -E 's/^Commit:[[:space:]]*([a-f0-9]{40})[[:space:]]*$/\1/')

# Validate version and commit
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error_exit "Invalid version format. Expected format: X.Y.Z (e.g., 0.45.10)"
fi

if [[ ! "$commit" =~ ^[a-f0-9]{40}$ ]]; then
    error_exit "Invalid commit format. Expected 40-character hexadecimal string"
fi

# Create target directory
target_dir="$HOME/.cursor-server/bin/$commit"
mkdir -p "$target_dir" || error_exit "Failed to create directory $target_dir"

# Set up temporary directory
temp_dir=$(mktemp -d) || error_exit "Failed to create temporary directory"
cleanup() {
    rm -rf "$temp_dir"
}
trap cleanup EXIT

# Download and extract
url="https://cursor.blob.core.windows.net/remote-releases/$version-$commit/vscode-reh-linux-x64.tar.gz"
echo "Downloading from $url..."

if ! curl -L --fail "$url" -o "$temp_dir/package.tar.gz"; then
    error_exit "Failed to download package"
fi

echo "Extracting package..."
if ! tar -xzf "$temp_dir/package.tar.gz" -C "$temp_dir"; then
    error_exit "Failed to extract package"
fi

echo "Installing to $target_dir..."
if ! mv "$temp_dir/vscode-reh-linux-x64"/* "$target_dir/"; then
    error_exit "Failed to move files to target directory"
fi

echo "Successfully installed Cursor server binaries"
