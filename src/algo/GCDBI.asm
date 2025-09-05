INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN CompareSizeBigInt@8:FAR
EXTRN CompareBigInt@8:FAR
EXTRN BigIntSign@4: FAR
EXTRN NegBigInt@4: FAR
EXTRN ModBigInt@12: FAR
EXTRN AbsBigInt@8: FAR
EXTRN init_BigInt@10: FAR

PUBLIC GCDBigInt
BI_CODE SEGMENT READONLY PUBLIC 'CODE'
 
GCDBigInt proc FAR USES ds es si di bx cx dx BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD, BIOffset3:WORD, BISeg3:WORD

	push ax

	mov ax, word ptr [bp + 12] ; второе число
	mov es, ax
	mov di, word ptr [bp + 10]
	mov cx, word ptr es:[di + BigInt.BIsize]  ; в cx размер
		
	mov dx, cx
	
	xor bx, bx
	mass_loop:
		push bx
		loop mass_loop
	mov di, sp
	mov ax, ss
	mov es, ax

	mov cx, dx

	mass_loop2:
		push bx
		loop mass_loop2
	mov si, sp
	mov ax, ss
	mov ds, ax

	push es
	push di
	push dx
	mov  ax, SEG temp1
	push  ax
	mov  ax, OFFSET temp1
	push  ax
	call  init_BigInt@10
		
	push ds
	push si
	push dx
	mov  ax, SEG temp2
	push  ax
	mov  ax, OFFSET temp2
	push  ax
	call  init_BigInt@10


	mov ax, word ptr [bp + 16]
	push ax
	mov ax, word ptr [bp + 14]
	push ax
	mov ax, word ptr [bp + 12]
	push ax
	mov ax, word ptr [bp + 10]
	push ax
	mov ax, 0000h
	call CompareSizeBigInt@8
	cmp ax, 0404h
	jz return1

	mov ax, word ptr [bp + 16]
	push ax
	mov ax, word ptr [bp + 14]
	push ax
	mov ax, word ptr [bp + 8]
	push ax
	mov ax, word ptr [bp + 6]
	push ax
	mov ax, 0000h
	call CompareSizeBigInt@8
	cmp ax, 0404h
	jz return1

			 
	push ds ;ds:si - buffer temp2
	push si
	push es ;es:di - buffer temp1
	push di

	mov ax, word ptr [bp + 16]
	push ax
	mov ax, word ptr [bp + 14]
	push ax
	mov ax, word ptr [bp + 16]
	push ax
	mov ax, word ptr [bp + 14]
	push ax
	call AbsBigInt@8
	mov ax, word ptr [bp + 12]
	push ax
	mov ax, word ptr [bp + 10]
	push ax
	mov ax, word ptr [bp + 12]
	push ax
	mov ax, word ptr [bp + 10]
	push ax
	call AbsBigInt@8
	
	  
	mov ax, word ptr [bp + 12]
	push ax
	mov ax, word ptr [bp + 10]
	push ax
	mov ax, word ptr [bp + 16]
	push ax
	mov ax, word ptr [bp + 14]
	push ax

	call CompareBigInt@8
	jl skip_swap_num1_num2

	mov ax, word ptr [bp + 12] ; второе число
	mov es, ax
	mov di, word ptr [bp + 10]
	   
	mov ax, word ptr [bp + 16] ; первое число
	mov ds, ax
	mov si, word ptr [bp + 14]
	jmp continue

	skip_swap_num1_num2:

		mov ax, word ptr [bp + 12] ; второе число
		mov ds, ax
		mov si, word ptr [bp + 10]
	   
		mov ax, word ptr [bp + 16] ; первое число
		mov es, ax
		mov di, word ptr [bp + 14]

continue:
	push ds
	push si
	mov ax, word ptr [bp + 8] ; result
	mov ds, ax
	mov si, word ptr [bp + 6]
	mov cx, word ptr ds:[si + BigInt.BIptr]
	mov ax, word ptr ds:[si + BigInt.BIptr + 2] ;ax:cx - buffer of result
	pop si
	pop ds
	   
	push ax
	push cx
	mov cx, word ptr es:[di + BigInt.BIptr]
	mov ax, word ptr es:[di + BigInt.BIptr + 2] ;es:di - buffer of num2
	mov es, ax
	mov di, cx
	pop cx
	pop ax

	push ax
	xor bx, bx
	shl dx, 1
	is_num2_zero:
		mov ax, word ptr es:[di+bx]
		test ax, ax
		jnz is_not_num2_zero
		add bx, 2
		cmp bx, dx
		jb is_num2_zero

	pop ax
	push ax
	push cx
	push ds
	push si
	push es
	push di
	mov es, ax
	mov di, cx
	mov ax, word ptr [bp + 16] ; num1
	mov ds, ax
	mov si, word ptr [bp + 14]
	mov cx, word ptr ds:[si + BigInt.BIptr]
	mov ax, word ptr ds:[si + BigInt.BIptr + 2]
	mov ds, ax
	mov si, cx

	xor bx, bx
	copy_result_num1:
		push dx
		mov dx, word ptr ds:[si + bx]
		mov word ptr es:[di + bx], dx
		pop dx
		add bx, 2
		cmp bx, dx
		jl copy_result_num1

	pop di
	pop es
	pop si
	pop ds
	pop cx
	pop ax
	  
	pop di
	pop es
	pop si
	pop es
	jmp return

