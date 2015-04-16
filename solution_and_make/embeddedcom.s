org 100h
section .text

jmp loop
    nop
    nop
    nop
    nop
loop:
    jmp loop

mov ah,03Ch        ; the open/create-a-file function
    mov cx,020h        ; file attribute - normal file
    mov dx,msg    ; address of a ZERO TERMINATED! filename string
    int 021h           ; call on Good Old Dos

jc exit

mov si,ax  ; returns a file handle (probably 5)

; ------ here decrypt file -------
    xor bx, bx
decrypt:
    mov al, [gzipf+bx]
    xor al, 0ebh
    mov [gzipf+bx], al
    inc bx
    cmp bx, 280
    jnz decrypt


mov ah,040h        ; the Write-to-a-file function for int 21h
    mov bx,si  ; the file handle goes in bx
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
    fool    db `\x1f\x8b\x08\x00\xb5\xcb.U\x00\x03+\xc8,\xa9L\xcb\xcf\xcf\xc9\xcb/IL\xcbIL\xe7\x02\x00~\x80D\xdf\x11\x00\x00\x00`
;--------------------------------------------------
    gzipf   incbin "keygen.xored.gz"

section .bss
