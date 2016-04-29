<?php
require_once APP_PATH . '/vendor/autoload.php';
require 'Jxn/Protoforge.php';

$app = new \Jxn\Protoforge(WEB_PATH, $uri);

$loader = new \Twig_Loader_Filesystem(WEB_PATH);
$twig = new \Twig_Environment($loader);
$templateFile = $app->getTemplateByUri($uri);

if (isset($opts['p'])) {
    foreach ($app->getPublicPages() as $page) {
        echo "$page\n";
    }
    exit;
}

if (in_array($uri, $noPassUriList)) {
    $publicPages = $app->getPublicPages();
    echo $twig->render('./_default.html.twig', [
        'pages' => $publicPages,
    ]);
} else {
    $pageName = $app->getPageNameByUri($uri);

    $parameters = [
        'page_title' => $app->formatPageName($pageName),
    ];
    if ($app->pageHasVariableFile($pageName)) {
        include $app->getPageVariableFile($pageName);
    }
    $parameters += (isset($_GET) && !empty($_GET)) ? $_GET: [];

    echo $twig->render($templateFile, $parameters);
}
