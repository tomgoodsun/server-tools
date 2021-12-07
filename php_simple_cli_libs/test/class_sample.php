<?php
require_once __DIR__ . '/../include.php';

class SampleCli extends Command
{
    private $apple = '';
    private $banana = '';
    private $coffee = '';

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

    protected function main()
    {
        $msg = 'Answer just \'yes\' or \'no\': ';
        $this->apple = $this->readInput(
            'Do you like apple? (yes / no): ',
            function ($input) {
                if ($input == "no\n" || $input == "yes\n") {
                    return true;
                }
            },
            $msg
        );

        $this->banana = $this->readInput(
            'Do you like banana? (yes / no): ',
            function ($input) {
                if ($input == "no\n" || $input == "yes\n") {
                    return true;
                }
            },
            $msg
        );

        $this->coffee = $this->readInput(
            'Do you like coffee? (yes / no): ',
            function ($input) {
                if ($input == "no\n" || $input == "yes\n") {
                    return true;
                }
            },
            $msg
        );

        if ($this->getArg('a')) {
            echo "'a' is in command line args.\n";
        }

        if ($this->getArg('long-arg')) {
            echo "'long-arg' is in command line args.\n";
        }

        if (!empty($this->getArg('long-arg-with'))) {
            echo "'long-arg-with' is in command line args and value is '" . $this->getArg('long-arg-with') . "'.\n";
        }

        echo "You like apple: " . $this->apple . "\n";
        echo "You like banana: " . $this->banana . "\n";
        echo "You like coffee: " . $this->coffee . "\n";
    }
}

(new SampleCli)->execute();

