org 0x7c00 ; origin of the bootloader
bits 16 ; we're in 16-bit real mode

start:

    ; put your code here

 
; !! these two lines must stay at the end of the file !!
times 510 - ($-$$) db 0 ; pad the file with 0s to make it 512 bytes
dw 0xAA55 ; magic number
