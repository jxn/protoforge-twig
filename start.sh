#! /bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR_NAME="$(basename $BASE_DIR)"
TMP_DIR="$BASE_DIR""/.tmp"
HTDOCS="$BASE_DIR"'/htdocs'
PORT='8080'

# Set a custom port
if [[ ! -z "$1" ]]; then
    PORT="$1"
fi

cd "$BASE_DIR"
if grep -q 'jxn/protoforge-twig.git' '.git/config' ; then
    echo "Removing temporary git repo..."
    rm -Rf '.git/'
    echo 'done.'
    echo "Initializing new Git repo..."
    git init
fi

cd "$BASE_DIR"
if [ -f "composer.json" ] ; then

    echo "Running composer install"
    cd "$BASE_DIR"

    global_composer=$(command -v composer 2>/dev/null)
    if [ "$global_composer" != "" ] ; then
        echo "Using global composer"
        composer install
    else
        if [ ! -f "composer.phar" ] ; then
            if type wget 2>/dev/null; then
                wget 'https://getcomposer.org/composer.phar'
            else
                echo "You need to install wget"
                echo "Maybe do 'brew install wget' if you use OS X"
                echo "Please install it and run this {$0} again."
                exit 1
            fi
        fi
        php -d detect_unicode=Off composer.phar install
    fi
fi

if [ ! -d "$TMP_DIR" ]; then
    echo "creating temp dir"
    mkdir "$TMP_DIR"
fi

echo "Opening htdocs directory"
cd "$HTDOCS"

echo "Running PHP server on port ""$PORT"
echo "Visit http://localhost:""$PORT""/"
echo "To specify a port, pass it as an argument to the start.sh script"
echo "e.g. ""$0"" ""8082"

echo "$PORT" > "$TMP_DIR""/http-port"

php -S "localhost:""$PORT"
