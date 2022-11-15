SECTION .bss
last_arg: resb 1

SECTION .text
; global _start           

put_symbol:
  push eax
  push ebx 
  push ecx
  push edx

  mov eax, 4
  mov ebx, 1
  mov ecx, [esp+20]
  mov edx, 1
  int 0x80

  pop edx
  pop ecx
  pop ebx
  pop eax
  ret

printf:
  mov eax, [esp+4]
  mov byte [last_arg], 0
  jmp printf_loop

printf_loop:
  cmp byte[eax], 0
  jz printf_end

  cmp byte[eax], 0x25
  jz print_ins

  push eax
  call put_symbol
  pop eax

  inc eax
  jmp printf_loop

print_ins:
  inc eax

  cmp byte[eax], 0x73
  jz print_str

  cmp byte[eax], 0x64
  jz print_number

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
  inc byte [last_arg]
  jmp printf_loop

print_number:
  push eax
  mov eax, [last_arg]
  add eax, [last_arg]
  add eax, [last_arg]
  add eax, [last_arg]
  mov eax, [esp+12+eax]
  mov eax, [eax]
  push dword 0
  mov ebp, esp

  jmp print_number_loop 

print_number_end_loop:
  cmp dword [ebp], 0
  jz print_number_end
  
  mov eax, 4
  mov ebx, 1
  mov ecx, esp
  mov edx, 1
  int 0x80
  pop edx
  dec dword [ebp]

  jmp print_number_end_loop

print_number_end:
  pop ebp
  pop eax
  inc eax
  inc byte [last_arg]
  jmp printf_loop


print_number_loop:
  cmp eax, 0
  jz print_number_end_loop
  mov edx, 0
  mov ecx, 0d10
  div ecx

  add edx, 0x30

  push edx
  inc dword [ebp]
  
  jmp print_number_loop


printf_end:
  ret

