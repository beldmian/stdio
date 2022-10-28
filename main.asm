SECTION .data
msg     db "Hello, %s, my friend, %s",0x0
name    db "World",0x0
end     db "end",0x0

SECTION .bss
last_arg: resb 1

SECTION .text
global _start           

put_symbol:
  mov eax, 4
  mov ebx, 1
  mov ecx, [esp+4]
  mov edx, 1
  int 0x80
  ret

printf:
  mov byte [last_arg], 0
  mov eax, [esp+4]
  jmp printf_loop

printf_loop:
  cmp byte[eax], 0
  jz printf_end

  cmp byte[eax], 0x25
  jz print_str

  push eax
  call put_symbol
  pop eax

  inc eax
  jmp printf_loop

print_str:
  push eax
  mov eax, [last_arg]
  add eax, [last_arg]
  add eax, [last_arg]
  add eax, [last_arg]
  mov eax, [esp+12+eax]
  call printf_loop
  pop eax
  inc eax
  inc eax
  inc byte [last_arg]
  jmp printf_loop

printf_end:
  ret
  
_start:        
  push end
  push name
  push msg
  call printf

  mov eax, 1  
  xor ebx, ebx
  int 0x80    
