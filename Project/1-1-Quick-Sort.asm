assume cs:code, ds:data, ss:stacksg

data segment
	s db 49, 38, 65, 97, 76, 13, 27, 49
data ends

stacksg segment stack
	dw 512 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 1024
		
		call QuickSort
		
		mov ax, 4c00h
		int 21h
	QuickSort:
		push ax
		push bx
		push bp
		
		mov bx, 0
		mov bp, 7
		call Sort
		
		pop bp
		pop bx
		pop ax
		
		ret
	Sort:
		cmp bx, bp
		jnb return
		
		push bx
		push bp
		call Partition
		pop bp
		pop bx
		
		push ax
		push bx
		push bp
		dec ax
		mov bp, ax
		call Sort
		pop bp
		pop bx
		pop ax
		
		push ax
		push bx
		push bp
		inc ax
		mov bx, ax
		call Sort
		pop bp
		pop bx
		pop ax
		
		return:
			ret
			
	Partition:
		mov al, s[bx]
		sttP3:
			sttP1:
				cmp bx, bp
				jnb edwP1
				cmp s[bp], al
				jb edwP1
				dec bp
				jmp sttP1
				edwP1:
					nop
			
			push ax
			mov al, s[bp]
			mov s[bx], al
			pop ax
			
			sttP2:
				cmp bx, bp
				jnb edwP2
				cmp s[bx], al
				jg edwP2
				inc bx
				jmp sttP2
				edwP2:
					nop
			
			push ax
			mov al, s[bx]
			mov s[bp], al
			pop ax
			
			cmp bx, bp
			jb sttP3
			
		mov s[bx], al
		mov ax, bx
		ret
code ends

end start