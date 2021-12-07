<?php
require_once __DIR__ . '/../include.php';

$judgingFunction = function ($input)
{
    if ($input == "no\n" || $input == "yes\n") {
        return true;
    }
    return false;
};

$msg = 'Answer just \'yes\' or \'no\': ';
$apple = CliUtil::readInput('Do you like apple? (yes / no): ', $judgingFunction, $msg);
$banana = CliUtil::readInput('Do you like banana? (yes / no): ', $judgingFunction, $msg);
$coffee = CliUtil::readInput('Do you like coffee? (yes / no): ', $judgingFunction, $msg);

if (CliArgs::getArg('a')) {
    echo "'a' is in command line args.\n";
}

if (CliArgs::getArg('long-arg')) {
    echo "'long-arg' is in command line args.\n";
}

if (!empty(CliArgs::getArg('long-arg-with'))) {
    echo "'long-arg-with' is in command line args and value is '" . CliArgs::getArg('long-arg-with') . "'.\n";
}

echo "You like apple: " . $apple . "\n";
echo "You like banana: " . $banana . "\n";
echo "You like coffee: " . $coffee . "\n";

