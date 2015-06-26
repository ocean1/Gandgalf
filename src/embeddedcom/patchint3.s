cpu 286
org 100h

start:
    mov si 
    call intgetaddr
    mov [ds:si], 0cfh
    mov ah,04Ch
    int 21h
    ret
intgetaddr:
    ; pass via SI the interrupt number
    xor ax, ax
    mov  ds, ax     ;...to DS register
    shl si, 2
    push word[ds:si+02]   ;push CS of INT routine
    push word[ds:si]      ;push IP of INT routine
    pop si
    pop ds
    ret


