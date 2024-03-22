import os

def append_file_contents_to_output(start_directory, output_file_path):
    """
    Appends the contents of each file in the directory and subdirectories
    to the output file, prefixed with the file name and relative directory path.
    """
    for root, _, files in os.walk(start_directory):
        for filename in files:
            file_path = os.path.join(root, filename)
            # Constructing relative path and filename info to add to the output file
            relative_path = os.path.relpath(root, start_directory)
            header = f"{'='*20}\nPath: {relative_path}\nFile: {filename}\n{'='*20}\n"
            with open(output_file_path, 'a') as output_file:
                output_file.write(header)
                with open(file_path, 'r') as file:
                    file_contents = file.read()
                    output_file.write(file_contents + "\n\n")

# Set the path to the directory containing the files
source_directory = '/home/sam/MicroBlogOps/ansible'
# Set the path and name of the output text file
output_file_path = '/home/sam/MicroBlogOps/copyoutput.txt'

# Ensure the output file is empty or create it if it doesn't exist
with open(output_file_path, 'w') as f:
    pass

append_file_contents_to_output(source_directory, output_file_path)

print(f"All file contents have been appended to {output_file_path}")
