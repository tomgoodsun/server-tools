<?php
class CliUtil
{
    /**
     * Wait and read stdin
     *
     * @param string $questionMsg
     * @param \Closure $judgingFunction
     * @param string $msgForUnexceptedAction
     * @return void
     */    
    public static function readInput(string $questionMsg, \Closure $judgingFunction, string $msgForUnexceptedAction)
    {
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
        return trim($input);
    }
}

