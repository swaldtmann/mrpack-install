#!/bin/bash

start=$(date +%s)

# Check if json file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <json_file>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is not installed."
    exit 1
fi

json_file=$1
output_dir=${2:-.}
output_dir=${output_dir%/}
side=${3:-client}

# Check if file exists
if [ ! -f $json_file ]; then
    echo "The files $json_file does not exist."
    exit 1
fi

# Create output dir if it doesn't exist
mkdir -p $output_dir

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

end=$(date +%s)
echo -e "\n$name installed at $(realpath $output_dir) in $(($end - $start)) seconds."
