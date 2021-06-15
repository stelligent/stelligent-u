class MoreStyle:
    '''
    Summary: Reset all colors with MoreStyle.reset; two
    sub classes Fg for foreground and Bg for background; 
    use as MoreStyle.subclass.colorname. # i.e. MoreStyle.Fg.RED or 
    MoreStyle.bg.GREEN also, the generic BOLD, DISABLE, # UNDERLINE, 
    REVERSE, STRIKETHROUGH, # and INVISIBLE work with the main 
    class i.e. MoreStyle.BOLD
    ''' 
    RESET='\033[0m'
    BOLD='\033[01m'
    DISABLE='\033[02m'
    UNDERLINE='\033[04m'
    REVERSE='\033[07m'
    STRIKETHROUGH='\033[09m'
    INVISIBLE='\033[08m'
    class Fg:
        BLACK='\033[30m'
        RED='\033[31m'
        GREEN='\033[32m'
        ORANGE='\033[33m'
        BLUE='\033[34m'
        PURPLE='\033[35m'
        CYAN='\033[36m'
        LIGHTGREY='\033[37m'
        DARKGREY='\033[90m'
        LIGHTRED='\033[91m'
        LIGHTGREEN='\033[92m'
        YELLOW='\033[93m'
        LIGHTBLUE='\033[94m'
        PINK='\033[95m'
        LIGHTCYAN='\033[96m'
    class Bg:
        BLACK='\033[40m'
        RED='\033[41m'
        GREEN='\033[42m'
        ORANGE='\033[43m'
        BLUE='\033[44m'
        PURPLE='\033[45m'
        CYAN='\033[46m'
        LIGHTGREY='\033[47m'


class MinStyle():
    """
    Summary: Provides a minimal color and style implementation
    """
    BLACK='\033[30m'
    RED='\033[31m'
    GREEN='\033[32m'
    ORANGE='\033[33m'
    BLUE='\033[34m'
    PURPLE='\033[35m'
    CYAN='\033[36m'
    LIGHTGREY='\033[37m'
    DARKGREY='\033[90m'
    LIGHTRED='\033[91m'
    LIGHTGREEN='\033[92m'
    YELLOW='\033[93m'
    LIGHTBLUE='\033[94m'
    PINK='\033[95m'
    LIGHTCYAN='\033[96m'
    WHITE = '\033[97m'
    UNDERLINE = '\033[4m'
    RESET = '\033[0m'
    DIV_DOUBLE='================================================================================================'
    DIV_SINGLE_LONG='------------------------------------------------------------------------------------------------'
    DIV_SINGLE_SHORT='--------------------------------------'