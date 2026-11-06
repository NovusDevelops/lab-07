#!/usr/bin/env bash

for i in {1..4}; do
  # get the input folder
  input_dir="Testcase$i" 
  diff_dir="${input_dir}Diff"
  passed=1

  # loop through all the files
  for file_1 in "$input_dir"/*.1.txt; do
    file_2="${file_1%.1.txt}.2.txt"  # get 2nd txt file
    [ -f "$file_2" ] || continue  # skip if 2nd txt is missing
    
    version=$(basename "$file_1" .1.txt)
    diff_file="$diff_dir/${version}Diff.txt"

    if ! cmp -s "$file_1" "$file_2"; then
    
      # files differ make sure dif_folder exist
      if [ ! -d "$diff_dir" ]; then  # doesn't exist diff folder
        passed=0
        break
      elif [ ! -f "$diff_file" ]; then  # diff file doesnt exist
        passed=0
        break
      # check diff file to make sure it is correct
      elif ! cmp -s <(diff -u "$file_1" "$file_2" | tail -n +3) <(tail -n +3 "$diff_file"); then
        passed=0
        break
      fi
    else
      # files are the same, make sure diff file doesn't exist
      if [ -d "$diff_dir" ] && [ -f "$diff_file" ]; then  # diff file exist when it shouldnts
        passed=0
        break
      fi
    fi
  done

  if [ $passed -eq 1 ]; then
    echo "Testcase$i: Passes"
  else
    echo "Testcase$i: Fails"
  fi  
done