INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall
.stack 200h


SHL_CODE SEGMENT READONLY PUBLIC 'CODE'
public ShlBigInt


; [bp+6]  = offset source (BigInt)
; [bp+8]  = segment source
; [bp+10] = bitCount (количество бит для сдвига)
; [bp+12] = offset result (BigInt)
; [bp+14] = segment result
ShlBigInt PROC FAR uses ax bx cx dx si di es ds FirstOffset:WORD, FirstSeg:WORD, BitCount:WORD, SecondOffset:WORD, SecondSegment:WORD
	
	mov ax, [bp + 8]
	mov ds, ax
	mov si, [bp + 6]
	
	mov ax, [bp + 14]
	mov es, ax
	mov di, [bp + 12]
	push di
	

	mov ax, ds:[si + BigInt.BIsize]    ; размер в словах
	push ax
	mov bx, 16
	mul bx                           ; AX = размер в битах
	mov dx, ax                       ; DX = общий размер в битах

	cmp [bp + 10], dx
	jae zero_result                  ; если сдвиг >= размера, результат = 0
	
	call clear_result_shl
	
	mov ax, ds:[si + BigInt.BIsize]
	mov es:[di + BigInt.BIsize], ax
	
	pop cx

	mov ax, word ptr ds:[si + BigInt.BIptr]     ; offset source data
	mov bx, word ptr ds:[si + BigInt.BIptr + 2]   ; segment source data
	push ds
	mov ds, bx
	mov si, ax                                ; DS:SI -> source data

	push dx
	push bx
	mov bx, cx
	shl bx, 1
	mov dl, byte ptr es:[si + bx - 1]
	mov dh, 0
	pop bx
	mov cx, 0001h
	and dx, cx
	mov cx, dx
	pop dx
	push cx
	
	mov ax, word ptr es:[di + BigInt.BIptr]     ; offset result data
	mov bx, word ptr es:[di + BigInt.BIptr + 2]   ; segment result data
	push es
	mov es, bx
	mov di, ax                                ; ES:DI -> result data


; ____________________________
	mov cl, byte ptr es:[si]
	push ax
	mov al, cl
	mov cl, 7
	shr al, cl
	mov cl, al
	pop ax
	
	push ax
	push cx
	mov cl, byte ptr es:[si]
	mov ah, cl
	mov cl, 6
	shr ah, cl
	and ah, 1
	pop cx
	mov ch, ah
	pop ax

	push ax
	mov ax, 1
	cmp [bp + 10], ax
	pop ax
	jne cont

	push ax
	xor cl, ch
	mov al, 1
	cmp cl, al
	pop ax
	jne set_zero

	push ax
	mov al, 127
	add al, 1
	pop ax
	jmp cont
; ____________________________

set_zero:
	push ax
	mov al, 1
	add al, 1
	pop ax

cont:
	pushf
	pop cx
	and cx, 0800h
	push cx

	; НАчинаем выполнять побитоый сдвиг:
	mov bx, [bp + 10]                       ; BX - копируем сюда
	xor ax, ax                       ; AX = копируем отсюда туда ^
	
copy_bits_loop:
	cmp bx, dx                       ; проверяем, не вышли ли за границы
	jae copy_done
	
	; Получаем бит из source[ax] (source[0])
	push ax
	push bx

	push bx
	push ds
	push si
	call get_bit_shl
	pop bx
	mov ah, al
	
	; Устанавливаем бит в result[bx] (result[bitCount])
	
	pop cx
	mov al, ah
	push cx
	push es
	push di
	call set_bit_shl
	mov ax, cx
 
	inc ax
	inc bx
	jmp copy_bits_loop
	
copy_done:
	pop cx
	pop es
	pop dx
	pop ds
	pop di
	
	call set_flags_shl
	
	ret 10

zero_result:
	call clear_result_shl
	or al, al
	jmp copy_done

ShlBigInt ENDP


clear_result_shl PROC NEAR
	push ax
	push bx
	push cx
	push dx
	push di
	push es
	
	mov ax, es:[di+BigInt.BIsize]
	mov bx, 2
	mul bx
	mov cx, ax
	
	mov ax, word ptr es:[di + BigInt.BIptr]
	mov bx, word ptr es:[di + BigInt.BIptr + 2]
	mov es, bx
	mov di, ax
	
	xor al, al
	rep stosb
	
	pop es
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret
clear_result_shl ENDP

; Получить бит по индексу
; Возвращает бит в AL
get_bit_shl PROC NEAR
	push bp
	mov bp, sp
	push bx
	push cx
	push dx
	push si
	push es
	
	mov bx, [bp + 8]
	mov es, [bp + 6]
	mov si, [bp + 4]
	
	mov ax, bx
	mov cl, 3
	shr ax, cl ; AX = номер байта
	add si, ax ; SI указывает на нужный байт
	
	mov cx, bx
	and cx, 7 ; CL = номер бита в байте (0-7) (обратный порядок)
	push ax
	mov ax, 7
	sub ax, cx
	mov cx, ax
	pop ax
	
	mov al, es:[si] ; загружаем байт
	shr al, cl ; сдвигаем к младшему биту
	and al, 1 ; оставляем только младший бит
	
	pop es
	pop si
	pop dx
	pop cx
	pop bx
	pop bp
	ret 6
get_bit_shl ENDP

; Установить бит по индексу CX в ES:DI
; Бит передается через AL
set_bit_shl PROC NEAR
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	
	mov cx, [bp + 8]
	mov es, [bp + 6]
	mov di, [bp + 4]
	
	mov bx, cx
	mov dx, cx
	push cx
	mov cl, 3
	shr bx, cl ; BX = номер байта
	pop cx
	add di, bx ; DI указывает на нужный байт
	
	mov cx, dx
	and cx, 7 ; CL = номер бита в байте (обратный порядок)
	push ax
	mov ax, 7
	sub ax, cx
	mov cx, ax
	pop ax
	
	mov ah, 1
	shl ah, cl ; AH = маска для бита
	
	test al, 1 ; проверяем устанавливаемый бит
	jz clear_bit
	
	or es:[di], ah ; устанавливаем бит
	jmp set_bit_done
	
clear_bit:
	not ah
	and es:[di], ah
	
set_bit_done:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
set_bit_shl ENDP


set_flags_shl PROC NEAR
	push bp
	mov bp, sp
	push es
	push di
	push ax
	push bx
	push cx

	mov ax, cx
	mov cx, word ptr es:[di + BigInt.BIsize]
	shl cx, 1
	les di, dword ptr es:[di + BigInt.BIptr]



zf_check:
	push ax
	xor al, al
	push di
	repe scasb
	pop di
	pop ax
	
	push cx
	pushf
	mov cx, dx
	pop dx
	push bx
	mov bx, 0040h
	and dx, bx
	pop bx
	add dx, cx
	add dx, ax
	pop cx



pf_sf_check:

	push cx
	shl cx, 1
	push bx
	mov bx, cx
	mov al, byte ptr es:[di + bx - 1]
	pop bx
	mov ah, byte ptr es:[di]

	test ax, 80FFh
	pop cx

	pushf
	pop cx
	and cx, 0084h
	or dx, cx
	push dx
	popf



done:
	pop cx
	pop bx
	pop ax
	pop di
	pop es
	pop bp
	ret
	
set_flags_shl endp

SHL_CODE ENDS
END

