<?php
class CliLibs
{
    /**
     * Wait and read stdin
     *
     * @param string $questionMsg
     * @param \Closure $judgingFunction
     * @param \Closure $nextFunction
     * @param string $msgForUnexceptedAction
     * @return void
     */    
    public static function readInput(
        string $questionMsg,
        \Closure $judgingFunction,
        \Closure $nextFunction,
        string $msgForUnexceptedAction
    ) {
        echo $questionMsg;
        $input = null;
        $inputReceived = false;
        while (false == $inputReceived) {
            $input = fgets(STDIN, 4096);
            $inputReceived = $judgingFunction($input);
            if (false == $inputReceived) {
                echo $msgForUnexceptedAction;
            }
        }
        $nextFunction(trim($input));
    }
}

