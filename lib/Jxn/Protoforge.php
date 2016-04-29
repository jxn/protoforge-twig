<?php

namespace Jxn;

class Protoforge
{
    protected $templatePath;
    protected $templateExt = '.html.twig';
    protected $variableFileExt = '.php';

    public function __construct($templatePath)
    {
        $this->templatePath = $templatePath;
    }

    public function getPublicPages()
    {
        return array_diff($this->getAllPages(), $this->getHiddenPages());
    }

    public function getAllPages()
    {
        $pages = [];
        $files = $this->getAllPagesFiles();
        foreach ($files as $file) {
            $pages[] = $this->getTemplateNameFromFile($file);
        }
        return $pages;
    }

    public function getAllPagesFiles()
    {
        return glob($this->templatePath . '/*' . $this->templateExt);
    }

    public function getTemplateNameFromFile($filename)
    {
        return substr(pathinfo($filename, PATHINFO_BASENAME), 0, -1 * strlen($this->templateExt));
    }

    public function getHiddenPages()
    {
        $pages = [];
        $files = $this->getHiddenPagesFiles();
        foreach ($files as $file) {
            $pages[] = $this->getTemplateNameFromFile($file);
        }
        return $pages;
    }

    public function getHiddenPagesFiles()
    {
        return glob($this->templatePath . '/_*' . $this->templateExt);
    }

    public function getTemplateByUri($uri)
    {
        // remove query string
        return $this->getPageNameByUri($uri) . $this->templateExt;
    }

    public function getPageNameByUri($uri)
    {
        // remove query string
        return parse_url($uri)['path'];
    }

    public function formatPageName($name)
    {
        return ucfirst(preg_replace('/[^A-Za-z0-9]/', ' ', trim(trim($name, ' '), '/')));
    }

    public function pageHasVariableFile($pageName)
    {
        return file_exists($this->templatePath . $pageName . $this->variableFileExt);
    }

    public function getPageVariableFile($pageName)
    {
        return $this->templatePath . $pageName . $this->variableFileExt;
    }
}
