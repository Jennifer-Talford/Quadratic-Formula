; Program Selection: Quadratic Formula
; Jennifer Talford

INCLUDE Irvine32.inc

.data

prompt1 BYTE "Enter a value for the coefficient A: ",0
prompt2 BYTE "Enter a value for the coefficient B: ",0
prompt3 BYTE "Enter a value for the coefficient C: ",0
prompt5 BYTE "There are two real roots: ",0
prompt7 BYTE "The roots are real and equal: ",0
prompt8 BYTE "The roots are imaginary. ",0

spaceholder BYTE " ",0

value1 SDWORD ?
value2 SDWORD ?
value3 SDWORD ?
det SDWORD ?

.code

main PROC
; prompt for user to enter 1st signed integer
mov EDX, OFFSET prompt1
call WriteString
call readInt
mov value1, EAX
; prompt for user to enter 2nd signed integer
mov EDX, OFFSET prompt2
call WriteString
call readInt
mov value2, EAX
; prompt for user to enter 3rd signed integer
mov EDX, OFFSET prompt3
call WriteString
call readInt
mov value3, EAX
; push the three values onto the stack
push value1
push value2
push value3
; call the subroutine determinant
call determinant
mov DET, EAX ; assign the returned value to det
; find the square root of determinant
; load the integer to ST(0)
fild DET 
; compute the square root and store to ST(0)
fsqrt 
fistp DET
; push the square root value of determinant onto the stack
push DET
; move the determinant value into eax
mov EAX, DET
; compare the value of EAX with 0
cmp EAX, 0
; if determinant value is equal to zero jump to L1
je L1 
; if EAX value is greater than zero jump to L2
jg L2 
; if EAX value is less than zero jump to L3
jl L3 

L1: 
; call the function oneRealRoot
call oneRealRoot 
exit

L2:
; call the function twoRealRoots
call twoRealRoots 
exit

L3:
; if determinant value is less than zero then print the roots are imaginary
mov EDX, OFFSET prompt8 
call WriteString
call Crlf
exit

; end the main
main ENDP 

; Start the function determinant to find the determinant value
determinant PROC

; get the values from the stack
push EBP
mov EBP, esp
mov ECX, [EBP + 16] ; a
mov EBX, [EBP + 12] ; b
mov EAX, [EBP + 8] ; c
cdq
imul EBX, EBX ; b * b
imul ECX, EAX ; a * c
imul ECX, 4 ; 4 * a * c
sub EBX, ECX ; b * b - ( 4 * a * c )
mov EDX, EBX
mov EAX, EDX
pop EBP
; return the determinant value
ret
determinant ENDP

; Start the subroutine oneRealRoot to find the root of the equation
oneRealRoot PROC

mov EDX, OFFSET prompt7
call WriteString
; get the values from the stack
push EBP
mov EBP, ESP
mov ECX, [EBP + 20] ; a
mov EBX, [EBP + 16] ; b
mov EDX, [EBP + 12] ; c
neg EBX ; - b
imul ECX, 2 ; 2 a
mov EAX, EBX
cdq
idiv ECX ; - b / 2 a
; print the root value
call WriteInt 
call Crlf
pop EBP
; return to the main
ret 
oneRealRoot ENDP

;Start the subroutine twoRealRoots to find the real roots of the equation
twoRealRoots PROC

mov edx, OFFSET prompt5
call WriteString
; get the values from the stack
push EBP
mov EBP, ESP
mov EDX, [EBP + 20] ; a
mov EBX, [EBP + 16] ; b
mov ECX, [EBP + 12] ; c
mov EAX, [EBP + 8] ; sqrt ( det )
neg EBX ; - b
add EAX, EBX ; - b + sqrt ( det )
imul EDX, 2 ; 2 * a
mov ESI, EDX
cdq
idiv ESI ; ( - b + sqrt ( det )) / 2
; print the first root
call WriteDec 
mov edx, OFFSET spaceholder
call WriteString
mov EBP, esp
mov EDX, [EBP + 20] ; a
mov EBX, [EBP + 16] ; b
mov ECX, [EBP + 12] ; c
mov EAX, [EBP + 8] ; sqrt ( det )
neg EBX ; - b
sub EAX, EBX ; - b - sqrt ( det )
imul EDX, 2 ; 2 * a
mov ESI, EDX
cdq
idiv ESI ; ( - b - sqrt ( det )) / 2
; print the second root
call WriteInt 
call Crlf
pop ebp
; return to the main
ret 
twoRealRoots ENDP

End main