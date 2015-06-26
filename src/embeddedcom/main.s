cpu   8086
org 100h

section .text

    times 4 nop

    jmp copy_prot

intcall:
    ; pass via SI the interrupt number
    pushf          ;pusha flags
    mov bp, ds
    xor di, di
    mov  ds, di     ;...to DS register
    shl si, 1
    shl si, 1
    push word[ds:si+02]   ;push CS of INT routine
    push word[ds:si]      ;push IP of INT routine
    mov ds, bp
iretinstr:
    iret           ;pop IP,CS and flags

intgetaddr:
    ; pass via SI the interrupt number
    xor ax, ax
    mov  ds, ax     ;...to DS register
    shl si, 1
    shl si, 1
    push word[ds:si+02]   ;push CS of INT routine
    push word[ds:si]      ;push IP of INT routine
    pop si
    pop ds
    ret

copy_prot:
    mov  ah,02     ;read operation
    mov  al,1     ;1 sector to read
    xor cx, cx
    inc cl          ;read the first sector
    xor dx, dx   ;side 0, drive A
    mov  bx, writehere
    pushf          ;pusha flags
    push cs        ;pusha CS
    mov si, 13h
    call intcall ;push address for next
    ;jc exit ; at worst we are reading uninitialized mem (:


end_copy_prot:

    mov ah,03Ch        ; the open/create-a-file function
    mov cx,020h        ; file attribute - normal file
    mov dx,msg         ; address of a ZERO TERMINATED! filename string
    int 021h           ; call on Good Old Dos

    jc exit

    push ax             ; store file handle

; ------ here decrypt file -------
    xor bx, bx
    push ds

    call intgetaddr
    ; if no debugger is found int3 handler should be IRET = CF
    mov cl, [ds:si]

    pop ds
    jmp decrypt

    gzipf   incbin "../keygen/keygen.xored.gz"
    gzipend:

decrypt:
    mov al, [gzipf+bx]
    sub al, cl
    xor al, [writehere]
    xor cl, [gzipf+bx]
    mov [gzipf+bx], al
    inc bx
    cmp bx, (gzipend - gzipf)
    jnz decrypt


    mov ah,040h        ; the Write-to-a-file function for int 21h
    pop bx  ; the file handle goes in bx
    mov cx,280  ; number of bytes to write
    mov dx,gzipf     ; address to write from (the text we input)
    int 021h           ; call on Good Old Dos

    mov ah,03Eh        ; the close-the-file function
    mov bx,si  ; the file handle
    int 021h           ; call on Good Old Dos

exit:
   mov ah,04Ch         ; terminate-program function
   int 021h            ; you guessed it!

;--------------------------------------------------
section .data
    msg db `kgn\x00`
    ; let`s fool binwalk users :)
    ; fool    db `\x1f\x8b\x08\x00\xb5\xcb.U\x00\x03+\xc8,\xa9L\xcb\xcf\xcf\xc9\xcb/IL\xcbIL\xe7\x02\x00~\x80D\xdf\x11\x00\x00\x00`
;--------------------------------------------------
    ;global _something_size
    ;_something_size dd _something_end - _something

section .bss
    writehere resb 1
