<?php
require_once __DIR__ . '/../include.php';

class SampleCli
{
    /**
     * @return \Closure
     */    
    public static function getJudgingFunction()
    {
        return function ($input) {
            if ($input == "no\n" || $input == "yes\n") {
                return true;
            }
            return false;
        };
    }

    /**
     * @return \Closure
     */    
    public static function getNextFunction()
    {
        return function ($input) {
            echo $input . "\n";
        };
    }
}

CliLib::readInput(
    'Type \'yes\' or \'no\': ',
    SampleCli::getJudgingFunction(),
    SampleCli::getNextFunction(),
    'Answer just \'yes\' or \'no\': '
);

