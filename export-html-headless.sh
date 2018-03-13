#! /bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR="$BASE_DIR""/.tmp"
BASE_DIR_NAME="$(basename $BASE_DIR)"
HTDOCS="$BASE_DIR"'/htdocs'
EXPORT_DIR="$BASE_DIR"'/exported-html'
FILE_SUFFIX=".html"
PATH_TYPE='relative'

if [[ ! -d "$EXPORT_DIR" ]]; then
    echo "Creating export directory: ""$EXPORT_DIR"
    mkdir "$EXPORT_DIR"
fi

function render_page () {
    local page="$1"
    if [[ "$PATH_TYPE" = "relative" ]]; then
        echo "Exporting ""$PAGE"" with relative paths and file suffix ""$FILE_SUFFIX"
        # fix absolute css/js paths
        # add file suffixes to local links
        # fix absolute links
        php htdocs/index.php -u "$page" | sed 's#</head>#<META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW"></head>#g' | sed 's#src="/#src="#g' | sed -E 's#href="/([^"]*)#href="\1'"$FILE_SUFFIX"'#g' | sed 's#href="/#href="#g' > "$EXPORT_DIR/$page""$FILE_SUFFIX"
    else
        echo "Exporting ""$PAGE"" with file suffix ""$FILE_SUFFIX"
        php htdocs/index.php -u "$PAGE" | sed 's#</head>#<META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW"></head>#g' | sed -E 's#href="/([^"]*)#href="\1'"$FILE_SUFFIX"'#g' > "$EXPORT_DIR/$PAGE""$FILE_SUFFIX"
    fi
}

echo "Copying files to export directory"
cp -RL "$HTDOCS/"* "$EXPORT_DIR/"

echo "removing PHP and twig files from export"
rm -R "$EXPORT_DIR/"*".html.twig"
rm -R "$EXPORT_DIR/"*".php"

echo "Compiling HTML from twig files"

render_page index

for PAGE in $(php htdocs/index.php -p); do
    render_page "$PAGE"
done
echo "Done."

exit 0
