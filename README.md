# Modrinth Modpack Installer

This is a simple Bash script for installing a Modrinth modpack based on a provided modrinth.index.json file.

This script is a part of the [Feather Panel](https://github.com/FeatherPanel/FeatherPanel) project.

## Usage

```bash
./mrpack-install.sh <input_file> [output_dir] [side] [auto_delete] [silent]
```

-   `<input_file>`: The modrinth.index.json or .mrpack file.
-   `[output_dir]` (optional): The directory where the modpack will be installed. If not provided, the current directory will be used.
-   `[side]` (optional): The side (client or server) for which the modpack will be installed. If not provided, the client side will be used.
-   `[auto_delete]` (optional): Whether or not to automatically delete the modpack json file and overrides folder after installation. If not provided, the modpack will not be deleted.
-   `[silent]` (optional): Whether or not to show messages during installation.

## Prerequisites

-   **jq**: JSON processor

    -   Ensure that jq is installed on your system.

-   **wget**: File downloader
    -   Ensure that wget is installed on your system.

## Installation Process

1. **Check JSON File**: Ensure that a valid JSON file is provided as an argument.

    ```bash
    ./install_modpack.sh <input_file>
    ```

2. **Check jq Installation**: Verify that jq is installed.

3. **Download Mod Files**: Download the mod files specified in the JSON file.

4. **Copy Overrides**: Copy overrides from the 'overrides' directory to the installation directory.

5. **Completion Message**: Display a completion message with the installation details, including the time taken.

## Example

```bash
./install_modpack.sh modrinth.index.json /path/to/installation/directory server true true
```

## Modrinth Documentation

-   [Modpack Format](https://docs.modrinth.com/modpacks/format)
