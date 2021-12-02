<?php
class CliArgs
{
    /**
     * @var string
     */
    private static $scriptPath;

    /**
     * @var string
     */
    private static $scriptFullPath;

    /**
     * @var array
     */
    private static $args = [];

    /**
     * Initialize
     */
    public static function init()
    {
        self::parseArg();
    }

    /**
     * Parse command line arguments
     */    
    private static function parseArg()
    {

        foreach ($_SERVER['argv'] as $i => $arg) {
            if (0 == $i) {
                self::$scriptPath = $arg;
                self::$scriptFullPath = $_SERVER['PWD'] . DIRECTORY_SEPARATOR . $arg;
                continue;
            }

            if (preg_match('/^\-\-[a-zA-Z0-9\-_].*=/', $arg)) {
                $pos = strpos($arg, '=');
                self::$args[substr($arg, 2, $pos - 1)] = substr($arg, $pos + 1);
            } elseif (preg_match('/^\-\-[a-zA-Z0-9\-_].+$/', $arg)) {
                self::$args[preg_replace('/^\-\-/', '', $arg)] = true;
            } elseif (preg_match('/^\-[a-zA-Z0-9]$/', $arg)) {
                self::$args[preg_replace('/^\-/', '', $arg)] = true;
            }
        }
    }

    /**
     * Get script path
     *
     * @return string
     */
    public static function getScriptPath()
    {
        return self::$scriptPath;
    }

    /**
     * Get script full path
     *
     * @return string
     */
    public static function getScriptFullPath()
    {
        return self::$scriptFullPath;
    }

    /**
     * Get argument value
     *
     * @return null|bool|string|int
     */
    public static function getArg($name)
    {
        if (array_key_exists($name, self::$args)) {
            return self::$args[$name];
        }
        return null;
    }
}

