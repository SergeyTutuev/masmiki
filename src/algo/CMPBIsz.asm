INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

PUBLIC CompareSizeBigInt

BI_CODE SEGMENT PUBLIC 'CODE'
; Процедура сравнения размеров BigInt
CompareSizeBigInt PROC FAR PUBLIC USES ds es si di cx dx FirstOffset:WORD, FirstSeg:WORD, SecondOffset:WORD, SecondSegment:WORD
    push ax
    mov bp, sp 
    
    mov es, word ptr [bp+22]
    mov di, word ptr [bp+20]

    mov cx, es:[di+BigInt.BIsize]

    mov ds, word ptr [bp+26]
    mov si, word ptr [bp+24]
  
    mov dx, ds:[si+BigInt.BIsize]   

    cmp cx, dx
    jne return_ne

     pop ax
     ret 8

     return_ne:
        pop ax
        mov ax, 0404h
        ret 8

CompareSizeBigInt ENDP
BI_CODE ENDS

END
