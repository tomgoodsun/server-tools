<?php
class CliArgs
{
    /**
     * @var string
     */
    private $script;

    /**
     * @var array
     */
    private $args = [];

    /**
     * Constructor
     */    
    public function __construct()
    {
        $this->parseArg();
    }

    /**
     * Parse command line arguments
     */    
    private function parseArg()
    {

        foreach ($_SERVER['argv'] as $i => $arg) {
            if (0 == $i) {
                $this->script = $arg;
                continue;
            }

            if (preg_match('/^\-\-[a-zA-Z0-9\-_].*=/', $arg)) {
                $pos = strpos($arg, '=');
                $this->arg[substr($arg, 0, $pos)] = substr($arg, $pos + 1);
            } elseif (preg_match('/^\-\-[a-zA-Z0-9\-_].+$/', $arg)) {
                $this->args[preg_replace('/^\-\-/', '', $arg)] = true;
            } elseif (preg_match('/^\-[a-zA-Z0-9].$/', $arg)) {
                $this->args[preg_replace('/^\-/', '', $arg)] = true;
            }
        }

        var_dump($this->args);
    }

    /**
     * Get argument value
     *
     * @return null|bool|string|int
     */    
    public function getArg($name)
    {
        if (array_key_exists($name, $this->arg)) {
            return $this->arg[$name];
        }
        return null;
    }
}