is_not_num2_zero:
	pop ax
 
	push ds
	push si
	mov ds, ax
	mov si, cx
	xor bx, bx
	
	copy_result_num2:
		push dx
		mov dx, word ptr es:[di + bx]
		mov word ptr ds:[si + bx], dx
		pop dx
		add bx, 2
		cmp bx, dx
		jl copy_result_num2

	pop si
	pop ds

	pop di
	pop es
	  
	mov ax, word ptr [bp + 16] ; num1
	mov ds, ax
	mov si, word ptr [bp + 14]
	mov cx, word ptr ds:[si + BigInt.BIptr]
	mov ax, word ptr ds:[si + BigInt.BIptr + 2]
	mov ds, ax
	mov si, cx

	xor bx, bx
	copy_temp1_num1:
		push dx
		mov dx, word ptr ds:[si + bx]
		mov word ptr es:[di + bx], dx
		pop dx
		add bx, 2
		cmp bx, dx
		jl copy_temp1_num1
	 
	pop si
	pop ds
	GCD_loop:
		mov ax, seg temp1
		push ax
		mov ax, offset temp1
		push ax
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		mov ax, seg temp2
		push ax
		mov ax, offset temp2
		push ax
		call ModBigInt@12
		
		mov ax, seg temp1
		push ax
		mov ax, offset temp1
		push ax
		mov ax, seg temp1
		push ax
		mov ax, offset temp1
		push ax
		call AbsBigInt@8

		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		call AbsBigInt@8

		xor bx, bx
		is_temp2_zero:
			mov ax, word ptr ds:[si+bx]
			test ax, ax
			jnz continue_GCD_loop
			add bx, 2
			cmp bx, dx
			jl is_temp2_zero
			jmp conclusion

		continue_GCD_loop:
			push es
			push di

			mov ax, seg temp1 ; temp1
			mov es, ax
			mov di, offset temp1
			mov cx, word ptr es:[di + BigInt.BIptr]
			mov ax, word ptr es:[di + BigInt.BIptr + 2]
			mov es, ax
			mov di, cx
					 
			push ds
			push si

			mov ax, word ptr [bp + 8] ; result
			mov ds, ax
			mov si, word ptr [bp + 6]
			mov cx, word ptr ds:[si + BigInt.BIptr]
			mov ax, word ptr ds:[si + BigInt.BIptr + 2]
			mov ds, ax
			mov si, cx

			xor bx, bx
			copy_temp1_result:
				mov ax, word ptr ds:[si + bx]
				mov word ptr es:[di + bx], ax
				add bx, 2
				cmp bx, dx
				jl copy_temp1_result


			pop si
			pop ds

			pop di
			pop es
			mov ax, word ptr [bp + 8] ; result
			mov es, ax
			mov di, word ptr [bp + 6]
			mov cx, word ptr es:[di + BigInt.BIptr]
			mov ax, word ptr es:[di + BigInt.BIptr + 2]
			mov es, ax
			mov di, cx

		xor bx, bx
		copy_temp2_result:
			mov ax, word ptr ds:[si + bx]
			mov word ptr es:[di + bx], ax
			add bx, 2
			cmp bx, dx
			jl copy_temp2_result
		jmp GCD_loop
conclusion:
	mov ax, seg temp2
	push ax
	mov ax, offset temp2
	push ax
	mov ax, word ptr [bp + 8]
	push ax
	mov ax, word ptr [bp + 6]
	push ax
	call CompareBigInt@8

	return:
		pop ax
		pushf
		pop bx
		shl dx, 1
		add sp, dx
		push bx
		popf
		ret 12
	return1:
		pop ax
		mov ax, 0404h
		shl dx, 1
		shl dx, 1
		add sp, dx
		ret 12

	temp1 BigInt <?>
	temp2 BigInt <?>
GCDBigInt ENDP

BI_CODE ENDS
END
