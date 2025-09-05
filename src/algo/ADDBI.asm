INCLUDE src/BigInt.inc
PUBLIC AddBigInt

.MODEL HUGE, stdcall


BI_CODE SEGMENT READONLY PUBLIC 'CODE'


; [bp+6]  - BIOffset1  ; смещение первого BigInt
; [bp+8]  - BISeg1     ; сегмент первого BigInt
; [bp+10] - BIOffset2  ; смещение второго BigInt
; [bp+12] - BISeg2     ; сегмент второго BigInt
; [bp+14] - BIOffset3  ; смещение результата
; [bp+16] - BISeg3     ; сегмент результата
AddBigInt PROC FAR USES ds es si di bx cx dx, BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD, BIOffset3:WORD, BISeg3:WORD
	push ax

	mov ax, word ptr [bp + 12]
	mov es, ax
	mov di, word ptr [bp + 10]
	mov cx, word ptr es:[di + BigInt.BIsize]

	mov ax, word ptr [bp + 16]
	mov ds, ax
	mov si, word ptr [bp + 14]
	mov bx, word ptr ds:[si + BigInt.BIsize]

	push ds
	push si
	mov ax, word ptr [bp + 8]
	mov ds, ax
	mov si, word ptr [bp + 6]
	mov dx, word ptr ds:[si + BigInt.BIsize]
	pop si
	pop ds

	mov ax, 0404h
	cmp cx, bx
	jnz return
	cmp cx, dx
	jnz return

	mov cx, word ptr es:[di + BigInt.BIsize]

	xor dx, dx
	loop_sum:
		mov bx, word ptr es:[di + BigInt.BIptr]
		mov ax, word ptr es:[di + BigInt.BIptr + 2]
		push es
		push di
		mov es, ax
		mov di, bx
		pushf
		mov ax, cx
		dec ax
		mov bx, 2
		mul bx
		mov bx, ax
		mov ah, byte ptr es:[bx + di]
		mov al, byte ptr es:[bx + di + 1]
		pop dx
		push dx
		popf
		pop di
		pop es

		mov bx, word ptr ds:[si + BigInt.BIptr]
		mov dx, word ptr ds:[si + BigInt.BIptr + 2]
		push ds
		push si
		mov ds, dx
		mov si, bx
		pushf
		push ax
		mov ax, cx
		dec ax
		mov bx, 2
		mul bx
		mov bx, ax
		pop ax
		pop dx
		push dx
		popf
		mov dh, byte ptr ds:[bx + si]
		mov dl, byte ptr ds:[bx + si + 1]
		adc ax, dx
		pop si
		pop ds

		push ds
		push si
		mov dx, word ptr [bp + 8]
		mov ds, dx
		mov si, word ptr [bp + 6]
		mov bx, word ptr ds:[si + BigInt.BIptr]
		mov dx, word ptr ds:[si + BigInt.BIptr + 2]
		mov ds, dx
		mov si, bx
		pushf
		push ax
		mov ax, cx
		dec ax
		mov bx, 2
		mul bx
		mov bx, ax
		pop ax
		pop dx
		push dx
		popf
		mov byte ptr ds:[bx + si], ah
		mov byte ptr ds:[bx + si + 1], al
		pop si
		pop ds
		loop loop_sum

	pushf
	pop ax

	mov dx, word ptr [bp + 8]
	mov ds, dx
	mov si, word ptr [bp + 6]
	mov cx, word ptr ds:[si + BigInt.BIsize]

	loop_set_zf:
		mov bx, word ptr ds:[si + BigInt.BIptr]
		mov dx, word ptr ds:[si + BigInt.BIptr + 2]
		push ds
		push si
		mov ds, dx
		mov si, bx
		push ax
		mov ax, cx
		dec ax
		mov bx, 2
		mul bx
		mov bx, ax
		pop ax
		mov dh, byte ptr ds:[bx + si]
		mov dl, byte ptr ds:[bx + si + 1]
		pop si
		pop ds
		cmp dx, 0
		jne finish
		loop loop_set_zf

	finish:
		pushf
		pop bx
		and bx, word ptr 0F77Fh
		and ax, word ptr 0FFBFh
		or ax, bx

	push ax
	mov cx, word ptr ds:[si + BigInt.BIsize]
	mov ax, cx
	dec ax
	mov bx, 2
	mul bx
	mov bx, ax
	mov ax, word ptr ds:[si + BigInt.BIptr]
	mov dx, word ptr ds:[si + BigInt.BIptr + 2]
	mov ds, dx
	mov si, ax
	mov al, byte ptr ds:[bx + si + 1]
	cmp al, 0
	pop ax
	pushf
	pop bx
	and bx, word ptr 0F73Fh
	and ax, word ptr 0FFFBh
	or ax, bx
	push ax
	popf

	mov ax, 0000h

	return:
		pushf
		pop bx
		cmp ax, 0404h
		pop ax
		jnz next
		mov ax, 0404h
	next:
		push bx
		popf
		ret 12
AddBigInt ENDP

BI_CODE ENDS

END
