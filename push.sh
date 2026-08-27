#!/bin/bash

message="Changes on $(date)"
echo "Push message: $message"

git add .
git commit -a -m "$message"
git push

