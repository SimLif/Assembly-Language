assume cs:code,ds:data

data segment
	k  db 30, 30 dup(0)
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov dx, offset k
		mov ax, 0a00h
		int 21h
		
		mov ax, 4c00h
		int 21h
code ends
end start