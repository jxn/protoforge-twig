#! /bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR="$BASE_DIR""/.tmp"
BASE_DIR_NAME="$(basename $BASE_DIR)"
HTDOCS="$BASE_DIR"'/htdocs'
EXPORT_DIR="$BASE_DIR"'/exported-html'
PORT='8080'
FILE_SUFFIX=".html"
PATH_TYPE='relative'

if [[ ! -z "$1" ]]; then
    PORT="$1"
else
    if [[ -f "$TMP_DIR/http-port" ]]; then
        PORT=$(cat "$TMP_DIR/http-port")
    fi
fi

if [[ ! -d "$EXPORT_DIR" ]]; then
    echo "Creating export directory: ""$EXPORT_DIR"
    mkdir "$EXPORT_DIR"
fi

echo "Compiling HTML from server on port ""$PORT"
echo "make sure ./start.sh is running.  http://localhost:""$PORT""/"
echo "To specify a port, pass it as an argument to the script."
echo "e.g. ""$0"" ""8081"

echo "Copying files to export directory"
cp -R "$HTDOCS/"* "$EXPORT_DIR/"

echo "removing PHP and twig files from export"
rm -R "$EXPORT_DIR/"*".html.twig"
rm -R "$EXPORT_DIR/"*".php"

echo "Compiling HTML from twig files"

for PAGE in $(php "$HTDOCS"/index.php -p); do
    echo "http://localhost:""$PORT""/""$PAGE"

    if [[ "$PATH_TYPE" = "relative" ]]; then
        echo "Exporting ""$PAGE"" with relative paths and file suffix ""$FILE_SUFFIX"
        curl "http://localhost:""$PORT""/""$PAGE" |sed 's#src="/#src="#g' | sed 's#href="/#href="#g' > "$EXPORT_DIR/$PAGE""$FILE_SUFFIX"
    else
        echo "Exporting ""$PAGE"" with file suffix ""$FILE_SUFFIX"
        curl "http://localhost:""$PORT""/""$PAGE" > "$EXPORT_DIR/$PAGE""$FILE_SUFFIX"
    fi
done
