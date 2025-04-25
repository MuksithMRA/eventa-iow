#!/bin/bash

# Script to remove comments from JavaScript files in the eventa-api directory
# Usage: ./remove_js_comments.sh

TARGET_DIR="/Users/htworks/repos/eventa/eventa-api"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Removing comments from JavaScript files in $TARGET_DIR..."

# Find all JavaScript files in the target directory, excluding node_modules
find "$TARGET_DIR" -name "*.js" -type f -not -path "*/node_modules/*" | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Remove single-line comments (// ...)
    # Remove multi-line comments (/* ... */)
    # Preserve strings with comments inside them
    # Preserve RegExp patterns that might look like comments
    perl -0777 -pe '
        # Handle strings first to protect them
        s/(["'\''`])((?:\\\\.|(?!\1).)*)\1/$1$2$1/g;
        
        # Handle RegExp patterns
        s/\/((?:\\\\.|[^\/\n])+)\/([gim]{0,3})/"\/REGEXP\/"/g;
        
        # Remove single-line comments
        s/\/\/.*$//gm;
        
        # Remove multi-line comments
        s/\/\*[\s\S]*?\*\///g;
        
        # Clean up empty lines and multiple consecutive empty lines
        s/^\s*$//gm;
        s/\n{3,}/\n\n/g;
    ' "$file" > "$temp_file"
    
    # Replace the original file with the modified content
    mv "$temp_file" "$file"
done

echo "Comment removal completed for JavaScript files in eventa-api!"
