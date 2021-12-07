<?php
abstract class Command
{
    protected $options = [];

    /**
     * Costructor
     *
     * @param array $options
     */
    public function __construct(array $options = [])
    {
        $this->options = $options;
    }

    /**
     * Get argument value
     *
     * @return null|bool|string|int
     */
    final protected function getArg(string $name)
    {
        return CliArgs::getArg($name);
    }

    /**
     *
     */
    public function execute()
    {
        $this->main();
    }

    /**
     * Wait and read stdin
     *
     * @param string $questionMsg
     * @param \Closure $judgingFunction
     * @param string $msgForUnexceptedAction
     * @return mixed
     */    
    final protected function readInput(
        string $questionMsg,
        \Closure $judgingFunction,
        string $msgForUnexceptedAction
    ) {
        return CliUtil::readInput($questionMsg, $judgingFunction, $msgForUnexceptedAction);
    }

    /**
     * Main routine
     */
    abstract protected function main();
}

