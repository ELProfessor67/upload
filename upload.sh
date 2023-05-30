#!/bin/bash

cloud_name="dxtul5fpg"
api_key="215411642249283"
api_secret="8tINVtFK3wY5gvXVOpl9OmZ72L8"

get_file_extension() {
    file_path=$1
    file_extension="${file_path##*.}"
    echo "$file_extension"
}


directory=$(pwd)
images=$(ls "$directory")

valid_extensions=("png" "jpg" "jpeg")
upload_url="https://api.cloudinary.com/v1_1/$cloud_name/image/upload"

for image in $images; do
    extension=$(get_file_extension "$image")

    if [[ " ${valid_extensions[@]} " =~ " ${extension} " ]]; then
      timestamp=$(date +%s)
      signature=$(echo -n "timestamp=${timestamp}${api_secret}" | sha1sum)
      
      response=$(curl -X POST -F "file=@$image" -F "timestamp=$timestamp" -F "api_key=$api_key" -F "signature=${signature%???}" $upload_url)
      public_url=$(echo "$response" | grep -o 'https://res.cloudinary.com/[^"]*')
      echo "Public URL: $public_url"
    else
        echo "Not a valid image"
    fi
done