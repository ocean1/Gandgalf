        cpu   8086
        org   100h 

; Compressed loader.
; Copy self to upper memory (current + 64K)
; Far jump to new copy
; Decompress payload to to home segment
; Jump to home segment 0100h

start: 
        mov   cx,[cdata+4]
        add   cx,8+cdata-start
        mov   ax,ds
        add   ax,1000h
        mov   es,ax

        mov   si,0100h
        mov   di,si
        rep   movsb

        push  es
        mov   ax,continue
        push  ax
        retf
continue:
        ; DS is the home segment
        ; ES is the current segment
        push  ds
        push  es
        pop   ds
        pop   es

        ; ES is the home segment
        ; DS is the current segment
        ; push the return address
        ; uncompress from DS:SI to ES:DI

        mov   di,0100h
        mov   si,cdata
        push  es  ; for below {
        push  di

        call  lz4_decompress
        push  es
        pop   ds

        retf      ; }
%include "LZ4_8088.ASM"
cdata:
