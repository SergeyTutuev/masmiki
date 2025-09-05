INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN init_BigInt@10:FAR
EXTRN ShlBigInt@10:FAR
EXTRN AddBigInt@12:FAR
EXTRN CompareBigInt@8:FAR

public MultiplyBigInt

BI_CODE SEGMENT READONLY PUBLIC 'CODE'

; Проверяет наличие переполнения после сдвига влево
; Принимает: [bp + 6] - offset left_BigInt, [bp + 8] - seg left_BigInt
; Возвращает: флаг OF установлен если было переполнение
OverFlowAfterLeftShift PROC NEAR
	push ax
	push cx
	push dx
	push bx
	push ds
	push si
	push es
	push di
	pushf

	mov ax, word ptr [bp + 8]    ; segment left_BigInt
	mov es, ax
	mov di, word ptr [bp + 6]    ; offset left_BigInt
	mov bx, word ptr es:[di + BigInt.BIsize]    ; size left_BigInt

	mov ds, word ptr es:[di + BigInt.BIptr + 2]    ; segment left_buf
	mov si, word ptr es:[di + BigInt.BIptr]        ; offset left_buf

	mov cx, bx    ; cx - кол-во слов
	mov ax, 0
	mov es, ax

lop:
	LODSW    ; загружаем слова слева направо
	xchg ah, al

	push cx
	mov cx, 16    ; проходимся по битам слова
	mov bx, 8000h    ; слева направо проверяем на кол-во нулей
lop_word:
	test ax, bx
	JNZ ext
	push ax
	mov ax, es
	inc ax
	mov es, ax
	pop ax
	shr bx, 1
	loop lop_word

	pop cx
	loop lop

return_overflow:
	popf
	pop di
	pop es
	pop si
	pop ds
	pop bx
	pop dx
	pop cx
	pop ax
	ret

ext:
	pop cx
	mov ax, es
	CMP ax, dx    ; es - кол-во ведущих нулей, dx - число, на которое делается левый сдвиг
	jae return_overflow    ; если ведущих больше, то значит переполнения нет, иначе выставляем OF
	pop ax
	OR ax, 0800h
	push ax
	jmp return_overflow
OverFlowAfterLeftShift ENDP


; Проверяет, является ли один из операндов нулем
; Принимает: [bp + 6] - offset left, [bp + 8] - seg left, [bp + 10] - offset right, [bp + 12] - seg right
;             [bp + 14] - offset result_BigInt, [bp + 16] - seg result_BigInt
; Возвращает: ax = 1111h если один из операндов нулевой, иначе ax = 0
CheckZeroOperand PROC NEAR
	push cx
	push dx
	push bx
	push ds
	push si
	push es
	push di
	pushf

	mov ax, word ptr [bp + 16]    ; segment result_BigInt
	push ax
	mov ax, word ptr [bp + 14]    ; offset result_BigInt
	push ax
	mov ax, word ptr [bp + 12]    ; seg right
	push ax
	mov ax, word ptr [bp + 10]    ; offset right
	push ax
	call CompareBigInt@8
	jz exit_CheckZeroOperand_zero

	mov ax, word ptr [bp + 16]    ; segment result_BigInt
	push ax
	mov ax, word ptr [bp + 14]    ; offset result_BigInt
	push ax
	mov ax, word ptr [bp + 8]     ; seg left
	push ax
	mov ax, word ptr [bp + 6]     ; offset left
	push ax
	call CompareBigInt@8
	jz exit_CheckZeroOperand_zero

	xor ax, ax

	popf
	pop di
	pop es
	pop si
	pop ds
	pop bx
	pop dx
	pop cx
	ret

exit_CheckZeroOperand_zero:
	mov ax, 1111h
	popf
	pop di
	pop es
	pop si
	pop ds
	pop bx
	pop dx
	pop cx
	ret
CheckZeroOperand ENDP


; [bp+6]  - ResultSeg        ; сегмент для результата
; [bp+8]  - ResultOffset     ; смещение для результата
; [bp+10] - RightSegment     ; сегмент правого операнда
; [bp+12] - RightOffset      ; смещение правого операнда
; [bp+14] - LeftSegment      ; сегмент левого операнда
; [bp+16] - LeftOffset       ; смещение левого операнда
MultiplyBigInt PROC FAR uses bx cx dx si di es ds ResultSeg:WORD, ResultOffset:WORD, RightSegment:WORD, RightOffset:WORD, LeftSegment:WORD, LeftOffset:WORD
	push ax    ; len (stack) = 1

	mov ax, word ptr [bp + 12]    ; segment right_BigInt
	mov es, ax
	mov di, word ptr [bp + 10]    ; offset right_BigInt
	mov ax, word ptr es:[di + BigInt.BIsize]    ; size right_BigInt
	mov cx, ax    ; size right_BigInt
	mov bx, ax    ; size right_BigInt
	mov di, ax    ; size right_BigInt

	xor ax, ax

