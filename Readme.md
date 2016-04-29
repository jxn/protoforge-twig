# Protoforge
Protoforge-twig is a tiny, junky little application to make it easier to rapidly prototype frontend html/css/js with the Twig language.

## Requirements
* PHP 5.4+
* Bash (for convenience CLI scripts to run and export HTML)
* CURL (for html export)
* git
* wget

## Set Up
1. Clone this repo into a new directory for your prototype/project: `git clone https://github.com/jxn/protoforge-twig.git YOUR_PROJECT_NAME`
2. cd into that new directory `cd YOUR_PROJECT_NAME`
3. Run `./start.sh`

The start.sh script will remove the .git directory to prepare for your new project.  It also runs composer (installing if necessary), installs twig in the project, starts the php built-in webserver, by default on port 8080.  If you need to specify a different port, pass it in as the first argument, like this: `./start.sh 8082`

## Usage
Once the server is started, just visit your the site in your browser (http://localhost:8080 if you did not change the port).
To add a page, put a new file with a '.html.twig' extension in the "htdocs" folder, for example "test_page.html.twig".  It will appear on the index page list when you refresh your browser.  Pages that start with underscores will not be shown on the index page, so name your layouts like "_layout1.html.twig" and "_header.html.twig", etc.  You can use twig variables, filters, functions, and logic.  See the twig documentation for more details.  You can pass in twig variables by setting them in twig templates, by using a PHP file with a $parameters['var'] = 'value'; array, or by adding HTTP GET parameters to your URL.  Check out the code in the demo.html.twig and demo.php files for more info.

## Exporting HTML
If you want to export the HTML files, run the `./export-html.sh` script, then grab the files out of the "exported-html" folder in the project root.  Delete the folder before exporting again to ensure it is clean.

## Stopping the web server
To stop the web server, hit "CTRL + C" in the terminal where you ran ./start.sh
