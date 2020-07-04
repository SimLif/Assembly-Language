assume cs:code, ds:data, ss:stacksg

SHOW macro string
	push ax
	
	lea dx, string
	mov ax, 0900h
	int 21h
	
	pop ax
endm

data segment
	test_str db '11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111.11111'
	str_list db '1234567890', 256 dup('$')
	divisor dw 10
data ends

stacksg segment stack
	dw 16 dup(?)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 32
		
		;SHOW test_str
		; the test_str shows that '0900h int21h' can word wrap
		
		mov ax, 65535
		mov bx, 0
		call Clearlist
		call NumtoStr
		SHOW str_list
		
		mov ax, 4c00h
		int 21h
	
	; function: make str_list all '$'
	; input: none
	; output: none
	Clearlist:
		push bx
		
		mov bx, 0
		forC1:
			cmp byte ptr str_list[bx], '$'
			jz endforC1
			
			mov byte ptr str_list[bx], '$'
			
			inc bx
			jmp forC1
			endforC1:
				nop
		
		pop bx
		ret
	
	; function: Convert number to string
	; input: ax--the number bx--the first empty place of string
	; output: bx--after the last place  of string 
	NumtoStr:
		push cx
		push dx
		
		mov cx, 0
		
		whileN1:
			mov dx, 0		
			div divisor
			add dx, 30h
			push dx
			inc cx
			cmp ax, 0
			jnz whileN1
		
		whileN2:
			pop dx
			mov byte ptr str_list[bx], dl
			inc bx
			loop whileN2
		
		pop dx
		pop cx
		ret
code ends
end start