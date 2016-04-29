<?php

$uri = '';
$opts = isset($argv) ? getopt('u:p', ['uri:', 'pages']): [];
if (isset($opts) && (array_key_exists('uri', $opts) || array_key_exists('u', $opts) )) {
    $uri = array_key_exists('uri', $opts) ? $opts['uri'] : $opts['u'];
} elseif (isset($_SERVER) && array_key_exists('REQUEST_URI', $_SERVER)) {
    $uri = $_SERVER['REQUEST_URI'];
}

define('WEB_PATH', __DIR__);
define('APP_PATH', __DIR__ . '/..');
define('LIB_PATH', APP_PATH . '/lib');

$noPassUriList = [ '', '/', '//', ];

// pass through assets if a file exists and isn't in the exception list
if (!in_array($uri, $noPassUriList) && file_exists(APP_PATH . $uri)) {
    return false;
} else {
    require_once LIB_PATH . '/init.php';
}
