INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR
EXTRN GCDBigInt@12:FAR
EXTRN NegBigInt@4:FAR

.data
    ; Данные чисел
    num1_data db 1Dh, 90h, 09h, 0A2h, 0DFh, 0D6h, 0D0h, 0BEh
    num2_data db 00h, 0ADh, 8Ch, 43h, 0B6h, 0E1h, 93h, 0B6h
    num3_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
    num4_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 06h


    ; Переменные BigInt
    myNum1 BigInt <?>
    myNum2 BigInt <?>
    result1 BigInt <?>
    right1 BigInt <?>
    
    ; Сообщения
    msg1_p db 'Test GCDCase1 passed',13,10,'$',0
    msg1_f db 'Test GCDCase1 failed',13,10,'$',0

    msg2_p db 'Test GCDCase2 passed',13,10,'$',0
    msg2_f db 'Test GCDCase2 failed',13,10,'$',0

    msg3_p db 'Test GCDCase3 passed',13,10,'$',0
    msg3_f db 'Test GCDCase3 failed',13,10,'$',0


.CODE
public TestGCDCase1, TestGCDCase2, TestGCDCase3
ASSUME DS:@data
TestGCDCase1 proc far
    mov ax, @data
    mov ds, ax
     ; Инициализация num1
    push ds
    mov ax, offset num1_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum1
    push ax
    call init_BigInt@10

    ; Инициализация num2
    mov ax, ds
    push ax
    mov ax, offset num2_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum2
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num3_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset result1
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num4_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset right1
    push ax
    call init_BigInt@10

    mov ax, DS
    push ax

    mov ax, offset myNum1
    push ax

    mov ax, DS
    push ax

    mov ax, offset myNum2
    push ax

    mov ax, DS
    push ax

    mov ax, offset result1
    push ax

    call GCDBigInt@12

    mov ax, DS
    push ax

    mov ax, offset right1
    push ax

    mov ax, DS
    push ax

    mov ax, offset result1
    push ax

    call CompareBigInt@8
    je print_success1

    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg1_f
    int 21h
    ret 0

    print_success1:
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg1_p
    int 21h

    ret 0
TestGCDCase1 endp

TestGCDCase2 proc far
    mov ax, @data
    mov ds, ax
     ; Инициализация num1
    push ds
    mov ax, offset num1_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum1
    push ax
    call init_BigInt@10

    mov ax, DS
    push ax

    mov ax, offset myNum1
    push ax

    call NegBigInt@4 ;меняем знак у первого числа на -

    ; Инициализация num2
    mov ax, ds
    push ax
    mov ax, offset num2_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum2
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num3_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset result1
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num4_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset right1
    push ax
    call init_BigInt@10

    mov ax, DS
    push ax

    mov ax, offset myNum1
    push ax

    mov ax, DS
    push ax

    mov ax, offset myNum2
    push ax

    mov ax, DS
    push ax

    mov ax, offset result1
    push ax

    call GCDBigInt@12

    mov ax, DS
    push ax

    mov ax, offset right1
    push ax

    mov ax, DS
    push ax

    mov ax, offset result1
    push ax

    call CompareBigInt@8
    je print_success2

    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg2_f
    int 21h
    ret 0

    print_success2:
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg2_p
    int 21h

    ret 0
TestGCDCase2 endp


TestGCDCase3 proc far
    mov ax, @data
    mov ds, ax
     ; Инициализация num1
    push ds
    mov ax, offset num1_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum1
    push ax
    call init_BigInt@10

    ; Инициализация num2
    mov ax, ds
    push ax
    mov ax, offset num2_data
    push ax
    mov ax, 6
    push ax
    mov ax, ds
    push ax
    mov ax, offset myNum2
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num3_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset result1
    push ax
    call init_BigInt@10

    ; Инициализация result1
    mov ax, ds
    push ax
    mov ax, offset num4_data
    push ax
    mov ax, 4
    push ax
    mov ax, ds
    push ax
    mov ax, offset right1
    push ax
    call init_BigInt@10

    mov ax, DS
    push ax

    mov ax, offset myNum1
    push ax

    mov ax, DS
    push ax

    mov ax, offset myNum2
    push ax

    mov ax, DS
    push ax

    mov ax, offset result1
    push ax

    call GCDBigInt@12

    cmp ax, 0404h
    je print_success3

    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg3_f
    int 21h
    ret 0

    print_success3:
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg3_p
    int 21h

    ret 0
TestGCDCase3 endp
END