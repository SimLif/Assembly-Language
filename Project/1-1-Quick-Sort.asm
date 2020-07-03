assume cs:code, ds:data, ss:stacksg

stacksg segment stack
	dw 16 dup(0)
stacksg ends

data segment
	s db 49, 38, 65, 97, 76, 13, 27, 49
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 32
		
		mov ax, 4c00h
		int 21h

code ends

end start
