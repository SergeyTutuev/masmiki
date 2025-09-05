INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

public NegBigInt


BI_CODE SEGMENT PUBLIC 'CODE'

;   [bp+6] - offset BigInt
;   [bp+8] - segment BigInt
NegBigInt PROC FAR PUBLIC USES ax ds es si di bx cx dx, BIOffset:WORD, BISeg:WORD
	; Загружаем адрес структуры BigInt
	mov   ax, word ptr [bp + 8]    ; segment num
	mov   es, ax                 ; ES = segment num
	mov   di, word ptr [bp + 6]    ; DI = offset num


	; Получаем размер числа и указатель на буфер
	mov   cx, es:[di + BigInt.BIsize]   ; CX = размер числа (в словах)
	mov   ax, word ptr es:[di + BigInt.BIptr]    ; offset буфера
	mov   dx, word ptr es:[di + BigInt.BIptr  +2]  ; segment буфера
	mov   ds, dx                  ; DS:SI будет указывать на буфер
	mov   si, ax


	; Проверяем число на ноль
	mov   bx, cx                  ; сохраняем CX
	xor   ax, ax
	cld                           ; направление - вперед

check_zero_loop:
	lodsw                         ; загружаем слово из буфера в AX
	test  ax, ax                  ; проверка на ноль
	jnz   not_zero                ; если не ноль, дальше
	loop  check_zero_loop

	jmp   done


not_zero:
	; Восстанавливаем регистры для основного цикла
	mov   cx, bx                  ; восстанавливаем CX (размер)
	mov   si, word ptr es:[di + BigInt.BIptr]    ; offset буфера

	; Инвертируем все биты числа
	cld                           ; направление - вперед
invert_loop:
	lodsw                         ; загружаем слово из буфера в AX
	not   ax                      ; инвертируем все биты
	mov   [si - 2], ax              ; сохраняем обратно
	loop  invert_loop


	; Добавляем 1 к числу (второй шаг доп. кода)
	mov   cx, bx                  ; восстанавливаем CX
	mov   si, word ptr es:[di + BigInt.BIptr]    ; offset буфера
	mov   dx, 1                   ; перенос
	std                           ; направление - назад (для удобства сложения)
	mov   di, si                  ; DI = начало буфера
	add   di, bx                  ; DI = начало буфера + размер (в словах)
	add   di, bx                  ; DI = начало буфера + размер*2 (в байтах)
	sub   di, 2                   ; DI указывает на последнее слово

add_one_loop:
	mov   ah, [di]                ; загружаем слово
	mov   al, [di + 1]
	add   ax, dx                  ; добавляем перенос
	mov   [di], ah                ; сохраняем
	mov   [di + 1], al
	jnc   done                    ; если нет переноса, заканчиваем
	mov   dx, 1                   ; иначе перенос = 1
	sub   di, 2                   ; переходим к предыдущему слову
	loop  add_one_loop


done:
	cld                           ; восстанавливаем направление

	ret  4                        ; очищаем стек от параметров
NegBigInt ENDP

BI_CODE ENDS

END
