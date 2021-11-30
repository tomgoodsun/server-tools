<?php
require_once __DIR__ . '/../include.php';

$judgingFunction = function ($input)
{
    if ($input == "no\n" || $input == "yes\n") {
        return true;
    }
    return false;
};

$nextFunction = function ($input)
{
    echo $input . "\n";
};

CliLibs::readInput(
    'Type \'yes\' or \'no\': ',
    $judgingFunction,
    $nextFunction,
    'Answer just \'yes\' or \'no\': '
);

