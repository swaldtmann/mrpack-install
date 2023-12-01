#!/bin/bash

start=$(date +%s)

# Check if json file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is not installed."
    exit 1
fi

input_file=$1
output_dir=${2:-.}
output_dir=${output_dir%/}
side=${3:-client}
autodelete=${4:-false}

# Check if file exists
if [ ! -f $input_file ]; then
    echo "The file $input_file does not exist."
    exit 1
fi

# Create output dir if it doesn't exist
mkdir -p $output_dir

if [[ $input_file == modrinth.index.json ]]; then
    json_file=$input_file
elif [[ $input_file == *.mrpack ]]; then
    unzip -q "$input_file" -d .
    json_file=modrinth.index.json

    if [ ! -f $json_file ]; then
        echo "The file $input_file is not a valid mrpack file."
        exit 1
    fi
else
    echo "The file $input_file must be modrinth.index.json or mrpack file."
    exit 1
fi

name=$(jq -r '.name' $json_file)
echo "Installing modpack $name..."
echo "Downloading files..."

# Get the list of downloads and paths
downloads=($(jq -r '.files[].downloads[0]' $json_file))
paths=($(jq -r '.files[].path' $json_file))

# Loop through the downloads and paths
while IFS= read -r line; do
    download=$(echo $line | jq -r '.downloads[0]')
    path=$(echo $line | jq -r '.path')

    echo "Downloading $path..."

    # Create the directory if it doesn't exist
    mkdir -p $output_dir/$(dirname $path)

    # Download the file
    wget -q --show-progress $download -O $output_dir/$path

    echo "Done."
done < <(jq -c '.files[]' $json_file)

echo "All downloads completed."
echo "Copying overrides..."

# Copy overrides
if [ $side = "client" ]; then
    if [ -d overrides ]; then
        cp -r overrides/* $output_dir
    fi

    if [ -d client-overrides ]; then
        cp -r client-overrides/* $output_dir
    fi
else
    if [ -d server-overrides ]; then
        cp -r server-overrides/* $output_dir
    fi
fi

cp -r overrides/* $output_dir

# Auto delete
if [ $autodelete = "true" ]; then
    echo "Deleting overrides..."
    rm -rf overrides
    rm -rf client-overrides
    rm -rf server-overrides

    echo "Deleting json file..."
    rm $json_file

    echo "Done."
fi

end=$(date +%s)
echo -e "\n$name installed at $(realpath $output_dir) in $(($end - $start)) seconds."