push_loop:
	push ax
	loop push_loop    ; len (stack) = 2 + cx * 2

	xor cx, cx
	push cx
	push cx
	push cx    ; len (stack) = 2 + cx * 2 + 6

	mov ax, sp
	add ax, 6
	mov dx, bp
	mov bp, sp
	mov word ptr [bp + BigInt.BIptr], ax    ; offset local buf
	mov ax, ss
	mov word ptr [bp + BigInt.BIptr + 2], ax    ; seg local buf

	mov word ptr [bp + BigInt.BIsize], bx    ; count word to local buf

	push ss    ; segment local BigInt
	push bp    ; offset local BigInt
	mov bp, dx    ; теперь адрес локального будет считаться через bp

	mov ax, word ptr [bp + 16]    ; segment result_BigInt
	mov ds, ax
	mov si, word ptr [bp + 14]    ; offset result_BigInt
	mov bx, word ptr ds:[si + BigInt.BIsize]    ; size result_BigInt

	push ds
	push si
	mov ax, word ptr [bp + 8]    ; segment left_BigInt
	mov ds, ax
	mov si, word ptr [bp + 6]    ; offset left_BigInt
	mov dx, word ptr ds:[si + BigInt.BIsize]    ; size left_BigInt
	pop si
	pop ds

	mov cx, di
	cmp di, bx
	jnz return_error
	cmp di, dx
	jnz return_error

	mov es, word ptr [bp + 12]    ; seg right_BigInt
	mov si, word ptr [bp + 10]    ; offset right_BigInt
	mov cx, word ptr es:[si + BigInt.BIsize]    ; len right_BigInt

	shl cx, 1
	mov ds, word ptr es:[si + BigInt.BIptr + 2]    ; seg right_buf
	mov ax, word ptr es:[si + BigInt.BIptr]        ; offset right_buf
	add ax, cx    ; ax указывает теперь на байт после буфера
	sub ax, 2
	mov si, ax

	mov di, word ptr [bp + 16]    ; seg resultBI
	mov es, di
	mov di, word ptr [bp + 14]    ; offset resultBI

	push ds
	push si
	mov ds, word ptr es:[di + BigInt.BIptr + 2]    ; seg result_buf
	mov si, word ptr es:[di + BigInt.BIptr]        ; offset result_buf
	pop di
	pop es

	push ds
	push si
	mov ax, es
	mov ds, ax
	mov ax, di
	mov si, ax
	pop di
	pop es

	cld
	xor ax, ax
	shr cx, 1
	push cx
	rep stosw    ; заполняем нулями result bufer
	pop cx

	push ax
	call CheckZeroOperand
	cmp ax, 1111h
	je return_error_operand_zero
	pop ax

	std    ; направление справа налево (от младших слов к старшим)
	xor dx, dx

mult_lop:
	lodsw    ; загрузка слова
	xchg ah, al

	mov bx, 0001h
	push cx
	mov cx, 16

word_lop:
	TEST bx, ax
	JZ word_lop_next

	push bx
	mov bx, sp

	push ax

	mov ax, word ptr ss:[bx + 6]    ; seg local BigInt
	push ax
	mov ax, word ptr ss:[bx + 4]    ; offset local BigInt
	push ax
	push dx    ; high word of struct pointer
	mov ax, word ptr [bp + 8]    ; seg left
	push ax
	mov ax, word ptr [bp + 6]    ; offset left
	push ax
	cld
	call ShlBigInt@10
	call OverFlowAfterLeftShift
	pushf
	pop es    ; флаги после левого сдвига + переполнение

	push ax
	mov ax, es
	and ax, 0800h
	mov es, ax
	pop ax

	std

	pop ax

	push ax

	mov ax, word ptr ss:[bx + 6]    ; seg local BigInt
	push ax
	mov ax, word ptr ss:[bx + 4]    ; offset local BigInt
	push ax
	mov ax, word ptr [bp + 16]    ; result seg
	push ax
	mov ax, word ptr [bp + 14]    ; result offset
	push ax
	mov ax, word ptr [bp + 16]    ; result seg
	push ax
	mov ax, word ptr [bp + 14]    ; result offset
	push ax

	call AddBigInt@12
	PUSHF    ; загружаю флаги после сложения
	pop di    ; di - флаги

	push ax
	push bx
	mov ax, di    ; в ax - флаги после сложения
	xor ah, ah
	and al, 01h    ; кладу в ax только флаг CF после сложения
	cmp ax, 0000h
	jz ax_cf_flag
	or ax, 0800h
ax_cf_flag:
	mov bx, es    ; достаю флаг переполнения после сдвига
	or ax, bx    ; В ax теперь флаг переполнения после сдвига или сложения
	mov es, ax    ; сохраняю в es
	pop bx
	pop ax

	pop ax

	pop bx

word_lop_next:
	shl bx, 1
	inc dx
	loop word_lop
	pop cx

next:
	loop mult_lop

	mov ax, word ptr [bp + 16]    ; segment result_BigInt
	mov ds, ax
	mov si, word ptr [bp + 14]    ; offset result_BigInt
	mov cx, word ptr ds:[si + BigInt.BIsize]    ; size result_BigInt

	pop bp
	pop ss

return:
	shl cx, 1
	add sp, cx
	add sp, 6

	pop ax

	push ax
	mov ax, es
	or di, ax    ; Теперь в di все флаги после сложения + ещё возможное переполнение после сдвига или сложения
	pop ax

	PUSH di
	POPF
	cld
	ret 12

return_error:
	pop bp
	pop ss

	shl cx, 1
	add sp, cx
	add sp, 6

	pop ax
	mov ax, 0404h    ; Ошибка, если размеры не совпадают
	cld
	ret 12

return_error_operand_zero:
	pushf
	pop ax

	pop ax
	pop bp
	pop ss

	shl cx, 1
	add sp, cx
	add sp, 6

	xor ax, ax
	or ax, 0004h
	or ax, 0040h
	push ax    ; в ax теперь флаги после умножения на 0
	popf

	pop ax
	cld
	ret 12
MultiplyBigInt ENDP

BI_CODE ENDS

END
