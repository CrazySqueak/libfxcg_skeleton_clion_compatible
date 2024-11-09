#include <fxcg/display.h>
#include <fxcg/keyboard.h>

#include "adder.h"
 
void main(void) {
    int key;
     
    Bdisp_AllClr_VRAM();
    Print_OS("Press EXE to exit", 0, 0);

    int x = add(1,2);
    if (x == 3) Print_OS("1+2=3 :)", 0, 0);

    while (1) {
        GetKey(&key);

        if (key == KEY_CTRL_EXE) {
            break;
        }
    }
 
    return;
}
