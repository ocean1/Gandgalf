        cpu   286
        org   100h 

; Compressed loader.
; Copy self to upper memory (current + 64K)
; Far jump to new copy
; Decompress payload to to home segment
; Jump to home segment 0100h

start: 
        times 4 nop
        jmp easy
        int 21h
easy:
        ;mov   cx,[cdata+4]
        ;add   cx,8+cdata-start
        mov   cx, 0ffffh ;br00dal! copy the whole segment
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

; ---------------------- lz4 decompression -----------------------------------------
lz4_decompress:
        push    di              ;save original starting offset (in case != 0)
        cld                     ;make strings copy forward
        ;lodsw
        ;lodsw                   ;skip magic number, smaller than "add si,4"
        lodsw                   ;load chunk size low 16-bit word
        xchg    bx,ax           ;BX = size of compressed chunk
        add     bx,si           ;BX = threshold to stop decompression
        lodsw                   ;load chunk size high 16-bit word
        xchg    cx,ax           ;set CX=0 so that AX=0 later
        inc     cx              ;is high word non-zero?
        loop    @done           ;If so, chunk too big or malformed, abort

@parsetoken:                    ;CX=0 here because of REP at end of loop
        xchg    cx,ax           ;zero ah here to benefit other reg loads
        lodsb                   ;grab token to AL
        mov     dx,ax           ;preserve packed token in DX
@copyliterals:
        shr     al,4           ;unpack upper 4 bits
        call    @buildfullcount ;build full literal count if necessary
@doliteralcopy:                 ;src and dst might overlap so do this by bytes
        rep     movsb           ;if cx=0 nothing happens

;At this point, we might be done; all LZ4 data ends with five literals and the
;offset token is ignored.  If we're at the end of our compressed chunk, stop.

        cmp     si,bx           ;are we at the end of our compressed chunk?
        jae     @done           ;if so, jump to exit; otherwise, process match

@copymatches:
        lodsw                   ;AX = match offset
        xchg    dx,ax           ;AX = packed token, DX = match offset
        and     al,0Fh          ;unpack match length token
        call    @buildfullcount ;build full match count if necessary
@domatchcopy:
        push    ds
        xchg    si,ax           ;ds:si saved
        mov     si,di
        sub     si,dx
        push    es
        pop     ds              ;ds:si points at match; es:di points at dest
        add     cx,4            ;minimum match is 4
        rep     movsb           ;copy match run; movsb handles si=di-1 condition
        xchg    si,ax
        pop     ds              ;ds:si restored
        jmp     @parsetoken

@buildfullcount:
        mov     cx,ax           ;CX = unpacked literal length token
        cmp     al,0Fh          ;is it 15?
        jne     @builddone      ;if not, we have nothing to build
@buildloop:
        lodsb                   ;load a byte
        add     cx,ax           ;add it to the full count
        cmp     al,0xFF         ;was it FFh?
        je      @buildloop      ;if so, keep going
@builddone:
        ret

@done:
        pop     ax              ;retrieve previous starting offset
        sub     di,ax           ;subtract prev offset from where we are now
        xchg    ax,di           ;AX = decompressed size
        ;ret
;--------------------- end of lz4 decompression ----------------------------------

        push  es
        pop   ds

        retf      ; }
cdata:
