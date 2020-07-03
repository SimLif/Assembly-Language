assume cs:code

data segment
	a dw 8f1dh
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ax, a
		ror ax, 1
		rol ax, 1
		
		mov ax, a
		mov cl, 5
		rcl ax, cl
		mov cl, 7
		rcr ax, cl
		
		mov ax, 4c00h
		int 21h
code ends

end start