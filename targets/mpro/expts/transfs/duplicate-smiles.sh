#!/usr/bin/env bash

input=$1
while IFS= read -r line
do
  echo "$line $line"
done < "$input"