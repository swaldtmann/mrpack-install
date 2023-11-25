# Modrinth Modpack Installer

This is a simple Bash script for installing a Modrinth modpack based on a provided modrinth.index.json file.

This script is a part of the [Feather Panel](https://github.com/FeatherPanel/FeatherPanel) project.

## Usage

```bash
./mrpack-install.sh <json_file> [output_dir] [side]
```

-   `<json_file>`: The JSON file containing information about the modpack.
-   `[output_dir]` (optional): The directory where the modpack will be installed. If not provided, the current directory will be used.
-   `[side]` (optional): The side (client or server) for which the modpack will be installed. If not provided, the client side will be used.

## Prerequisites

-   **jq**: JSON processor

    -   Ensure that jq is installed on your system.

-   **wget**: File downloader
    -   Ensure that wget is installed on your system.

## Installation Process

1. **Check JSON File**: Ensure that a valid JSON file is provided as an argument.

    ```bash
    ./install_modpack.sh <json_file>
    ```

2. **Check jq Installation**: Verify that jq is installed.

3. **Download Mod Files**: Download the mod files specified in the JSON file.

4. **Copy Overrides**: Copy overrides from the 'overrides' directory to the installation directory.

5. **Completion Message**: Display a completion message with the installation details, including the time taken.

## Example

```bash
./install_modpack.sh modrinth.index.json /path/to/installation/directory server
```

## Modrinth Documentation

-   [Modpack Format](https://docs.modrinth.com/modpacks/format)
