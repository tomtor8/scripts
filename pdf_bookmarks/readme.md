# Introduction
- this shell script changes the csv file (see example inputfile.csv) into outputfile.txt (see example outputfile.txt)

# Background
- this script helps simplify the creation of PDF bookmarks or outlines for the `pdftk-java` generated metadata file
- outlines in this file must be formatted as shown in the `outputfile.txt`
- the `inputfile.csv` must follow the syntax shown in the example inputfile.csv

**Metadata file creation from a pdf**

```bash
pdftk input.pdf dump_data_utf8 output bookmarks_utf8.txt
```

# Usage
`create-bookmarks <inputfile name>`
- the script takes one positional argument that is not optional (the name of the csv input file)
- after creating the output file (the name of the created file is the original basename plus -processed.txt) you can check the contents of the file and copy it
- then paste the final product to the metadata file and use `pdftk` to apply the changes to the PDF file

**Updating the PDF metadata** 

```bash
pdftk input.pdf update_info_utf8 bookmarks_utf8.txt output output_with_bookmarks.pdf
```

## Note
- you can have leading or trailing spaces or tabs around the items in the input csv file - the script handles this problem
- e.g. `1  |23     |   Some title    `
