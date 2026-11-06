#!/usr/bin/env bash

for i in {1..4}; do
    # get the input folder
  input_dir="Testcase$i" 
  output_dir="${input_dir}Diff"

  rm -rf "$output_dir"  # clear from prior runs incase

  # loop through all the files
  for file_1 in "$input_dir"/*.1.txt; do
    file_2="${file_1%.1.txt}.2.txt"  # get 2nd txt file
    [ -f "$file_2" ] || continue  # skip if 2nd txt is missing

    if ! cmp -s "$file_1" "$file_2"; then
    
      # files differ create a diff file
      mkdir -p "$output_dir"
      version="${file_1%.1.txt}"
      
      diff_file="$output_dir/${version}Diff.txt"
      diff "$file_1" "$file_2" > "$diff_file"
    fi
  done
  

  
done