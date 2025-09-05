INCLUDE src/Bigint.inc


.MODEL HUGE, stdcall

Public StringToBigInt


EXTRN AddBigInt@12:FAR
EXTRN MultiplyBigInt@12:FAR
EXTRN NegBigInt@4:FAR


BI_CODE SEGMENT READONLY PUBLIC 'CODE'

; [bp+6]  - BIOffset     ; смещение BigInt
; [bp+8]  - BISeg        ; сегмент BigInt
; [bp+10] - Buff_off     ; смещение входного буфера
; [bp+12] - Buff_seg     ; сегмент входного буфера
; [bp+14] - Buff_size    ; размер буфера
StringToBigInt PROC FAR USES es ds di si ax bx cx dx BIOffset:WORD, BISeg:WORD, Buff_off:WORD, Buff_seg:WORD, Buff_size:WORD

	mov bx, word ptr [bp + 12]
	mov ds, bx
	mov di, word ptr [bp + 10]

	mov bl, byte ptr ds:[di]
	cmp bl, '-'
	jz letsdoit
	cmp bl, '+'
	jz letsdoit
	cmp bl, 30h
	js return_with_cf
	cmp bl, 40h
	jns return_with_cf




	letsdoit:
		mov cx, word ptr [bp + 14]
		dec cx
		cmp cx, 0
		jz goon
		inc di
		loopncheck:
			mov bl, byte ptr ds:[di]
			cmp bl, 30h
			js return_with_cf
			cmp bl, 40h
			jns return_with_cf
			inc di
			loop loopncheck

	
	
	goon: mov ax, ss
	push ax

	mov ax, sp
	sub ax, 8
	push ax

	mov ax, ss
	push ss
	
	mov ax, word ptr [bp + 8]   ; load segment of myBigInt
	mov   es, ax                ; ES = target struct?segment
	mov   di, word ptr [bp + 6]   ; DI = offset of myBigInt

	mov   ax, word ptr es:[di + BigInt.BIsize]  ; AX = size
	mov cx, 2
	mul cx
	mov cx, ax

	mov ax, sp
	sub ax, cx
	sub ax, 4
	push ax
	
	mov ax, word ptr [bp + 8]   ; load segment of myBigInt
	mov   es, ax                ; ES = target struct?segment
	mov   di, word ptr [bp + 6]   ; DI = offset of myBigInt

	mov   ax, word ptr es:[di + BigInt.BIsize]  ; AX = size

	push ax


	mov cx, ax

	xor ax, ax
	loop_zero:
		push ax
		loop loop_zero

	mov ax, ss
	push ax

	mov ax, sp
	sub ax, 8
	push ax

	mov ax, ss
	push ss
	
	mov ax, word ptr [bp + 8]   ; load segment of myBigInt
	mov   es, ax                ; ES = target struct?segment
	mov   di, word ptr [bp + 6]   ; DI = offset of myBigInt

	mov   ax, word ptr es:[di + BigInt.BIsize]  ; AX = size
	mov cx, 2
	mul cx
	mov cx, ax

	mov ax, sp
	sub ax, cx
	sub ax, 4
	push ax
	
	mov ax, word ptr [bp + 8]   ; load segment of myBigInt
	mov   es, ax                ; ES = target struct?segment
	mov   di, word ptr [bp + 6]   ; DI = offset of myBigInt

	mov   ax, word ptr es:[di + BigInt.BIsize]  ; AX = size

	push ax

	mov cx, ax
	mov dx, 2
	mul dx
	mov di, ax

	xor ax, ax
	loopzero:
		push ax
		loop loopzero

	mov cx, word ptr [bp + 14]
	mov dx, cx

	mov es, bp
	mov ax, sp
	mov bp, sp
	pushf
	loop_create:
		add bp, di
		add bp, 9
		add bp, di
		mov bl, 10
		mov byte ptr [bp], bl
		mov bp, ax
		add bp, di
		add bp, 8
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, ax
		add bp, di
		add bp, 6
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, es
		mov bx, word ptr [bp + 8]
		push bx
		mov bx, word ptr [bp + 6]
		push bx
		mov bp, ax
		add bp, di
		add bp, 10
		add bp, di
		add bp, 8
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, ax
		add bp, di
		add bp, 10
		add bp, di
		add bp, 6
		mov bx, word ptr [bp]
		mov bp, ax
		push bx

		call MultiplyBigInt@12
		pop bx
		pushf
		pop si
		and si, 0800h
		or bx, si
		push bx

		mov si, dx
		sub si, cx
		mov bp, es
		mov bx, word ptr [bp + 12]
		mov ds, bx
		mov bx, word ptr [bp + 10]
		mov bp, ax
		add si, bx
		mov bl, byte ptr ds:[si]
		cmp bl, '+'
		jnz next1
		mov bl, 30h
		next1: cmp bl, '-'
		jnz next2
		mov bl, 30h
		next2: sub bl, 30h
		add bp, di
		add bp, 9
		add bp, di
		mov byte ptr [bp], bl
		mov bp, ax
		add bp, di
		add bp, 8
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, ax
		add bp, di
		add bp, 6
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, ax
		add bp, di
		add bp, 10
		add bp, di
		add bp, 8
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, ax
		add bp, di
		add bp, 10
		add bp, di
		add bp, 6
		mov bx, word ptr [bp]
		mov bp, ax
		push bx
		mov bp, es
		mov bx, word ptr [bp + 8]
		push bx
		mov bx, word ptr [bp + 6]
		push bx
		mov bp, ax

		call AddBigInt@12
		pop bx
		pushf
		pop si
		and si, 0800h
		or bx, si
		push bx

		dec cx
		cmp cx, 0
		jnz loop_create

	mov bp, es

	mov bx, word ptr [bp + 12]
	mov ds, bx
	mov si, word ptr [bp + 10]
	mov bl, byte ptr ds:[si]

	cmp bl, '-'
	jnz return

	mov bx, word ptr [bp + 8]
	push bx

	mov bx, word ptr [bp + 6]
	push bx

	call NegBigInt@4


	return:
		pop bx
		and bx, word ptr 0FFFEh
		mov sp, ax
		add sp, di
		add sp, di
		add sp, 20
		push bx
		popf
		ret 10

	return_with_cf:
		pushf
		pop bx
		or bx, 0001h
		and bx, word ptr 0F7FFh
		push bx
		popf
		ret 10

StringToBigInt ENDP

End
