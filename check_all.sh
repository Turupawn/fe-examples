#!/bin/bash

directory="src"

if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

temp_file=$(mktemp)
trap 'rm -f $temp_file' EXIT

find "$directory" -type f -name "*.fe" | while read -r file; do
  echo "Checking: $file"
  ./fe-driver2 "$file"
  echo $? >> "$temp_file"
  if [[ $? != 0 ]]; then
    echo "Not Good"
  fi
  echo "----------------------------------------"
done

if grep -q -v "^0$" "$temp_file"; then
  echo "Some checks failed."
  exit 1
fi

echo "All checks were successful."
exit 0