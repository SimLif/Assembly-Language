assume cs:code, ds:data, ss:stacksg

data segment
	s db 0, 49, 38, 65, 97, 76, 13, 27, 49
	len dw 8
	divisor db 2
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
		
		call HeapSort
		
		mov ax, 4c00h
		int 21h
		
	HeapSort:
		push ax
		push bx
		push cx
		
		mov ax, len
		div divisor
		mov bh, 0
		mov bl, al
		mov ax, len
		
		forH1:
			cmp bx, 0
			jna endforH1
			push bx
			call HeapAdjust
			pop bx
			
			dec bx
			jmp forH1
			
			endforH1:
				nop
		
		mov bx, len
		forH2:
			cmp bx, 1
			jna endforH2
			call Swap
			push ax
			push bx
			dec bx
			mov ax, bx
			mov bx, 1
			call HeapAdjust
			pop bx
			pop ax
			dec bx
			jmp forH2
			
			endforH2:
				nop
		
		
		pop cx
		pop bx
		pop ax
		
		ret
	
	Swap:
		push ax
		push cx
		mov al, s[1]
		mov cl, s[bx]
		mov s[1], cl
		mov s[bx], al
		pop cx
		pop ax
		
		ret
	
	HeapAdjust:
		push cx
		push bp
		
		mov cl, s[bx]
		mov bp, bx
		add bx, bx
		
		forA1:
			cmp bx, ax
			ja endforA1
			
			ifA1:
				push bx
				inc bx
				cmp bx, ax
				pop bx
				
				jae endifA1
				push ax
				mov al, s[bx]
				cmp al, s[bx+1]
				pop ax
				jae endifA1
				inc bx
				endifA1:
					nop
				
			ifA2:
				cmp cl, s[bx]
				jae endforA1
			
			push ax
			mov al, s[bx]
			mov s[bp], al
			pop ax
			
			mov bp, bx
			add bx, bx
			jmp forA1
			
			endforA1:
				nop
		
		mov s[bp], cl
		
		pop bp
		pop cx
		
		ret
	
code ends
end start