assume cs:code

data segment
	a dw 100h
	b dw 100h
	x dw 0f0fh
	y dw 00ffh
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov dx, 0
		mov ax, a
		div b
		
		mov dx, 0
		mov ax, x
		div y
		
		mov ax, 4c00h
		int 21h
code ends

end start