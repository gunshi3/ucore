
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 10 12 40       	mov    $0x40121000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 10 12 00       	mov    %eax,0x121000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 00 12 00       	mov    $0x120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 60 aa 2a 00       	mov    $0x2aaa60,%eax
  100045:	2d 44 0a 12 00       	sub    $0x120a44,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 44 0a 12 00 	movl   $0x120a44,(%esp)
  10005d:	e8 46 7c 00 00       	call   107ca8 <memset>

    cons_init();                // init the console
  100062:	e8 42 16 00 00       	call   1016a9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 e0 84 10 00 	movl   $0x1084e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 fc 84 10 00 	movl   $0x1084fc,(%esp)
  10007c:	e8 48 02 00 00       	call   1002c9 <cprintf>

    print_kerninfo();
  100081:	e8 06 09 00 00       	call   10098c <print_kerninfo>

    grade_backtrace();
  100086:	e8 9a 00 00 00       	call   100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 c4 33 00 00       	call   103454 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 8f 17 00 00       	call   101824 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 34 19 00 00       	call   1019ce <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 51 0d 00 00       	call   100df0 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 cc 18 00 00       	call   101970 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  1000a4:	e8 86 01 00 00       	call   10022f <lab1_switch_test>

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x73>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	f3 0f 1e fb          	endbr32 
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000bc:	00 
  1000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c4:	00 
  1000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000cc:	e8 09 0d 00 00       	call   100dda <mon_backtrace>
}
  1000d1:	90                   	nop
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d4:	f3 0f 1e fb          	endbr32 
  1000d8:	55                   	push   %ebp
  1000d9:	89 e5                	mov    %esp,%ebp
  1000db:	53                   	push   %ebx
  1000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f7:	89 04 24             	mov    %eax,(%esp)
  1000fa:	e8 ac ff ff ff       	call   1000ab <grade_backtrace2>
}
  1000ff:	90                   	nop
  100100:	83 c4 14             	add    $0x14,%esp
  100103:	5b                   	pop    %ebx
  100104:	5d                   	pop    %ebp
  100105:	c3                   	ret    

00100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100106:	f3 0f 1e fb          	endbr32 
  10010a:	55                   	push   %ebp
  10010b:	89 e5                	mov    %esp,%ebp
  10010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100110:	8b 45 10             	mov    0x10(%ebp),%eax
  100113:	89 44 24 04          	mov    %eax,0x4(%esp)
  100117:	8b 45 08             	mov    0x8(%ebp),%eax
  10011a:	89 04 24             	mov    %eax,(%esp)
  10011d:	e8 b2 ff ff ff       	call   1000d4 <grade_backtrace1>
}
  100122:	90                   	nop
  100123:	c9                   	leave  
  100124:	c3                   	ret    

00100125 <grade_backtrace>:

void
grade_backtrace(void) {
  100125:	f3 0f 1e fb          	endbr32 
  100129:	55                   	push   %ebp
  10012a:	89 e5                	mov    %esp,%ebp
  10012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012f:	b8 36 00 10 00       	mov    $0x100036,%eax
  100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10013b:	ff 
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100147:	e8 ba ff ff ff       	call   100106 <grade_backtrace0>
}
  10014c:	90                   	nop
  10014d:	c9                   	leave  
  10014e:	c3                   	ret    

0010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014f:	f3 0f 1e fb          	endbr32 
  100153:	55                   	push   %ebp
  100154:	89 e5                	mov    %esp,%ebp
  100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	83 e0 03             	and    $0x3,%eax
  10016c:	89 c2                	mov    %eax,%edx
  10016e:	a1 00 30 12 00       	mov    0x123000,%eax
  100173:	89 54 24 08          	mov    %edx,0x8(%esp)
  100177:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017b:	c7 04 24 01 85 10 00 	movl   $0x108501,(%esp)
  100182:	e8 42 01 00 00       	call   1002c9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10018b:	89 c2                	mov    %eax,%edx
  10018d:	a1 00 30 12 00       	mov    0x123000,%eax
  100192:	89 54 24 08          	mov    %edx,0x8(%esp)
  100196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019a:	c7 04 24 0f 85 10 00 	movl   $0x10850f,(%esp)
  1001a1:	e8 23 01 00 00       	call   1002c9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001aa:	89 c2                	mov    %eax,%edx
  1001ac:	a1 00 30 12 00       	mov    0x123000,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 1d 85 10 00 	movl   $0x10851d,(%esp)
  1001c0:	e8 04 01 00 00       	call   1002c9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c9:	89 c2                	mov    %eax,%edx
  1001cb:	a1 00 30 12 00       	mov    0x123000,%eax
  1001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d8:	c7 04 24 2b 85 10 00 	movl   $0x10852b,(%esp)
  1001df:	e8 e5 00 00 00       	call   1002c9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e8:	89 c2                	mov    %eax,%edx
  1001ea:	a1 00 30 12 00       	mov    0x123000,%eax
  1001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f7:	c7 04 24 39 85 10 00 	movl   $0x108539,(%esp)
  1001fe:	e8 c6 00 00 00       	call   1002c9 <cprintf>
    round ++;
  100203:	a1 00 30 12 00       	mov    0x123000,%eax
  100208:	40                   	inc    %eax
  100209:	a3 00 30 12 00       	mov    %eax,0x123000
}
  10020e:	90                   	nop
  10020f:	c9                   	leave  
  100210:	c3                   	ret    

00100211 <lab1_switch_to_user>:

static void lab1_switch_to_user(void) {
  100211:	f3 0f 1e fb          	endbr32 
  100215:	55                   	push   %ebp
  100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  100218:	16                   	push   %ss
  100219:	54                   	push   %esp
  10021a:	cd 78                	int    $0x78
  10021c:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  10021e:	90                   	nop
  10021f:	5d                   	pop    %ebp
  100220:	c3                   	ret    

00100221 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100221:	f3 0f 1e fb          	endbr32 
  100225:	55                   	push   %ebp
  100226:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  100228:	cd 79                	int    $0x79
  10022a:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        : 
        : "i"(T_SWITCH_TOK)
    );
}
  10022c:	90                   	nop
  10022d:	5d                   	pop    %ebp
  10022e:	c3                   	ret    

0010022f <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10022f:	f3 0f 1e fb          	endbr32 
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100239:	e8 11 ff ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023e:	c7 04 24 48 85 10 00 	movl   $0x108548,(%esp)
  100245:	e8 7f 00 00 00       	call   1002c9 <cprintf>
    lab1_switch_to_user();
  10024a:	e8 c2 ff ff ff       	call   100211 <lab1_switch_to_user>
    lab1_print_cur_status();
  10024f:	e8 fb fe ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100254:	c7 04 24 68 85 10 00 	movl   $0x108568,(%esp)
  10025b:	e8 69 00 00 00       	call   1002c9 <cprintf>
    lab1_switch_to_kernel();
  100260:	e8 bc ff ff ff       	call   100221 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100265:	e8 e5 fe ff ff       	call   10014f <lab1_print_cur_status>
}
  10026a:	90                   	nop
  10026b:	c9                   	leave  
  10026c:	c3                   	ret    

0010026d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10026d:	f3 0f 1e fb          	endbr32 
  100271:	55                   	push   %ebp
  100272:	89 e5                	mov    %esp,%ebp
  100274:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100277:	8b 45 08             	mov    0x8(%ebp),%eax
  10027a:	89 04 24             	mov    %eax,(%esp)
  10027d:	e8 58 14 00 00       	call   1016da <cons_putc>
    (*cnt) ++;
  100282:	8b 45 0c             	mov    0xc(%ebp),%eax
  100285:	8b 00                	mov    (%eax),%eax
  100287:	8d 50 01             	lea    0x1(%eax),%edx
  10028a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10028d:	89 10                	mov    %edx,(%eax)
}
  10028f:	90                   	nop
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100292:	f3 0f 1e fb          	endbr32 
  100296:	55                   	push   %ebp
  100297:	89 e5                	mov    %esp,%ebp
  100299:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b8:	c7 04 24 6d 02 10 00 	movl   $0x10026d,(%esp)
  1002bf:	e8 50 7d 00 00       	call   108014 <vprintfmt>
    return cnt;
  1002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c7:	c9                   	leave  
  1002c8:	c3                   	ret    

001002c9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002c9:	f3 0f 1e fb          	endbr32 
  1002cd:	55                   	push   %ebp
  1002ce:	89 e5                	mov    %esp,%ebp
  1002d0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e3:	89 04 24             	mov    %eax,(%esp)
  1002e6:	e8 a7 ff ff ff       	call   100292 <vcprintf>
  1002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002f1:	c9                   	leave  
  1002f2:	c3                   	ret    

001002f3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002f3:	f3 0f 1e fb          	endbr32 
  1002f7:	55                   	push   %ebp
  1002f8:	89 e5                	mov    %esp,%ebp
  1002fa:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100300:	89 04 24             	mov    %eax,(%esp)
  100303:	e8 d2 13 00 00       	call   1016da <cons_putc>
}
  100308:	90                   	nop
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10030b:	f3 0f 1e fb          	endbr32 
  10030f:	55                   	push   %ebp
  100310:	89 e5                	mov    %esp,%ebp
  100312:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100315:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10031c:	eb 13                	jmp    100331 <cputs+0x26>
        cputch(c, &cnt);
  10031e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100322:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100325:	89 54 24 04          	mov    %edx,0x4(%esp)
  100329:	89 04 24             	mov    %eax,(%esp)
  10032c:	e8 3c ff ff ff       	call   10026d <cputch>
    while ((c = *str ++) != '\0') {
  100331:	8b 45 08             	mov    0x8(%ebp),%eax
  100334:	8d 50 01             	lea    0x1(%eax),%edx
  100337:	89 55 08             	mov    %edx,0x8(%ebp)
  10033a:	0f b6 00             	movzbl (%eax),%eax
  10033d:	88 45 f7             	mov    %al,-0x9(%ebp)
  100340:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100344:	75 d8                	jne    10031e <cputs+0x13>
    }
    cputch('\n', &cnt);
  100346:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100349:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100354:	e8 14 ff ff ff       	call   10026d <cputch>
    return cnt;
  100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10035c:	c9                   	leave  
  10035d:	c3                   	ret    

0010035e <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035e:	f3 0f 1e fb          	endbr32 
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100368:	90                   	nop
  100369:	e8 ad 13 00 00       	call   10171b <cons_getc>
  10036e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100375:	74 f2                	je     100369 <getchar+0xb>
        /* do nothing */;
    return c;
  100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037a:	c9                   	leave  
  10037b:	c3                   	ret    

0010037c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10037c:	f3 0f 1e fb          	endbr32 
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10038a:	74 13                	je     10039f <readline+0x23>
        cprintf("%s", prompt);
  10038c:	8b 45 08             	mov    0x8(%ebp),%eax
  10038f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100393:	c7 04 24 87 85 10 00 	movl   $0x108587,(%esp)
  10039a:	e8 2a ff ff ff       	call   1002c9 <cprintf>
    }
    int i = 0, c;
  10039f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a6:	e8 b3 ff ff ff       	call   10035e <getchar>
  1003ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003b2:	79 07                	jns    1003bb <readline+0x3f>
            return NULL;
  1003b4:	b8 00 00 00 00       	mov    $0x0,%eax
  1003b9:	eb 78                	jmp    100433 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003bb:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003bf:	7e 28                	jle    1003e9 <readline+0x6d>
  1003c1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c8:	7f 1f                	jg     1003e9 <readline+0x6d>
            cputchar(c);
  1003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003cd:	89 04 24             	mov    %eax,(%esp)
  1003d0:	e8 1e ff ff ff       	call   1002f3 <cputchar>
            buf[i ++] = c;
  1003d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d8:	8d 50 01             	lea    0x1(%eax),%edx
  1003db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003e1:	88 90 20 30 12 00    	mov    %dl,0x123020(%eax)
  1003e7:	eb 45                	jmp    10042e <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003e9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003ed:	75 16                	jne    100405 <readline+0x89>
  1003ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f3:	7e 10                	jle    100405 <readline+0x89>
            cputchar(c);
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	89 04 24             	mov    %eax,(%esp)
  1003fb:	e8 f3 fe ff ff       	call   1002f3 <cputchar>
            i --;
  100400:	ff 4d f4             	decl   -0xc(%ebp)
  100403:	eb 29                	jmp    10042e <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100405:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100409:	74 06                	je     100411 <readline+0x95>
  10040b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10040f:	75 95                	jne    1003a6 <readline+0x2a>
            cputchar(c);
  100411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100414:	89 04 24             	mov    %eax,(%esp)
  100417:	e8 d7 fe ff ff       	call   1002f3 <cputchar>
            buf[i] = '\0';
  10041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041f:	05 20 30 12 00       	add    $0x123020,%eax
  100424:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100427:	b8 20 30 12 00       	mov    $0x123020,%eax
  10042c:	eb 05                	jmp    100433 <readline+0xb7>
        c = getchar();
  10042e:	e9 73 ff ff ff       	jmp    1003a6 <readline+0x2a>
        }
    }
}
  100433:	c9                   	leave  
  100434:	c3                   	ret    

00100435 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100435:	f3 0f 1e fb          	endbr32 
  100439:	55                   	push   %ebp
  10043a:	89 e5                	mov    %esp,%ebp
  10043c:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10043f:	a1 20 34 12 00       	mov    0x123420,%eax
  100444:	85 c0                	test   %eax,%eax
  100446:	75 5b                	jne    1004a3 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100448:	c7 05 20 34 12 00 01 	movl   $0x1,0x123420
  10044f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100452:	8d 45 14             	lea    0x14(%ebp),%eax
  100455:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100458:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045f:	8b 45 08             	mov    0x8(%ebp),%eax
  100462:	89 44 24 04          	mov    %eax,0x4(%esp)
  100466:	c7 04 24 8a 85 10 00 	movl   $0x10858a,(%esp)
  10046d:	e8 57 fe ff ff       	call   1002c9 <cprintf>
    vcprintf(fmt, ap);
  100472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100475:	89 44 24 04          	mov    %eax,0x4(%esp)
  100479:	8b 45 10             	mov    0x10(%ebp),%eax
  10047c:	89 04 24             	mov    %eax,(%esp)
  10047f:	e8 0e fe ff ff       	call   100292 <vcprintf>
    cprintf("\n");
  100484:	c7 04 24 a6 85 10 00 	movl   $0x1085a6,(%esp)
  10048b:	e8 39 fe ff ff       	call   1002c9 <cprintf>
    
    cprintf("stack trackback:\n");
  100490:	c7 04 24 a8 85 10 00 	movl   $0x1085a8,(%esp)
  100497:	e8 2d fe ff ff       	call   1002c9 <cprintf>
    print_stackframe();
  10049c:	e8 3d 06 00 00       	call   100ade <print_stackframe>
  1004a1:	eb 01                	jmp    1004a4 <__panic+0x6f>
        goto panic_dead;
  1004a3:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a4:	e8 d3 14 00 00       	call   10197c <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004b0:	e8 4c 08 00 00       	call   100d01 <kmonitor>
  1004b5:	eb f2                	jmp    1004a9 <__panic+0x74>

001004b7 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b7:	f3 0f 1e fb          	endbr32 
  1004bb:	55                   	push   %ebp
  1004bc:	89 e5                	mov    %esp,%ebp
  1004be:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004c1:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d5:	c7 04 24 ba 85 10 00 	movl   $0x1085ba,(%esp)
  1004dc:	e8 e8 fd ff ff       	call   1002c9 <cprintf>
    vcprintf(fmt, ap);
  1004e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004eb:	89 04 24             	mov    %eax,(%esp)
  1004ee:	e8 9f fd ff ff       	call   100292 <vcprintf>
    cprintf("\n");
  1004f3:	c7 04 24 a6 85 10 00 	movl   $0x1085a6,(%esp)
  1004fa:	e8 ca fd ff ff       	call   1002c9 <cprintf>
    va_end(ap);
}
  1004ff:	90                   	nop
  100500:	c9                   	leave  
  100501:	c3                   	ret    

00100502 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100502:	f3 0f 1e fb          	endbr32 
  100506:	55                   	push   %ebp
  100507:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100509:	a1 20 34 12 00       	mov    0x123420,%eax
}
  10050e:	5d                   	pop    %ebp
  10050f:	c3                   	ret    

00100510 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100510:	f3 0f 1e fb          	endbr32 
  100514:	55                   	push   %ebp
  100515:	89 e5                	mov    %esp,%ebp
  100517:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051d:	8b 00                	mov    (%eax),%eax
  10051f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100522:	8b 45 10             	mov    0x10(%ebp),%eax
  100525:	8b 00                	mov    (%eax),%eax
  100527:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10052a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100531:	e9 ca 00 00 00       	jmp    100600 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100536:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10053c:	01 d0                	add    %edx,%eax
  10053e:	89 c2                	mov    %eax,%edx
  100540:	c1 ea 1f             	shr    $0x1f,%edx
  100543:	01 d0                	add    %edx,%eax
  100545:	d1 f8                	sar    %eax
  100547:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100550:	eb 03                	jmp    100555 <stab_binsearch+0x45>
            m --;
  100552:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100558:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10055b:	7c 1f                	jl     10057c <stab_binsearch+0x6c>
  10055d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100560:	89 d0                	mov    %edx,%eax
  100562:	01 c0                	add    %eax,%eax
  100564:	01 d0                	add    %edx,%eax
  100566:	c1 e0 02             	shl    $0x2,%eax
  100569:	89 c2                	mov    %eax,%edx
  10056b:	8b 45 08             	mov    0x8(%ebp),%eax
  10056e:	01 d0                	add    %edx,%eax
  100570:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100574:	0f b6 c0             	movzbl %al,%eax
  100577:	39 45 14             	cmp    %eax,0x14(%ebp)
  10057a:	75 d6                	jne    100552 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100582:	7d 09                	jge    10058d <stab_binsearch+0x7d>
            l = true_m + 1;
  100584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100587:	40                   	inc    %eax
  100588:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10058b:	eb 73                	jmp    100600 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10058d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100594:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100597:	89 d0                	mov    %edx,%eax
  100599:	01 c0                	add    %eax,%eax
  10059b:	01 d0                	add    %edx,%eax
  10059d:	c1 e0 02             	shl    $0x2,%eax
  1005a0:	89 c2                	mov    %eax,%edx
  1005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a5:	01 d0                	add    %edx,%eax
  1005a7:	8b 40 08             	mov    0x8(%eax),%eax
  1005aa:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ad:	76 11                	jbe    1005c0 <stab_binsearch+0xb0>
            *region_left = m;
  1005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b5:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005ba:	40                   	inc    %eax
  1005bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005be:	eb 40                	jmp    100600 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c3:	89 d0                	mov    %edx,%eax
  1005c5:	01 c0                	add    %eax,%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	c1 e0 02             	shl    $0x2,%eax
  1005cc:	89 c2                	mov    %eax,%edx
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	01 d0                	add    %edx,%eax
  1005d3:	8b 40 08             	mov    0x8(%eax),%eax
  1005d6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005d9:	73 14                	jae    1005ef <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005de:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e4:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e9:	48                   	dec    %eax
  1005ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005ed:	eb 11                	jmp    100600 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f5:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005fd:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  100600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100603:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100606:	0f 8e 2a ff ff ff    	jle    100536 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  10060c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100610:	75 0f                	jne    100621 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100612:	8b 45 0c             	mov    0xc(%ebp),%eax
  100615:	8b 00                	mov    (%eax),%eax
  100617:	8d 50 ff             	lea    -0x1(%eax),%edx
  10061a:	8b 45 10             	mov    0x10(%ebp),%eax
  10061d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10061f:	eb 3e                	jmp    10065f <stab_binsearch+0x14f>
        l = *region_right;
  100621:	8b 45 10             	mov    0x10(%ebp),%eax
  100624:	8b 00                	mov    (%eax),%eax
  100626:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100629:	eb 03                	jmp    10062e <stab_binsearch+0x11e>
  10062b:	ff 4d fc             	decl   -0x4(%ebp)
  10062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100631:	8b 00                	mov    (%eax),%eax
  100633:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100636:	7e 1f                	jle    100657 <stab_binsearch+0x147>
  100638:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10063b:	89 d0                	mov    %edx,%eax
  10063d:	01 c0                	add    %eax,%eax
  10063f:	01 d0                	add    %edx,%eax
  100641:	c1 e0 02             	shl    $0x2,%eax
  100644:	89 c2                	mov    %eax,%edx
  100646:	8b 45 08             	mov    0x8(%ebp),%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10064f:	0f b6 c0             	movzbl %al,%eax
  100652:	39 45 14             	cmp    %eax,0x14(%ebp)
  100655:	75 d4                	jne    10062b <stab_binsearch+0x11b>
        *region_left = l;
  100657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10065d:	89 10                	mov    %edx,(%eax)
}
  10065f:	90                   	nop
  100660:	c9                   	leave  
  100661:	c3                   	ret    

00100662 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100662:	f3 0f 1e fb          	endbr32 
  100666:	55                   	push   %ebp
  100667:	89 e5                	mov    %esp,%ebp
  100669:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066f:	c7 00 d8 85 10 00    	movl   $0x1085d8,(%eax)
    info->eip_line = 0;
  100675:	8b 45 0c             	mov    0xc(%ebp),%eax
  100678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100682:	c7 40 08 d8 85 10 00 	movl   $0x1085d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100689:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100693:	8b 45 0c             	mov    0xc(%ebp),%eax
  100696:	8b 55 08             	mov    0x8(%ebp),%edx
  100699:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a6:	c7 45 f4 bc 9d 10 00 	movl   $0x109dbc,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006ad:	c7 45 f0 34 a3 11 00 	movl   $0x11a334,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b4:	c7 45 ec 35 a3 11 00 	movl   $0x11a335,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006bb:	c7 45 e8 7b d7 11 00 	movl   $0x11d77b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c8:	76 0b                	jbe    1006d5 <debuginfo_eip+0x73>
  1006ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006cd:	48                   	dec    %eax
  1006ce:	0f b6 00             	movzbl (%eax),%eax
  1006d1:	84 c0                	test   %al,%al
  1006d3:	74 0a                	je     1006df <debuginfo_eip+0x7d>
        return -1;
  1006d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006da:	e9 ab 02 00 00       	jmp    10098a <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006ec:	c1 f8 02             	sar    $0x2,%eax
  1006ef:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f5:	48                   	dec    %eax
  1006f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100700:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100707:	00 
  100708:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10070b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100712:	89 44 24 04          	mov    %eax,0x4(%esp)
  100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100719:	89 04 24             	mov    %eax,(%esp)
  10071c:	e8 ef fd ff ff       	call   100510 <stab_binsearch>
    if (lfile == 0)
  100721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100724:	85 c0                	test   %eax,%eax
  100726:	75 0a                	jne    100732 <debuginfo_eip+0xd0>
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 58 02 00 00       	jmp    10098a <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100735:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100738:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073e:	8b 45 08             	mov    0x8(%ebp),%eax
  100741:	89 44 24 10          	mov    %eax,0x10(%esp)
  100745:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10074c:	00 
  10074d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100750:	89 44 24 08          	mov    %eax,0x8(%esp)
  100754:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100757:	89 44 24 04          	mov    %eax,0x4(%esp)
  10075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075e:	89 04 24             	mov    %eax,(%esp)
  100761:	e8 aa fd ff ff       	call   100510 <stab_binsearch>

    if (lfun <= rfun) {
  100766:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100769:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10076c:	39 c2                	cmp    %eax,%edx
  10076e:	7f 78                	jg     1007e8 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100770:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	89 d0                	mov    %edx,%eax
  100777:	01 c0                	add    %eax,%eax
  100779:	01 d0                	add    %edx,%eax
  10077b:	c1 e0 02             	shl    $0x2,%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100783:	01 d0                	add    %edx,%eax
  100785:	8b 10                	mov    (%eax),%edx
  100787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10078a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10078d:	39 c2                	cmp    %eax,%edx
  10078f:	73 22                	jae    1007b3 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100794:	89 c2                	mov    %eax,%edx
  100796:	89 d0                	mov    %edx,%eax
  100798:	01 c0                	add    %eax,%eax
  10079a:	01 d0                	add    %edx,%eax
  10079c:	c1 e0 02             	shl    $0x2,%eax
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	8b 10                	mov    (%eax),%edx
  1007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ab:	01 c2                	add    %eax,%edx
  1007ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	89 d0                	mov    %edx,%eax
  1007ba:	01 c0                	add    %eax,%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	c1 e0 02             	shl    $0x2,%eax
  1007c1:	89 c2                	mov    %eax,%edx
  1007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c6:	01 d0                	add    %edx,%eax
  1007c8:	8b 50 08             	mov    0x8(%eax),%edx
  1007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ce:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d4:	8b 40 10             	mov    0x10(%eax),%eax
  1007d7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e6:	eb 15                	jmp    1007fd <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ee:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	8b 40 08             	mov    0x8(%eax),%eax
  100803:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10080a:	00 
  10080b:	89 04 24             	mov    %eax,(%esp)
  10080e:	e8 09 73 00 00       	call   107b1c <strfind>
  100813:	8b 55 0c             	mov    0xc(%ebp),%edx
  100816:	8b 52 08             	mov    0x8(%edx),%edx
  100819:	29 d0                	sub    %edx,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100820:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100823:	8b 45 08             	mov    0x8(%ebp),%eax
  100826:	89 44 24 10          	mov    %eax,0x10(%esp)
  10082a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100831:	00 
  100832:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100835:	89 44 24 08          	mov    %eax,0x8(%esp)
  100839:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10083c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100843:	89 04 24             	mov    %eax,(%esp)
  100846:	e8 c5 fc ff ff       	call   100510 <stab_binsearch>
    if (lline <= rline) {
  10084b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100851:	39 c2                	cmp    %eax,%edx
  100853:	7f 23                	jg     100878 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100855:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100858:	89 c2                	mov    %eax,%edx
  10085a:	89 d0                	mov    %edx,%eax
  10085c:	01 c0                	add    %eax,%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	c1 e0 02             	shl    $0x2,%eax
  100863:	89 c2                	mov    %eax,%edx
  100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100868:	01 d0                	add    %edx,%eax
  10086a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086e:	89 c2                	mov    %eax,%edx
  100870:	8b 45 0c             	mov    0xc(%ebp),%eax
  100873:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100876:	eb 11                	jmp    100889 <debuginfo_eip+0x227>
        return -1;
  100878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10087d:	e9 08 01 00 00       	jmp    10098a <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100885:	48                   	dec    %eax
  100886:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100889:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088f:	39 c2                	cmp    %eax,%edx
  100891:	7c 56                	jl     1008e9 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100893:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100896:	89 c2                	mov    %eax,%edx
  100898:	89 d0                	mov    %edx,%eax
  10089a:	01 c0                	add    %eax,%eax
  10089c:	01 d0                	add    %edx,%eax
  10089e:	c1 e0 02             	shl    $0x2,%eax
  1008a1:	89 c2                	mov    %eax,%edx
  1008a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a6:	01 d0                	add    %edx,%eax
  1008a8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ac:	3c 84                	cmp    $0x84,%al
  1008ae:	74 39                	je     1008e9 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b3:	89 c2                	mov    %eax,%edx
  1008b5:	89 d0                	mov    %edx,%eax
  1008b7:	01 c0                	add    %eax,%eax
  1008b9:	01 d0                	add    %edx,%eax
  1008bb:	c1 e0 02             	shl    $0x2,%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c3:	01 d0                	add    %edx,%eax
  1008c5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c9:	3c 64                	cmp    $0x64,%al
  1008cb:	75 b5                	jne    100882 <debuginfo_eip+0x220>
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	8b 40 08             	mov    0x8(%eax),%eax
  1008e5:	85 c0                	test   %eax,%eax
  1008e7:	74 99                	je     100882 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ef:	39 c2                	cmp    %eax,%edx
  1008f1:	7c 42                	jl     100935 <debuginfo_eip+0x2d3>
  1008f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f6:	89 c2                	mov    %eax,%edx
  1008f8:	89 d0                	mov    %edx,%eax
  1008fa:	01 c0                	add    %eax,%eax
  1008fc:	01 d0                	add    %edx,%eax
  1008fe:	c1 e0 02             	shl    $0x2,%eax
  100901:	89 c2                	mov    %eax,%edx
  100903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100906:	01 d0                	add    %edx,%eax
  100908:	8b 10                	mov    (%eax),%edx
  10090a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10090d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100910:	39 c2                	cmp    %eax,%edx
  100912:	73 21                	jae    100935 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100917:	89 c2                	mov    %eax,%edx
  100919:	89 d0                	mov    %edx,%eax
  10091b:	01 c0                	add    %eax,%eax
  10091d:	01 d0                	add    %edx,%eax
  10091f:	c1 e0 02             	shl    $0x2,%eax
  100922:	89 c2                	mov    %eax,%edx
  100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100927:	01 d0                	add    %edx,%eax
  100929:	8b 10                	mov    (%eax),%edx
  10092b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092e:	01 c2                	add    %eax,%edx
  100930:	8b 45 0c             	mov    0xc(%ebp),%eax
  100933:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100935:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100938:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10093b:	39 c2                	cmp    %eax,%edx
  10093d:	7d 46                	jge    100985 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10093f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100942:	40                   	inc    %eax
  100943:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100946:	eb 16                	jmp    10095e <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100948:	8b 45 0c             	mov    0xc(%ebp),%eax
  10094b:	8b 40 14             	mov    0x14(%eax),%eax
  10094e:	8d 50 01             	lea    0x1(%eax),%edx
  100951:	8b 45 0c             	mov    0xc(%ebp),%eax
  100954:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100957:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10095a:	40                   	inc    %eax
  10095b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100961:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100964:	39 c2                	cmp    %eax,%edx
  100966:	7d 1d                	jge    100985 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10096b:	89 c2                	mov    %eax,%edx
  10096d:	89 d0                	mov    %edx,%eax
  10096f:	01 c0                	add    %eax,%eax
  100971:	01 d0                	add    %edx,%eax
  100973:	c1 e0 02             	shl    $0x2,%eax
  100976:	89 c2                	mov    %eax,%edx
  100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097b:	01 d0                	add    %edx,%eax
  10097d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100981:	3c a0                	cmp    $0xa0,%al
  100983:	74 c3                	je     100948 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100985:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10098a:	c9                   	leave  
  10098b:	c3                   	ret    

0010098c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10098c:	f3 0f 1e fb          	endbr32 
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100996:	c7 04 24 e2 85 10 00 	movl   $0x1085e2,(%esp)
  10099d:	e8 27 f9 ff ff       	call   1002c9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1009a2:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009a9:	00 
  1009aa:	c7 04 24 fb 85 10 00 	movl   $0x1085fb,(%esp)
  1009b1:	e8 13 f9 ff ff       	call   1002c9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b6:	c7 44 24 04 cc 84 10 	movl   $0x1084cc,0x4(%esp)
  1009bd:	00 
  1009be:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1009c5:	e8 ff f8 ff ff       	call   1002c9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009ca:	c7 44 24 04 44 0a 12 	movl   $0x120a44,0x4(%esp)
  1009d1:	00 
  1009d2:	c7 04 24 2b 86 10 00 	movl   $0x10862b,(%esp)
  1009d9:	e8 eb f8 ff ff       	call   1002c9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009de:	c7 44 24 04 60 aa 2a 	movl   $0x2aaa60,0x4(%esp)
  1009e5:	00 
  1009e6:	c7 04 24 43 86 10 00 	movl   $0x108643,(%esp)
  1009ed:	e8 d7 f8 ff ff       	call   1002c9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009f2:	b8 60 aa 2a 00       	mov    $0x2aaa60,%eax
  1009f7:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009fc:	05 ff 03 00 00       	add    $0x3ff,%eax
  100a01:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a07:	85 c0                	test   %eax,%eax
  100a09:	0f 48 c2             	cmovs  %edx,%eax
  100a0c:	c1 f8 0a             	sar    $0xa,%eax
  100a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a13:	c7 04 24 5c 86 10 00 	movl   $0x10865c,(%esp)
  100a1a:	e8 aa f8 ff ff       	call   1002c9 <cprintf>
}
  100a1f:	90                   	nop
  100a20:	c9                   	leave  
  100a21:	c3                   	ret    

00100a22 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a22:	f3 0f 1e fb          	endbr32 
  100a26:	55                   	push   %ebp
  100a27:	89 e5                	mov    %esp,%ebp
  100a29:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a2f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a36:	8b 45 08             	mov    0x8(%ebp),%eax
  100a39:	89 04 24             	mov    %eax,(%esp)
  100a3c:	e8 21 fc ff ff       	call   100662 <debuginfo_eip>
  100a41:	85 c0                	test   %eax,%eax
  100a43:	74 15                	je     100a5a <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a45:	8b 45 08             	mov    0x8(%ebp),%eax
  100a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a4c:	c7 04 24 86 86 10 00 	movl   $0x108686,(%esp)
  100a53:	e8 71 f8 ff ff       	call   1002c9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a58:	eb 6c                	jmp    100ac6 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a61:	eb 1b                	jmp    100a7e <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	01 d0                	add    %edx,%eax
  100a6b:	0f b6 10             	movzbl (%eax),%edx
  100a6e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a77:	01 c8                	add    %ecx,%eax
  100a79:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a7b:	ff 45 f4             	incl   -0xc(%ebp)
  100a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a84:	7c dd                	jl     100a63 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a86:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8f:	01 d0                	add    %edx,%eax
  100a91:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a97:	8b 55 08             	mov    0x8(%ebp),%edx
  100a9a:	89 d1                	mov    %edx,%ecx
  100a9c:	29 c1                	sub    %eax,%ecx
  100a9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100aa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa8:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100ab2:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aba:	c7 04 24 a2 86 10 00 	movl   $0x1086a2,(%esp)
  100ac1:	e8 03 f8 ff ff       	call   1002c9 <cprintf>
}
  100ac6:	90                   	nop
  100ac7:	c9                   	leave  
  100ac8:	c3                   	ret    

00100ac9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ac9:	f3 0f 1e fb          	endbr32 
  100acd:	55                   	push   %ebp
  100ace:	89 e5                	mov    %esp,%ebp
  100ad0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ad3:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100adc:	c9                   	leave  
  100add:	c3                   	ret    

00100ade <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100ade:	f3 0f 1e fb          	endbr32 
  100ae2:	55                   	push   %ebp
  100ae3:	89 e5                	mov    %esp,%ebp
  100ae5:	53                   	push   %ebx
  100ae6:	83 ec 34             	sub    $0x34,%esp
    首先通过函数读取ebp、eip寄存器值，分别表示指向栈底的地址、当前指令的地址；
    ss:[ebp + 8]为函数第一个参数地址，ss:[ebp + 12]为第二个参数地址；
    ss:[ebp]处为上一级函数的ebp地址，ss:[ebp+4]为返回地址；
    可通过指针索引的方式访问指针所指内容
    */
    uint32_t *ebp = 0;                  
  100ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32_t esp = 0;                   
  100af0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100af7:	89 e8                	mov    %ebp,%eax
  100af9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100afc:	8b 45 ec             	mov    -0x14(%ebp),%eax

    ebp = (uint32_t *)read_ebp();           //函数读取ebp、eip寄存器值
  100aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    esp = read_eip();                       //
  100b02:	e8 c2 ff ff ff       	call   100ac9 <read_eip>
  100b07:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp)                             //当栈底元素不为空的时候,迭代打印
  100b0a:	eb 73                	jmp    100b7f <print_stackframe+0xa1>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
  100b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b12:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1a:	c7 04 24 b4 86 10 00 	movl   $0x1086b4,(%esp)
  100b21:	e8 a3 f7 ff ff       	call   1002c9 <cprintf>
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
  100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b29:	83 c0 14             	add    $0x14,%eax
  100b2c:	8b 18                	mov    (%eax),%ebx
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b31:	83 c0 10             	add    $0x10,%eax
  100b34:	8b 08                	mov    (%eax),%ecx
  100b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b39:	83 c0 0c             	add    $0xc,%eax
  100b3c:	8b 10                	mov    (%eax),%edx
  100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b41:	83 c0 08             	add    $0x8,%eax
  100b44:	8b 00                	mov    (%eax),%eax
  100b46:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b4a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b56:	c7 04 24 d0 86 10 00 	movl   $0x1086d0,(%esp)
  100b5d:	e8 67 f7 ff ff       	call   1002c9 <cprintf>

        print_debuginfo(esp - 1);
  100b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b65:	48                   	dec    %eax
  100b66:	89 04 24             	mov    %eax,(%esp)
  100b69:	e8 b4 fe ff ff       	call   100a22 <print_debuginfo>

        esp = ebp[1];                       //迭代,将ebp[1]-----> esp, *[*ebp]指向下一个地址,将它赋值给ebp
  100b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b71:	8b 40 04             	mov    0x4(%eax),%eax
  100b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = (uint32_t *)*ebp;
  100b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b7a:	8b 00                	mov    (%eax),%eax
  100b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (ebp)                             //当栈底元素不为空的时候,迭代打印
  100b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b83:	75 87                	jne    100b0c <print_stackframe+0x2e>
    }
}
  100b85:	90                   	nop
  100b86:	90                   	nop
  100b87:	83 c4 34             	add    $0x34,%esp
  100b8a:	5b                   	pop    %ebx
  100b8b:	5d                   	pop    %ebp
  100b8c:	c3                   	ret    

00100b8d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b8d:	f3 0f 1e fb          	endbr32 
  100b91:	55                   	push   %ebp
  100b92:	89 e5                	mov    %esp,%ebp
  100b94:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b9e:	eb 0c                	jmp    100bac <parse+0x1f>
            *buf ++ = '\0';
  100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba3:	8d 50 01             	lea    0x1(%eax),%edx
  100ba6:	89 55 08             	mov    %edx,0x8(%ebp)
  100ba9:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bac:	8b 45 08             	mov    0x8(%ebp),%eax
  100baf:	0f b6 00             	movzbl (%eax),%eax
  100bb2:	84 c0                	test   %al,%al
  100bb4:	74 1d                	je     100bd3 <parse+0x46>
  100bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb9:	0f b6 00             	movzbl (%eax),%eax
  100bbc:	0f be c0             	movsbl %al,%eax
  100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc3:	c7 04 24 70 87 10 00 	movl   $0x108770,(%esp)
  100bca:	e8 17 6f 00 00       	call   107ae6 <strchr>
  100bcf:	85 c0                	test   %eax,%eax
  100bd1:	75 cd                	jne    100ba0 <parse+0x13>
        }
        if (*buf == '\0') {
  100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd6:	0f b6 00             	movzbl (%eax),%eax
  100bd9:	84 c0                	test   %al,%al
  100bdb:	74 65                	je     100c42 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bdd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100be1:	75 14                	jne    100bf7 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100be3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bea:	00 
  100beb:	c7 04 24 75 87 10 00 	movl   $0x108775,(%esp)
  100bf2:	e8 d2 f6 ff ff       	call   1002c9 <cprintf>
        }
        argv[argc ++] = buf;
  100bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bfa:	8d 50 01             	lea    0x1(%eax),%edx
  100bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c0a:	01 c2                	add    %eax,%edx
  100c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c11:	eb 03                	jmp    100c16 <parse+0x89>
            buf ++;
  100c13:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c16:	8b 45 08             	mov    0x8(%ebp),%eax
  100c19:	0f b6 00             	movzbl (%eax),%eax
  100c1c:	84 c0                	test   %al,%al
  100c1e:	74 8c                	je     100bac <parse+0x1f>
  100c20:	8b 45 08             	mov    0x8(%ebp),%eax
  100c23:	0f b6 00             	movzbl (%eax),%eax
  100c26:	0f be c0             	movsbl %al,%eax
  100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2d:	c7 04 24 70 87 10 00 	movl   $0x108770,(%esp)
  100c34:	e8 ad 6e 00 00       	call   107ae6 <strchr>
  100c39:	85 c0                	test   %eax,%eax
  100c3b:	74 d6                	je     100c13 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c3d:	e9 6a ff ff ff       	jmp    100bac <parse+0x1f>
            break;
  100c42:	90                   	nop
        }
    }
    return argc;
  100c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c46:	c9                   	leave  
  100c47:	c3                   	ret    

00100c48 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c48:	f3 0f 1e fb          	endbr32 
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	53                   	push   %ebx
  100c50:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c53:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c5d:	89 04 24             	mov    %eax,(%esp)
  100c60:	e8 28 ff ff ff       	call   100b8d <parse>
  100c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c6c:	75 0a                	jne    100c78 <runcmd+0x30>
        return 0;
  100c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  100c73:	e9 83 00 00 00       	jmp    100cfb <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c7f:	eb 5a                	jmp    100cdb <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c81:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c87:	89 d0                	mov    %edx,%eax
  100c89:	01 c0                	add    %eax,%eax
  100c8b:	01 d0                	add    %edx,%eax
  100c8d:	c1 e0 02             	shl    $0x2,%eax
  100c90:	05 00 00 12 00       	add    $0x120000,%eax
  100c95:	8b 00                	mov    (%eax),%eax
  100c97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c9b:	89 04 24             	mov    %eax,(%esp)
  100c9e:	e8 9f 6d 00 00       	call   107a42 <strcmp>
  100ca3:	85 c0                	test   %eax,%eax
  100ca5:	75 31                	jne    100cd8 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100caa:	89 d0                	mov    %edx,%eax
  100cac:	01 c0                	add    %eax,%eax
  100cae:	01 d0                	add    %edx,%eax
  100cb0:	c1 e0 02             	shl    $0x2,%eax
  100cb3:	05 08 00 12 00       	add    $0x120008,%eax
  100cb8:	8b 10                	mov    (%eax),%edx
  100cba:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cbd:	83 c0 04             	add    $0x4,%eax
  100cc0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cc3:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd1:	89 1c 24             	mov    %ebx,(%esp)
  100cd4:	ff d2                	call   *%edx
  100cd6:	eb 23                	jmp    100cfb <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd8:	ff 45 f4             	incl   -0xc(%ebp)
  100cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cde:	83 f8 02             	cmp    $0x2,%eax
  100ce1:	76 9e                	jbe    100c81 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ce3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cea:	c7 04 24 93 87 10 00 	movl   $0x108793,(%esp)
  100cf1:	e8 d3 f5 ff ff       	call   1002c9 <cprintf>
    return 0;
  100cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cfb:	83 c4 64             	add    $0x64,%esp
  100cfe:	5b                   	pop    %ebx
  100cff:	5d                   	pop    %ebp
  100d00:	c3                   	ret    

00100d01 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d01:	f3 0f 1e fb          	endbr32 
  100d05:	55                   	push   %ebp
  100d06:	89 e5                	mov    %esp,%ebp
  100d08:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d0b:	c7 04 24 ac 87 10 00 	movl   $0x1087ac,(%esp)
  100d12:	e8 b2 f5 ff ff       	call   1002c9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d17:	c7 04 24 d4 87 10 00 	movl   $0x1087d4,(%esp)
  100d1e:	e8 a6 f5 ff ff       	call   1002c9 <cprintf>

    if (tf != NULL) {
  100d23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d27:	74 0b                	je     100d34 <kmonitor+0x33>
        print_trapframe(tf);
  100d29:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2c:	89 04 24             	mov    %eax,(%esp)
  100d2f:	e8 5f 0e 00 00       	call   101b93 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d34:	c7 04 24 f9 87 10 00 	movl   $0x1087f9,(%esp)
  100d3b:	e8 3c f6 ff ff       	call   10037c <readline>
  100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d47:	74 eb                	je     100d34 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d49:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d53:	89 04 24             	mov    %eax,(%esp)
  100d56:	e8 ed fe ff ff       	call   100c48 <runcmd>
  100d5b:	85 c0                	test   %eax,%eax
  100d5d:	78 02                	js     100d61 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d5f:	eb d3                	jmp    100d34 <kmonitor+0x33>
                break;
  100d61:	90                   	nop
            }
        }
    }
}
  100d62:	90                   	nop
  100d63:	c9                   	leave  
  100d64:	c3                   	ret    

00100d65 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d65:	f3 0f 1e fb          	endbr32 
  100d69:	55                   	push   %ebp
  100d6a:	89 e5                	mov    %esp,%ebp
  100d6c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d76:	eb 3d                	jmp    100db5 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d7b:	89 d0                	mov    %edx,%eax
  100d7d:	01 c0                	add    %eax,%eax
  100d7f:	01 d0                	add    %edx,%eax
  100d81:	c1 e0 02             	shl    $0x2,%eax
  100d84:	05 04 00 12 00       	add    $0x120004,%eax
  100d89:	8b 08                	mov    (%eax),%ecx
  100d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d8e:	89 d0                	mov    %edx,%eax
  100d90:	01 c0                	add    %eax,%eax
  100d92:	01 d0                	add    %edx,%eax
  100d94:	c1 e0 02             	shl    $0x2,%eax
  100d97:	05 00 00 12 00       	add    $0x120000,%eax
  100d9c:	8b 00                	mov    (%eax),%eax
  100d9e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100da2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100da6:	c7 04 24 fd 87 10 00 	movl   $0x1087fd,(%esp)
  100dad:	e8 17 f5 ff ff       	call   1002c9 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100db2:	ff 45 f4             	incl   -0xc(%ebp)
  100db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100db8:	83 f8 02             	cmp    $0x2,%eax
  100dbb:	76 bb                	jbe    100d78 <mon_help+0x13>
    }
    return 0;
  100dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dc2:	c9                   	leave  
  100dc3:	c3                   	ret    

00100dc4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dc4:	f3 0f 1e fb          	endbr32 
  100dc8:	55                   	push   %ebp
  100dc9:	89 e5                	mov    %esp,%ebp
  100dcb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dce:	e8 b9 fb ff ff       	call   10098c <print_kerninfo>
    return 0;
  100dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd8:	c9                   	leave  
  100dd9:	c3                   	ret    

00100dda <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100dda:	f3 0f 1e fb          	endbr32 
  100dde:	55                   	push   %ebp
  100ddf:	89 e5                	mov    %esp,%ebp
  100de1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100de4:	e8 f5 fc ff ff       	call   100ade <print_stackframe>
    return 0;
  100de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df0:	f3 0f 1e fb          	endbr32 
  100df4:	55                   	push   %ebp
  100df5:	89 e5                	mov    %esp,%ebp
  100df7:	83 ec 28             	sub    $0x28,%esp
  100dfa:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e00:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e04:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e08:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e0c:	ee                   	out    %al,(%dx)
}
  100e0d:	90                   	nop
  100e0e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e14:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e18:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e1c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e20:	ee                   	out    %al,(%dx)
}
  100e21:	90                   	nop
  100e22:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e28:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e2c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e34:	ee                   	out    %al,(%dx)
}
  100e35:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e36:	c7 05 a0 3f 12 00 00 	movl   $0x0,0x123fa0
  100e3d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e40:	c7 04 24 06 88 10 00 	movl   $0x108806,(%esp)
  100e47:	e8 7d f4 ff ff       	call   1002c9 <cprintf>
    pic_enable(IRQ_TIMER);
  100e4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e53:	e8 95 09 00 00       	call   1017ed <pic_enable>
}
  100e58:	90                   	nop
  100e59:	c9                   	leave  
  100e5a:	c3                   	ret    

00100e5b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e5b:	55                   	push   %ebp
  100e5c:	89 e5                	mov    %esp,%ebp
  100e5e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e61:	9c                   	pushf  
  100e62:	58                   	pop    %eax
  100e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e69:	25 00 02 00 00       	and    $0x200,%eax
  100e6e:	85 c0                	test   %eax,%eax
  100e70:	74 0c                	je     100e7e <__intr_save+0x23>
        intr_disable();
  100e72:	e8 05 0b 00 00       	call   10197c <intr_disable>
        return 1;
  100e77:	b8 01 00 00 00       	mov    $0x1,%eax
  100e7c:	eb 05                	jmp    100e83 <__intr_save+0x28>
    }
    return 0;
  100e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e83:	c9                   	leave  
  100e84:	c3                   	ret    

00100e85 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e85:	55                   	push   %ebp
  100e86:	89 e5                	mov    %esp,%ebp
  100e88:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e8f:	74 05                	je     100e96 <__intr_restore+0x11>
        intr_enable();
  100e91:	e8 da 0a 00 00       	call   101970 <intr_enable>
    }
}
  100e96:	90                   	nop
  100e97:	c9                   	leave  
  100e98:	c3                   	ret    

00100e99 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e99:	f3 0f 1e fb          	endbr32 
  100e9d:	55                   	push   %ebp
  100e9e:	89 e5                	mov    %esp,%ebp
  100ea0:	83 ec 10             	sub    $0x10,%esp
  100ea3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ea9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ead:	89 c2                	mov    %eax,%edx
  100eaf:	ec                   	in     (%dx),%al
  100eb0:	88 45 f1             	mov    %al,-0xf(%ebp)
  100eb3:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100eb9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ebd:	89 c2                	mov    %eax,%edx
  100ebf:	ec                   	in     (%dx),%al
  100ec0:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ec3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ec9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ecd:	89 c2                	mov    %eax,%edx
  100ecf:	ec                   	in     (%dx),%al
  100ed0:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ed3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ed9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100edd:	89 c2                	mov    %eax,%edx
  100edf:	ec                   	in     (%dx),%al
  100ee0:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ee3:	90                   	nop
  100ee4:	c9                   	leave  
  100ee5:	c3                   	ret    

00100ee6 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ee6:	f3 0f 1e fb          	endbr32 
  100eea:	55                   	push   %ebp
  100eeb:	89 e5                	mov    %esp,%ebp
  100eed:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef0:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efa:	0f b7 00             	movzwl (%eax),%eax
  100efd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f04:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0c:	0f b7 00             	movzwl (%eax),%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f17:	74 12                	je     100f2b <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f19:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f20:	66 c7 05 46 34 12 00 	movw   $0x3b4,0x123446
  100f27:	b4 03 
  100f29:	eb 13                	jmp    100f3e <cga_init+0x58>
    } else {
        *cp = was;
  100f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f32:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f35:	66 c7 05 46 34 12 00 	movw   $0x3d4,0x123446
  100f3c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f3e:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f45:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f49:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f51:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f55:	ee                   	out    %al,(%dx)
}
  100f56:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f57:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f5e:	40                   	inc    %eax
  100f5f:	0f b7 c0             	movzwl %ax,%eax
  100f62:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f66:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f6a:	89 c2                	mov    %eax,%edx
  100f6c:	ec                   	in     (%dx),%al
  100f6d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f70:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f74:	0f b6 c0             	movzbl %al,%eax
  100f77:	c1 e0 08             	shl    $0x8,%eax
  100f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f7d:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f84:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f88:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
}
  100f95:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f96:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f9d:	40                   	inc    %eax
  100f9e:	0f b7 c0             	movzwl %ax,%eax
  100fa1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fa5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100faf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fb3:	0f b6 c0             	movzbl %al,%eax
  100fb6:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fbc:	a3 40 34 12 00       	mov    %eax,0x123440
    crt_pos = pos;
  100fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fc4:	0f b7 c0             	movzwl %ax,%eax
  100fc7:	66 a3 44 34 12 00    	mov    %ax,0x123444
}
  100fcd:	90                   	nop
  100fce:	c9                   	leave  
  100fcf:	c3                   	ret    

00100fd0 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd0:	f3 0f 1e fb          	endbr32 
  100fd4:	55                   	push   %ebp
  100fd5:	89 e5                	mov    %esp,%ebp
  100fd7:	83 ec 48             	sub    $0x48,%esp
  100fda:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe0:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fe8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
}
  100fed:	90                   	nop
  100fee:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ff4:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ffc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101000:	ee                   	out    %al,(%dx)
}
  101001:	90                   	nop
  101002:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101008:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10100c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101010:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101014:	ee                   	out    %al,(%dx)
}
  101015:	90                   	nop
  101016:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10101c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101020:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101024:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101028:	ee                   	out    %al,(%dx)
}
  101029:	90                   	nop
  10102a:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101030:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101034:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101038:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10103c:	ee                   	out    %al,(%dx)
}
  10103d:	90                   	nop
  10103e:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101044:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101048:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10104c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101050:	ee                   	out    %al,(%dx)
}
  101051:	90                   	nop
  101052:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101058:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10105c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101060:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101064:	ee                   	out    %al,(%dx)
}
  101065:	90                   	nop
  101066:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10106c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101070:	89 c2                	mov    %eax,%edx
  101072:	ec                   	in     (%dx),%al
  101073:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101076:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10107a:	3c ff                	cmp    $0xff,%al
  10107c:	0f 95 c0             	setne  %al
  10107f:	0f b6 c0             	movzbl %al,%eax
  101082:	a3 48 34 12 00       	mov    %eax,0x123448
  101087:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10108d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101091:	89 c2                	mov    %eax,%edx
  101093:	ec                   	in     (%dx),%al
  101094:	88 45 f1             	mov    %al,-0xf(%ebp)
  101097:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10109d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010a1:	89 c2                	mov    %eax,%edx
  1010a3:	ec                   	in     (%dx),%al
  1010a4:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010a7:	a1 48 34 12 00       	mov    0x123448,%eax
  1010ac:	85 c0                	test   %eax,%eax
  1010ae:	74 0c                	je     1010bc <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010b7:	e8 31 07 00 00       	call   1017ed <pic_enable>
    }
}
  1010bc:	90                   	nop
  1010bd:	c9                   	leave  
  1010be:	c3                   	ret    

001010bf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010bf:	f3 0f 1e fb          	endbr32 
  1010c3:	55                   	push   %ebp
  1010c4:	89 e5                	mov    %esp,%ebp
  1010c6:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d0:	eb 08                	jmp    1010da <lpt_putc_sub+0x1b>
        delay();
  1010d2:	e8 c2 fd ff ff       	call   100e99 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d7:	ff 45 fc             	incl   -0x4(%ebp)
  1010da:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010e4:	89 c2                	mov    %eax,%edx
  1010e6:	ec                   	in     (%dx),%al
  1010e7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010ee:	84 c0                	test   %al,%al
  1010f0:	78 09                	js     1010fb <lpt_putc_sub+0x3c>
  1010f2:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010f9:	7e d7                	jle    1010d2 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fe:	0f b6 c0             	movzbl %al,%eax
  101101:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101107:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10110a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10110e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101112:	ee                   	out    %al,(%dx)
}
  101113:	90                   	nop
  101114:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10111a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10111e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101122:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101126:	ee                   	out    %al,(%dx)
}
  101127:	90                   	nop
  101128:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10112e:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101132:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101136:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10113a:	ee                   	out    %al,(%dx)
}
  10113b:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10113c:	90                   	nop
  10113d:	c9                   	leave  
  10113e:	c3                   	ret    

0010113f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10113f:	f3 0f 1e fb          	endbr32 
  101143:	55                   	push   %ebp
  101144:	89 e5                	mov    %esp,%ebp
  101146:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101149:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10114d:	74 0d                	je     10115c <lpt_putc+0x1d>
        lpt_putc_sub(c);
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	89 04 24             	mov    %eax,(%esp)
  101155:	e8 65 ff ff ff       	call   1010bf <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10115a:	eb 24                	jmp    101180 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  10115c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101163:	e8 57 ff ff ff       	call   1010bf <lpt_putc_sub>
        lpt_putc_sub(' ');
  101168:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10116f:	e8 4b ff ff ff       	call   1010bf <lpt_putc_sub>
        lpt_putc_sub('\b');
  101174:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10117b:	e8 3f ff ff ff       	call   1010bf <lpt_putc_sub>
}
  101180:	90                   	nop
  101181:	c9                   	leave  
  101182:	c3                   	ret    

00101183 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101183:	f3 0f 1e fb          	endbr32 
  101187:	55                   	push   %ebp
  101188:	89 e5                	mov    %esp,%ebp
  10118a:	53                   	push   %ebx
  10118b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10118e:	8b 45 08             	mov    0x8(%ebp),%eax
  101191:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101196:	85 c0                	test   %eax,%eax
  101198:	75 07                	jne    1011a1 <cga_putc+0x1e>
        c |= 0x0700;
  10119a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a4:	0f b6 c0             	movzbl %al,%eax
  1011a7:	83 f8 0d             	cmp    $0xd,%eax
  1011aa:	74 72                	je     10121e <cga_putc+0x9b>
  1011ac:	83 f8 0d             	cmp    $0xd,%eax
  1011af:	0f 8f a3 00 00 00    	jg     101258 <cga_putc+0xd5>
  1011b5:	83 f8 08             	cmp    $0x8,%eax
  1011b8:	74 0a                	je     1011c4 <cga_putc+0x41>
  1011ba:	83 f8 0a             	cmp    $0xa,%eax
  1011bd:	74 4c                	je     10120b <cga_putc+0x88>
  1011bf:	e9 94 00 00 00       	jmp    101258 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011c4:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1011cb:	85 c0                	test   %eax,%eax
  1011cd:	0f 84 af 00 00 00    	je     101282 <cga_putc+0xff>
            crt_pos --;
  1011d3:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1011da:	48                   	dec    %eax
  1011db:	0f b7 c0             	movzwl %ax,%eax
  1011de:	66 a3 44 34 12 00    	mov    %ax,0x123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e7:	98                   	cwtl   
  1011e8:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ed:	98                   	cwtl   
  1011ee:	83 c8 20             	or     $0x20,%eax
  1011f1:	98                   	cwtl   
  1011f2:	8b 15 40 34 12 00    	mov    0x123440,%edx
  1011f8:	0f b7 0d 44 34 12 00 	movzwl 0x123444,%ecx
  1011ff:	01 c9                	add    %ecx,%ecx
  101201:	01 ca                	add    %ecx,%edx
  101203:	0f b7 c0             	movzwl %ax,%eax
  101206:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101209:	eb 77                	jmp    101282 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10120b:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  101212:	83 c0 50             	add    $0x50,%eax
  101215:	0f b7 c0             	movzwl %ax,%eax
  101218:	66 a3 44 34 12 00    	mov    %ax,0x123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10121e:	0f b7 1d 44 34 12 00 	movzwl 0x123444,%ebx
  101225:	0f b7 0d 44 34 12 00 	movzwl 0x123444,%ecx
  10122c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101231:	89 c8                	mov    %ecx,%eax
  101233:	f7 e2                	mul    %edx
  101235:	c1 ea 06             	shr    $0x6,%edx
  101238:	89 d0                	mov    %edx,%eax
  10123a:	c1 e0 02             	shl    $0x2,%eax
  10123d:	01 d0                	add    %edx,%eax
  10123f:	c1 e0 04             	shl    $0x4,%eax
  101242:	29 c1                	sub    %eax,%ecx
  101244:	89 c8                	mov    %ecx,%eax
  101246:	0f b7 c0             	movzwl %ax,%eax
  101249:	29 c3                	sub    %eax,%ebx
  10124b:	89 d8                	mov    %ebx,%eax
  10124d:	0f b7 c0             	movzwl %ax,%eax
  101250:	66 a3 44 34 12 00    	mov    %ax,0x123444
        break;
  101256:	eb 2b                	jmp    101283 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101258:	8b 0d 40 34 12 00    	mov    0x123440,%ecx
  10125e:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  101265:	8d 50 01             	lea    0x1(%eax),%edx
  101268:	0f b7 d2             	movzwl %dx,%edx
  10126b:	66 89 15 44 34 12 00 	mov    %dx,0x123444
  101272:	01 c0                	add    %eax,%eax
  101274:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101277:	8b 45 08             	mov    0x8(%ebp),%eax
  10127a:	0f b7 c0             	movzwl %ax,%eax
  10127d:	66 89 02             	mov    %ax,(%edx)
        break;
  101280:	eb 01                	jmp    101283 <cga_putc+0x100>
        break;
  101282:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101283:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  10128a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10128f:	76 5d                	jbe    1012ee <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101291:	a1 40 34 12 00       	mov    0x123440,%eax
  101296:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10129c:	a1 40 34 12 00       	mov    0x123440,%eax
  1012a1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012a8:	00 
  1012a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012ad:	89 04 24             	mov    %eax,(%esp)
  1012b0:	e8 36 6a 00 00       	call   107ceb <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012b5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012bc:	eb 14                	jmp    1012d2 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012be:	a1 40 34 12 00       	mov    0x123440,%eax
  1012c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012c6:	01 d2                	add    %edx,%edx
  1012c8:	01 d0                	add    %edx,%eax
  1012ca:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012cf:	ff 45 f4             	incl   -0xc(%ebp)
  1012d2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012d9:	7e e3                	jle    1012be <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012db:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1012e2:	83 e8 50             	sub    $0x50,%eax
  1012e5:	0f b7 c0             	movzwl %ax,%eax
  1012e8:	66 a3 44 34 12 00    	mov    %ax,0x123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012ee:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  1012f5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012f9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012fd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101301:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101305:	ee                   	out    %al,(%dx)
}
  101306:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101307:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  10130e:	c1 e8 08             	shr    $0x8,%eax
  101311:	0f b7 c0             	movzwl %ax,%eax
  101314:	0f b6 c0             	movzbl %al,%eax
  101317:	0f b7 15 46 34 12 00 	movzwl 0x123446,%edx
  10131e:	42                   	inc    %edx
  10131f:	0f b7 d2             	movzwl %dx,%edx
  101322:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101326:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101329:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10132d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101331:	ee                   	out    %al,(%dx)
}
  101332:	90                   	nop
    outb(addr_6845, 15);
  101333:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  10133a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10133e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101342:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101346:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10134a:	ee                   	out    %al,(%dx)
}
  10134b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10134c:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  101353:	0f b6 c0             	movzbl %al,%eax
  101356:	0f b7 15 46 34 12 00 	movzwl 0x123446,%edx
  10135d:	42                   	inc    %edx
  10135e:	0f b7 d2             	movzwl %dx,%edx
  101361:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101365:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101368:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10136c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101370:	ee                   	out    %al,(%dx)
}
  101371:	90                   	nop
}
  101372:	90                   	nop
  101373:	83 c4 34             	add    $0x34,%esp
  101376:	5b                   	pop    %ebx
  101377:	5d                   	pop    %ebp
  101378:	c3                   	ret    

00101379 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101379:	f3 0f 1e fb          	endbr32 
  10137d:	55                   	push   %ebp
  10137e:	89 e5                	mov    %esp,%ebp
  101380:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10138a:	eb 08                	jmp    101394 <serial_putc_sub+0x1b>
        delay();
  10138c:	e8 08 fb ff ff       	call   100e99 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101391:	ff 45 fc             	incl   -0x4(%ebp)
  101394:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10139a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10139e:	89 c2                	mov    %eax,%edx
  1013a0:	ec                   	in     (%dx),%al
  1013a1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013a4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013a8:	0f b6 c0             	movzbl %al,%eax
  1013ab:	83 e0 20             	and    $0x20,%eax
  1013ae:	85 c0                	test   %eax,%eax
  1013b0:	75 09                	jne    1013bb <serial_putc_sub+0x42>
  1013b2:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013b9:	7e d1                	jle    10138c <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1013be:	0f b6 c0             	movzbl %al,%eax
  1013c1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013c7:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013ca:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013ce:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013d2:	ee                   	out    %al,(%dx)
}
  1013d3:	90                   	nop
}
  1013d4:	90                   	nop
  1013d5:	c9                   	leave  
  1013d6:	c3                   	ret    

001013d7 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013d7:	f3 0f 1e fb          	endbr32 
  1013db:	55                   	push   %ebp
  1013dc:	89 e5                	mov    %esp,%ebp
  1013de:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013e1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013e5:	74 0d                	je     1013f4 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ea:	89 04 24             	mov    %eax,(%esp)
  1013ed:	e8 87 ff ff ff       	call   101379 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013f2:	eb 24                	jmp    101418 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013fb:	e8 79 ff ff ff       	call   101379 <serial_putc_sub>
        serial_putc_sub(' ');
  101400:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101407:	e8 6d ff ff ff       	call   101379 <serial_putc_sub>
        serial_putc_sub('\b');
  10140c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101413:	e8 61 ff ff ff       	call   101379 <serial_putc_sub>
}
  101418:	90                   	nop
  101419:	c9                   	leave  
  10141a:	c3                   	ret    

0010141b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10141b:	f3 0f 1e fb          	endbr32 
  10141f:	55                   	push   %ebp
  101420:	89 e5                	mov    %esp,%ebp
  101422:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101425:	eb 33                	jmp    10145a <cons_intr+0x3f>
        if (c != 0) {
  101427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10142b:	74 2d                	je     10145a <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  10142d:	a1 64 36 12 00       	mov    0x123664,%eax
  101432:	8d 50 01             	lea    0x1(%eax),%edx
  101435:	89 15 64 36 12 00    	mov    %edx,0x123664
  10143b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10143e:	88 90 60 34 12 00    	mov    %dl,0x123460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101444:	a1 64 36 12 00       	mov    0x123664,%eax
  101449:	3d 00 02 00 00       	cmp    $0x200,%eax
  10144e:	75 0a                	jne    10145a <cons_intr+0x3f>
                cons.wpos = 0;
  101450:	c7 05 64 36 12 00 00 	movl   $0x0,0x123664
  101457:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10145a:	8b 45 08             	mov    0x8(%ebp),%eax
  10145d:	ff d0                	call   *%eax
  10145f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101462:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101466:	75 bf                	jne    101427 <cons_intr+0xc>
            }
        }
    }
}
  101468:	90                   	nop
  101469:	90                   	nop
  10146a:	c9                   	leave  
  10146b:	c3                   	ret    

0010146c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10146c:	f3 0f 1e fb          	endbr32 
  101470:	55                   	push   %ebp
  101471:	89 e5                	mov    %esp,%ebp
  101473:	83 ec 10             	sub    $0x10,%esp
  101476:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10147c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101480:	89 c2                	mov    %eax,%edx
  101482:	ec                   	in     (%dx),%al
  101483:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101486:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10148a:	0f b6 c0             	movzbl %al,%eax
  10148d:	83 e0 01             	and    $0x1,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	75 07                	jne    10149b <serial_proc_data+0x2f>
        return -1;
  101494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101499:	eb 2a                	jmp    1014c5 <serial_proc_data+0x59>
  10149b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014a1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014a5:	89 c2                	mov    %eax,%edx
  1014a7:	ec                   	in     (%dx),%al
  1014a8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014af:	0f b6 c0             	movzbl %al,%eax
  1014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014b5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014b9:	75 07                	jne    1014c2 <serial_proc_data+0x56>
        c = '\b';
  1014bb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014c5:	c9                   	leave  
  1014c6:	c3                   	ret    

001014c7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014c7:	f3 0f 1e fb          	endbr32 
  1014cb:	55                   	push   %ebp
  1014cc:	89 e5                	mov    %esp,%ebp
  1014ce:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014d1:	a1 48 34 12 00       	mov    0x123448,%eax
  1014d6:	85 c0                	test   %eax,%eax
  1014d8:	74 0c                	je     1014e6 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014da:	c7 04 24 6c 14 10 00 	movl   $0x10146c,(%esp)
  1014e1:	e8 35 ff ff ff       	call   10141b <cons_intr>
    }
}
  1014e6:	90                   	nop
  1014e7:	c9                   	leave  
  1014e8:	c3                   	ret    

001014e9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014e9:	f3 0f 1e fb          	endbr32 
  1014ed:	55                   	push   %ebp
  1014ee:	89 e5                	mov    %esp,%ebp
  1014f0:	83 ec 38             	sub    $0x38,%esp
  1014f3:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014fc:	89 c2                	mov    %eax,%edx
  1014fe:	ec                   	in     (%dx),%al
  1014ff:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101502:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101506:	0f b6 c0             	movzbl %al,%eax
  101509:	83 e0 01             	and    $0x1,%eax
  10150c:	85 c0                	test   %eax,%eax
  10150e:	75 0a                	jne    10151a <kbd_proc_data+0x31>
        return -1;
  101510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101515:	e9 56 01 00 00       	jmp    101670 <kbd_proc_data+0x187>
  10151a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101523:	89 c2                	mov    %eax,%edx
  101525:	ec                   	in     (%dx),%al
  101526:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101529:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10152d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101530:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101534:	75 17                	jne    10154d <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101536:	a1 68 36 12 00       	mov    0x123668,%eax
  10153b:	83 c8 40             	or     $0x40,%eax
  10153e:	a3 68 36 12 00       	mov    %eax,0x123668
        return 0;
  101543:	b8 00 00 00 00       	mov    $0x0,%eax
  101548:	e9 23 01 00 00       	jmp    101670 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10154d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101551:	84 c0                	test   %al,%al
  101553:	79 45                	jns    10159a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101555:	a1 68 36 12 00       	mov    0x123668,%eax
  10155a:	83 e0 40             	and    $0x40,%eax
  10155d:	85 c0                	test   %eax,%eax
  10155f:	75 08                	jne    101569 <kbd_proc_data+0x80>
  101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101565:	24 7f                	and    $0x7f,%al
  101567:	eb 04                	jmp    10156d <kbd_proc_data+0x84>
  101569:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101570:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101574:	0f b6 80 40 00 12 00 	movzbl 0x120040(%eax),%eax
  10157b:	0c 40                	or     $0x40,%al
  10157d:	0f b6 c0             	movzbl %al,%eax
  101580:	f7 d0                	not    %eax
  101582:	89 c2                	mov    %eax,%edx
  101584:	a1 68 36 12 00       	mov    0x123668,%eax
  101589:	21 d0                	and    %edx,%eax
  10158b:	a3 68 36 12 00       	mov    %eax,0x123668
        return 0;
  101590:	b8 00 00 00 00       	mov    $0x0,%eax
  101595:	e9 d6 00 00 00       	jmp    101670 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10159a:	a1 68 36 12 00       	mov    0x123668,%eax
  10159f:	83 e0 40             	and    $0x40,%eax
  1015a2:	85 c0                	test   %eax,%eax
  1015a4:	74 11                	je     1015b7 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015a6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015aa:	a1 68 36 12 00       	mov    0x123668,%eax
  1015af:	83 e0 bf             	and    $0xffffffbf,%eax
  1015b2:	a3 68 36 12 00       	mov    %eax,0x123668
    }

    shift |= shiftcode[data];
  1015b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015bb:	0f b6 80 40 00 12 00 	movzbl 0x120040(%eax),%eax
  1015c2:	0f b6 d0             	movzbl %al,%edx
  1015c5:	a1 68 36 12 00       	mov    0x123668,%eax
  1015ca:	09 d0                	or     %edx,%eax
  1015cc:	a3 68 36 12 00       	mov    %eax,0x123668
    shift ^= togglecode[data];
  1015d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015d5:	0f b6 80 40 01 12 00 	movzbl 0x120140(%eax),%eax
  1015dc:	0f b6 d0             	movzbl %al,%edx
  1015df:	a1 68 36 12 00       	mov    0x123668,%eax
  1015e4:	31 d0                	xor    %edx,%eax
  1015e6:	a3 68 36 12 00       	mov    %eax,0x123668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015eb:	a1 68 36 12 00       	mov    0x123668,%eax
  1015f0:	83 e0 03             	and    $0x3,%eax
  1015f3:	8b 14 85 40 05 12 00 	mov    0x120540(,%eax,4),%edx
  1015fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015fe:	01 d0                	add    %edx,%eax
  101600:	0f b6 00             	movzbl (%eax),%eax
  101603:	0f b6 c0             	movzbl %al,%eax
  101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101609:	a1 68 36 12 00       	mov    0x123668,%eax
  10160e:	83 e0 08             	and    $0x8,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	74 22                	je     101637 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101615:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101619:	7e 0c                	jle    101627 <kbd_proc_data+0x13e>
  10161b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10161f:	7f 06                	jg     101627 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101621:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101625:	eb 10                	jmp    101637 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101627:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10162b:	7e 0a                	jle    101637 <kbd_proc_data+0x14e>
  10162d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101631:	7f 04                	jg     101637 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101633:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101637:	a1 68 36 12 00       	mov    0x123668,%eax
  10163c:	f7 d0                	not    %eax
  10163e:	83 e0 06             	and    $0x6,%eax
  101641:	85 c0                	test   %eax,%eax
  101643:	75 28                	jne    10166d <kbd_proc_data+0x184>
  101645:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10164c:	75 1f                	jne    10166d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10164e:	c7 04 24 21 88 10 00 	movl   $0x108821,(%esp)
  101655:	e8 6f ec ff ff       	call   1002c9 <cprintf>
  10165a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101660:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101664:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101668:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10166b:	ee                   	out    %al,(%dx)
}
  10166c:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101670:	c9                   	leave  
  101671:	c3                   	ret    

00101672 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101672:	f3 0f 1e fb          	endbr32 
  101676:	55                   	push   %ebp
  101677:	89 e5                	mov    %esp,%ebp
  101679:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10167c:	c7 04 24 e9 14 10 00 	movl   $0x1014e9,(%esp)
  101683:	e8 93 fd ff ff       	call   10141b <cons_intr>
}
  101688:	90                   	nop
  101689:	c9                   	leave  
  10168a:	c3                   	ret    

0010168b <kbd_init>:

static void
kbd_init(void) {
  10168b:	f3 0f 1e fb          	endbr32 
  10168f:	55                   	push   %ebp
  101690:	89 e5                	mov    %esp,%ebp
  101692:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101695:	e8 d8 ff ff ff       	call   101672 <kbd_intr>
    pic_enable(IRQ_KBD);
  10169a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016a1:	e8 47 01 00 00       	call   1017ed <pic_enable>
}
  1016a6:	90                   	nop
  1016a7:	c9                   	leave  
  1016a8:	c3                   	ret    

001016a9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016a9:	f3 0f 1e fb          	endbr32 
  1016ad:	55                   	push   %ebp
  1016ae:	89 e5                	mov    %esp,%ebp
  1016b0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016b3:	e8 2e f8 ff ff       	call   100ee6 <cga_init>
    serial_init();
  1016b8:	e8 13 f9 ff ff       	call   100fd0 <serial_init>
    kbd_init();
  1016bd:	e8 c9 ff ff ff       	call   10168b <kbd_init>
    if (!serial_exists) {
  1016c2:	a1 48 34 12 00       	mov    0x123448,%eax
  1016c7:	85 c0                	test   %eax,%eax
  1016c9:	75 0c                	jne    1016d7 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016cb:	c7 04 24 2d 88 10 00 	movl   $0x10882d,(%esp)
  1016d2:	e8 f2 eb ff ff       	call   1002c9 <cprintf>
    }
}
  1016d7:	90                   	nop
  1016d8:	c9                   	leave  
  1016d9:	c3                   	ret    

001016da <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016da:	f3 0f 1e fb          	endbr32 
  1016de:	55                   	push   %ebp
  1016df:	89 e5                	mov    %esp,%ebp
  1016e1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016e4:	e8 72 f7 ff ff       	call   100e5b <__intr_save>
  1016e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ef:	89 04 24             	mov    %eax,(%esp)
  1016f2:	e8 48 fa ff ff       	call   10113f <lpt_putc>
        cga_putc(c);
  1016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fa:	89 04 24             	mov    %eax,(%esp)
  1016fd:	e8 81 fa ff ff       	call   101183 <cga_putc>
        serial_putc(c);
  101702:	8b 45 08             	mov    0x8(%ebp),%eax
  101705:	89 04 24             	mov    %eax,(%esp)
  101708:	e8 ca fc ff ff       	call   1013d7 <serial_putc>
    }
    local_intr_restore(intr_flag);
  10170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101710:	89 04 24             	mov    %eax,(%esp)
  101713:	e8 6d f7 ff ff       	call   100e85 <__intr_restore>
}
  101718:	90                   	nop
  101719:	c9                   	leave  
  10171a:	c3                   	ret    

0010171b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10171b:	f3 0f 1e fb          	endbr32 
  10171f:	55                   	push   %ebp
  101720:	89 e5                	mov    %esp,%ebp
  101722:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10172c:	e8 2a f7 ff ff       	call   100e5b <__intr_save>
  101731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101734:	e8 8e fd ff ff       	call   1014c7 <serial_intr>
        kbd_intr();
  101739:	e8 34 ff ff ff       	call   101672 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10173e:	8b 15 60 36 12 00    	mov    0x123660,%edx
  101744:	a1 64 36 12 00       	mov    0x123664,%eax
  101749:	39 c2                	cmp    %eax,%edx
  10174b:	74 31                	je     10177e <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  10174d:	a1 60 36 12 00       	mov    0x123660,%eax
  101752:	8d 50 01             	lea    0x1(%eax),%edx
  101755:	89 15 60 36 12 00    	mov    %edx,0x123660
  10175b:	0f b6 80 60 34 12 00 	movzbl 0x123460(%eax),%eax
  101762:	0f b6 c0             	movzbl %al,%eax
  101765:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101768:	a1 60 36 12 00       	mov    0x123660,%eax
  10176d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101772:	75 0a                	jne    10177e <cons_getc+0x63>
                cons.rpos = 0;
  101774:	c7 05 60 36 12 00 00 	movl   $0x0,0x123660
  10177b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101781:	89 04 24             	mov    %eax,(%esp)
  101784:	e8 fc f6 ff ff       	call   100e85 <__intr_restore>
    return c;
  101789:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10178c:	c9                   	leave  
  10178d:	c3                   	ret    

0010178e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10178e:	f3 0f 1e fb          	endbr32 
  101792:	55                   	push   %ebp
  101793:	89 e5                	mov    %esp,%ebp
  101795:	83 ec 14             	sub    $0x14,%esp
  101798:	8b 45 08             	mov    0x8(%ebp),%eax
  10179b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10179f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017a2:	66 a3 50 05 12 00    	mov    %ax,0x120550
    if (did_init) {
  1017a8:	a1 6c 36 12 00       	mov    0x12366c,%eax
  1017ad:	85 c0                	test   %eax,%eax
  1017af:	74 39                	je     1017ea <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017b4:	0f b6 c0             	movzbl %al,%eax
  1017b7:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017bd:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017c4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
}
  1017c9:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017ce:	c1 e8 08             	shr    $0x8,%eax
  1017d1:	0f b7 c0             	movzwl %ax,%eax
  1017d4:	0f b6 c0             	movzbl %al,%eax
  1017d7:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017dd:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017e4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017e8:	ee                   	out    %al,(%dx)
}
  1017e9:	90                   	nop
    }
}
  1017ea:	90                   	nop
  1017eb:	c9                   	leave  
  1017ec:	c3                   	ret    

001017ed <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017ed:	f3 0f 1e fb          	endbr32 
  1017f1:	55                   	push   %ebp
  1017f2:	89 e5                	mov    %esp,%ebp
  1017f4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1017fa:	ba 01 00 00 00       	mov    $0x1,%edx
  1017ff:	88 c1                	mov    %al,%cl
  101801:	d3 e2                	shl    %cl,%edx
  101803:	89 d0                	mov    %edx,%eax
  101805:	98                   	cwtl   
  101806:	f7 d0                	not    %eax
  101808:	0f bf d0             	movswl %ax,%edx
  10180b:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  101812:	98                   	cwtl   
  101813:	21 d0                	and    %edx,%eax
  101815:	98                   	cwtl   
  101816:	0f b7 c0             	movzwl %ax,%eax
  101819:	89 04 24             	mov    %eax,(%esp)
  10181c:	e8 6d ff ff ff       	call   10178e <pic_setmask>
}
  101821:	90                   	nop
  101822:	c9                   	leave  
  101823:	c3                   	ret    

00101824 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101824:	f3 0f 1e fb          	endbr32 
  101828:	55                   	push   %ebp
  101829:	89 e5                	mov    %esp,%ebp
  10182b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10182e:	c7 05 6c 36 12 00 01 	movl   $0x1,0x12366c
  101835:	00 00 00 
  101838:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10183e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101842:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101846:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184a:	ee                   	out    %al,(%dx)
}
  10184b:	90                   	nop
  10184c:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101852:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101856:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10185a:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10185e:	ee                   	out    %al,(%dx)
}
  10185f:	90                   	nop
  101860:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101866:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10186a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10186e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101872:	ee                   	out    %al,(%dx)
}
  101873:	90                   	nop
  101874:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10187a:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10187e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101882:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101886:	ee                   	out    %al,(%dx)
}
  101887:	90                   	nop
  101888:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10188e:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101892:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101896:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10189a:	ee                   	out    %al,(%dx)
}
  10189b:	90                   	nop
  10189c:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018a2:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018a6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018aa:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018ae:	ee                   	out    %al,(%dx)
}
  1018af:	90                   	nop
  1018b0:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018b6:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ba:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018be:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018c2:	ee                   	out    %al,(%dx)
}
  1018c3:	90                   	nop
  1018c4:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018ca:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ce:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018d2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018d6:	ee                   	out    %al,(%dx)
}
  1018d7:	90                   	nop
  1018d8:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018de:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018e6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018ea:	ee                   	out    %al,(%dx)
}
  1018eb:	90                   	nop
  1018ec:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018f2:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018fe:	ee                   	out    %al,(%dx)
}
  1018ff:	90                   	nop
  101900:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101906:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10190a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10190e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101912:	ee                   	out    %al,(%dx)
}
  101913:	90                   	nop
  101914:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10191a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10191e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101922:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101926:	ee                   	out    %al,(%dx)
}
  101927:	90                   	nop
  101928:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10192e:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101932:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101936:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10193a:	ee                   	out    %al,(%dx)
}
  10193b:	90                   	nop
  10193c:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101942:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101946:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10194a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10194e:	ee                   	out    %al,(%dx)
}
  10194f:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101950:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  101957:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10195c:	74 0f                	je     10196d <pic_init+0x149>
        pic_setmask(irq_mask);
  10195e:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  101965:	89 04 24             	mov    %eax,(%esp)
  101968:	e8 21 fe ff ff       	call   10178e <pic_setmask>
    }
}
  10196d:	90                   	nop
  10196e:	c9                   	leave  
  10196f:	c3                   	ret    

00101970 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101970:	f3 0f 1e fb          	endbr32 
  101974:	55                   	push   %ebp
  101975:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101977:	fb                   	sti    
}
  101978:	90                   	nop
    sti();
}
  101979:	90                   	nop
  10197a:	5d                   	pop    %ebp
  10197b:	c3                   	ret    

0010197c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10197c:	f3 0f 1e fb          	endbr32 
  101980:	55                   	push   %ebp
  101981:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101983:	fa                   	cli    
}
  101984:	90                   	nop
    cli();
}
  101985:	90                   	nop
  101986:	5d                   	pop    %ebp
  101987:	c3                   	ret    

00101988 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101988:	f3 0f 1e fb          	endbr32 
  10198c:	55                   	push   %ebp
  10198d:	89 e5                	mov    %esp,%ebp
  10198f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101992:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101999:	00 
  10199a:	c7 04 24 60 88 10 00 	movl   $0x108860,(%esp)
  1019a1:	e8 23 e9 ff ff       	call   1002c9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1019a6:	c7 04 24 6a 88 10 00 	movl   $0x10886a,(%esp)
  1019ad:	e8 17 e9 ff ff       	call   1002c9 <cprintf>
    panic("EOT: kernel seems ok.");
  1019b2:	c7 44 24 08 78 88 10 	movl   $0x108878,0x8(%esp)
  1019b9:	00 
  1019ba:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019c1:	00 
  1019c2:	c7 04 24 8e 88 10 00 	movl   $0x10888e,(%esp)
  1019c9:	e8 67 ea ff ff       	call   100435 <__panic>

001019ce <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019ce:	f3 0f 1e fb          	endbr32 
  1019d2:	55                   	push   %ebp
  1019d3:	89 e5                	mov    %esp,%ebp
  1019d5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019df:	e9 c4 00 00 00       	jmp    101aa8 <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e7:	8b 04 85 e0 05 12 00 	mov    0x1205e0(,%eax,4),%eax
  1019ee:	0f b7 d0             	movzwl %ax,%edx
  1019f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f4:	66 89 14 c5 80 36 12 	mov    %dx,0x123680(,%eax,8)
  1019fb:	00 
  1019fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ff:	66 c7 04 c5 82 36 12 	movw   $0x8,0x123682(,%eax,8)
  101a06:	00 08 00 
  101a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0c:	0f b6 14 c5 84 36 12 	movzbl 0x123684(,%eax,8),%edx
  101a13:	00 
  101a14:	80 e2 e0             	and    $0xe0,%dl
  101a17:	88 14 c5 84 36 12 00 	mov    %dl,0x123684(,%eax,8)
  101a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a21:	0f b6 14 c5 84 36 12 	movzbl 0x123684(,%eax,8),%edx
  101a28:	00 
  101a29:	80 e2 1f             	and    $0x1f,%dl
  101a2c:	88 14 c5 84 36 12 00 	mov    %dl,0x123684(,%eax,8)
  101a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a36:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a3d:	00 
  101a3e:	80 e2 f0             	and    $0xf0,%dl
  101a41:	80 ca 0e             	or     $0xe,%dl
  101a44:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a4e:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a55:	00 
  101a56:	80 e2 ef             	and    $0xef,%dl
  101a59:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a63:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a6a:	00 
  101a6b:	80 e2 9f             	and    $0x9f,%dl
  101a6e:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a78:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a7f:	00 
  101a80:	80 ca 80             	or     $0x80,%dl
  101a83:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8d:	8b 04 85 e0 05 12 00 	mov    0x1205e0(,%eax,4),%eax
  101a94:	c1 e8 10             	shr    $0x10,%eax
  101a97:	0f b7 d0             	movzwl %ax,%edx
  101a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a9d:	66 89 14 c5 86 36 12 	mov    %dx,0x123686(,%eax,8)
  101aa4:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101aa5:	ff 45 fc             	incl   -0x4(%ebp)
  101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aab:	3d ff 00 00 00       	cmp    $0xff,%eax
  101ab0:	0f 86 2e ff ff ff    	jbe    1019e4 <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101ab6:	a1 c4 07 12 00       	mov    0x1207c4,%eax
  101abb:	0f b7 c0             	movzwl %ax,%eax
  101abe:	66 a3 48 3a 12 00    	mov    %ax,0x123a48
  101ac4:	66 c7 05 4a 3a 12 00 	movw   $0x8,0x123a4a
  101acb:	08 00 
  101acd:	0f b6 05 4c 3a 12 00 	movzbl 0x123a4c,%eax
  101ad4:	24 e0                	and    $0xe0,%al
  101ad6:	a2 4c 3a 12 00       	mov    %al,0x123a4c
  101adb:	0f b6 05 4c 3a 12 00 	movzbl 0x123a4c,%eax
  101ae2:	24 1f                	and    $0x1f,%al
  101ae4:	a2 4c 3a 12 00       	mov    %al,0x123a4c
  101ae9:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101af0:	24 f0                	and    $0xf0,%al
  101af2:	0c 0e                	or     $0xe,%al
  101af4:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101af9:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b00:	24 ef                	and    $0xef,%al
  101b02:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b07:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b0e:	0c 60                	or     $0x60,%al
  101b10:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b15:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b1c:	0c 80                	or     $0x80,%al
  101b1e:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b23:	a1 c4 07 12 00       	mov    0x1207c4,%eax
  101b28:	c1 e8 10             	shr    $0x10,%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	66 a3 4e 3a 12 00    	mov    %ax,0x123a4e
  101b34:	c7 45 f8 60 05 12 00 	movl   $0x120560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b3e:	0f 01 18             	lidtl  (%eax)
}
  101b41:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101b42:	90                   	nop
  101b43:	c9                   	leave  
  101b44:	c3                   	ret    

00101b45 <trapname>:

static const char *
trapname(int trapno) {
  101b45:	f3 0f 1e fb          	endbr32 
  101b49:	55                   	push   %ebp
  101b4a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	83 f8 13             	cmp    $0x13,%eax
  101b52:	77 0c                	ja     101b60 <trapname+0x1b>
        return excnames[trapno];
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	8b 04 85 e0 8b 10 00 	mov    0x108be0(,%eax,4),%eax
  101b5e:	eb 18                	jmp    101b78 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b60:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b64:	7e 0d                	jle    101b73 <trapname+0x2e>
  101b66:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b6a:	7f 07                	jg     101b73 <trapname+0x2e>
        return "Hardware Interrupt";
  101b6c:	b8 9f 88 10 00       	mov    $0x10889f,%eax
  101b71:	eb 05                	jmp    101b78 <trapname+0x33>
    }
    return "(unknown trap)";
  101b73:	b8 b2 88 10 00       	mov    $0x1088b2,%eax
}
  101b78:	5d                   	pop    %ebp
  101b79:	c3                   	ret    

00101b7a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b7a:	f3 0f 1e fb          	endbr32 
  101b7e:	55                   	push   %ebp
  101b7f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b88:	83 f8 08             	cmp    $0x8,%eax
  101b8b:	0f 94 c0             	sete   %al
  101b8e:	0f b6 c0             	movzbl %al,%eax
}
  101b91:	5d                   	pop    %ebp
  101b92:	c3                   	ret    

00101b93 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b93:	f3 0f 1e fb          	endbr32 
  101b97:	55                   	push   %ebp
  101b98:	89 e5                	mov    %esp,%ebp
  101b9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba4:	c7 04 24 f3 88 10 00 	movl   $0x1088f3,(%esp)
  101bab:	e8 19 e7 ff ff       	call   1002c9 <cprintf>
    print_regs(&tf->tf_regs);
  101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb3:	89 04 24             	mov    %eax,(%esp)
  101bb6:	e8 8d 01 00 00       	call   101d48 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc6:	c7 04 24 04 89 10 00 	movl   $0x108904,(%esp)
  101bcd:	e8 f7 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 17 89 10 00 	movl   $0x108917,(%esp)
  101be4:	e8 e0 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	c7 04 24 2a 89 10 00 	movl   $0x10892a,(%esp)
  101bfb:	e8 c9 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 3d 89 10 00 	movl   $0x10893d,(%esp)
  101c12:	e8 b2 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 30             	mov    0x30(%eax),%eax
  101c1d:	89 04 24             	mov    %eax,(%esp)
  101c20:	e8 20 ff ff ff       	call   101b45 <trapname>
  101c25:	8b 55 08             	mov    0x8(%ebp),%edx
  101c28:	8b 52 30             	mov    0x30(%edx),%edx
  101c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c33:	c7 04 24 50 89 10 00 	movl   $0x108950,(%esp)
  101c3a:	e8 8a e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c42:	8b 40 34             	mov    0x34(%eax),%eax
  101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c49:	c7 04 24 62 89 10 00 	movl   $0x108962,(%esp)
  101c50:	e8 74 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c55:	8b 45 08             	mov    0x8(%ebp),%eax
  101c58:	8b 40 38             	mov    0x38(%eax),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 71 89 10 00 	movl   $0x108971,(%esp)
  101c66:	e8 5e e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c76:	c7 04 24 80 89 10 00 	movl   $0x108980,(%esp)
  101c7d:	e8 47 e6 ff ff       	call   1002c9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 40             	mov    0x40(%eax),%eax
  101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8c:	c7 04 24 93 89 10 00 	movl   $0x108993,(%esp)
  101c93:	e8 31 e6 ff ff       	call   1002c9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ca6:	eb 3d                	jmp    101ce5 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 50 40             	mov    0x40(%eax),%edx
  101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cb1:	21 d0                	and    %edx,%eax
  101cb3:	85 c0                	test   %eax,%eax
  101cb5:	74 28                	je     101cdf <print_trapframe+0x14c>
  101cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cba:	8b 04 85 80 05 12 00 	mov    0x120580(,%eax,4),%eax
  101cc1:	85 c0                	test   %eax,%eax
  101cc3:	74 1a                	je     101cdf <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc8:	8b 04 85 80 05 12 00 	mov    0x120580(,%eax,4),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 a2 89 10 00 	movl   $0x1089a2,(%esp)
  101cda:	e8 ea e5 ff ff       	call   1002c9 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cdf:	ff 45 f4             	incl   -0xc(%ebp)
  101ce2:	d1 65 f0             	shll   -0x10(%ebp)
  101ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ce8:	83 f8 17             	cmp    $0x17,%eax
  101ceb:	76 bb                	jbe    101ca8 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ced:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf0:	8b 40 40             	mov    0x40(%eax),%eax
  101cf3:	c1 e8 0c             	shr    $0xc,%eax
  101cf6:	83 e0 03             	and    $0x3,%eax
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 a6 89 10 00 	movl   $0x1089a6,(%esp)
  101d04:	e8 c0 e5 ff ff       	call   1002c9 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d09:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0c:	89 04 24             	mov    %eax,(%esp)
  101d0f:	e8 66 fe ff ff       	call   101b7a <trap_in_kernel>
  101d14:	85 c0                	test   %eax,%eax
  101d16:	75 2d                	jne    101d45 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d18:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1b:	8b 40 44             	mov    0x44(%eax),%eax
  101d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d22:	c7 04 24 af 89 10 00 	movl   $0x1089af,(%esp)
  101d29:	e8 9b e5 ff ff       	call   1002c9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d31:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d39:	c7 04 24 be 89 10 00 	movl   $0x1089be,(%esp)
  101d40:	e8 84 e5 ff ff       	call   1002c9 <cprintf>
    }
}
  101d45:	90                   	nop
  101d46:	c9                   	leave  
  101d47:	c3                   	ret    

00101d48 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d48:	f3 0f 1e fb          	endbr32 
  101d4c:	55                   	push   %ebp
  101d4d:	89 e5                	mov    %esp,%ebp
  101d4f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d52:	8b 45 08             	mov    0x8(%ebp),%eax
  101d55:	8b 00                	mov    (%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 d1 89 10 00 	movl   $0x1089d1,(%esp)
  101d62:	e8 62 e5 ff ff       	call   1002c9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d67:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6a:	8b 40 04             	mov    0x4(%eax),%eax
  101d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d71:	c7 04 24 e0 89 10 00 	movl   $0x1089e0,(%esp)
  101d78:	e8 4c e5 ff ff       	call   1002c9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d80:	8b 40 08             	mov    0x8(%eax),%eax
  101d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d87:	c7 04 24 ef 89 10 00 	movl   $0x1089ef,(%esp)
  101d8e:	e8 36 e5 ff ff       	call   1002c9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d93:	8b 45 08             	mov    0x8(%ebp),%eax
  101d96:	8b 40 0c             	mov    0xc(%eax),%eax
  101d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9d:	c7 04 24 fe 89 10 00 	movl   $0x1089fe,(%esp)
  101da4:	e8 20 e5 ff ff       	call   1002c9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101da9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dac:	8b 40 10             	mov    0x10(%eax),%eax
  101daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db3:	c7 04 24 0d 8a 10 00 	movl   $0x108a0d,(%esp)
  101dba:	e8 0a e5 ff ff       	call   1002c9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc2:	8b 40 14             	mov    0x14(%eax),%eax
  101dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc9:	c7 04 24 1c 8a 10 00 	movl   $0x108a1c,(%esp)
  101dd0:	e8 f4 e4 ff ff       	call   1002c9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd8:	8b 40 18             	mov    0x18(%eax),%eax
  101ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddf:	c7 04 24 2b 8a 10 00 	movl   $0x108a2b,(%esp)
  101de6:	e8 de e4 ff ff       	call   1002c9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101deb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dee:	8b 40 1c             	mov    0x1c(%eax),%eax
  101df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df5:	c7 04 24 3a 8a 10 00 	movl   $0x108a3a,(%esp)
  101dfc:	e8 c8 e4 ff ff       	call   1002c9 <cprintf>
}
  101e01:	90                   	nop
  101e02:	c9                   	leave  
  101e03:	c3                   	ret    

00101e04 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e04:	f3 0f 1e fb          	endbr32 
  101e08:	55                   	push   %ebp
  101e09:	89 e5                	mov    %esp,%ebp
  101e0b:	57                   	push   %edi
  101e0c:	56                   	push   %esi
  101e0d:	53                   	push   %ebx
  101e0e:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e11:	8b 45 08             	mov    0x8(%ebp),%eax
  101e14:	8b 40 30             	mov    0x30(%eax),%eax
  101e17:	83 f8 79             	cmp    $0x79,%eax
  101e1a:	0f 84 c6 01 00 00    	je     101fe6 <trap_dispatch+0x1e2>
  101e20:	83 f8 79             	cmp    $0x79,%eax
  101e23:	0f 87 3a 02 00 00    	ja     102063 <trap_dispatch+0x25f>
  101e29:	83 f8 78             	cmp    $0x78,%eax
  101e2c:	0f 84 d0 00 00 00    	je     101f02 <trap_dispatch+0xfe>
  101e32:	83 f8 78             	cmp    $0x78,%eax
  101e35:	0f 87 28 02 00 00    	ja     102063 <trap_dispatch+0x25f>
  101e3b:	83 f8 2f             	cmp    $0x2f,%eax
  101e3e:	0f 87 1f 02 00 00    	ja     102063 <trap_dispatch+0x25f>
  101e44:	83 f8 2e             	cmp    $0x2e,%eax
  101e47:	0f 83 4b 02 00 00    	jae    102098 <trap_dispatch+0x294>
  101e4d:	83 f8 24             	cmp    $0x24,%eax
  101e50:	74 5e                	je     101eb0 <trap_dispatch+0xac>
  101e52:	83 f8 24             	cmp    $0x24,%eax
  101e55:	0f 87 08 02 00 00    	ja     102063 <trap_dispatch+0x25f>
  101e5b:	83 f8 20             	cmp    $0x20,%eax
  101e5e:	74 0a                	je     101e6a <trap_dispatch+0x66>
  101e60:	83 f8 21             	cmp    $0x21,%eax
  101e63:	74 74                	je     101ed9 <trap_dispatch+0xd5>
  101e65:	e9 f9 01 00 00       	jmp    102063 <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
  101e6a:	a1 a0 3f 12 00       	mov    0x123fa0,%eax
  101e6f:	40                   	inc    %eax
  101e70:	a3 a0 3f 12 00       	mov    %eax,0x123fa0
        if (ticks % TICK_NUM == 0) {
  101e75:	8b 0d a0 3f 12 00    	mov    0x123fa0,%ecx
  101e7b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e80:	89 c8                	mov    %ecx,%eax
  101e82:	f7 e2                	mul    %edx
  101e84:	c1 ea 05             	shr    $0x5,%edx
  101e87:	89 d0                	mov    %edx,%eax
  101e89:	c1 e0 02             	shl    $0x2,%eax
  101e8c:	01 d0                	add    %edx,%eax
  101e8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e95:	01 d0                	add    %edx,%eax
  101e97:	c1 e0 02             	shl    $0x2,%eax
  101e9a:	29 c1                	sub    %eax,%ecx
  101e9c:	89 ca                	mov    %ecx,%edx
  101e9e:	85 d2                	test   %edx,%edx
  101ea0:	0f 85 f5 01 00 00    	jne    10209b <trap_dispatch+0x297>
            print_ticks();
  101ea6:	e8 dd fa ff ff       	call   101988 <print_ticks>
        }
        break;
  101eab:	e9 eb 01 00 00       	jmp    10209b <trap_dispatch+0x297>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101eb0:	e8 66 f8 ff ff       	call   10171b <cons_getc>
  101eb5:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb8:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ebc:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ec0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec8:	c7 04 24 49 8a 10 00 	movl   $0x108a49,(%esp)
  101ecf:	e8 f5 e3 ff ff       	call   1002c9 <cprintf>
        break;
  101ed4:	e9 c9 01 00 00       	jmp    1020a2 <trap_dispatch+0x29e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed9:	e8 3d f8 ff ff       	call   10171b <cons_getc>
  101ede:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ee1:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ee5:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ee9:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ef1:	c7 04 24 5b 8a 10 00 	movl   $0x108a5b,(%esp)
  101ef8:	e8 cc e3 ff ff       	call   1002c9 <cprintf>
        break;
  101efd:	e9 a0 01 00 00       	jmp    1020a2 <trap_dispatch+0x29e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101f02:	8b 45 08             	mov    0x8(%ebp),%eax
  101f05:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f09:	83 f8 1b             	cmp    $0x1b,%eax
  101f0c:	0f 84 8c 01 00 00    	je     10209e <trap_dispatch+0x29a>
            switchk2u = *tf;
  101f12:	8b 55 08             	mov    0x8(%ebp),%edx
  101f15:	b8 c0 3f 12 00       	mov    $0x123fc0,%eax
  101f1a:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101f1f:	89 c1                	mov    %eax,%ecx
  101f21:	83 e1 01             	and    $0x1,%ecx
  101f24:	85 c9                	test   %ecx,%ecx
  101f26:	74 0c                	je     101f34 <trap_dispatch+0x130>
  101f28:	0f b6 0a             	movzbl (%edx),%ecx
  101f2b:	88 08                	mov    %cl,(%eax)
  101f2d:	8d 40 01             	lea    0x1(%eax),%eax
  101f30:	8d 52 01             	lea    0x1(%edx),%edx
  101f33:	4b                   	dec    %ebx
  101f34:	89 c1                	mov    %eax,%ecx
  101f36:	83 e1 02             	and    $0x2,%ecx
  101f39:	85 c9                	test   %ecx,%ecx
  101f3b:	74 0f                	je     101f4c <trap_dispatch+0x148>
  101f3d:	0f b7 0a             	movzwl (%edx),%ecx
  101f40:	66 89 08             	mov    %cx,(%eax)
  101f43:	8d 40 02             	lea    0x2(%eax),%eax
  101f46:	8d 52 02             	lea    0x2(%edx),%edx
  101f49:	83 eb 02             	sub    $0x2,%ebx
  101f4c:	89 df                	mov    %ebx,%edi
  101f4e:	83 e7 fc             	and    $0xfffffffc,%edi
  101f51:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f56:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101f59:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101f5c:	83 c1 04             	add    $0x4,%ecx
  101f5f:	39 f9                	cmp    %edi,%ecx
  101f61:	72 f3                	jb     101f56 <trap_dispatch+0x152>
  101f63:	01 c8                	add    %ecx,%eax
  101f65:	01 ca                	add    %ecx,%edx
  101f67:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f6c:	89 de                	mov    %ebx,%esi
  101f6e:	83 e6 02             	and    $0x2,%esi
  101f71:	85 f6                	test   %esi,%esi
  101f73:	74 0b                	je     101f80 <trap_dispatch+0x17c>
  101f75:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101f79:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101f7d:	83 c1 02             	add    $0x2,%ecx
  101f80:	83 e3 01             	and    $0x1,%ebx
  101f83:	85 db                	test   %ebx,%ebx
  101f85:	74 07                	je     101f8e <trap_dispatch+0x18a>
  101f87:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f8b:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f8e:	66 c7 05 fc 3f 12 00 	movw   $0x1b,0x123ffc
  101f95:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f97:	66 c7 05 08 40 12 00 	movw   $0x23,0x124008
  101f9e:	23 00 
  101fa0:	0f b7 05 08 40 12 00 	movzwl 0x124008,%eax
  101fa7:	66 a3 e8 3f 12 00    	mov    %ax,0x123fe8
  101fad:	0f b7 05 e8 3f 12 00 	movzwl 0x123fe8,%eax
  101fb4:	66 a3 ec 3f 12 00    	mov    %ax,0x123fec
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101fba:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbd:	83 c0 44             	add    $0x44,%eax
  101fc0:	a3 04 40 12 00       	mov    %eax,0x124004
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101fc5:	a1 00 40 12 00       	mov    0x124000,%eax
  101fca:	0d 00 30 00 00       	or     $0x3000,%eax
  101fcf:	a3 00 40 12 00       	mov    %eax,0x124000
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd7:	83 e8 04             	sub    $0x4,%eax
  101fda:	ba c0 3f 12 00       	mov    $0x123fc0,%edx
  101fdf:	89 10                	mov    %edx,(%eax)
        }
        break;
  101fe1:	e9 b8 00 00 00       	jmp    10209e <trap_dispatch+0x29a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fed:	83 f8 08             	cmp    $0x8,%eax
  101ff0:	0f 84 ab 00 00 00    	je     1020a1 <trap_dispatch+0x29d>
            tf->tf_cs = KERNEL_CS;
  101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff9:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101fff:	8b 45 08             	mov    0x8(%ebp),%eax
  102002:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  102008:	8b 45 08             	mov    0x8(%ebp),%eax
  10200b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10200f:	8b 45 08             	mov    0x8(%ebp),%eax
  102012:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  102016:	8b 45 08             	mov    0x8(%ebp),%eax
  102019:	8b 40 40             	mov    0x40(%eax),%eax
  10201c:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  102021:	89 c2                	mov    %eax,%edx
  102023:	8b 45 08             	mov    0x8(%ebp),%eax
  102026:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102029:	8b 45 08             	mov    0x8(%ebp),%eax
  10202c:	8b 40 44             	mov    0x44(%eax),%eax
  10202f:	83 e8 44             	sub    $0x44,%eax
  102032:	a3 0c 40 12 00       	mov    %eax,0x12400c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  102037:	a1 0c 40 12 00       	mov    0x12400c,%eax
  10203c:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  102043:	00 
  102044:	8b 55 08             	mov    0x8(%ebp),%edx
  102047:	89 54 24 04          	mov    %edx,0x4(%esp)
  10204b:	89 04 24             	mov    %eax,(%esp)
  10204e:	e8 98 5c 00 00       	call   107ceb <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  102053:	8b 15 0c 40 12 00    	mov    0x12400c,%edx
  102059:	8b 45 08             	mov    0x8(%ebp),%eax
  10205c:	83 e8 04             	sub    $0x4,%eax
  10205f:	89 10                	mov    %edx,(%eax)
        }
        break;
  102061:	eb 3e                	jmp    1020a1 <trap_dispatch+0x29d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102063:	8b 45 08             	mov    0x8(%ebp),%eax
  102066:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10206a:	83 e0 03             	and    $0x3,%eax
  10206d:	85 c0                	test   %eax,%eax
  10206f:	75 31                	jne    1020a2 <trap_dispatch+0x29e>
            print_trapframe(tf);
  102071:	8b 45 08             	mov    0x8(%ebp),%eax
  102074:	89 04 24             	mov    %eax,(%esp)
  102077:	e8 17 fb ff ff       	call   101b93 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10207c:	c7 44 24 08 6a 8a 10 	movl   $0x108a6a,0x8(%esp)
  102083:	00 
  102084:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  10208b:	00 
  10208c:	c7 04 24 8e 88 10 00 	movl   $0x10888e,(%esp)
  102093:	e8 9d e3 ff ff       	call   100435 <__panic>
        break;
  102098:	90                   	nop
  102099:	eb 07                	jmp    1020a2 <trap_dispatch+0x29e>
        break;
  10209b:	90                   	nop
  10209c:	eb 04                	jmp    1020a2 <trap_dispatch+0x29e>
        break;
  10209e:	90                   	nop
  10209f:	eb 01                	jmp    1020a2 <trap_dispatch+0x29e>
        break;
  1020a1:	90                   	nop
        }
    }
}
  1020a2:	90                   	nop
  1020a3:	83 c4 2c             	add    $0x2c,%esp
  1020a6:	5b                   	pop    %ebx
  1020a7:	5e                   	pop    %esi
  1020a8:	5f                   	pop    %edi
  1020a9:	5d                   	pop    %ebp
  1020aa:	c3                   	ret    

001020ab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1020ab:	f3 0f 1e fb          	endbr32 
  1020af:	55                   	push   %ebp
  1020b0:	89 e5                	mov    %esp,%ebp
  1020b2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b8:	89 04 24             	mov    %eax,(%esp)
  1020bb:	e8 44 fd ff ff       	call   101e04 <trap_dispatch>
}
  1020c0:	90                   	nop
  1020c1:	c9                   	leave  
  1020c2:	c3                   	ret    

001020c3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $0
  1020c5:	6a 00                	push   $0x0
  jmp __alltraps
  1020c7:	e9 69 0a 00 00       	jmp    102b35 <__alltraps>

001020cc <vector1>:
.globl vector1
vector1:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $1
  1020ce:	6a 01                	push   $0x1
  jmp __alltraps
  1020d0:	e9 60 0a 00 00       	jmp    102b35 <__alltraps>

001020d5 <vector2>:
.globl vector2
vector2:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $2
  1020d7:	6a 02                	push   $0x2
  jmp __alltraps
  1020d9:	e9 57 0a 00 00       	jmp    102b35 <__alltraps>

001020de <vector3>:
.globl vector3
vector3:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $3
  1020e0:	6a 03                	push   $0x3
  jmp __alltraps
  1020e2:	e9 4e 0a 00 00       	jmp    102b35 <__alltraps>

001020e7 <vector4>:
.globl vector4
vector4:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $4
  1020e9:	6a 04                	push   $0x4
  jmp __alltraps
  1020eb:	e9 45 0a 00 00       	jmp    102b35 <__alltraps>

001020f0 <vector5>:
.globl vector5
vector5:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $5
  1020f2:	6a 05                	push   $0x5
  jmp __alltraps
  1020f4:	e9 3c 0a 00 00       	jmp    102b35 <__alltraps>

001020f9 <vector6>:
.globl vector6
vector6:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $6
  1020fb:	6a 06                	push   $0x6
  jmp __alltraps
  1020fd:	e9 33 0a 00 00       	jmp    102b35 <__alltraps>

00102102 <vector7>:
.globl vector7
vector7:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $7
  102104:	6a 07                	push   $0x7
  jmp __alltraps
  102106:	e9 2a 0a 00 00       	jmp    102b35 <__alltraps>

0010210b <vector8>:
.globl vector8
vector8:
  pushl $8
  10210b:	6a 08                	push   $0x8
  jmp __alltraps
  10210d:	e9 23 0a 00 00       	jmp    102b35 <__alltraps>

00102112 <vector9>:
.globl vector9
vector9:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $9
  102114:	6a 09                	push   $0x9
  jmp __alltraps
  102116:	e9 1a 0a 00 00       	jmp    102b35 <__alltraps>

0010211b <vector10>:
.globl vector10
vector10:
  pushl $10
  10211b:	6a 0a                	push   $0xa
  jmp __alltraps
  10211d:	e9 13 0a 00 00       	jmp    102b35 <__alltraps>

00102122 <vector11>:
.globl vector11
vector11:
  pushl $11
  102122:	6a 0b                	push   $0xb
  jmp __alltraps
  102124:	e9 0c 0a 00 00       	jmp    102b35 <__alltraps>

00102129 <vector12>:
.globl vector12
vector12:
  pushl $12
  102129:	6a 0c                	push   $0xc
  jmp __alltraps
  10212b:	e9 05 0a 00 00       	jmp    102b35 <__alltraps>

00102130 <vector13>:
.globl vector13
vector13:
  pushl $13
  102130:	6a 0d                	push   $0xd
  jmp __alltraps
  102132:	e9 fe 09 00 00       	jmp    102b35 <__alltraps>

00102137 <vector14>:
.globl vector14
vector14:
  pushl $14
  102137:	6a 0e                	push   $0xe
  jmp __alltraps
  102139:	e9 f7 09 00 00       	jmp    102b35 <__alltraps>

0010213e <vector15>:
.globl vector15
vector15:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $15
  102140:	6a 0f                	push   $0xf
  jmp __alltraps
  102142:	e9 ee 09 00 00       	jmp    102b35 <__alltraps>

00102147 <vector16>:
.globl vector16
vector16:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $16
  102149:	6a 10                	push   $0x10
  jmp __alltraps
  10214b:	e9 e5 09 00 00       	jmp    102b35 <__alltraps>

00102150 <vector17>:
.globl vector17
vector17:
  pushl $17
  102150:	6a 11                	push   $0x11
  jmp __alltraps
  102152:	e9 de 09 00 00       	jmp    102b35 <__alltraps>

00102157 <vector18>:
.globl vector18
vector18:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $18
  102159:	6a 12                	push   $0x12
  jmp __alltraps
  10215b:	e9 d5 09 00 00       	jmp    102b35 <__alltraps>

00102160 <vector19>:
.globl vector19
vector19:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $19
  102162:	6a 13                	push   $0x13
  jmp __alltraps
  102164:	e9 cc 09 00 00       	jmp    102b35 <__alltraps>

00102169 <vector20>:
.globl vector20
vector20:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $20
  10216b:	6a 14                	push   $0x14
  jmp __alltraps
  10216d:	e9 c3 09 00 00       	jmp    102b35 <__alltraps>

00102172 <vector21>:
.globl vector21
vector21:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $21
  102174:	6a 15                	push   $0x15
  jmp __alltraps
  102176:	e9 ba 09 00 00       	jmp    102b35 <__alltraps>

0010217b <vector22>:
.globl vector22
vector22:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $22
  10217d:	6a 16                	push   $0x16
  jmp __alltraps
  10217f:	e9 b1 09 00 00       	jmp    102b35 <__alltraps>

00102184 <vector23>:
.globl vector23
vector23:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $23
  102186:	6a 17                	push   $0x17
  jmp __alltraps
  102188:	e9 a8 09 00 00       	jmp    102b35 <__alltraps>

0010218d <vector24>:
.globl vector24
vector24:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $24
  10218f:	6a 18                	push   $0x18
  jmp __alltraps
  102191:	e9 9f 09 00 00       	jmp    102b35 <__alltraps>

00102196 <vector25>:
.globl vector25
vector25:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $25
  102198:	6a 19                	push   $0x19
  jmp __alltraps
  10219a:	e9 96 09 00 00       	jmp    102b35 <__alltraps>

0010219f <vector26>:
.globl vector26
vector26:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $26
  1021a1:	6a 1a                	push   $0x1a
  jmp __alltraps
  1021a3:	e9 8d 09 00 00       	jmp    102b35 <__alltraps>

001021a8 <vector27>:
.globl vector27
vector27:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $27
  1021aa:	6a 1b                	push   $0x1b
  jmp __alltraps
  1021ac:	e9 84 09 00 00       	jmp    102b35 <__alltraps>

001021b1 <vector28>:
.globl vector28
vector28:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $28
  1021b3:	6a 1c                	push   $0x1c
  jmp __alltraps
  1021b5:	e9 7b 09 00 00       	jmp    102b35 <__alltraps>

001021ba <vector29>:
.globl vector29
vector29:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $29
  1021bc:	6a 1d                	push   $0x1d
  jmp __alltraps
  1021be:	e9 72 09 00 00       	jmp    102b35 <__alltraps>

001021c3 <vector30>:
.globl vector30
vector30:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $30
  1021c5:	6a 1e                	push   $0x1e
  jmp __alltraps
  1021c7:	e9 69 09 00 00       	jmp    102b35 <__alltraps>

001021cc <vector31>:
.globl vector31
vector31:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $31
  1021ce:	6a 1f                	push   $0x1f
  jmp __alltraps
  1021d0:	e9 60 09 00 00       	jmp    102b35 <__alltraps>

001021d5 <vector32>:
.globl vector32
vector32:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $32
  1021d7:	6a 20                	push   $0x20
  jmp __alltraps
  1021d9:	e9 57 09 00 00       	jmp    102b35 <__alltraps>

001021de <vector33>:
.globl vector33
vector33:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $33
  1021e0:	6a 21                	push   $0x21
  jmp __alltraps
  1021e2:	e9 4e 09 00 00       	jmp    102b35 <__alltraps>

001021e7 <vector34>:
.globl vector34
vector34:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $34
  1021e9:	6a 22                	push   $0x22
  jmp __alltraps
  1021eb:	e9 45 09 00 00       	jmp    102b35 <__alltraps>

001021f0 <vector35>:
.globl vector35
vector35:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $35
  1021f2:	6a 23                	push   $0x23
  jmp __alltraps
  1021f4:	e9 3c 09 00 00       	jmp    102b35 <__alltraps>

001021f9 <vector36>:
.globl vector36
vector36:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $36
  1021fb:	6a 24                	push   $0x24
  jmp __alltraps
  1021fd:	e9 33 09 00 00       	jmp    102b35 <__alltraps>

00102202 <vector37>:
.globl vector37
vector37:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $37
  102204:	6a 25                	push   $0x25
  jmp __alltraps
  102206:	e9 2a 09 00 00       	jmp    102b35 <__alltraps>

0010220b <vector38>:
.globl vector38
vector38:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $38
  10220d:	6a 26                	push   $0x26
  jmp __alltraps
  10220f:	e9 21 09 00 00       	jmp    102b35 <__alltraps>

00102214 <vector39>:
.globl vector39
vector39:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $39
  102216:	6a 27                	push   $0x27
  jmp __alltraps
  102218:	e9 18 09 00 00       	jmp    102b35 <__alltraps>

0010221d <vector40>:
.globl vector40
vector40:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $40
  10221f:	6a 28                	push   $0x28
  jmp __alltraps
  102221:	e9 0f 09 00 00       	jmp    102b35 <__alltraps>

00102226 <vector41>:
.globl vector41
vector41:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $41
  102228:	6a 29                	push   $0x29
  jmp __alltraps
  10222a:	e9 06 09 00 00       	jmp    102b35 <__alltraps>

0010222f <vector42>:
.globl vector42
vector42:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $42
  102231:	6a 2a                	push   $0x2a
  jmp __alltraps
  102233:	e9 fd 08 00 00       	jmp    102b35 <__alltraps>

00102238 <vector43>:
.globl vector43
vector43:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $43
  10223a:	6a 2b                	push   $0x2b
  jmp __alltraps
  10223c:	e9 f4 08 00 00       	jmp    102b35 <__alltraps>

00102241 <vector44>:
.globl vector44
vector44:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $44
  102243:	6a 2c                	push   $0x2c
  jmp __alltraps
  102245:	e9 eb 08 00 00       	jmp    102b35 <__alltraps>

0010224a <vector45>:
.globl vector45
vector45:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $45
  10224c:	6a 2d                	push   $0x2d
  jmp __alltraps
  10224e:	e9 e2 08 00 00       	jmp    102b35 <__alltraps>

00102253 <vector46>:
.globl vector46
vector46:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $46
  102255:	6a 2e                	push   $0x2e
  jmp __alltraps
  102257:	e9 d9 08 00 00       	jmp    102b35 <__alltraps>

0010225c <vector47>:
.globl vector47
vector47:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $47
  10225e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102260:	e9 d0 08 00 00       	jmp    102b35 <__alltraps>

00102265 <vector48>:
.globl vector48
vector48:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $48
  102267:	6a 30                	push   $0x30
  jmp __alltraps
  102269:	e9 c7 08 00 00       	jmp    102b35 <__alltraps>

0010226e <vector49>:
.globl vector49
vector49:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $49
  102270:	6a 31                	push   $0x31
  jmp __alltraps
  102272:	e9 be 08 00 00       	jmp    102b35 <__alltraps>

00102277 <vector50>:
.globl vector50
vector50:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $50
  102279:	6a 32                	push   $0x32
  jmp __alltraps
  10227b:	e9 b5 08 00 00       	jmp    102b35 <__alltraps>

00102280 <vector51>:
.globl vector51
vector51:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $51
  102282:	6a 33                	push   $0x33
  jmp __alltraps
  102284:	e9 ac 08 00 00       	jmp    102b35 <__alltraps>

00102289 <vector52>:
.globl vector52
vector52:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $52
  10228b:	6a 34                	push   $0x34
  jmp __alltraps
  10228d:	e9 a3 08 00 00       	jmp    102b35 <__alltraps>

00102292 <vector53>:
.globl vector53
vector53:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $53
  102294:	6a 35                	push   $0x35
  jmp __alltraps
  102296:	e9 9a 08 00 00       	jmp    102b35 <__alltraps>

0010229b <vector54>:
.globl vector54
vector54:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $54
  10229d:	6a 36                	push   $0x36
  jmp __alltraps
  10229f:	e9 91 08 00 00       	jmp    102b35 <__alltraps>

001022a4 <vector55>:
.globl vector55
vector55:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $55
  1022a6:	6a 37                	push   $0x37
  jmp __alltraps
  1022a8:	e9 88 08 00 00       	jmp    102b35 <__alltraps>

001022ad <vector56>:
.globl vector56
vector56:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $56
  1022af:	6a 38                	push   $0x38
  jmp __alltraps
  1022b1:	e9 7f 08 00 00       	jmp    102b35 <__alltraps>

001022b6 <vector57>:
.globl vector57
vector57:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $57
  1022b8:	6a 39                	push   $0x39
  jmp __alltraps
  1022ba:	e9 76 08 00 00       	jmp    102b35 <__alltraps>

001022bf <vector58>:
.globl vector58
vector58:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $58
  1022c1:	6a 3a                	push   $0x3a
  jmp __alltraps
  1022c3:	e9 6d 08 00 00       	jmp    102b35 <__alltraps>

001022c8 <vector59>:
.globl vector59
vector59:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $59
  1022ca:	6a 3b                	push   $0x3b
  jmp __alltraps
  1022cc:	e9 64 08 00 00       	jmp    102b35 <__alltraps>

001022d1 <vector60>:
.globl vector60
vector60:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $60
  1022d3:	6a 3c                	push   $0x3c
  jmp __alltraps
  1022d5:	e9 5b 08 00 00       	jmp    102b35 <__alltraps>

001022da <vector61>:
.globl vector61
vector61:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $61
  1022dc:	6a 3d                	push   $0x3d
  jmp __alltraps
  1022de:	e9 52 08 00 00       	jmp    102b35 <__alltraps>

001022e3 <vector62>:
.globl vector62
vector62:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $62
  1022e5:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022e7:	e9 49 08 00 00       	jmp    102b35 <__alltraps>

001022ec <vector63>:
.globl vector63
vector63:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $63
  1022ee:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022f0:	e9 40 08 00 00       	jmp    102b35 <__alltraps>

001022f5 <vector64>:
.globl vector64
vector64:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $64
  1022f7:	6a 40                	push   $0x40
  jmp __alltraps
  1022f9:	e9 37 08 00 00       	jmp    102b35 <__alltraps>

001022fe <vector65>:
.globl vector65
vector65:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $65
  102300:	6a 41                	push   $0x41
  jmp __alltraps
  102302:	e9 2e 08 00 00       	jmp    102b35 <__alltraps>

00102307 <vector66>:
.globl vector66
vector66:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $66
  102309:	6a 42                	push   $0x42
  jmp __alltraps
  10230b:	e9 25 08 00 00       	jmp    102b35 <__alltraps>

00102310 <vector67>:
.globl vector67
vector67:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $67
  102312:	6a 43                	push   $0x43
  jmp __alltraps
  102314:	e9 1c 08 00 00       	jmp    102b35 <__alltraps>

00102319 <vector68>:
.globl vector68
vector68:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $68
  10231b:	6a 44                	push   $0x44
  jmp __alltraps
  10231d:	e9 13 08 00 00       	jmp    102b35 <__alltraps>

00102322 <vector69>:
.globl vector69
vector69:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $69
  102324:	6a 45                	push   $0x45
  jmp __alltraps
  102326:	e9 0a 08 00 00       	jmp    102b35 <__alltraps>

0010232b <vector70>:
.globl vector70
vector70:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $70
  10232d:	6a 46                	push   $0x46
  jmp __alltraps
  10232f:	e9 01 08 00 00       	jmp    102b35 <__alltraps>

00102334 <vector71>:
.globl vector71
vector71:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $71
  102336:	6a 47                	push   $0x47
  jmp __alltraps
  102338:	e9 f8 07 00 00       	jmp    102b35 <__alltraps>

0010233d <vector72>:
.globl vector72
vector72:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $72
  10233f:	6a 48                	push   $0x48
  jmp __alltraps
  102341:	e9 ef 07 00 00       	jmp    102b35 <__alltraps>

00102346 <vector73>:
.globl vector73
vector73:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $73
  102348:	6a 49                	push   $0x49
  jmp __alltraps
  10234a:	e9 e6 07 00 00       	jmp    102b35 <__alltraps>

0010234f <vector74>:
.globl vector74
vector74:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $74
  102351:	6a 4a                	push   $0x4a
  jmp __alltraps
  102353:	e9 dd 07 00 00       	jmp    102b35 <__alltraps>

00102358 <vector75>:
.globl vector75
vector75:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $75
  10235a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10235c:	e9 d4 07 00 00       	jmp    102b35 <__alltraps>

00102361 <vector76>:
.globl vector76
vector76:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $76
  102363:	6a 4c                	push   $0x4c
  jmp __alltraps
  102365:	e9 cb 07 00 00       	jmp    102b35 <__alltraps>

0010236a <vector77>:
.globl vector77
vector77:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $77
  10236c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10236e:	e9 c2 07 00 00       	jmp    102b35 <__alltraps>

00102373 <vector78>:
.globl vector78
vector78:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $78
  102375:	6a 4e                	push   $0x4e
  jmp __alltraps
  102377:	e9 b9 07 00 00       	jmp    102b35 <__alltraps>

0010237c <vector79>:
.globl vector79
vector79:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $79
  10237e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102380:	e9 b0 07 00 00       	jmp    102b35 <__alltraps>

00102385 <vector80>:
.globl vector80
vector80:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $80
  102387:	6a 50                	push   $0x50
  jmp __alltraps
  102389:	e9 a7 07 00 00       	jmp    102b35 <__alltraps>

0010238e <vector81>:
.globl vector81
vector81:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $81
  102390:	6a 51                	push   $0x51
  jmp __alltraps
  102392:	e9 9e 07 00 00       	jmp    102b35 <__alltraps>

00102397 <vector82>:
.globl vector82
vector82:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $82
  102399:	6a 52                	push   $0x52
  jmp __alltraps
  10239b:	e9 95 07 00 00       	jmp    102b35 <__alltraps>

001023a0 <vector83>:
.globl vector83
vector83:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $83
  1023a2:	6a 53                	push   $0x53
  jmp __alltraps
  1023a4:	e9 8c 07 00 00       	jmp    102b35 <__alltraps>

001023a9 <vector84>:
.globl vector84
vector84:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $84
  1023ab:	6a 54                	push   $0x54
  jmp __alltraps
  1023ad:	e9 83 07 00 00       	jmp    102b35 <__alltraps>

001023b2 <vector85>:
.globl vector85
vector85:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $85
  1023b4:	6a 55                	push   $0x55
  jmp __alltraps
  1023b6:	e9 7a 07 00 00       	jmp    102b35 <__alltraps>

001023bb <vector86>:
.globl vector86
vector86:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $86
  1023bd:	6a 56                	push   $0x56
  jmp __alltraps
  1023bf:	e9 71 07 00 00       	jmp    102b35 <__alltraps>

001023c4 <vector87>:
.globl vector87
vector87:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $87
  1023c6:	6a 57                	push   $0x57
  jmp __alltraps
  1023c8:	e9 68 07 00 00       	jmp    102b35 <__alltraps>

001023cd <vector88>:
.globl vector88
vector88:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $88
  1023cf:	6a 58                	push   $0x58
  jmp __alltraps
  1023d1:	e9 5f 07 00 00       	jmp    102b35 <__alltraps>

001023d6 <vector89>:
.globl vector89
vector89:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $89
  1023d8:	6a 59                	push   $0x59
  jmp __alltraps
  1023da:	e9 56 07 00 00       	jmp    102b35 <__alltraps>

001023df <vector90>:
.globl vector90
vector90:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $90
  1023e1:	6a 5a                	push   $0x5a
  jmp __alltraps
  1023e3:	e9 4d 07 00 00       	jmp    102b35 <__alltraps>

001023e8 <vector91>:
.globl vector91
vector91:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $91
  1023ea:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023ec:	e9 44 07 00 00       	jmp    102b35 <__alltraps>

001023f1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $92
  1023f3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023f5:	e9 3b 07 00 00       	jmp    102b35 <__alltraps>

001023fa <vector93>:
.globl vector93
vector93:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $93
  1023fc:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023fe:	e9 32 07 00 00       	jmp    102b35 <__alltraps>

00102403 <vector94>:
.globl vector94
vector94:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $94
  102405:	6a 5e                	push   $0x5e
  jmp __alltraps
  102407:	e9 29 07 00 00       	jmp    102b35 <__alltraps>

0010240c <vector95>:
.globl vector95
vector95:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $95
  10240e:	6a 5f                	push   $0x5f
  jmp __alltraps
  102410:	e9 20 07 00 00       	jmp    102b35 <__alltraps>

00102415 <vector96>:
.globl vector96
vector96:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $96
  102417:	6a 60                	push   $0x60
  jmp __alltraps
  102419:	e9 17 07 00 00       	jmp    102b35 <__alltraps>

0010241e <vector97>:
.globl vector97
vector97:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $97
  102420:	6a 61                	push   $0x61
  jmp __alltraps
  102422:	e9 0e 07 00 00       	jmp    102b35 <__alltraps>

00102427 <vector98>:
.globl vector98
vector98:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $98
  102429:	6a 62                	push   $0x62
  jmp __alltraps
  10242b:	e9 05 07 00 00       	jmp    102b35 <__alltraps>

00102430 <vector99>:
.globl vector99
vector99:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $99
  102432:	6a 63                	push   $0x63
  jmp __alltraps
  102434:	e9 fc 06 00 00       	jmp    102b35 <__alltraps>

00102439 <vector100>:
.globl vector100
vector100:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $100
  10243b:	6a 64                	push   $0x64
  jmp __alltraps
  10243d:	e9 f3 06 00 00       	jmp    102b35 <__alltraps>

00102442 <vector101>:
.globl vector101
vector101:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $101
  102444:	6a 65                	push   $0x65
  jmp __alltraps
  102446:	e9 ea 06 00 00       	jmp    102b35 <__alltraps>

0010244b <vector102>:
.globl vector102
vector102:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $102
  10244d:	6a 66                	push   $0x66
  jmp __alltraps
  10244f:	e9 e1 06 00 00       	jmp    102b35 <__alltraps>

00102454 <vector103>:
.globl vector103
vector103:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $103
  102456:	6a 67                	push   $0x67
  jmp __alltraps
  102458:	e9 d8 06 00 00       	jmp    102b35 <__alltraps>

0010245d <vector104>:
.globl vector104
vector104:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $104
  10245f:	6a 68                	push   $0x68
  jmp __alltraps
  102461:	e9 cf 06 00 00       	jmp    102b35 <__alltraps>

00102466 <vector105>:
.globl vector105
vector105:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $105
  102468:	6a 69                	push   $0x69
  jmp __alltraps
  10246a:	e9 c6 06 00 00       	jmp    102b35 <__alltraps>

0010246f <vector106>:
.globl vector106
vector106:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $106
  102471:	6a 6a                	push   $0x6a
  jmp __alltraps
  102473:	e9 bd 06 00 00       	jmp    102b35 <__alltraps>

00102478 <vector107>:
.globl vector107
vector107:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $107
  10247a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10247c:	e9 b4 06 00 00       	jmp    102b35 <__alltraps>

00102481 <vector108>:
.globl vector108
vector108:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $108
  102483:	6a 6c                	push   $0x6c
  jmp __alltraps
  102485:	e9 ab 06 00 00       	jmp    102b35 <__alltraps>

0010248a <vector109>:
.globl vector109
vector109:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $109
  10248c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10248e:	e9 a2 06 00 00       	jmp    102b35 <__alltraps>

00102493 <vector110>:
.globl vector110
vector110:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $110
  102495:	6a 6e                	push   $0x6e
  jmp __alltraps
  102497:	e9 99 06 00 00       	jmp    102b35 <__alltraps>

0010249c <vector111>:
.globl vector111
vector111:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $111
  10249e:	6a 6f                	push   $0x6f
  jmp __alltraps
  1024a0:	e9 90 06 00 00       	jmp    102b35 <__alltraps>

001024a5 <vector112>:
.globl vector112
vector112:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $112
  1024a7:	6a 70                	push   $0x70
  jmp __alltraps
  1024a9:	e9 87 06 00 00       	jmp    102b35 <__alltraps>

001024ae <vector113>:
.globl vector113
vector113:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $113
  1024b0:	6a 71                	push   $0x71
  jmp __alltraps
  1024b2:	e9 7e 06 00 00       	jmp    102b35 <__alltraps>

001024b7 <vector114>:
.globl vector114
vector114:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $114
  1024b9:	6a 72                	push   $0x72
  jmp __alltraps
  1024bb:	e9 75 06 00 00       	jmp    102b35 <__alltraps>

001024c0 <vector115>:
.globl vector115
vector115:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $115
  1024c2:	6a 73                	push   $0x73
  jmp __alltraps
  1024c4:	e9 6c 06 00 00       	jmp    102b35 <__alltraps>

001024c9 <vector116>:
.globl vector116
vector116:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $116
  1024cb:	6a 74                	push   $0x74
  jmp __alltraps
  1024cd:	e9 63 06 00 00       	jmp    102b35 <__alltraps>

001024d2 <vector117>:
.globl vector117
vector117:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $117
  1024d4:	6a 75                	push   $0x75
  jmp __alltraps
  1024d6:	e9 5a 06 00 00       	jmp    102b35 <__alltraps>

001024db <vector118>:
.globl vector118
vector118:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $118
  1024dd:	6a 76                	push   $0x76
  jmp __alltraps
  1024df:	e9 51 06 00 00       	jmp    102b35 <__alltraps>

001024e4 <vector119>:
.globl vector119
vector119:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $119
  1024e6:	6a 77                	push   $0x77
  jmp __alltraps
  1024e8:	e9 48 06 00 00       	jmp    102b35 <__alltraps>

001024ed <vector120>:
.globl vector120
vector120:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $120
  1024ef:	6a 78                	push   $0x78
  jmp __alltraps
  1024f1:	e9 3f 06 00 00       	jmp    102b35 <__alltraps>

001024f6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $121
  1024f8:	6a 79                	push   $0x79
  jmp __alltraps
  1024fa:	e9 36 06 00 00       	jmp    102b35 <__alltraps>

001024ff <vector122>:
.globl vector122
vector122:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $122
  102501:	6a 7a                	push   $0x7a
  jmp __alltraps
  102503:	e9 2d 06 00 00       	jmp    102b35 <__alltraps>

00102508 <vector123>:
.globl vector123
vector123:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $123
  10250a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10250c:	e9 24 06 00 00       	jmp    102b35 <__alltraps>

00102511 <vector124>:
.globl vector124
vector124:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $124
  102513:	6a 7c                	push   $0x7c
  jmp __alltraps
  102515:	e9 1b 06 00 00       	jmp    102b35 <__alltraps>

0010251a <vector125>:
.globl vector125
vector125:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $125
  10251c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10251e:	e9 12 06 00 00       	jmp    102b35 <__alltraps>

00102523 <vector126>:
.globl vector126
vector126:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $126
  102525:	6a 7e                	push   $0x7e
  jmp __alltraps
  102527:	e9 09 06 00 00       	jmp    102b35 <__alltraps>

0010252c <vector127>:
.globl vector127
vector127:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $127
  10252e:	6a 7f                	push   $0x7f
  jmp __alltraps
  102530:	e9 00 06 00 00       	jmp    102b35 <__alltraps>

00102535 <vector128>:
.globl vector128
vector128:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $128
  102537:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10253c:	e9 f4 05 00 00       	jmp    102b35 <__alltraps>

00102541 <vector129>:
.globl vector129
vector129:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $129
  102543:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102548:	e9 e8 05 00 00       	jmp    102b35 <__alltraps>

0010254d <vector130>:
.globl vector130
vector130:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $130
  10254f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102554:	e9 dc 05 00 00       	jmp    102b35 <__alltraps>

00102559 <vector131>:
.globl vector131
vector131:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $131
  10255b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102560:	e9 d0 05 00 00       	jmp    102b35 <__alltraps>

00102565 <vector132>:
.globl vector132
vector132:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $132
  102567:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10256c:	e9 c4 05 00 00       	jmp    102b35 <__alltraps>

00102571 <vector133>:
.globl vector133
vector133:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $133
  102573:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102578:	e9 b8 05 00 00       	jmp    102b35 <__alltraps>

0010257d <vector134>:
.globl vector134
vector134:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $134
  10257f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102584:	e9 ac 05 00 00       	jmp    102b35 <__alltraps>

00102589 <vector135>:
.globl vector135
vector135:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $135
  10258b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102590:	e9 a0 05 00 00       	jmp    102b35 <__alltraps>

00102595 <vector136>:
.globl vector136
vector136:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $136
  102597:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10259c:	e9 94 05 00 00       	jmp    102b35 <__alltraps>

001025a1 <vector137>:
.globl vector137
vector137:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $137
  1025a3:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1025a8:	e9 88 05 00 00       	jmp    102b35 <__alltraps>

001025ad <vector138>:
.globl vector138
vector138:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $138
  1025af:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1025b4:	e9 7c 05 00 00       	jmp    102b35 <__alltraps>

001025b9 <vector139>:
.globl vector139
vector139:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $139
  1025bb:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1025c0:	e9 70 05 00 00       	jmp    102b35 <__alltraps>

001025c5 <vector140>:
.globl vector140
vector140:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $140
  1025c7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1025cc:	e9 64 05 00 00       	jmp    102b35 <__alltraps>

001025d1 <vector141>:
.globl vector141
vector141:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $141
  1025d3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1025d8:	e9 58 05 00 00       	jmp    102b35 <__alltraps>

001025dd <vector142>:
.globl vector142
vector142:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $142
  1025df:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1025e4:	e9 4c 05 00 00       	jmp    102b35 <__alltraps>

001025e9 <vector143>:
.globl vector143
vector143:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $143
  1025eb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025f0:	e9 40 05 00 00       	jmp    102b35 <__alltraps>

001025f5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $144
  1025f7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025fc:	e9 34 05 00 00       	jmp    102b35 <__alltraps>

00102601 <vector145>:
.globl vector145
vector145:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $145
  102603:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102608:	e9 28 05 00 00       	jmp    102b35 <__alltraps>

0010260d <vector146>:
.globl vector146
vector146:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $146
  10260f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102614:	e9 1c 05 00 00       	jmp    102b35 <__alltraps>

00102619 <vector147>:
.globl vector147
vector147:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $147
  10261b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102620:	e9 10 05 00 00       	jmp    102b35 <__alltraps>

00102625 <vector148>:
.globl vector148
vector148:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $148
  102627:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10262c:	e9 04 05 00 00       	jmp    102b35 <__alltraps>

00102631 <vector149>:
.globl vector149
vector149:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $149
  102633:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102638:	e9 f8 04 00 00       	jmp    102b35 <__alltraps>

0010263d <vector150>:
.globl vector150
vector150:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $150
  10263f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102644:	e9 ec 04 00 00       	jmp    102b35 <__alltraps>

00102649 <vector151>:
.globl vector151
vector151:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $151
  10264b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102650:	e9 e0 04 00 00       	jmp    102b35 <__alltraps>

00102655 <vector152>:
.globl vector152
vector152:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $152
  102657:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10265c:	e9 d4 04 00 00       	jmp    102b35 <__alltraps>

00102661 <vector153>:
.globl vector153
vector153:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $153
  102663:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102668:	e9 c8 04 00 00       	jmp    102b35 <__alltraps>

0010266d <vector154>:
.globl vector154
vector154:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $154
  10266f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102674:	e9 bc 04 00 00       	jmp    102b35 <__alltraps>

00102679 <vector155>:
.globl vector155
vector155:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $155
  10267b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102680:	e9 b0 04 00 00       	jmp    102b35 <__alltraps>

00102685 <vector156>:
.globl vector156
vector156:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $156
  102687:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10268c:	e9 a4 04 00 00       	jmp    102b35 <__alltraps>

00102691 <vector157>:
.globl vector157
vector157:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $157
  102693:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102698:	e9 98 04 00 00       	jmp    102b35 <__alltraps>

0010269d <vector158>:
.globl vector158
vector158:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $158
  10269f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1026a4:	e9 8c 04 00 00       	jmp    102b35 <__alltraps>

001026a9 <vector159>:
.globl vector159
vector159:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $159
  1026ab:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1026b0:	e9 80 04 00 00       	jmp    102b35 <__alltraps>

001026b5 <vector160>:
.globl vector160
vector160:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $160
  1026b7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1026bc:	e9 74 04 00 00       	jmp    102b35 <__alltraps>

001026c1 <vector161>:
.globl vector161
vector161:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $161
  1026c3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1026c8:	e9 68 04 00 00       	jmp    102b35 <__alltraps>

001026cd <vector162>:
.globl vector162
vector162:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $162
  1026cf:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1026d4:	e9 5c 04 00 00       	jmp    102b35 <__alltraps>

001026d9 <vector163>:
.globl vector163
vector163:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $163
  1026db:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1026e0:	e9 50 04 00 00       	jmp    102b35 <__alltraps>

001026e5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $164
  1026e7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026ec:	e9 44 04 00 00       	jmp    102b35 <__alltraps>

001026f1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $165
  1026f3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026f8:	e9 38 04 00 00       	jmp    102b35 <__alltraps>

001026fd <vector166>:
.globl vector166
vector166:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $166
  1026ff:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102704:	e9 2c 04 00 00       	jmp    102b35 <__alltraps>

00102709 <vector167>:
.globl vector167
vector167:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $167
  10270b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102710:	e9 20 04 00 00       	jmp    102b35 <__alltraps>

00102715 <vector168>:
.globl vector168
vector168:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $168
  102717:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10271c:	e9 14 04 00 00       	jmp    102b35 <__alltraps>

00102721 <vector169>:
.globl vector169
vector169:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $169
  102723:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102728:	e9 08 04 00 00       	jmp    102b35 <__alltraps>

0010272d <vector170>:
.globl vector170
vector170:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $170
  10272f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102734:	e9 fc 03 00 00       	jmp    102b35 <__alltraps>

00102739 <vector171>:
.globl vector171
vector171:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $171
  10273b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102740:	e9 f0 03 00 00       	jmp    102b35 <__alltraps>

00102745 <vector172>:
.globl vector172
vector172:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $172
  102747:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10274c:	e9 e4 03 00 00       	jmp    102b35 <__alltraps>

00102751 <vector173>:
.globl vector173
vector173:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $173
  102753:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102758:	e9 d8 03 00 00       	jmp    102b35 <__alltraps>

0010275d <vector174>:
.globl vector174
vector174:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $174
  10275f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102764:	e9 cc 03 00 00       	jmp    102b35 <__alltraps>

00102769 <vector175>:
.globl vector175
vector175:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $175
  10276b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102770:	e9 c0 03 00 00       	jmp    102b35 <__alltraps>

00102775 <vector176>:
.globl vector176
vector176:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $176
  102777:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10277c:	e9 b4 03 00 00       	jmp    102b35 <__alltraps>

00102781 <vector177>:
.globl vector177
vector177:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $177
  102783:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102788:	e9 a8 03 00 00       	jmp    102b35 <__alltraps>

0010278d <vector178>:
.globl vector178
vector178:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $178
  10278f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102794:	e9 9c 03 00 00       	jmp    102b35 <__alltraps>

00102799 <vector179>:
.globl vector179
vector179:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $179
  10279b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1027a0:	e9 90 03 00 00       	jmp    102b35 <__alltraps>

001027a5 <vector180>:
.globl vector180
vector180:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $180
  1027a7:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1027ac:	e9 84 03 00 00       	jmp    102b35 <__alltraps>

001027b1 <vector181>:
.globl vector181
vector181:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $181
  1027b3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1027b8:	e9 78 03 00 00       	jmp    102b35 <__alltraps>

001027bd <vector182>:
.globl vector182
vector182:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $182
  1027bf:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1027c4:	e9 6c 03 00 00       	jmp    102b35 <__alltraps>

001027c9 <vector183>:
.globl vector183
vector183:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $183
  1027cb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1027d0:	e9 60 03 00 00       	jmp    102b35 <__alltraps>

001027d5 <vector184>:
.globl vector184
vector184:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $184
  1027d7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1027dc:	e9 54 03 00 00       	jmp    102b35 <__alltraps>

001027e1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $185
  1027e3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027e8:	e9 48 03 00 00       	jmp    102b35 <__alltraps>

001027ed <vector186>:
.globl vector186
vector186:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $186
  1027ef:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027f4:	e9 3c 03 00 00       	jmp    102b35 <__alltraps>

001027f9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $187
  1027fb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102800:	e9 30 03 00 00       	jmp    102b35 <__alltraps>

00102805 <vector188>:
.globl vector188
vector188:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $188
  102807:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10280c:	e9 24 03 00 00       	jmp    102b35 <__alltraps>

00102811 <vector189>:
.globl vector189
vector189:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $189
  102813:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102818:	e9 18 03 00 00       	jmp    102b35 <__alltraps>

0010281d <vector190>:
.globl vector190
vector190:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $190
  10281f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102824:	e9 0c 03 00 00       	jmp    102b35 <__alltraps>

00102829 <vector191>:
.globl vector191
vector191:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $191
  10282b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102830:	e9 00 03 00 00       	jmp    102b35 <__alltraps>

00102835 <vector192>:
.globl vector192
vector192:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $192
  102837:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10283c:	e9 f4 02 00 00       	jmp    102b35 <__alltraps>

00102841 <vector193>:
.globl vector193
vector193:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $193
  102843:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102848:	e9 e8 02 00 00       	jmp    102b35 <__alltraps>

0010284d <vector194>:
.globl vector194
vector194:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $194
  10284f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102854:	e9 dc 02 00 00       	jmp    102b35 <__alltraps>

00102859 <vector195>:
.globl vector195
vector195:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $195
  10285b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102860:	e9 d0 02 00 00       	jmp    102b35 <__alltraps>

00102865 <vector196>:
.globl vector196
vector196:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $196
  102867:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10286c:	e9 c4 02 00 00       	jmp    102b35 <__alltraps>

00102871 <vector197>:
.globl vector197
vector197:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $197
  102873:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102878:	e9 b8 02 00 00       	jmp    102b35 <__alltraps>

0010287d <vector198>:
.globl vector198
vector198:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $198
  10287f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102884:	e9 ac 02 00 00       	jmp    102b35 <__alltraps>

00102889 <vector199>:
.globl vector199
vector199:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $199
  10288b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102890:	e9 a0 02 00 00       	jmp    102b35 <__alltraps>

00102895 <vector200>:
.globl vector200
vector200:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $200
  102897:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10289c:	e9 94 02 00 00       	jmp    102b35 <__alltraps>

001028a1 <vector201>:
.globl vector201
vector201:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $201
  1028a3:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1028a8:	e9 88 02 00 00       	jmp    102b35 <__alltraps>

001028ad <vector202>:
.globl vector202
vector202:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $202
  1028af:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1028b4:	e9 7c 02 00 00       	jmp    102b35 <__alltraps>

001028b9 <vector203>:
.globl vector203
vector203:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $203
  1028bb:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1028c0:	e9 70 02 00 00       	jmp    102b35 <__alltraps>

001028c5 <vector204>:
.globl vector204
vector204:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $204
  1028c7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1028cc:	e9 64 02 00 00       	jmp    102b35 <__alltraps>

001028d1 <vector205>:
.globl vector205
vector205:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $205
  1028d3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1028d8:	e9 58 02 00 00       	jmp    102b35 <__alltraps>

001028dd <vector206>:
.globl vector206
vector206:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $206
  1028df:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1028e4:	e9 4c 02 00 00       	jmp    102b35 <__alltraps>

001028e9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $207
  1028eb:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028f0:	e9 40 02 00 00       	jmp    102b35 <__alltraps>

001028f5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $208
  1028f7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028fc:	e9 34 02 00 00       	jmp    102b35 <__alltraps>

00102901 <vector209>:
.globl vector209
vector209:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $209
  102903:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102908:	e9 28 02 00 00       	jmp    102b35 <__alltraps>

0010290d <vector210>:
.globl vector210
vector210:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $210
  10290f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102914:	e9 1c 02 00 00       	jmp    102b35 <__alltraps>

00102919 <vector211>:
.globl vector211
vector211:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $211
  10291b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102920:	e9 10 02 00 00       	jmp    102b35 <__alltraps>

00102925 <vector212>:
.globl vector212
vector212:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $212
  102927:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10292c:	e9 04 02 00 00       	jmp    102b35 <__alltraps>

00102931 <vector213>:
.globl vector213
vector213:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $213
  102933:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102938:	e9 f8 01 00 00       	jmp    102b35 <__alltraps>

0010293d <vector214>:
.globl vector214
vector214:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $214
  10293f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102944:	e9 ec 01 00 00       	jmp    102b35 <__alltraps>

00102949 <vector215>:
.globl vector215
vector215:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $215
  10294b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102950:	e9 e0 01 00 00       	jmp    102b35 <__alltraps>

00102955 <vector216>:
.globl vector216
vector216:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $216
  102957:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10295c:	e9 d4 01 00 00       	jmp    102b35 <__alltraps>

00102961 <vector217>:
.globl vector217
vector217:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $217
  102963:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102968:	e9 c8 01 00 00       	jmp    102b35 <__alltraps>

0010296d <vector218>:
.globl vector218
vector218:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $218
  10296f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102974:	e9 bc 01 00 00       	jmp    102b35 <__alltraps>

00102979 <vector219>:
.globl vector219
vector219:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $219
  10297b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102980:	e9 b0 01 00 00       	jmp    102b35 <__alltraps>

00102985 <vector220>:
.globl vector220
vector220:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $220
  102987:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10298c:	e9 a4 01 00 00       	jmp    102b35 <__alltraps>

00102991 <vector221>:
.globl vector221
vector221:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $221
  102993:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102998:	e9 98 01 00 00       	jmp    102b35 <__alltraps>

0010299d <vector222>:
.globl vector222
vector222:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $222
  10299f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1029a4:	e9 8c 01 00 00       	jmp    102b35 <__alltraps>

001029a9 <vector223>:
.globl vector223
vector223:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $223
  1029ab:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1029b0:	e9 80 01 00 00       	jmp    102b35 <__alltraps>

001029b5 <vector224>:
.globl vector224
vector224:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $224
  1029b7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1029bc:	e9 74 01 00 00       	jmp    102b35 <__alltraps>

001029c1 <vector225>:
.globl vector225
vector225:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $225
  1029c3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1029c8:	e9 68 01 00 00       	jmp    102b35 <__alltraps>

001029cd <vector226>:
.globl vector226
vector226:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $226
  1029cf:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1029d4:	e9 5c 01 00 00       	jmp    102b35 <__alltraps>

001029d9 <vector227>:
.globl vector227
vector227:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $227
  1029db:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1029e0:	e9 50 01 00 00       	jmp    102b35 <__alltraps>

001029e5 <vector228>:
.globl vector228
vector228:
  pushl $0
  1029e5:	6a 00                	push   $0x0
  pushl $228
  1029e7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029ec:	e9 44 01 00 00       	jmp    102b35 <__alltraps>

001029f1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1029f1:	6a 00                	push   $0x0
  pushl $229
  1029f3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029f8:	e9 38 01 00 00       	jmp    102b35 <__alltraps>

001029fd <vector230>:
.globl vector230
vector230:
  pushl $0
  1029fd:	6a 00                	push   $0x0
  pushl $230
  1029ff:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a04:	e9 2c 01 00 00       	jmp    102b35 <__alltraps>

00102a09 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a09:	6a 00                	push   $0x0
  pushl $231
  102a0b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a10:	e9 20 01 00 00       	jmp    102b35 <__alltraps>

00102a15 <vector232>:
.globl vector232
vector232:
  pushl $0
  102a15:	6a 00                	push   $0x0
  pushl $232
  102a17:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a1c:	e9 14 01 00 00       	jmp    102b35 <__alltraps>

00102a21 <vector233>:
.globl vector233
vector233:
  pushl $0
  102a21:	6a 00                	push   $0x0
  pushl $233
  102a23:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a28:	e9 08 01 00 00       	jmp    102b35 <__alltraps>

00102a2d <vector234>:
.globl vector234
vector234:
  pushl $0
  102a2d:	6a 00                	push   $0x0
  pushl $234
  102a2f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a34:	e9 fc 00 00 00       	jmp    102b35 <__alltraps>

00102a39 <vector235>:
.globl vector235
vector235:
  pushl $0
  102a39:	6a 00                	push   $0x0
  pushl $235
  102a3b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a40:	e9 f0 00 00 00       	jmp    102b35 <__alltraps>

00102a45 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a45:	6a 00                	push   $0x0
  pushl $236
  102a47:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a4c:	e9 e4 00 00 00       	jmp    102b35 <__alltraps>

00102a51 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a51:	6a 00                	push   $0x0
  pushl $237
  102a53:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a58:	e9 d8 00 00 00       	jmp    102b35 <__alltraps>

00102a5d <vector238>:
.globl vector238
vector238:
  pushl $0
  102a5d:	6a 00                	push   $0x0
  pushl $238
  102a5f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a64:	e9 cc 00 00 00       	jmp    102b35 <__alltraps>

00102a69 <vector239>:
.globl vector239
vector239:
  pushl $0
  102a69:	6a 00                	push   $0x0
  pushl $239
  102a6b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a70:	e9 c0 00 00 00       	jmp    102b35 <__alltraps>

00102a75 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a75:	6a 00                	push   $0x0
  pushl $240
  102a77:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a7c:	e9 b4 00 00 00       	jmp    102b35 <__alltraps>

00102a81 <vector241>:
.globl vector241
vector241:
  pushl $0
  102a81:	6a 00                	push   $0x0
  pushl $241
  102a83:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a88:	e9 a8 00 00 00       	jmp    102b35 <__alltraps>

00102a8d <vector242>:
.globl vector242
vector242:
  pushl $0
  102a8d:	6a 00                	push   $0x0
  pushl $242
  102a8f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a94:	e9 9c 00 00 00       	jmp    102b35 <__alltraps>

00102a99 <vector243>:
.globl vector243
vector243:
  pushl $0
  102a99:	6a 00                	push   $0x0
  pushl $243
  102a9b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102aa0:	e9 90 00 00 00       	jmp    102b35 <__alltraps>

00102aa5 <vector244>:
.globl vector244
vector244:
  pushl $0
  102aa5:	6a 00                	push   $0x0
  pushl $244
  102aa7:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102aac:	e9 84 00 00 00       	jmp    102b35 <__alltraps>

00102ab1 <vector245>:
.globl vector245
vector245:
  pushl $0
  102ab1:	6a 00                	push   $0x0
  pushl $245
  102ab3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102ab8:	e9 78 00 00 00       	jmp    102b35 <__alltraps>

00102abd <vector246>:
.globl vector246
vector246:
  pushl $0
  102abd:	6a 00                	push   $0x0
  pushl $246
  102abf:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102ac4:	e9 6c 00 00 00       	jmp    102b35 <__alltraps>

00102ac9 <vector247>:
.globl vector247
vector247:
  pushl $0
  102ac9:	6a 00                	push   $0x0
  pushl $247
  102acb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102ad0:	e9 60 00 00 00       	jmp    102b35 <__alltraps>

00102ad5 <vector248>:
.globl vector248
vector248:
  pushl $0
  102ad5:	6a 00                	push   $0x0
  pushl $248
  102ad7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102adc:	e9 54 00 00 00       	jmp    102b35 <__alltraps>

00102ae1 <vector249>:
.globl vector249
vector249:
  pushl $0
  102ae1:	6a 00                	push   $0x0
  pushl $249
  102ae3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102ae8:	e9 48 00 00 00       	jmp    102b35 <__alltraps>

00102aed <vector250>:
.globl vector250
vector250:
  pushl $0
  102aed:	6a 00                	push   $0x0
  pushl $250
  102aef:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102af4:	e9 3c 00 00 00       	jmp    102b35 <__alltraps>

00102af9 <vector251>:
.globl vector251
vector251:
  pushl $0
  102af9:	6a 00                	push   $0x0
  pushl $251
  102afb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b00:	e9 30 00 00 00       	jmp    102b35 <__alltraps>

00102b05 <vector252>:
.globl vector252
vector252:
  pushl $0
  102b05:	6a 00                	push   $0x0
  pushl $252
  102b07:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b0c:	e9 24 00 00 00       	jmp    102b35 <__alltraps>

00102b11 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b11:	6a 00                	push   $0x0
  pushl $253
  102b13:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b18:	e9 18 00 00 00       	jmp    102b35 <__alltraps>

00102b1d <vector254>:
.globl vector254
vector254:
  pushl $0
  102b1d:	6a 00                	push   $0x0
  pushl $254
  102b1f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b24:	e9 0c 00 00 00       	jmp    102b35 <__alltraps>

00102b29 <vector255>:
.globl vector255
vector255:
  pushl $0
  102b29:	6a 00                	push   $0x0
  pushl $255
  102b2b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b30:	e9 00 00 00 00       	jmp    102b35 <__alltraps>

00102b35 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102b35:	1e                   	push   %ds
    pushl %es
  102b36:	06                   	push   %es
    pushl %fs
  102b37:	0f a0                	push   %fs
    pushl %gs
  102b39:	0f a8                	push   %gs
    pushal
  102b3b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102b3c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102b41:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102b43:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102b45:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102b46:	e8 60 f5 ff ff       	call   1020ab <trap>

    # pop the pushed stack pointer
    popl %esp
  102b4b:	5c                   	pop    %esp

00102b4c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102b4c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102b4d:	0f a9                	pop    %gs
    popl %fs
  102b4f:	0f a1                	pop    %fs
    popl %es
  102b51:	07                   	pop    %es
    popl %ds
  102b52:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102b53:	83 c4 08             	add    $0x8,%esp
    iret
  102b56:	cf                   	iret   

00102b57 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102b57:	55                   	push   %ebp
  102b58:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102b5a:	a1 18 40 12 00       	mov    0x124018,%eax
  102b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  102b62:	29 c2                	sub    %eax,%edx
  102b64:	89 d0                	mov    %edx,%eax
  102b66:	c1 f8 02             	sar    $0x2,%eax
  102b69:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102b6f:	5d                   	pop    %ebp
  102b70:	c3                   	ret    

00102b71 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102b71:	55                   	push   %ebp
  102b72:	89 e5                	mov    %esp,%ebp
  102b74:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	89 04 24             	mov    %eax,(%esp)
  102b7d:	e8 d5 ff ff ff       	call   102b57 <page2ppn>
  102b82:	c1 e0 0c             	shl    $0xc,%eax
}
  102b85:	c9                   	leave  
  102b86:	c3                   	ret    

00102b87 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102b87:	55                   	push   %ebp
  102b88:	89 e5                	mov    %esp,%ebp
  102b8a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b90:	c1 e8 0c             	shr    $0xc,%eax
  102b93:	89 c2                	mov    %eax,%edx
  102b95:	a1 80 3e 12 00       	mov    0x123e80,%eax
  102b9a:	39 c2                	cmp    %eax,%edx
  102b9c:	72 1c                	jb     102bba <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102b9e:	c7 44 24 08 30 8c 10 	movl   $0x108c30,0x8(%esp)
  102ba5:	00 
  102ba6:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  102bad:	00 
  102bae:	c7 04 24 4f 8c 10 00 	movl   $0x108c4f,(%esp)
  102bb5:	e8 7b d8 ff ff       	call   100435 <__panic>
    }
    return &pages[PPN(pa)];
  102bba:	8b 0d 18 40 12 00    	mov    0x124018,%ecx
  102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc3:	c1 e8 0c             	shr    $0xc,%eax
  102bc6:	89 c2                	mov    %eax,%edx
  102bc8:	89 d0                	mov    %edx,%eax
  102bca:	c1 e0 02             	shl    $0x2,%eax
  102bcd:	01 d0                	add    %edx,%eax
  102bcf:	c1 e0 02             	shl    $0x2,%eax
  102bd2:	01 c8                	add    %ecx,%eax
}
  102bd4:	c9                   	leave  
  102bd5:	c3                   	ret    

00102bd6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102bd6:	55                   	push   %ebp
  102bd7:	89 e5                	mov    %esp,%ebp
  102bd9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdf:	89 04 24             	mov    %eax,(%esp)
  102be2:	e8 8a ff ff ff       	call   102b71 <page2pa>
  102be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bed:	c1 e8 0c             	shr    $0xc,%eax
  102bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bf3:	a1 80 3e 12 00       	mov    0x123e80,%eax
  102bf8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102bfb:	72 23                	jb     102c20 <page2kva+0x4a>
  102bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c04:	c7 44 24 08 60 8c 10 	movl   $0x108c60,0x8(%esp)
  102c0b:	00 
  102c0c:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  102c13:	00 
  102c14:	c7 04 24 4f 8c 10 00 	movl   $0x108c4f,(%esp)
  102c1b:	e8 15 d8 ff ff       	call   100435 <__panic>
  102c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c23:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102c28:	c9                   	leave  
  102c29:	c3                   	ret    

00102c2a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102c2a:	55                   	push   %ebp
  102c2b:	89 e5                	mov    %esp,%ebp
  102c2d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102c30:	8b 45 08             	mov    0x8(%ebp),%eax
  102c33:	83 e0 01             	and    $0x1,%eax
  102c36:	85 c0                	test   %eax,%eax
  102c38:	75 1c                	jne    102c56 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102c3a:	c7 44 24 08 84 8c 10 	movl   $0x108c84,0x8(%esp)
  102c41:	00 
  102c42:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102c49:	00 
  102c4a:	c7 04 24 4f 8c 10 00 	movl   $0x108c4f,(%esp)
  102c51:	e8 df d7 ff ff       	call   100435 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102c56:	8b 45 08             	mov    0x8(%ebp),%eax
  102c59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102c5e:	89 04 24             	mov    %eax,(%esp)
  102c61:	e8 21 ff ff ff       	call   102b87 <pa2page>
}
  102c66:	c9                   	leave  
  102c67:	c3                   	ret    

00102c68 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102c68:	55                   	push   %ebp
  102c69:	89 e5                	mov    %esp,%ebp
  102c6b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102c76:	89 04 24             	mov    %eax,(%esp)
  102c79:	e8 09 ff ff ff       	call   102b87 <pa2page>
}
  102c7e:	c9                   	leave  
  102c7f:	c3                   	ret    

00102c80 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102c80:	55                   	push   %ebp
  102c81:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102c83:	8b 45 08             	mov    0x8(%ebp),%eax
  102c86:	8b 00                	mov    (%eax),%eax
}
  102c88:	5d                   	pop    %ebp
  102c89:	c3                   	ret    

00102c8a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102c8a:	55                   	push   %ebp
  102c8b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c93:	89 10                	mov    %edx,(%eax)
}
  102c95:	90                   	nop
  102c96:	5d                   	pop    %ebp
  102c97:	c3                   	ret    

00102c98 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102c98:	55                   	push   %ebp
  102c99:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9e:	8b 00                	mov    (%eax),%eax
  102ca0:	8d 50 01             	lea    0x1(%eax),%edx
  102ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cab:	8b 00                	mov    (%eax),%eax
}
  102cad:	5d                   	pop    %ebp
  102cae:	c3                   	ret    

00102caf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102caf:	55                   	push   %ebp
  102cb0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb5:	8b 00                	mov    (%eax),%eax
  102cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102cba:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbd:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc2:	8b 00                	mov    (%eax),%eax
}
  102cc4:	5d                   	pop    %ebp
  102cc5:	c3                   	ret    

00102cc6 <__intr_save>:
__intr_save(void) {
  102cc6:	55                   	push   %ebp
  102cc7:	89 e5                	mov    %esp,%ebp
  102cc9:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102ccc:	9c                   	pushf  
  102ccd:	58                   	pop    %eax
  102cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102cd4:	25 00 02 00 00       	and    $0x200,%eax
  102cd9:	85 c0                	test   %eax,%eax
  102cdb:	74 0c                	je     102ce9 <__intr_save+0x23>
        intr_disable();
  102cdd:	e8 9a ec ff ff       	call   10197c <intr_disable>
        return 1;
  102ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  102ce7:	eb 05                	jmp    102cee <__intr_save+0x28>
    return 0;
  102ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102cee:	c9                   	leave  
  102cef:	c3                   	ret    

00102cf0 <__intr_restore>:
__intr_restore(bool flag) {
  102cf0:	55                   	push   %ebp
  102cf1:	89 e5                	mov    %esp,%ebp
  102cf3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102cf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102cfa:	74 05                	je     102d01 <__intr_restore+0x11>
        intr_enable();
  102cfc:	e8 6f ec ff ff       	call   101970 <intr_enable>
}
  102d01:	90                   	nop
  102d02:	c9                   	leave  
  102d03:	c3                   	ret    

00102d04 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d04:	55                   	push   %ebp
  102d05:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d07:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d0d:	b8 23 00 00 00       	mov    $0x23,%eax
  102d12:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d14:	b8 23 00 00 00       	mov    $0x23,%eax
  102d19:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d1b:	b8 10 00 00 00       	mov    $0x10,%eax
  102d20:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102d22:	b8 10 00 00 00       	mov    $0x10,%eax
  102d27:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102d29:	b8 10 00 00 00       	mov    $0x10,%eax
  102d2e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102d30:	ea 37 2d 10 00 08 00 	ljmp   $0x8,$0x102d37
}
  102d37:	90                   	nop
  102d38:	5d                   	pop    %ebp
  102d39:	c3                   	ret    

00102d3a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102d3a:	f3 0f 1e fb          	endbr32 
  102d3e:	55                   	push   %ebp
  102d3f:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102d41:	8b 45 08             	mov    0x8(%ebp),%eax
  102d44:	a3 a4 3e 12 00       	mov    %eax,0x123ea4
}
  102d49:	90                   	nop
  102d4a:	5d                   	pop    %ebp
  102d4b:	c3                   	ret    

00102d4c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102d4c:	f3 0f 1e fb          	endbr32 
  102d50:	55                   	push   %ebp
  102d51:	89 e5                	mov    %esp,%ebp
  102d53:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102d56:	b8 00 00 12 00       	mov    $0x120000,%eax
  102d5b:	89 04 24             	mov    %eax,(%esp)
  102d5e:	e8 d7 ff ff ff       	call   102d3a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102d63:	66 c7 05 a8 3e 12 00 	movw   $0x10,0x123ea8
  102d6a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102d6c:	66 c7 05 28 0a 12 00 	movw   $0x68,0x120a28
  102d73:	68 00 
  102d75:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102d7a:	0f b7 c0             	movzwl %ax,%eax
  102d7d:	66 a3 2a 0a 12 00    	mov    %ax,0x120a2a
  102d83:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102d88:	c1 e8 10             	shr    $0x10,%eax
  102d8b:	a2 2c 0a 12 00       	mov    %al,0x120a2c
  102d90:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102d97:	24 f0                	and    $0xf0,%al
  102d99:	0c 09                	or     $0x9,%al
  102d9b:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102da0:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102da7:	24 ef                	and    $0xef,%al
  102da9:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102dae:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102db5:	24 9f                	and    $0x9f,%al
  102db7:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102dbc:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102dc3:	0c 80                	or     $0x80,%al
  102dc5:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102dca:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102dd1:	24 f0                	and    $0xf0,%al
  102dd3:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102dd8:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102ddf:	24 ef                	and    $0xef,%al
  102de1:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102de6:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102ded:	24 df                	and    $0xdf,%al
  102def:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102df4:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102dfb:	0c 40                	or     $0x40,%al
  102dfd:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e02:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e09:	24 7f                	and    $0x7f,%al
  102e0b:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e10:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102e15:	c1 e8 18             	shr    $0x18,%eax
  102e18:	a2 2f 0a 12 00       	mov    %al,0x120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102e1d:	c7 04 24 30 0a 12 00 	movl   $0x120a30,(%esp)
  102e24:	e8 db fe ff ff       	call   102d04 <lgdt>
  102e29:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102e2f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102e33:	0f 00 d8             	ltr    %ax
}
  102e36:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102e37:	90                   	nop
  102e38:	c9                   	leave  
  102e39:	c3                   	ret    

00102e3a <init_pmm_manager>:
/*-------------------------------------------------------------------------------------------*/
//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102e3a:	f3 0f 1e fb          	endbr32 
  102e3e:	55                   	push   %ebp
  102e3f:	89 e5                	mov    %esp,%ebp
  102e41:	83 ec 18             	sub    $0x18,%esp
    // pmm_manager = &default_pmm_manager;
    pmm_manager = &buddy_pmm_manager;
  102e44:	c7 05 10 40 12 00 a4 	movl   $0x109ba4,0x124010
  102e4b:	9b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102e4e:	a1 10 40 12 00       	mov    0x124010,%eax
  102e53:	8b 00                	mov    (%eax),%eax
  102e55:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e59:	c7 04 24 b0 8c 10 00 	movl   $0x108cb0,(%esp)
  102e60:	e8 64 d4 ff ff       	call   1002c9 <cprintf>
    pmm_manager->init();
  102e65:	a1 10 40 12 00       	mov    0x124010,%eax
  102e6a:	8b 40 04             	mov    0x4(%eax),%eax
  102e6d:	ff d0                	call   *%eax
}
  102e6f:	90                   	nop
  102e70:	c9                   	leave  
  102e71:	c3                   	ret    

00102e72 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102e72:	f3 0f 1e fb          	endbr32 
  102e76:	55                   	push   %ebp
  102e77:	89 e5                	mov    %esp,%ebp
  102e79:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102e7c:	a1 10 40 12 00       	mov    0x124010,%eax
  102e81:	8b 40 08             	mov    0x8(%eax),%eax
  102e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e87:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  102e8e:	89 14 24             	mov    %edx,(%esp)
  102e91:	ff d0                	call   *%eax
}
  102e93:	90                   	nop
  102e94:	c9                   	leave  
  102e95:	c3                   	ret    

00102e96 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102e96:	f3 0f 1e fb          	endbr32 
  102e9a:	55                   	push   %ebp
  102e9b:	89 e5                	mov    %esp,%ebp
  102e9d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102ea7:	e8 1a fe ff ff       	call   102cc6 <__intr_save>
  102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102eaf:	a1 10 40 12 00       	mov    0x124010,%eax
  102eb4:	8b 40 0c             	mov    0xc(%eax),%eax
  102eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  102eba:	89 14 24             	mov    %edx,(%esp)
  102ebd:	ff d0                	call   *%eax
  102ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec5:	89 04 24             	mov    %eax,(%esp)
  102ec8:	e8 23 fe ff ff       	call   102cf0 <__intr_restore>
    return page;
  102ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ed0:	c9                   	leave  
  102ed1:	c3                   	ret    

00102ed2 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102ed2:	f3 0f 1e fb          	endbr32 
  102ed6:	55                   	push   %ebp
  102ed7:	89 e5                	mov    %esp,%ebp
  102ed9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102edc:	e8 e5 fd ff ff       	call   102cc6 <__intr_save>
  102ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102ee4:	a1 10 40 12 00       	mov    0x124010,%eax
  102ee9:	8b 40 10             	mov    0x10(%eax),%eax
  102eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  102eef:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  102ef6:	89 14 24             	mov    %edx,(%esp)
  102ef9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efe:	89 04 24             	mov    %eax,(%esp)
  102f01:	e8 ea fd ff ff       	call   102cf0 <__intr_restore>
}
  102f06:	90                   	nop
  102f07:	c9                   	leave  
  102f08:	c3                   	ret    

00102f09 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102f09:	f3 0f 1e fb          	endbr32 
  102f0d:	55                   	push   %ebp
  102f0e:	89 e5                	mov    %esp,%ebp
  102f10:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102f13:	e8 ae fd ff ff       	call   102cc6 <__intr_save>
  102f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102f1b:	a1 10 40 12 00       	mov    0x124010,%eax
  102f20:	8b 40 14             	mov    0x14(%eax),%eax
  102f23:	ff d0                	call   *%eax
  102f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2b:	89 04 24             	mov    %eax,(%esp)
  102f2e:	e8 bd fd ff ff       	call   102cf0 <__intr_restore>
    return ret;
  102f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102f36:	c9                   	leave  
  102f37:	c3                   	ret    

00102f38 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102f38:	f3 0f 1e fb          	endbr32 
  102f3c:	55                   	push   %ebp
  102f3d:	89 e5                	mov    %esp,%ebp
  102f3f:	57                   	push   %edi
  102f40:	56                   	push   %esi
  102f41:	53                   	push   %ebx
  102f42:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102f48:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102f4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102f56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102f5d:	c7 04 24 c7 8c 10 00 	movl   $0x108cc7,(%esp)
  102f64:	e8 60 d3 ff ff       	call   1002c9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102f69:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f70:	e9 1a 01 00 00       	jmp    10308f <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f75:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f78:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f7b:	89 d0                	mov    %edx,%eax
  102f7d:	c1 e0 02             	shl    $0x2,%eax
  102f80:	01 d0                	add    %edx,%eax
  102f82:	c1 e0 02             	shl    $0x2,%eax
  102f85:	01 c8                	add    %ecx,%eax
  102f87:	8b 50 08             	mov    0x8(%eax),%edx
  102f8a:	8b 40 04             	mov    0x4(%eax),%eax
  102f8d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102f90:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102f93:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f99:	89 d0                	mov    %edx,%eax
  102f9b:	c1 e0 02             	shl    $0x2,%eax
  102f9e:	01 d0                	add    %edx,%eax
  102fa0:	c1 e0 02             	shl    $0x2,%eax
  102fa3:	01 c8                	add    %ecx,%eax
  102fa5:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fa8:	8b 58 10             	mov    0x10(%eax),%ebx
  102fab:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fae:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102fb1:	01 c8                	add    %ecx,%eax
  102fb3:	11 da                	adc    %ebx,%edx
  102fb5:	89 45 98             	mov    %eax,-0x68(%ebp)
  102fb8:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102fbb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fc1:	89 d0                	mov    %edx,%eax
  102fc3:	c1 e0 02             	shl    $0x2,%eax
  102fc6:	01 d0                	add    %edx,%eax
  102fc8:	c1 e0 02             	shl    $0x2,%eax
  102fcb:	01 c8                	add    %ecx,%eax
  102fcd:	83 c0 14             	add    $0x14,%eax
  102fd0:	8b 00                	mov    (%eax),%eax
  102fd2:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102fd5:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fd8:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102fdb:	83 c0 ff             	add    $0xffffffff,%eax
  102fde:	83 d2 ff             	adc    $0xffffffff,%edx
  102fe1:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102fe7:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ff3:	89 d0                	mov    %edx,%eax
  102ff5:	c1 e0 02             	shl    $0x2,%eax
  102ff8:	01 d0                	add    %edx,%eax
  102ffa:	c1 e0 02             	shl    $0x2,%eax
  102ffd:	01 c8                	add    %ecx,%eax
  102fff:	8b 48 0c             	mov    0xc(%eax),%ecx
  103002:	8b 58 10             	mov    0x10(%eax),%ebx
  103005:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103008:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  10300c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103012:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103018:	89 44 24 14          	mov    %eax,0x14(%esp)
  10301c:	89 54 24 18          	mov    %edx,0x18(%esp)
  103020:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103023:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103026:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10302a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10302e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103032:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103036:	c7 04 24 d4 8c 10 00 	movl   $0x108cd4,(%esp)
  10303d:	e8 87 d2 ff ff       	call   1002c9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103042:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103045:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103048:	89 d0                	mov    %edx,%eax
  10304a:	c1 e0 02             	shl    $0x2,%eax
  10304d:	01 d0                	add    %edx,%eax
  10304f:	c1 e0 02             	shl    $0x2,%eax
  103052:	01 c8                	add    %ecx,%eax
  103054:	83 c0 14             	add    $0x14,%eax
  103057:	8b 00                	mov    (%eax),%eax
  103059:	83 f8 01             	cmp    $0x1,%eax
  10305c:	75 2e                	jne    10308c <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  10305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103064:	3b 45 98             	cmp    -0x68(%ebp),%eax
  103067:	89 d0                	mov    %edx,%eax
  103069:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  10306c:	73 1e                	jae    10308c <page_init+0x154>
  10306e:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  103073:	b8 00 00 00 00       	mov    $0x0,%eax
  103078:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  10307b:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  10307e:	72 0c                	jb     10308c <page_init+0x154>
                maxpa = end;
  103080:	8b 45 98             	mov    -0x68(%ebp),%eax
  103083:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103086:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103089:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  10308c:	ff 45 dc             	incl   -0x24(%ebp)
  10308f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103092:	8b 00                	mov    (%eax),%eax
  103094:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103097:	0f 8c d8 fe ff ff    	jl     102f75 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10309d:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1030a7:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  1030aa:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  1030ad:	73 0e                	jae    1030bd <page_init+0x185>
        maxpa = KMEMSIZE;
  1030af:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  1030b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1030bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030c3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030c7:	c1 ea 0c             	shr    $0xc,%edx
  1030ca:	a3 80 3e 12 00       	mov    %eax,0x123e80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1030cf:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  1030d6:	b8 60 aa 2a 00       	mov    $0x2aaa60,%eax
  1030db:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1030e1:	01 d0                	add    %edx,%eax
  1030e3:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1030e6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1030e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ee:	f7 75 c0             	divl   -0x40(%ebp)
  1030f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1030f4:	29 d0                	sub    %edx,%eax
  1030f6:	a3 18 40 12 00       	mov    %eax,0x124018

    for (i = 0; i < npage; i ++) {
  1030fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103102:	eb 2f                	jmp    103133 <page_init+0x1fb>
        SetPageReserved(pages + i);
  103104:	8b 0d 18 40 12 00    	mov    0x124018,%ecx
  10310a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10310d:	89 d0                	mov    %edx,%eax
  10310f:	c1 e0 02             	shl    $0x2,%eax
  103112:	01 d0                	add    %edx,%eax
  103114:	c1 e0 02             	shl    $0x2,%eax
  103117:	01 c8                	add    %ecx,%eax
  103119:	83 c0 04             	add    $0x4,%eax
  10311c:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103123:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103126:	8b 45 90             	mov    -0x70(%ebp),%eax
  103129:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10312c:	0f ab 10             	bts    %edx,(%eax)
}
  10312f:	90                   	nop
    for (i = 0; i < npage; i ++) {
  103130:	ff 45 dc             	incl   -0x24(%ebp)
  103133:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103136:	a1 80 3e 12 00       	mov    0x123e80,%eax
  10313b:	39 c2                	cmp    %eax,%edx
  10313d:	72 c5                	jb     103104 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10313f:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  103145:	89 d0                	mov    %edx,%eax
  103147:	c1 e0 02             	shl    $0x2,%eax
  10314a:	01 d0                	add    %edx,%eax
  10314c:	c1 e0 02             	shl    $0x2,%eax
  10314f:	89 c2                	mov    %eax,%edx
  103151:	a1 18 40 12 00       	mov    0x124018,%eax
  103156:	01 d0                	add    %edx,%eax
  103158:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10315b:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103162:	77 23                	ja     103187 <page_init+0x24f>
  103164:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103167:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10316b:	c7 44 24 08 04 8d 10 	movl   $0x108d04,0x8(%esp)
  103172:	00 
  103173:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  10317a:	00 
  10317b:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103182:	e8 ae d2 ff ff       	call   100435 <__panic>
  103187:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10318a:	05 00 00 00 40       	add    $0x40000000,%eax
  10318f:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103192:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103199:	e9 4b 01 00 00       	jmp    1032e9 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10319e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031a4:	89 d0                	mov    %edx,%eax
  1031a6:	c1 e0 02             	shl    $0x2,%eax
  1031a9:	01 d0                	add    %edx,%eax
  1031ab:	c1 e0 02             	shl    $0x2,%eax
  1031ae:	01 c8                	add    %ecx,%eax
  1031b0:	8b 50 08             	mov    0x8(%eax),%edx
  1031b3:	8b 40 04             	mov    0x4(%eax),%eax
  1031b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031bc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031c2:	89 d0                	mov    %edx,%eax
  1031c4:	c1 e0 02             	shl    $0x2,%eax
  1031c7:	01 d0                	add    %edx,%eax
  1031c9:	c1 e0 02             	shl    $0x2,%eax
  1031cc:	01 c8                	add    %ecx,%eax
  1031ce:	8b 48 0c             	mov    0xc(%eax),%ecx
  1031d1:	8b 58 10             	mov    0x10(%eax),%ebx
  1031d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031da:	01 c8                	add    %ecx,%eax
  1031dc:	11 da                	adc    %ebx,%edx
  1031de:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1031e1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1031e4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031ea:	89 d0                	mov    %edx,%eax
  1031ec:	c1 e0 02             	shl    $0x2,%eax
  1031ef:	01 d0                	add    %edx,%eax
  1031f1:	c1 e0 02             	shl    $0x2,%eax
  1031f4:	01 c8                	add    %ecx,%eax
  1031f6:	83 c0 14             	add    $0x14,%eax
  1031f9:	8b 00                	mov    (%eax),%eax
  1031fb:	83 f8 01             	cmp    $0x1,%eax
  1031fe:	0f 85 e2 00 00 00    	jne    1032e6 <page_init+0x3ae>
            if (begin < freemem) {
  103204:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103207:	ba 00 00 00 00       	mov    $0x0,%edx
  10320c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10320f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103212:	19 d1                	sbb    %edx,%ecx
  103214:	73 0d                	jae    103223 <page_init+0x2eb>
                begin = freemem;
  103216:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103219:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10321c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103223:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103228:	b8 00 00 00 00       	mov    $0x0,%eax
  10322d:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103230:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103233:	73 0e                	jae    103243 <page_init+0x30b>
                end = KMEMSIZE;
  103235:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10323c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103243:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103246:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103249:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10324c:	89 d0                	mov    %edx,%eax
  10324e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103251:	0f 83 8f 00 00 00    	jae    1032e6 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  103257:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10325e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103261:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103264:	01 d0                	add    %edx,%eax
  103266:	48                   	dec    %eax
  103267:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10326a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10326d:	ba 00 00 00 00       	mov    $0x0,%edx
  103272:	f7 75 b0             	divl   -0x50(%ebp)
  103275:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103278:	29 d0                	sub    %edx,%eax
  10327a:	ba 00 00 00 00       	mov    $0x0,%edx
  10327f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103282:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103285:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103288:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10328b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10328e:	ba 00 00 00 00       	mov    $0x0,%edx
  103293:	89 c3                	mov    %eax,%ebx
  103295:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10329b:	89 de                	mov    %ebx,%esi
  10329d:	89 d0                	mov    %edx,%eax
  10329f:	83 e0 00             	and    $0x0,%eax
  1032a2:	89 c7                	mov    %eax,%edi
  1032a4:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1032a7:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1032aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032b0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1032b3:	89 d0                	mov    %edx,%eax
  1032b5:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1032b8:	73 2c                	jae    1032e6 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1032ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1032bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1032c0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1032c3:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1032c6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1032ca:	c1 ea 0c             	shr    $0xc,%edx
  1032cd:	89 c3                	mov    %eax,%ebx
  1032cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032d2:	89 04 24             	mov    %eax,(%esp)
  1032d5:	e8 ad f8 ff ff       	call   102b87 <pa2page>
  1032da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1032de:	89 04 24             	mov    %eax,(%esp)
  1032e1:	e8 8c fb ff ff       	call   102e72 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1032e6:	ff 45 dc             	incl   -0x24(%ebp)
  1032e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1032ec:	8b 00                	mov    (%eax),%eax
  1032ee:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1032f1:	0f 8c a7 fe ff ff    	jl     10319e <page_init+0x266>
                }
            }
        }
    }
}
  1032f7:	90                   	nop
  1032f8:	90                   	nop
  1032f9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1032ff:	5b                   	pop    %ebx
  103300:	5e                   	pop    %esi
  103301:	5f                   	pop    %edi
  103302:	5d                   	pop    %ebp
  103303:	c3                   	ret    

00103304 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103304:	f3 0f 1e fb          	endbr32 
  103308:	55                   	push   %ebp
  103309:	89 e5                	mov    %esp,%ebp
  10330b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10330e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103311:	33 45 14             	xor    0x14(%ebp),%eax
  103314:	25 ff 0f 00 00       	and    $0xfff,%eax
  103319:	85 c0                	test   %eax,%eax
  10331b:	74 24                	je     103341 <boot_map_segment+0x3d>
  10331d:	c7 44 24 0c 36 8d 10 	movl   $0x108d36,0xc(%esp)
  103324:	00 
  103325:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  10332c:	00 
  10332d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103334:	00 
  103335:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  10333c:	e8 f4 d0 ff ff       	call   100435 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103341:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103348:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334b:	25 ff 0f 00 00       	and    $0xfff,%eax
  103350:	89 c2                	mov    %eax,%edx
  103352:	8b 45 10             	mov    0x10(%ebp),%eax
  103355:	01 c2                	add    %eax,%edx
  103357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335a:	01 d0                	add    %edx,%eax
  10335c:	48                   	dec    %eax
  10335d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103363:	ba 00 00 00 00       	mov    $0x0,%edx
  103368:	f7 75 f0             	divl   -0x10(%ebp)
  10336b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10336e:	29 d0                	sub    %edx,%eax
  103370:	c1 e8 0c             	shr    $0xc,%eax
  103373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103376:	8b 45 0c             	mov    0xc(%ebp),%eax
  103379:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103384:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103387:	8b 45 14             	mov    0x14(%ebp),%eax
  10338a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10338d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103390:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103395:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103398:	eb 68                	jmp    103402 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10339a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1033a1:	00 
  1033a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ac:	89 04 24             	mov    %eax,(%esp)
  1033af:	e8 8a 01 00 00       	call   10353e <get_pte>
  1033b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1033b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1033bb:	75 24                	jne    1033e1 <boot_map_segment+0xdd>
  1033bd:	c7 44 24 0c 62 8d 10 	movl   $0x108d62,0xc(%esp)
  1033c4:	00 
  1033c5:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1033cc:	00 
  1033cd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1033d4:	00 
  1033d5:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1033dc:	e8 54 d0 ff ff       	call   100435 <__panic>
        *ptep = pa | PTE_P | perm;
  1033e1:	8b 45 14             	mov    0x14(%ebp),%eax
  1033e4:	0b 45 18             	or     0x18(%ebp),%eax
  1033e7:	83 c8 01             	or     $0x1,%eax
  1033ea:	89 c2                	mov    %eax,%edx
  1033ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ef:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1033f1:	ff 4d f4             	decl   -0xc(%ebp)
  1033f4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1033fb:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103406:	75 92                	jne    10339a <boot_map_segment+0x96>
    }
}
  103408:	90                   	nop
  103409:	90                   	nop
  10340a:	c9                   	leave  
  10340b:	c3                   	ret    

0010340c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10340c:	f3 0f 1e fb          	endbr32 
  103410:	55                   	push   %ebp
  103411:	89 e5                	mov    %esp,%ebp
  103413:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103416:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10341d:	e8 74 fa ff ff       	call   102e96 <alloc_pages>
  103422:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103429:	75 1c                	jne    103447 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  10342b:	c7 44 24 08 6f 8d 10 	movl   $0x108d6f,0x8(%esp)
  103432:	00 
  103433:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10343a:	00 
  10343b:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103442:	e8 ee cf ff ff       	call   100435 <__panic>
    }
    return page2kva(p);
  103447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10344a:	89 04 24             	mov    %eax,(%esp)
  10344d:	e8 84 f7 ff ff       	call   102bd6 <page2kva>
}
  103452:	c9                   	leave  
  103453:	c3                   	ret    

00103454 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103454:	f3 0f 1e fb          	endbr32 
  103458:	55                   	push   %ebp
  103459:	89 e5                	mov    %esp,%ebp
  10345b:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10345e:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103463:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103466:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10346d:	77 23                	ja     103492 <pmm_init+0x3e>
  10346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103472:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103476:	c7 44 24 08 04 8d 10 	movl   $0x108d04,0x8(%esp)
  10347d:	00 
  10347e:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103485:	00 
  103486:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  10348d:	e8 a3 cf ff ff       	call   100435 <__panic>
  103492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103495:	05 00 00 00 40       	add    $0x40000000,%eax
  10349a:	a3 14 40 12 00       	mov    %eax,0x124014
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10349f:	e8 96 f9 ff ff       	call   102e3a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1034a4:	e8 8f fa ff ff       	call   102f38 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1034a9:	e8 f3 03 00 00       	call   1038a1 <check_alloc_page>

    check_pgdir();
  1034ae:	e8 11 04 00 00       	call   1038c4 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1034b3:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1034b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034bb:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1034c2:	77 23                	ja     1034e7 <pmm_init+0x93>
  1034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034cb:	c7 44 24 08 04 8d 10 	movl   $0x108d04,0x8(%esp)
  1034d2:	00 
  1034d3:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  1034da:	00 
  1034db:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1034e2:	e8 4e cf ff ff       	call   100435 <__panic>
  1034e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ea:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1034f0:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1034f5:	05 ac 0f 00 00       	add    $0xfac,%eax
  1034fa:	83 ca 03             	or     $0x3,%edx
  1034fd:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1034ff:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103504:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10350b:	00 
  10350c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103513:	00 
  103514:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10351b:	38 
  10351c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103523:	c0 
  103524:	89 04 24             	mov    %eax,(%esp)
  103527:	e8 d8 fd ff ff       	call   103304 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10352c:	e8 1b f8 ff ff       	call   102d4c <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103531:	e8 2e 0a 00 00       	call   103f64 <check_boot_pgdir>

    print_pgdir();
  103536:	e8 b3 0e 00 00       	call   1043ee <print_pgdir>

}
  10353b:	90                   	nop
  10353c:	c9                   	leave  
  10353d:	c3                   	ret    

0010353e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10353e:	f3 0f 1e fb          	endbr32 
  103542:	55                   	push   %ebp
  103543:	89 e5                	mov    %esp,%ebp
  103545:	83 ec 38             	sub    $0x38,%esp
        }
        return NULL;          // (8) return page table entry
    #endif

    //代码实现部分8steps
    pde_t *pdep = &pgdir[PDX(la)];                      //取出1级表项,两个过程: 1. 线性虚拟地址la >> 页目录索引 PDX(la) ((((uintptr_t)(la)) >> PDXSHIFT) & 0x3FF)
  103548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10354b:	c1 e8 16             	shr    $0x16,%eax
  10354e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103555:	8b 45 08             	mov    0x8(%ebp),%eax
  103558:	01 d0                	add    %edx,%eax
  10355a:	89 45 f4             	mov    %eax,-0xc(%ebp)
                                                        //2.用页目录索引PDX查找页目录pgdir
    if (!(*pdep & PTE_P)) {                             //检查项是否不存在 PTE_P 页目录或页表的 Present 位
  10355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103560:	8b 00                	mov    (%eax),%eax
  103562:	83 e0 01             	and    $0x1,%eax
  103565:	85 c0                	test   %eax,%eax
  103567:	0f 85 af 00 00 00    	jne    10361c <get_pte+0xde>
        struct Page *page;                              //不存在则构建
        if (!create || (page = alloc_page()) == NULL) { //构建失败
  10356d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103571:	74 15                	je     103588 <get_pte+0x4a>
  103573:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10357a:	e8 17 f9 ff ff       	call   102e96 <alloc_pages>
  10357f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103586:	75 0a                	jne    103592 <get_pte+0x54>
            return NULL;
  103588:	b8 00 00 00 00       	mov    $0x0,%eax
  10358d:	e9 e7 00 00 00       	jmp    103679 <get_pte+0x13b>
        }
        set_page_ref(page, 1);                          //设置引用计数, 被映射了多少次                             
  103592:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103599:	00 
  10359a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359d:	89 04 24             	mov    %eax,(%esp)
  1035a0:	e8 e5 f6 ff ff       	call   102c8a <set_page_ref>
        uintptr_t pa = page2pa(page);                   //取物理地址, page2ppn(page) << PGSHIFT;
  1035a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035a8:	89 04 24             	mov    %eax,(%esp)
  1035ab:	e8 c1 f5 ff ff       	call   102b71 <page2pa>
  1035b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                   //clear清零页面
  1035b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035bc:	c1 e8 0c             	shr    $0xc,%eax
  1035bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1035c2:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1035c7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1035ca:	72 23                	jb     1035ef <get_pte+0xb1>
  1035cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1035d3:	c7 44 24 08 60 8c 10 	movl   $0x108c60,0x8(%esp)
  1035da:	00 
  1035db:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
  1035e2:	00 
  1035e3:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1035ea:	e8 46 ce ff ff       	call   100435 <__panic>
  1035ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035f2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1035f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1035fe:	00 
  1035ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103606:	00 
  103607:	89 04 24             	mov    %eax,(%esp)
  10360a:	e8 99 46 00 00       	call   107ca8 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;             //设置页面目录条目的权限,
  10360f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103612:	83 c8 07             	or     $0x7,%eax
  103615:	89 c2                	mov    %eax,%edx
  103617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10361a:	89 10                	mov    %edx,(%eax)
                                                        // PTE_U: 位3，表示用户态的软件可以读取对应地址的物理内存页内容
                                                        // PTE_W: 位2，表示物理内存页内容可写
                                                        // PTE_P: 位1，表示物理内存页存在
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; //返回虚拟地址, KADDR: pa >> va, PTX: la >> 页目录索引
  10361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10361f:	8b 00                	mov    (%eax),%eax
  103621:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103626:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10362c:	c1 e8 0c             	shr    $0xc,%eax
  10362f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103632:	a1 80 3e 12 00       	mov    0x123e80,%eax
  103637:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10363a:	72 23                	jb     10365f <get_pte+0x121>
  10363c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10363f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103643:	c7 44 24 08 60 8c 10 	movl   $0x108c60,0x8(%esp)
  10364a:	00 
  10364b:	c7 44 24 04 7d 01 00 	movl   $0x17d,0x4(%esp)
  103652:	00 
  103653:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  10365a:	e8 d6 cd ff ff       	call   100435 <__panic>
  10365f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103662:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103667:	89 c2                	mov    %eax,%edx
  103669:	8b 45 0c             	mov    0xc(%ebp),%eax
  10366c:	c1 e8 0c             	shr    $0xc,%eax
  10366f:	25 ff 03 00 00       	and    $0x3ff,%eax
  103674:	c1 e0 02             	shl    $0x2,%eax
  103677:	01 d0                	add    %edx,%eax
}
  103679:	c9                   	leave  
  10367a:	c3                   	ret    

0010367b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10367b:	f3 0f 1e fb          	endbr32 
  10367f:	55                   	push   %ebp
  103680:	89 e5                	mov    %esp,%ebp
  103682:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103685:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10368c:	00 
  10368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103690:	89 44 24 04          	mov    %eax,0x4(%esp)
  103694:	8b 45 08             	mov    0x8(%ebp),%eax
  103697:	89 04 24             	mov    %eax,(%esp)
  10369a:	e8 9f fe ff ff       	call   10353e <get_pte>
  10369f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1036a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1036a6:	74 08                	je     1036b0 <get_page+0x35>
        *ptep_store = ptep;
  1036a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036ae:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1036b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036b4:	74 1b                	je     1036d1 <get_page+0x56>
  1036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036b9:	8b 00                	mov    (%eax),%eax
  1036bb:	83 e0 01             	and    $0x1,%eax
  1036be:	85 c0                	test   %eax,%eax
  1036c0:	74 0f                	je     1036d1 <get_page+0x56>
        return pte2page(*ptep);
  1036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c5:	8b 00                	mov    (%eax),%eax
  1036c7:	89 04 24             	mov    %eax,(%esp)
  1036ca:	e8 5b f5 ff ff       	call   102c2a <pte2page>
  1036cf:	eb 05                	jmp    1036d6 <get_page+0x5b>
    }
    return NULL;
  1036d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1036d6:	c9                   	leave  
  1036d7:	c3                   	ret    

001036d8 <page_remove_pte>:
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 

//释放某虚地址所在的页并取消对应二级页表项的映射
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1036d8:	55                   	push   %ebp
  1036d9:	89 e5                	mov    %esp,%ebp
  1036db:	83 ec 28             	sub    $0x28,%esp
                                    //(6) flush tlb
        }
    #endif

    //具体实现
    if (*ptep & PTE_P) {                        //检查当前页表项是否存在
  1036de:	8b 45 10             	mov    0x10(%ebp),%eax
  1036e1:	8b 00                	mov    (%eax),%eax
  1036e3:	83 e0 01             	and    $0x1,%eax
  1036e6:	85 c0                	test   %eax,%eax
  1036e8:	74 4d                	je     103737 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);    //找到pte对应的页面
  1036ea:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ed:	8b 00                	mov    (%eax),%eax
  1036ef:	89 04 24             	mov    %eax,(%esp)
  1036f2:	e8 33 f5 ff ff       	call   102c2a <pte2page>
  1036f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {          //如果当前页面只被引用了0次
  1036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036fd:	89 04 24             	mov    %eax,(%esp)
  103700:	e8 aa f5 ff ff       	call   102caf <page_ref_dec>
  103705:	85 c0                	test   %eax,%eax
  103707:	75 13                	jne    10371c <page_remove_pte+0x44>
            free_page(page);                    //那么直接释放该页     
  103709:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103710:	00 
  103711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103714:	89 04 24             	mov    %eax,(%esp)
  103717:	e8 b6 f7 ff ff       	call   102ed2 <free_pages>
        }
        *ptep = 0;                              
  10371c:	8b 45 10             	mov    0x10(%ebp),%eax
  10371f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);              //刷新TLB, 使TLB条目无效
  103725:	8b 45 0c             	mov    0xc(%ebp),%eax
  103728:	89 44 24 04          	mov    %eax,0x4(%esp)
  10372c:	8b 45 08             	mov    0x8(%ebp),%eax
  10372f:	89 04 24             	mov    %eax,(%esp)
  103732:	e8 09 01 00 00       	call   103840 <tlb_invalidate>
    }
}
  103737:	90                   	nop
  103738:	c9                   	leave  
  103739:	c3                   	ret    

0010373a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10373a:	f3 0f 1e fb          	endbr32 
  10373e:	55                   	push   %ebp
  10373f:	89 e5                	mov    %esp,%ebp
  103741:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103744:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10374b:	00 
  10374c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10374f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103753:	8b 45 08             	mov    0x8(%ebp),%eax
  103756:	89 04 24             	mov    %eax,(%esp)
  103759:	e8 e0 fd ff ff       	call   10353e <get_pte>
  10375e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103765:	74 19                	je     103780 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  103767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10376a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10376e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103771:	89 44 24 04          	mov    %eax,0x4(%esp)
  103775:	8b 45 08             	mov    0x8(%ebp),%eax
  103778:	89 04 24             	mov    %eax,(%esp)
  10377b:	e8 58 ff ff ff       	call   1036d8 <page_remove_pte>
    }
}
  103780:	90                   	nop
  103781:	c9                   	leave  
  103782:	c3                   	ret    

00103783 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103783:	f3 0f 1e fb          	endbr32 
  103787:	55                   	push   %ebp
  103788:	89 e5                	mov    %esp,%ebp
  10378a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10378d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103794:	00 
  103795:	8b 45 10             	mov    0x10(%ebp),%eax
  103798:	89 44 24 04          	mov    %eax,0x4(%esp)
  10379c:	8b 45 08             	mov    0x8(%ebp),%eax
  10379f:	89 04 24             	mov    %eax,(%esp)
  1037a2:	e8 97 fd ff ff       	call   10353e <get_pte>
  1037a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1037aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1037ae:	75 0a                	jne    1037ba <page_insert+0x37>
        return -E_NO_MEM;
  1037b0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1037b5:	e9 84 00 00 00       	jmp    10383e <page_insert+0xbb>
    }
    page_ref_inc(page);
  1037ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037bd:	89 04 24             	mov    %eax,(%esp)
  1037c0:	e8 d3 f4 ff ff       	call   102c98 <page_ref_inc>
    if (*ptep & PTE_P) {
  1037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037c8:	8b 00                	mov    (%eax),%eax
  1037ca:	83 e0 01             	and    $0x1,%eax
  1037cd:	85 c0                	test   %eax,%eax
  1037cf:	74 3e                	je     10380f <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  1037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037d4:	8b 00                	mov    (%eax),%eax
  1037d6:	89 04 24             	mov    %eax,(%esp)
  1037d9:	e8 4c f4 ff ff       	call   102c2a <pte2page>
  1037de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1037e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1037e7:	75 0d                	jne    1037f6 <page_insert+0x73>
            page_ref_dec(page);
  1037e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037ec:	89 04 24             	mov    %eax,(%esp)
  1037ef:	e8 bb f4 ff ff       	call   102caf <page_ref_dec>
  1037f4:	eb 19                	jmp    10380f <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037fd:	8b 45 10             	mov    0x10(%ebp),%eax
  103800:	89 44 24 04          	mov    %eax,0x4(%esp)
  103804:	8b 45 08             	mov    0x8(%ebp),%eax
  103807:	89 04 24             	mov    %eax,(%esp)
  10380a:	e8 c9 fe ff ff       	call   1036d8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10380f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103812:	89 04 24             	mov    %eax,(%esp)
  103815:	e8 57 f3 ff ff       	call   102b71 <page2pa>
  10381a:	0b 45 14             	or     0x14(%ebp),%eax
  10381d:	83 c8 01             	or     $0x1,%eax
  103820:	89 c2                	mov    %eax,%edx
  103822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103825:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103827:	8b 45 10             	mov    0x10(%ebp),%eax
  10382a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10382e:	8b 45 08             	mov    0x8(%ebp),%eax
  103831:	89 04 24             	mov    %eax,(%esp)
  103834:	e8 07 00 00 00       	call   103840 <tlb_invalidate>
    return 0;
  103839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10383e:	c9                   	leave  
  10383f:	c3                   	ret    

00103840 <tlb_invalidate>:
// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//使一个TLB条目无效，但仅当页表存在
//编辑的是处理器当前正在使用的
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103840:	f3 0f 1e fb          	endbr32 
  103844:	55                   	push   %ebp
  103845:	89 e5                	mov    %esp,%ebp
  103847:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10384a:	0f 20 d8             	mov    %cr3,%eax
  10384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103850:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103853:	8b 45 08             	mov    0x8(%ebp),%eax
  103856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103859:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103860:	77 23                	ja     103885 <tlb_invalidate+0x45>
  103862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103865:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103869:	c7 44 24 08 04 8d 10 	movl   $0x108d04,0x8(%esp)
  103870:	00 
  103871:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103878:	00 
  103879:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103880:	e8 b0 cb ff ff       	call   100435 <__panic>
  103885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103888:	05 00 00 00 40       	add    $0x40000000,%eax
  10388d:	39 d0                	cmp    %edx,%eax
  10388f:	75 0d                	jne    10389e <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103891:	8b 45 0c             	mov    0xc(%ebp),%eax
  103894:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10389a:	0f 01 38             	invlpg (%eax)
}
  10389d:	90                   	nop
    }
}
  10389e:	90                   	nop
  10389f:	c9                   	leave  
  1038a0:	c3                   	ret    

001038a1 <check_alloc_page>:

static void
check_alloc_page(void) {
  1038a1:	f3 0f 1e fb          	endbr32 
  1038a5:	55                   	push   %ebp
  1038a6:	89 e5                	mov    %esp,%ebp
  1038a8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1038ab:	a1 10 40 12 00       	mov    0x124010,%eax
  1038b0:	8b 40 18             	mov    0x18(%eax),%eax
  1038b3:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1038b5:	c7 04 24 88 8d 10 00 	movl   $0x108d88,(%esp)
  1038bc:	e8 08 ca ff ff       	call   1002c9 <cprintf>
}
  1038c1:	90                   	nop
  1038c2:	c9                   	leave  
  1038c3:	c3                   	ret    

001038c4 <check_pgdir>:

static void
check_pgdir(void) {
  1038c4:	f3 0f 1e fb          	endbr32 
  1038c8:	55                   	push   %ebp
  1038c9:	89 e5                	mov    %esp,%ebp
  1038cb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1038ce:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1038d3:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1038d8:	76 24                	jbe    1038fe <check_pgdir+0x3a>
  1038da:	c7 44 24 0c a7 8d 10 	movl   $0x108da7,0xc(%esp)
  1038e1:	00 
  1038e2:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1038e9:	00 
  1038ea:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1038f1:	00 
  1038f2:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1038f9:	e8 37 cb ff ff       	call   100435 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1038fe:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103903:	85 c0                	test   %eax,%eax
  103905:	74 0e                	je     103915 <check_pgdir+0x51>
  103907:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10390c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103911:	85 c0                	test   %eax,%eax
  103913:	74 24                	je     103939 <check_pgdir+0x75>
  103915:	c7 44 24 0c c4 8d 10 	movl   $0x108dc4,0xc(%esp)
  10391c:	00 
  10391d:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103924:	00 
  103925:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  10392c:	00 
  10392d:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103934:	e8 fc ca ff ff       	call   100435 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103939:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10393e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103945:	00 
  103946:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10394d:	00 
  10394e:	89 04 24             	mov    %eax,(%esp)
  103951:	e8 25 fd ff ff       	call   10367b <get_page>
  103956:	85 c0                	test   %eax,%eax
  103958:	74 24                	je     10397e <check_pgdir+0xba>
  10395a:	c7 44 24 0c fc 8d 10 	movl   $0x108dfc,0xc(%esp)
  103961:	00 
  103962:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103969:	00 
  10396a:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103971:	00 
  103972:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103979:	e8 b7 ca ff ff       	call   100435 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10397e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103985:	e8 0c f5 ff ff       	call   102e96 <alloc_pages>
  10398a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10398d:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103992:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103999:	00 
  10399a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039a1:	00 
  1039a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039a9:	89 04 24             	mov    %eax,(%esp)
  1039ac:	e8 d2 fd ff ff       	call   103783 <page_insert>
  1039b1:	85 c0                	test   %eax,%eax
  1039b3:	74 24                	je     1039d9 <check_pgdir+0x115>
  1039b5:	c7 44 24 0c 24 8e 10 	movl   $0x108e24,0xc(%esp)
  1039bc:	00 
  1039bd:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1039c4:	00 
  1039c5:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1039cc:	00 
  1039cd:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1039d4:	e8 5c ca ff ff       	call   100435 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1039d9:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1039de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039e5:	00 
  1039e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1039ed:	00 
  1039ee:	89 04 24             	mov    %eax,(%esp)
  1039f1:	e8 48 fb ff ff       	call   10353e <get_pte>
  1039f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039fd:	75 24                	jne    103a23 <check_pgdir+0x15f>
  1039ff:	c7 44 24 0c 50 8e 10 	movl   $0x108e50,0xc(%esp)
  103a06:	00 
  103a07:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103a0e:	00 
  103a0f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103a16:	00 
  103a17:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103a1e:	e8 12 ca ff ff       	call   100435 <__panic>
    assert(pte2page(*ptep) == p1);
  103a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a26:	8b 00                	mov    (%eax),%eax
  103a28:	89 04 24             	mov    %eax,(%esp)
  103a2b:	e8 fa f1 ff ff       	call   102c2a <pte2page>
  103a30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a33:	74 24                	je     103a59 <check_pgdir+0x195>
  103a35:	c7 44 24 0c 7d 8e 10 	movl   $0x108e7d,0xc(%esp)
  103a3c:	00 
  103a3d:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103a44:	00 
  103a45:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103a4c:	00 
  103a4d:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103a54:	e8 dc c9 ff ff       	call   100435 <__panic>
    assert(page_ref(p1) == 1);
  103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a5c:	89 04 24             	mov    %eax,(%esp)
  103a5f:	e8 1c f2 ff ff       	call   102c80 <page_ref>
  103a64:	83 f8 01             	cmp    $0x1,%eax
  103a67:	74 24                	je     103a8d <check_pgdir+0x1c9>
  103a69:	c7 44 24 0c 93 8e 10 	movl   $0x108e93,0xc(%esp)
  103a70:	00 
  103a71:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103a78:	00 
  103a79:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103a80:	00 
  103a81:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103a88:	e8 a8 c9 ff ff       	call   100435 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103a8d:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103a92:	8b 00                	mov    (%eax),%eax
  103a94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a9f:	c1 e8 0c             	shr    $0xc,%eax
  103aa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103aa5:	a1 80 3e 12 00       	mov    0x123e80,%eax
  103aaa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103aad:	72 23                	jb     103ad2 <check_pgdir+0x20e>
  103aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ab2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ab6:	c7 44 24 08 60 8c 10 	movl   $0x108c60,0x8(%esp)
  103abd:	00 
  103abe:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103ac5:	00 
  103ac6:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103acd:	e8 63 c9 ff ff       	call   100435 <__panic>
  103ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ad5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103ada:	83 c0 04             	add    $0x4,%eax
  103add:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103ae0:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103ae5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103aec:	00 
  103aed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103af4:	00 
  103af5:	89 04 24             	mov    %eax,(%esp)
  103af8:	e8 41 fa ff ff       	call   10353e <get_pte>
  103afd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b00:	74 24                	je     103b26 <check_pgdir+0x262>
  103b02:	c7 44 24 0c a8 8e 10 	movl   $0x108ea8,0xc(%esp)
  103b09:	00 
  103b0a:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103b11:	00 
  103b12:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103b19:	00 
  103b1a:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103b21:	e8 0f c9 ff ff       	call   100435 <__panic>

    p2 = alloc_page();
  103b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b2d:	e8 64 f3 ff ff       	call   102e96 <alloc_pages>
  103b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103b35:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103b3a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103b41:	00 
  103b42:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b49:	00 
  103b4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b51:	89 04 24             	mov    %eax,(%esp)
  103b54:	e8 2a fc ff ff       	call   103783 <page_insert>
  103b59:	85 c0                	test   %eax,%eax
  103b5b:	74 24                	je     103b81 <check_pgdir+0x2bd>
  103b5d:	c7 44 24 0c d0 8e 10 	movl   $0x108ed0,0xc(%esp)
  103b64:	00 
  103b65:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103b6c:	00 
  103b6d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103b74:	00 
  103b75:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103b7c:	e8 b4 c8 ff ff       	call   100435 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b81:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103b86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b8d:	00 
  103b8e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b95:	00 
  103b96:	89 04 24             	mov    %eax,(%esp)
  103b99:	e8 a0 f9 ff ff       	call   10353e <get_pte>
  103b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103ba5:	75 24                	jne    103bcb <check_pgdir+0x307>
  103ba7:	c7 44 24 0c 08 8f 10 	movl   $0x108f08,0xc(%esp)
  103bae:	00 
  103baf:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103bb6:	00 
  103bb7:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103bbe:	00 
  103bbf:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103bc6:	e8 6a c8 ff ff       	call   100435 <__panic>
    assert(*ptep & PTE_U);
  103bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bce:	8b 00                	mov    (%eax),%eax
  103bd0:	83 e0 04             	and    $0x4,%eax
  103bd3:	85 c0                	test   %eax,%eax
  103bd5:	75 24                	jne    103bfb <check_pgdir+0x337>
  103bd7:	c7 44 24 0c 38 8f 10 	movl   $0x108f38,0xc(%esp)
  103bde:	00 
  103bdf:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103be6:	00 
  103be7:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103bee:	00 
  103bef:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103bf6:	e8 3a c8 ff ff       	call   100435 <__panic>
    assert(*ptep & PTE_W);
  103bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bfe:	8b 00                	mov    (%eax),%eax
  103c00:	83 e0 02             	and    $0x2,%eax
  103c03:	85 c0                	test   %eax,%eax
  103c05:	75 24                	jne    103c2b <check_pgdir+0x367>
  103c07:	c7 44 24 0c 46 8f 10 	movl   $0x108f46,0xc(%esp)
  103c0e:	00 
  103c0f:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103c16:	00 
  103c17:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103c1e:	00 
  103c1f:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103c26:	e8 0a c8 ff ff       	call   100435 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103c2b:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103c30:	8b 00                	mov    (%eax),%eax
  103c32:	83 e0 04             	and    $0x4,%eax
  103c35:	85 c0                	test   %eax,%eax
  103c37:	75 24                	jne    103c5d <check_pgdir+0x399>
  103c39:	c7 44 24 0c 54 8f 10 	movl   $0x108f54,0xc(%esp)
  103c40:	00 
  103c41:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103c48:	00 
  103c49:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103c50:	00 
  103c51:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103c58:	e8 d8 c7 ff ff       	call   100435 <__panic>
    assert(page_ref(p2) == 1);
  103c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c60:	89 04 24             	mov    %eax,(%esp)
  103c63:	e8 18 f0 ff ff       	call   102c80 <page_ref>
  103c68:	83 f8 01             	cmp    $0x1,%eax
  103c6b:	74 24                	je     103c91 <check_pgdir+0x3cd>
  103c6d:	c7 44 24 0c 6a 8f 10 	movl   $0x108f6a,0xc(%esp)
  103c74:	00 
  103c75:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103c7c:	00 
  103c7d:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103c84:	00 
  103c85:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103c8c:	e8 a4 c7 ff ff       	call   100435 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103c91:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103c96:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103c9d:	00 
  103c9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103ca5:	00 
  103ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ca9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cad:	89 04 24             	mov    %eax,(%esp)
  103cb0:	e8 ce fa ff ff       	call   103783 <page_insert>
  103cb5:	85 c0                	test   %eax,%eax
  103cb7:	74 24                	je     103cdd <check_pgdir+0x419>
  103cb9:	c7 44 24 0c 7c 8f 10 	movl   $0x108f7c,0xc(%esp)
  103cc0:	00 
  103cc1:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103cc8:	00 
  103cc9:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103cd0:	00 
  103cd1:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103cd8:	e8 58 c7 ff ff       	call   100435 <__panic>
    assert(page_ref(p1) == 2);
  103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce0:	89 04 24             	mov    %eax,(%esp)
  103ce3:	e8 98 ef ff ff       	call   102c80 <page_ref>
  103ce8:	83 f8 02             	cmp    $0x2,%eax
  103ceb:	74 24                	je     103d11 <check_pgdir+0x44d>
  103ced:	c7 44 24 0c a8 8f 10 	movl   $0x108fa8,0xc(%esp)
  103cf4:	00 
  103cf5:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103cfc:	00 
  103cfd:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103d04:	00 
  103d05:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103d0c:	e8 24 c7 ff ff       	call   100435 <__panic>
    assert(page_ref(p2) == 0);
  103d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d14:	89 04 24             	mov    %eax,(%esp)
  103d17:	e8 64 ef ff ff       	call   102c80 <page_ref>
  103d1c:	85 c0                	test   %eax,%eax
  103d1e:	74 24                	je     103d44 <check_pgdir+0x480>
  103d20:	c7 44 24 0c ba 8f 10 	movl   $0x108fba,0xc(%esp)
  103d27:	00 
  103d28:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103d2f:	00 
  103d30:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103d37:	00 
  103d38:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103d3f:	e8 f1 c6 ff ff       	call   100435 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103d44:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103d49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d50:	00 
  103d51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d58:	00 
  103d59:	89 04 24             	mov    %eax,(%esp)
  103d5c:	e8 dd f7 ff ff       	call   10353e <get_pte>
  103d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d68:	75 24                	jne    103d8e <check_pgdir+0x4ca>
  103d6a:	c7 44 24 0c 08 8f 10 	movl   $0x108f08,0xc(%esp)
  103d71:	00 
  103d72:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103d79:	00 
  103d7a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103d81:	00 
  103d82:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103d89:	e8 a7 c6 ff ff       	call   100435 <__panic>
    assert(pte2page(*ptep) == p1);
  103d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d91:	8b 00                	mov    (%eax),%eax
  103d93:	89 04 24             	mov    %eax,(%esp)
  103d96:	e8 8f ee ff ff       	call   102c2a <pte2page>
  103d9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103d9e:	74 24                	je     103dc4 <check_pgdir+0x500>
  103da0:	c7 44 24 0c 7d 8e 10 	movl   $0x108e7d,0xc(%esp)
  103da7:	00 
  103da8:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103daf:	00 
  103db0:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103db7:	00 
  103db8:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103dbf:	e8 71 c6 ff ff       	call   100435 <__panic>
    assert((*ptep & PTE_U) == 0);
  103dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dc7:	8b 00                	mov    (%eax),%eax
  103dc9:	83 e0 04             	and    $0x4,%eax
  103dcc:	85 c0                	test   %eax,%eax
  103dce:	74 24                	je     103df4 <check_pgdir+0x530>
  103dd0:	c7 44 24 0c cc 8f 10 	movl   $0x108fcc,0xc(%esp)
  103dd7:	00 
  103dd8:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103ddf:	00 
  103de0:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103de7:	00 
  103de8:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103def:	e8 41 c6 ff ff       	call   100435 <__panic>

    page_remove(boot_pgdir, 0x0);
  103df4:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103df9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e00:	00 
  103e01:	89 04 24             	mov    %eax,(%esp)
  103e04:	e8 31 f9 ff ff       	call   10373a <page_remove>
    assert(page_ref(p1) == 1);
  103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e0c:	89 04 24             	mov    %eax,(%esp)
  103e0f:	e8 6c ee ff ff       	call   102c80 <page_ref>
  103e14:	83 f8 01             	cmp    $0x1,%eax
  103e17:	74 24                	je     103e3d <check_pgdir+0x579>
  103e19:	c7 44 24 0c 93 8e 10 	movl   $0x108e93,0xc(%esp)
  103e20:	00 
  103e21:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103e28:	00 
  103e29:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  103e30:	00 
  103e31:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103e38:	e8 f8 c5 ff ff       	call   100435 <__panic>
    assert(page_ref(p2) == 0);
  103e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e40:	89 04 24             	mov    %eax,(%esp)
  103e43:	e8 38 ee ff ff       	call   102c80 <page_ref>
  103e48:	85 c0                	test   %eax,%eax
  103e4a:	74 24                	je     103e70 <check_pgdir+0x5ac>
  103e4c:	c7 44 24 0c ba 8f 10 	movl   $0x108fba,0xc(%esp)
  103e53:	00 
  103e54:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103e5b:	00 
  103e5c:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103e63:	00 
  103e64:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103e6b:	e8 c5 c5 ff ff       	call   100435 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103e70:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103e75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e7c:	00 
  103e7d:	89 04 24             	mov    %eax,(%esp)
  103e80:	e8 b5 f8 ff ff       	call   10373a <page_remove>
    assert(page_ref(p1) == 0);
  103e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e88:	89 04 24             	mov    %eax,(%esp)
  103e8b:	e8 f0 ed ff ff       	call   102c80 <page_ref>
  103e90:	85 c0                	test   %eax,%eax
  103e92:	74 24                	je     103eb8 <check_pgdir+0x5f4>
  103e94:	c7 44 24 0c e1 8f 10 	movl   $0x108fe1,0xc(%esp)
  103e9b:	00 
  103e9c:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103ea3:	00 
  103ea4:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  103eab:	00 
  103eac:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103eb3:	e8 7d c5 ff ff       	call   100435 <__panic>
    assert(page_ref(p2) == 0);
  103eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ebb:	89 04 24             	mov    %eax,(%esp)
  103ebe:	e8 bd ed ff ff       	call   102c80 <page_ref>
  103ec3:	85 c0                	test   %eax,%eax
  103ec5:	74 24                	je     103eeb <check_pgdir+0x627>
  103ec7:	c7 44 24 0c ba 8f 10 	movl   $0x108fba,0xc(%esp)
  103ece:	00 
  103ecf:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103ed6:	00 
  103ed7:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103ede:	00 
  103edf:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103ee6:	e8 4a c5 ff ff       	call   100435 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103eeb:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103ef0:	8b 00                	mov    (%eax),%eax
  103ef2:	89 04 24             	mov    %eax,(%esp)
  103ef5:	e8 6e ed ff ff       	call   102c68 <pde2page>
  103efa:	89 04 24             	mov    %eax,(%esp)
  103efd:	e8 7e ed ff ff       	call   102c80 <page_ref>
  103f02:	83 f8 01             	cmp    $0x1,%eax
  103f05:	74 24                	je     103f2b <check_pgdir+0x667>
  103f07:	c7 44 24 0c f4 8f 10 	movl   $0x108ff4,0xc(%esp)
  103f0e:	00 
  103f0f:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103f16:	00 
  103f17:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  103f1e:	00 
  103f1f:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103f26:	e8 0a c5 ff ff       	call   100435 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103f2b:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103f30:	8b 00                	mov    (%eax),%eax
  103f32:	89 04 24             	mov    %eax,(%esp)
  103f35:	e8 2e ed ff ff       	call   102c68 <pde2page>
  103f3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f41:	00 
  103f42:	89 04 24             	mov    %eax,(%esp)
  103f45:	e8 88 ef ff ff       	call   102ed2 <free_pages>
    boot_pgdir[0] = 0;
  103f4a:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103f55:	c7 04 24 1b 90 10 00 	movl   $0x10901b,(%esp)
  103f5c:	e8 68 c3 ff ff       	call   1002c9 <cprintf>
}
  103f61:	90                   	nop
  103f62:	c9                   	leave  
  103f63:	c3                   	ret    

00103f64 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103f64:	f3 0f 1e fb          	endbr32 
  103f68:	55                   	push   %ebp
  103f69:	89 e5                	mov    %esp,%ebp
  103f6b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103f6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103f75:	e9 ca 00 00 00       	jmp    104044 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f83:	c1 e8 0c             	shr    $0xc,%eax
  103f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f89:	a1 80 3e 12 00       	mov    0x123e80,%eax
  103f8e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103f91:	72 23                	jb     103fb6 <check_boot_pgdir+0x52>
  103f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f96:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f9a:	c7 44 24 08 60 8c 10 	movl   $0x108c60,0x8(%esp)
  103fa1:	00 
  103fa2:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  103fa9:	00 
  103faa:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  103fb1:	e8 7f c4 ff ff       	call   100435 <__panic>
  103fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fb9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103fbe:	89 c2                	mov    %eax,%edx
  103fc0:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103fc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103fcc:	00 
  103fcd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fd1:	89 04 24             	mov    %eax,(%esp)
  103fd4:	e8 65 f5 ff ff       	call   10353e <get_pte>
  103fd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103fdc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103fe0:	75 24                	jne    104006 <check_boot_pgdir+0xa2>
  103fe2:	c7 44 24 0c 38 90 10 	movl   $0x109038,0xc(%esp)
  103fe9:	00 
  103fea:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  103ff1:	00 
  103ff2:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  103ff9:	00 
  103ffa:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104001:	e8 2f c4 ff ff       	call   100435 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104006:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104009:	8b 00                	mov    (%eax),%eax
  10400b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104010:	89 c2                	mov    %eax,%edx
  104012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104015:	39 c2                	cmp    %eax,%edx
  104017:	74 24                	je     10403d <check_boot_pgdir+0xd9>
  104019:	c7 44 24 0c 75 90 10 	movl   $0x109075,0xc(%esp)
  104020:	00 
  104021:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  104028:	00 
  104029:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104030:	00 
  104031:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104038:	e8 f8 c3 ff ff       	call   100435 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  10403d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104047:	a1 80 3e 12 00       	mov    0x123e80,%eax
  10404c:	39 c2                	cmp    %eax,%edx
  10404e:	0f 82 26 ff ff ff    	jb     103f7a <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104054:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104059:	05 ac 0f 00 00       	add    $0xfac,%eax
  10405e:	8b 00                	mov    (%eax),%eax
  104060:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104065:	89 c2                	mov    %eax,%edx
  104067:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10406c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10406f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104076:	77 23                	ja     10409b <check_boot_pgdir+0x137>
  104078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10407b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10407f:	c7 44 24 08 04 8d 10 	movl   $0x108d04,0x8(%esp)
  104086:	00 
  104087:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  10408e:	00 
  10408f:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104096:	e8 9a c3 ff ff       	call   100435 <__panic>
  10409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10409e:	05 00 00 00 40       	add    $0x40000000,%eax
  1040a3:	39 d0                	cmp    %edx,%eax
  1040a5:	74 24                	je     1040cb <check_boot_pgdir+0x167>
  1040a7:	c7 44 24 0c 8c 90 10 	movl   $0x10908c,0xc(%esp)
  1040ae:	00 
  1040af:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1040b6:	00 
  1040b7:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  1040be:	00 
  1040bf:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1040c6:	e8 6a c3 ff ff       	call   100435 <__panic>

    assert(boot_pgdir[0] == 0);
  1040cb:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1040d0:	8b 00                	mov    (%eax),%eax
  1040d2:	85 c0                	test   %eax,%eax
  1040d4:	74 24                	je     1040fa <check_boot_pgdir+0x196>
  1040d6:	c7 44 24 0c c0 90 10 	movl   $0x1090c0,0xc(%esp)
  1040dd:	00 
  1040de:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1040e5:	00 
  1040e6:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  1040ed:	00 
  1040ee:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1040f5:	e8 3b c3 ff ff       	call   100435 <__panic>

    struct Page *p;
    p = alloc_page();
  1040fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104101:	e8 90 ed ff ff       	call   102e96 <alloc_pages>
  104106:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104109:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10410e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104115:	00 
  104116:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10411d:	00 
  10411e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104121:	89 54 24 04          	mov    %edx,0x4(%esp)
  104125:	89 04 24             	mov    %eax,(%esp)
  104128:	e8 56 f6 ff ff       	call   103783 <page_insert>
  10412d:	85 c0                	test   %eax,%eax
  10412f:	74 24                	je     104155 <check_boot_pgdir+0x1f1>
  104131:	c7 44 24 0c d4 90 10 	movl   $0x1090d4,0xc(%esp)
  104138:	00 
  104139:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  104140:	00 
  104141:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104148:	00 
  104149:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104150:	e8 e0 c2 ff ff       	call   100435 <__panic>
    assert(page_ref(p) == 1);
  104155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104158:	89 04 24             	mov    %eax,(%esp)
  10415b:	e8 20 eb ff ff       	call   102c80 <page_ref>
  104160:	83 f8 01             	cmp    $0x1,%eax
  104163:	74 24                	je     104189 <check_boot_pgdir+0x225>
  104165:	c7 44 24 0c 02 91 10 	movl   $0x109102,0xc(%esp)
  10416c:	00 
  10416d:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  104174:	00 
  104175:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  10417c:	00 
  10417d:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104184:	e8 ac c2 ff ff       	call   100435 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104189:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10418e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104195:	00 
  104196:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10419d:	00 
  10419e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041a5:	89 04 24             	mov    %eax,(%esp)
  1041a8:	e8 d6 f5 ff ff       	call   103783 <page_insert>
  1041ad:	85 c0                	test   %eax,%eax
  1041af:	74 24                	je     1041d5 <check_boot_pgdir+0x271>
  1041b1:	c7 44 24 0c 14 91 10 	movl   $0x109114,0xc(%esp)
  1041b8:	00 
  1041b9:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1041c0:	00 
  1041c1:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  1041c8:	00 
  1041c9:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1041d0:	e8 60 c2 ff ff       	call   100435 <__panic>
    assert(page_ref(p) == 2);
  1041d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041d8:	89 04 24             	mov    %eax,(%esp)
  1041db:	e8 a0 ea ff ff       	call   102c80 <page_ref>
  1041e0:	83 f8 02             	cmp    $0x2,%eax
  1041e3:	74 24                	je     104209 <check_boot_pgdir+0x2a5>
  1041e5:	c7 44 24 0c 4b 91 10 	movl   $0x10914b,0xc(%esp)
  1041ec:	00 
  1041ed:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  1041f4:	00 
  1041f5:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  1041fc:	00 
  1041fd:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  104204:	e8 2c c2 ff ff       	call   100435 <__panic>

    const char *str = "ucore: Hello world!!";
  104209:	c7 45 e8 5c 91 10 00 	movl   $0x10915c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104213:	89 44 24 04          	mov    %eax,0x4(%esp)
  104217:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10421e:	e8 a1 37 00 00       	call   1079c4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104223:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10422a:	00 
  10422b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104232:	e8 0b 38 00 00       	call   107a42 <strcmp>
  104237:	85 c0                	test   %eax,%eax
  104239:	74 24                	je     10425f <check_boot_pgdir+0x2fb>
  10423b:	c7 44 24 0c 74 91 10 	movl   $0x109174,0xc(%esp)
  104242:	00 
  104243:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  10424a:	00 
  10424b:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104252:	00 
  104253:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  10425a:	e8 d6 c1 ff ff       	call   100435 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10425f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104262:	89 04 24             	mov    %eax,(%esp)
  104265:	e8 6c e9 ff ff       	call   102bd6 <page2kva>
  10426a:	05 00 01 00 00       	add    $0x100,%eax
  10426f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104272:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104279:	e8 e8 36 00 00       	call   107966 <strlen>
  10427e:	85 c0                	test   %eax,%eax
  104280:	74 24                	je     1042a6 <check_boot_pgdir+0x342>
  104282:	c7 44 24 0c ac 91 10 	movl   $0x1091ac,0xc(%esp)
  104289:	00 
  10428a:	c7 44 24 08 4d 8d 10 	movl   $0x108d4d,0x8(%esp)
  104291:	00 
  104292:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  104299:	00 
  10429a:	c7 04 24 28 8d 10 00 	movl   $0x108d28,(%esp)
  1042a1:	e8 8f c1 ff ff       	call   100435 <__panic>

    free_page(p);
  1042a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1042ad:	00 
  1042ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042b1:	89 04 24             	mov    %eax,(%esp)
  1042b4:	e8 19 ec ff ff       	call   102ed2 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1042b9:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1042be:	8b 00                	mov    (%eax),%eax
  1042c0:	89 04 24             	mov    %eax,(%esp)
  1042c3:	e8 a0 e9 ff ff       	call   102c68 <pde2page>
  1042c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1042cf:	00 
  1042d0:	89 04 24             	mov    %eax,(%esp)
  1042d3:	e8 fa eb ff ff       	call   102ed2 <free_pages>
    boot_pgdir[0] = 0;
  1042d8:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1042dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1042e3:	c7 04 24 d0 91 10 00 	movl   $0x1091d0,(%esp)
  1042ea:	e8 da bf ff ff       	call   1002c9 <cprintf>
}
  1042ef:	90                   	nop
  1042f0:	c9                   	leave  
  1042f1:	c3                   	ret    

001042f2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1042f2:	f3 0f 1e fb          	endbr32 
  1042f6:	55                   	push   %ebp
  1042f7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1042f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1042fc:	83 e0 04             	and    $0x4,%eax
  1042ff:	85 c0                	test   %eax,%eax
  104301:	74 04                	je     104307 <perm2str+0x15>
  104303:	b0 75                	mov    $0x75,%al
  104305:	eb 02                	jmp    104309 <perm2str+0x17>
  104307:	b0 2d                	mov    $0x2d,%al
  104309:	a2 08 3f 12 00       	mov    %al,0x123f08
    str[1] = 'r';
  10430e:	c6 05 09 3f 12 00 72 	movb   $0x72,0x123f09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104315:	8b 45 08             	mov    0x8(%ebp),%eax
  104318:	83 e0 02             	and    $0x2,%eax
  10431b:	85 c0                	test   %eax,%eax
  10431d:	74 04                	je     104323 <perm2str+0x31>
  10431f:	b0 77                	mov    $0x77,%al
  104321:	eb 02                	jmp    104325 <perm2str+0x33>
  104323:	b0 2d                	mov    $0x2d,%al
  104325:	a2 0a 3f 12 00       	mov    %al,0x123f0a
    str[3] = '\0';
  10432a:	c6 05 0b 3f 12 00 00 	movb   $0x0,0x123f0b
    return str;
  104331:	b8 08 3f 12 00       	mov    $0x123f08,%eax
}
  104336:	5d                   	pop    %ebp
  104337:	c3                   	ret    

00104338 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104338:	f3 0f 1e fb          	endbr32 
  10433c:	55                   	push   %ebp
  10433d:	89 e5                	mov    %esp,%ebp
  10433f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104342:	8b 45 10             	mov    0x10(%ebp),%eax
  104345:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104348:	72 0d                	jb     104357 <get_pgtable_items+0x1f>
        return 0;
  10434a:	b8 00 00 00 00       	mov    $0x0,%eax
  10434f:	e9 98 00 00 00       	jmp    1043ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104354:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104357:	8b 45 10             	mov    0x10(%ebp),%eax
  10435a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10435d:	73 18                	jae    104377 <get_pgtable_items+0x3f>
  10435f:	8b 45 10             	mov    0x10(%ebp),%eax
  104362:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104369:	8b 45 14             	mov    0x14(%ebp),%eax
  10436c:	01 d0                	add    %edx,%eax
  10436e:	8b 00                	mov    (%eax),%eax
  104370:	83 e0 01             	and    $0x1,%eax
  104373:	85 c0                	test   %eax,%eax
  104375:	74 dd                	je     104354 <get_pgtable_items+0x1c>
    }
    if (start < right) {
  104377:	8b 45 10             	mov    0x10(%ebp),%eax
  10437a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10437d:	73 68                	jae    1043e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10437f:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104383:	74 08                	je     10438d <get_pgtable_items+0x55>
            *left_store = start;
  104385:	8b 45 18             	mov    0x18(%ebp),%eax
  104388:	8b 55 10             	mov    0x10(%ebp),%edx
  10438b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10438d:	8b 45 10             	mov    0x10(%ebp),%eax
  104390:	8d 50 01             	lea    0x1(%eax),%edx
  104393:	89 55 10             	mov    %edx,0x10(%ebp)
  104396:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10439d:	8b 45 14             	mov    0x14(%ebp),%eax
  1043a0:	01 d0                	add    %edx,%eax
  1043a2:	8b 00                	mov    (%eax),%eax
  1043a4:	83 e0 07             	and    $0x7,%eax
  1043a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1043aa:	eb 03                	jmp    1043af <get_pgtable_items+0x77>
            start ++;
  1043ac:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1043af:	8b 45 10             	mov    0x10(%ebp),%eax
  1043b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043b5:	73 1d                	jae    1043d4 <get_pgtable_items+0x9c>
  1043b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1043ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1043c4:	01 d0                	add    %edx,%eax
  1043c6:	8b 00                	mov    (%eax),%eax
  1043c8:	83 e0 07             	and    $0x7,%eax
  1043cb:	89 c2                	mov    %eax,%edx
  1043cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043d0:	39 c2                	cmp    %eax,%edx
  1043d2:	74 d8                	je     1043ac <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  1043d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1043d8:	74 08                	je     1043e2 <get_pgtable_items+0xaa>
            *right_store = start;
  1043da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1043dd:	8b 55 10             	mov    0x10(%ebp),%edx
  1043e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1043e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043e5:	eb 05                	jmp    1043ec <get_pgtable_items+0xb4>
    }
    return 0;
  1043e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1043ec:	c9                   	leave  
  1043ed:	c3                   	ret    

001043ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1043ee:	f3 0f 1e fb          	endbr32 
  1043f2:	55                   	push   %ebp
  1043f3:	89 e5                	mov    %esp,%ebp
  1043f5:	57                   	push   %edi
  1043f6:	56                   	push   %esi
  1043f7:	53                   	push   %ebx
  1043f8:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1043fb:	c7 04 24 f0 91 10 00 	movl   $0x1091f0,(%esp)
  104402:	e8 c2 be ff ff       	call   1002c9 <cprintf>
    size_t left, right = 0, perm;
  104407:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10440e:	e9 fa 00 00 00       	jmp    10450d <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104416:	89 04 24             	mov    %eax,(%esp)
  104419:	e8 d4 fe ff ff       	call   1042f2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10441e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104421:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104424:	29 d1                	sub    %edx,%ecx
  104426:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104428:	89 d6                	mov    %edx,%esi
  10442a:	c1 e6 16             	shl    $0x16,%esi
  10442d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104430:	89 d3                	mov    %edx,%ebx
  104432:	c1 e3 16             	shl    $0x16,%ebx
  104435:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104438:	89 d1                	mov    %edx,%ecx
  10443a:	c1 e1 16             	shl    $0x16,%ecx
  10443d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104443:	29 d7                	sub    %edx,%edi
  104445:	89 fa                	mov    %edi,%edx
  104447:	89 44 24 14          	mov    %eax,0x14(%esp)
  10444b:	89 74 24 10          	mov    %esi,0x10(%esp)
  10444f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104457:	89 54 24 04          	mov    %edx,0x4(%esp)
  10445b:	c7 04 24 21 92 10 00 	movl   $0x109221,(%esp)
  104462:	e8 62 be ff ff       	call   1002c9 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10446a:	c1 e0 0a             	shl    $0xa,%eax
  10446d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104470:	eb 54                	jmp    1044c6 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104475:	89 04 24             	mov    %eax,(%esp)
  104478:	e8 75 fe ff ff       	call   1042f2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10447d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104480:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104483:	29 d1                	sub    %edx,%ecx
  104485:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104487:	89 d6                	mov    %edx,%esi
  104489:	c1 e6 0c             	shl    $0xc,%esi
  10448c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10448f:	89 d3                	mov    %edx,%ebx
  104491:	c1 e3 0c             	shl    $0xc,%ebx
  104494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104497:	89 d1                	mov    %edx,%ecx
  104499:	c1 e1 0c             	shl    $0xc,%ecx
  10449c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10449f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044a2:	29 d7                	sub    %edx,%edi
  1044a4:	89 fa                	mov    %edi,%edx
  1044a6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1044aa:	89 74 24 10          	mov    %esi,0x10(%esp)
  1044ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1044b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1044b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1044ba:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  1044c1:	e8 03 be ff ff       	call   1002c9 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1044c6:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1044cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1044ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044d1:	89 d3                	mov    %edx,%ebx
  1044d3:	c1 e3 0a             	shl    $0xa,%ebx
  1044d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044d9:	89 d1                	mov    %edx,%ecx
  1044db:	c1 e1 0a             	shl    $0xa,%ecx
  1044de:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1044e1:	89 54 24 14          	mov    %edx,0x14(%esp)
  1044e5:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1044e8:	89 54 24 10          	mov    %edx,0x10(%esp)
  1044ec:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1044f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1044f8:	89 0c 24             	mov    %ecx,(%esp)
  1044fb:	e8 38 fe ff ff       	call   104338 <get_pgtable_items>
  104500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104503:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104507:	0f 85 65 ff ff ff    	jne    104472 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10450d:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104512:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104515:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104518:	89 54 24 14          	mov    %edx,0x14(%esp)
  10451c:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10451f:	89 54 24 10          	mov    %edx,0x10(%esp)
  104523:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104527:	89 44 24 08          	mov    %eax,0x8(%esp)
  10452b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104532:	00 
  104533:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10453a:	e8 f9 fd ff ff       	call   104338 <get_pgtable_items>
  10453f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104546:	0f 85 c7 fe ff ff    	jne    104413 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10454c:	c7 04 24 64 92 10 00 	movl   $0x109264,(%esp)
  104553:	e8 71 bd ff ff       	call   1002c9 <cprintf>
}
  104558:	90                   	nop
  104559:	83 c4 4c             	add    $0x4c,%esp
  10455c:	5b                   	pop    %ebx
  10455d:	5e                   	pop    %esi
  10455e:	5f                   	pop    %edi
  10455f:	5d                   	pop    %ebp
  104560:	c3                   	ret    

00104561 <page2ppn>:
page2ppn(struct Page *page) {
  104561:	55                   	push   %ebp
  104562:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104564:	a1 18 40 12 00       	mov    0x124018,%eax
  104569:	8b 55 08             	mov    0x8(%ebp),%edx
  10456c:	29 c2                	sub    %eax,%edx
  10456e:	89 d0                	mov    %edx,%eax
  104570:	c1 f8 02             	sar    $0x2,%eax
  104573:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104579:	5d                   	pop    %ebp
  10457a:	c3                   	ret    

0010457b <page2pa>:
page2pa(struct Page *page) {
  10457b:	55                   	push   %ebp
  10457c:	89 e5                	mov    %esp,%ebp
  10457e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104581:	8b 45 08             	mov    0x8(%ebp),%eax
  104584:	89 04 24             	mov    %eax,(%esp)
  104587:	e8 d5 ff ff ff       	call   104561 <page2ppn>
  10458c:	c1 e0 0c             	shl    $0xc,%eax
}
  10458f:	c9                   	leave  
  104590:	c3                   	ret    

00104591 <page2kva>:
page2kva(struct Page *page) {
  104591:	55                   	push   %ebp
  104592:	89 e5                	mov    %esp,%ebp
  104594:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  104597:	8b 45 08             	mov    0x8(%ebp),%eax
  10459a:	89 04 24             	mov    %eax,(%esp)
  10459d:	e8 d9 ff ff ff       	call   10457b <page2pa>
  1045a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a8:	c1 e8 0c             	shr    $0xc,%eax
  1045ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045ae:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1045b3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1045b6:	72 23                	jb     1045db <page2kva+0x4a>
  1045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045bf:	c7 44 24 08 98 92 10 	movl   $0x109298,0x8(%esp)
  1045c6:	00 
  1045c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  1045ce:	00 
  1045cf:	c7 04 24 bb 92 10 00 	movl   $0x1092bb,(%esp)
  1045d6:	e8 5a be ff ff       	call   100435 <__panic>
  1045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045de:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1045e3:	c9                   	leave  
  1045e4:	c3                   	ret    

001045e5 <kmem_cache_grow>:
static struct kmem_cache_t *sized_caches[SIZED_CACHE_NUM];
static char *cache_cache_name = "cache";
static char *sized_cache_name = "sized";

// kmem_cache_grow - add a free slab
static void * kmem_cache_grow(struct kmem_cache_t *cachep) {
  1045e5:	f3 0f 1e fb          	endbr32 
  1045e9:	55                   	push   %ebp
  1045ea:	89 e5                	mov    %esp,%ebp
  1045ec:	83 ec 58             	sub    $0x58,%esp
    struct Page *page = alloc_page();
  1045ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045f6:	e8 9b e8 ff ff       	call   102e96 <alloc_pages>
  1045fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    void *kva = page2kva(page);
  1045fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104601:	89 04 24             	mov    %eax,(%esp)
  104604:	e8 88 ff ff ff       	call   104591 <page2kva>
  104609:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // Init slub meta data
    struct slab_t *slab = (struct slab_t *) page;
  10460c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10460f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    slab->cachep = cachep;
  104612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104615:	8b 55 08             	mov    0x8(%ebp),%edx
  104618:	89 50 04             	mov    %edx,0x4(%eax)
    slab->inuse = slab->free = 0;
  10461b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10461e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  104624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104627:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
  10462b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10462e:	66 89 50 08          	mov    %dx,0x8(%eax)
    list_add(&(cachep->slabs_free), &(slab->slab_link));
  104632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104635:	83 c0 0c             	add    $0xc,%eax
  104638:	8b 55 08             	mov    0x8(%ebp),%edx
  10463b:	83 c2 10             	add    $0x10,%edx
  10463e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104641:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104647:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10464a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10464d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104653:	8b 40 04             	mov    0x4(%eax),%eax
  104656:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104659:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10465c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10465f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104662:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104665:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104668:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10466b:	89 10                	mov    %edx,(%eax)
  10466d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104670:	8b 10                	mov    (%eax),%edx
  104672:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104675:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104678:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10467b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10467e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104684:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104687:	89 10                	mov    %edx,(%eax)
}
  104689:	90                   	nop
}
  10468a:	90                   	nop
}
  10468b:	90                   	nop
    // Init bufctl
    int16_t *bufctl = kva;
  10468c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10468f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (int i = 1; i < cachep->num; i++)
  104692:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  104699:	eb 1a                	jmp    1046b5 <kmem_cache_grow+0xd0>
        bufctl[i-1] = i;
  10469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469e:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
  1046a3:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1046a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046a9:	01 c2                	add    %eax,%edx
  1046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ae:	98                   	cwtl   
  1046af:	66 89 02             	mov    %ax,(%edx)
    for (int i = 1; i < cachep->num; i++)
  1046b2:	ff 45 f4             	incl   -0xc(%ebp)
  1046b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b8:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  1046bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1046bf:	7c da                	jl     10469b <kmem_cache_grow+0xb6>
    bufctl[cachep->num-1] = -1;
  1046c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c4:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  1046c8:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
  1046cd:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1046d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046d3:	01 d0                	add    %edx,%eax
  1046d5:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
    // Init cache 
    void *buf = bufctl + cachep->num;
  1046da:	8b 45 08             	mov    0x8(%ebp),%eax
  1046dd:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  1046e1:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1046e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046e7:	01 d0                	add    %edx,%eax
  1046e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cachep->ctor) 
  1046ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ef:	8b 40 1c             	mov    0x1c(%eax),%eax
  1046f2:	85 c0                	test   %eax,%eax
  1046f4:	74 51                	je     104747 <kmem_cache_grow+0x162>
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
  1046f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046fc:	eb 2a                	jmp    104728 <kmem_cache_grow+0x143>
            cachep->ctor(p, cachep, cachep->objsize);
  1046fe:	8b 45 08             	mov    0x8(%ebp),%eax
  104701:	8b 40 1c             	mov    0x1c(%eax),%eax
  104704:	8b 55 08             	mov    0x8(%ebp),%edx
  104707:	0f b7 52 18          	movzwl 0x18(%edx),%edx
  10470b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10470f:	8b 55 08             	mov    0x8(%ebp),%edx
  104712:	89 54 24 04          	mov    %edx,0x4(%esp)
  104716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104719:	89 14 24             	mov    %edx,(%esp)
  10471c:	ff d0                	call   *%eax
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
  10471e:	8b 45 08             	mov    0x8(%ebp),%eax
  104721:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  104725:	01 45 f0             	add    %eax,-0x10(%ebp)
  104728:	8b 45 08             	mov    0x8(%ebp),%eax
  10472b:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  10472f:	89 c2                	mov    %eax,%edx
  104731:	8b 45 08             	mov    0x8(%ebp),%eax
  104734:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  104738:	0f af c2             	imul   %edx,%eax
  10473b:	89 c2                	mov    %eax,%edx
  10473d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104740:	01 d0                	add    %edx,%eax
  104742:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104745:	72 b7                	jb     1046fe <kmem_cache_grow+0x119>
    return slab;
  104747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  10474a:	c9                   	leave  
  10474b:	c3                   	ret    

0010474c <kmem_slab_destroy>:

// kmem_slab_destroy - destroy a slab
static void kmem_slab_destroy(struct kmem_cache_t *cachep, struct slab_t *slab) {
  10474c:	f3 0f 1e fb          	endbr32 
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	83 ec 38             	sub    $0x38,%esp
    // Destruct cache
    struct Page *page = (struct Page *) slab;
  104756:	8b 45 0c             	mov    0xc(%ebp),%eax
  104759:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int16_t *bufctl = page2kva(page);
  10475c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10475f:	89 04 24             	mov    %eax,(%esp)
  104762:	e8 2a fe ff ff       	call   104591 <page2kva>
  104767:	89 45 ec             	mov    %eax,-0x14(%ebp)
    void *buf = bufctl + cachep->num;
  10476a:	8b 45 08             	mov    0x8(%ebp),%eax
  10476d:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  104771:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104777:	01 d0                	add    %edx,%eax
  104779:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (cachep->dtor)
  10477c:	8b 45 08             	mov    0x8(%ebp),%eax
  10477f:	8b 40 20             	mov    0x20(%eax),%eax
  104782:	85 c0                	test   %eax,%eax
  104784:	74 51                	je     1047d7 <kmem_slab_destroy+0x8b>
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
  104786:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10478c:	eb 2a                	jmp    1047b8 <kmem_slab_destroy+0x6c>
            cachep->dtor(p, cachep, cachep->objsize);
  10478e:	8b 45 08             	mov    0x8(%ebp),%eax
  104791:	8b 40 20             	mov    0x20(%eax),%eax
  104794:	8b 55 08             	mov    0x8(%ebp),%edx
  104797:	0f b7 52 18          	movzwl 0x18(%edx),%edx
  10479b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10479f:	8b 55 08             	mov    0x8(%ebp),%edx
  1047a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047a9:	89 14 24             	mov    %edx,(%esp)
  1047ac:	ff d0                	call   *%eax
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
  1047ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1047b1:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  1047b5:	01 45 f4             	add    %eax,-0xc(%ebp)
  1047b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1047bb:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  1047bf:	89 c2                	mov    %eax,%edx
  1047c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c4:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  1047c8:	0f af c2             	imul   %edx,%eax
  1047cb:	89 c2                	mov    %eax,%edx
  1047cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047d0:	01 d0                	add    %edx,%eax
  1047d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1047d5:	72 b7                	jb     10478e <kmem_slab_destroy+0x42>
    // Return slub page 
    page->property = page->flags = 0;
  1047d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  1047e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047e4:	8b 50 04             	mov    0x4(%eax),%edx
  1047e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047ea:	89 50 08             	mov    %edx,0x8(%eax)
    list_del(&(page->page_link));
  1047ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047f0:	83 c0 0c             	add    $0xc,%eax
  1047f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_del(listelm->prev, listelm->next);
  1047f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047f9:	8b 40 04             	mov    0x4(%eax),%eax
  1047fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1047ff:	8b 12                	mov    (%edx),%edx
  104801:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104804:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104807:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10480a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10480d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104813:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104816:	89 10                	mov    %edx,(%eax)
}
  104818:	90                   	nop
}
  104819:	90                   	nop
    free_page(page);
  10481a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104821:	00 
  104822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104825:	89 04 24             	mov    %eax,(%esp)
  104828:	e8 a5 e6 ff ff       	call   102ed2 <free_pages>
}
  10482d:	90                   	nop
  10482e:	c9                   	leave  
  10482f:	c3                   	ret    

00104830 <kmem_sized_index>:

static int kmem_sized_index(size_t size) {
  104830:	f3 0f 1e fb          	endbr32 
  104834:	55                   	push   %ebp
  104835:	89 e5                	mov    %esp,%ebp
  104837:	83 ec 20             	sub    $0x20,%esp
    // Round up 
    size_t rsize = ROUNDUP(size, 2);
  10483a:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
  104841:	8b 55 08             	mov    0x8(%ebp),%edx
  104844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104847:	01 d0                	add    %edx,%eax
  104849:	48                   	dec    %eax
  10484a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10484d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104850:	ba 00 00 00 00       	mov    $0x0,%edx
  104855:	f7 75 f0             	divl   -0x10(%ebp)
  104858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10485b:	29 d0                	sub    %edx,%eax
  10485d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (rsize < SIZED_CACHE_MIN)
  104860:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
  104864:	77 07                	ja     10486d <kmem_sized_index+0x3d>
        rsize = SIZED_CACHE_MIN;
  104866:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%ebp)
    // Find index
    int index = 0;
  10486d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for (int t = rsize / 32; t; t /= 2)
  104874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104877:	c1 e8 05             	shr    $0x5,%eax
  10487a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10487d:	eb 12                	jmp    104891 <kmem_sized_index+0x61>
        index ++;
  10487f:	ff 45 f8             	incl   -0x8(%ebp)
    for (int t = rsize / 32; t; t /= 2)
  104882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104885:	89 c2                	mov    %eax,%edx
  104887:	c1 ea 1f             	shr    $0x1f,%edx
  10488a:	01 d0                	add    %edx,%eax
  10488c:	d1 f8                	sar    %eax
  10488e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104895:	75 e8                	jne    10487f <kmem_sized_index+0x4f>
    return index;
  104897:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10489a:	c9                   	leave  
  10489b:	c3                   	ret    

0010489c <test_ctor>:

struct test_object {
    char test_member[TEST_OBJECT_LENTH];
};

static void test_ctor(void* objp, struct kmem_cache_t * cachep, size_t size) {
  10489c:	f3 0f 1e fb          	endbr32 
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	83 ec 10             	sub    $0x10,%esp
    char *p = objp;
  1048a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (int i = 0; i < size; i++)
  1048ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1048b3:	eb 0e                	jmp    1048c3 <test_ctor+0x27>
        p[i] = TEST_OBJECT_CTVAL;
  1048b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1048b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048bb:	01 d0                	add    %edx,%eax
  1048bd:	c6 00 22             	movb   $0x22,(%eax)
    for (int i = 0; i < size; i++)
  1048c0:	ff 45 fc             	incl   -0x4(%ebp)
  1048c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1048c6:	39 45 10             	cmp    %eax,0x10(%ebp)
  1048c9:	77 ea                	ja     1048b5 <test_ctor+0x19>
}
  1048cb:	90                   	nop
  1048cc:	90                   	nop
  1048cd:	c9                   	leave  
  1048ce:	c3                   	ret    

001048cf <test_dtor>:

static void test_dtor(void* objp, struct kmem_cache_t * cachep, size_t size) {
  1048cf:	f3 0f 1e fb          	endbr32 
  1048d3:	55                   	push   %ebp
  1048d4:	89 e5                	mov    %esp,%ebp
  1048d6:	83 ec 10             	sub    $0x10,%esp
    char *p = objp;
  1048d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1048dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (int i = 0; i < size; i++)
  1048df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1048e6:	eb 0e                	jmp    1048f6 <test_dtor+0x27>
        p[i] = TEST_OBJECT_DTVAL;
  1048e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1048eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048ee:	01 d0                	add    %edx,%eax
  1048f0:	c6 00 11             	movb   $0x11,(%eax)
    for (int i = 0; i < size; i++)
  1048f3:	ff 45 fc             	incl   -0x4(%ebp)
  1048f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1048f9:	39 45 10             	cmp    %eax,0x10(%ebp)
  1048fc:	77 ea                	ja     1048e8 <test_dtor+0x19>
}
  1048fe:	90                   	nop
  1048ff:	90                   	nop
  104900:	c9                   	leave  
  104901:	c3                   	ret    

00104902 <list_length>:

static size_t list_length(list_entry_t *listelm) {
  104902:	f3 0f 1e fb          	endbr32 
  104906:	55                   	push   %ebp
  104907:	89 e5                	mov    %esp,%ebp
  104909:	83 ec 10             	sub    $0x10,%esp
    size_t len = 0;
  10490c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    list_entry_t *le = listelm;
  104913:	8b 45 08             	mov    0x8(%ebp),%eax
  104916:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while ((le = list_next(le)) != listelm)
  104919:	eb 03                	jmp    10491e <list_length+0x1c>
        len ++;
  10491b:	ff 45 fc             	incl   -0x4(%ebp)
  10491e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104921:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return listelm->next;
  104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104927:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != listelm)
  10492a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10492d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104930:	3b 45 08             	cmp    0x8(%ebp),%eax
  104933:	75 e6                	jne    10491b <list_length+0x19>
    return len;
  104935:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104938:	c9                   	leave  
  104939:	c3                   	ret    

0010493a <check_kmem>:

static void check_kmem() {
  10493a:	f3 0f 1e fb          	endbr32 
  10493e:	55                   	push   %ebp
  10493f:	89 e5                	mov    %esp,%ebp
  104941:	53                   	push   %ebx
  104942:	83 ec 54             	sub    $0x54,%esp

    assert(sizeof(struct Page) == sizeof(struct slab_t));

    size_t fp = nr_free_pages();
  104945:	e8 bf e5 ff ff       	call   102f09 <nr_free_pages>
  10494a:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // Create a cache 
    struct kmem_cache_t *cp0 = kmem_cache_create(test_object_name, sizeof(struct test_object), test_ctor, test_dtor);
  10494d:	a1 40 0a 12 00       	mov    0x120a40,%eax
  104952:	c7 44 24 0c cf 48 10 	movl   $0x1048cf,0xc(%esp)
  104959:	00 
  10495a:	c7 44 24 08 9c 48 10 	movl   $0x10489c,0x8(%esp)
  104961:	00 
  104962:	c7 44 24 04 fe 07 00 	movl   $0x7fe,0x4(%esp)
  104969:	00 
  10496a:	89 04 24             	mov    %eax,(%esp)
  10496d:	e8 c6 06 00 00       	call   105038 <kmem_cache_create>
  104972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(cp0 != NULL);
  104975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104979:	75 24                	jne    10499f <check_kmem+0x65>
  10497b:	c7 44 24 0c da 92 10 	movl   $0x1092da,0xc(%esp)
  104982:	00 
  104983:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  10498a:	00 
  10498b:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  104992:	00 
  104993:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  10499a:	e8 96 ba ff ff       	call   100435 <__panic>
    assert(kmem_cache_size(cp0) == sizeof(struct test_object));
  10499f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049a2:	89 04 24             	mov    %eax,(%esp)
  1049a5:	e8 c0 0c 00 00       	call   10566a <kmem_cache_size>
  1049aa:	3d fe 07 00 00       	cmp    $0x7fe,%eax
  1049af:	74 24                	je     1049d5 <check_kmem+0x9b>
  1049b1:	c7 44 24 0c 0c 93 10 	movl   $0x10930c,0xc(%esp)
  1049b8:	00 
  1049b9:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  1049c0:	00 
  1049c1:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  1049c8:	00 
  1049c9:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  1049d0:	e8 60 ba ff ff       	call   100435 <__panic>
    assert(strcmp(kmem_cache_name(cp0), test_object_name) == 0);
  1049d5:	8b 1d 40 0a 12 00    	mov    0x120a40,%ebx
  1049db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049de:	89 04 24             	mov    %eax,(%esp)
  1049e1:	e8 94 0c 00 00       	call   10567a <kmem_cache_name>
  1049e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1049ea:	89 04 24             	mov    %eax,(%esp)
  1049ed:	e8 50 30 00 00       	call   107a42 <strcmp>
  1049f2:	85 c0                	test   %eax,%eax
  1049f4:	74 24                	je     104a1a <check_kmem+0xe0>
  1049f6:	c7 44 24 0c 40 93 10 	movl   $0x109340,0xc(%esp)
  1049fd:	00 
  1049fe:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104a05:	00 
  104a06:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  104a0d:	00 
  104a0e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104a15:	e8 1b ba ff ff       	call   100435 <__panic>
    // Allocate six objects
    struct test_object *p0, *p1, *p2, *p3, *p4, *p5;
    char *p;
    assert((p0 = kmem_cache_alloc(cp0)) != NULL);
  104a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a1d:	89 04 24             	mov    %eax,(%esp)
  104a20:	e8 70 08 00 00       	call   105295 <kmem_cache_alloc>
  104a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104a2c:	75 24                	jne    104a52 <check_kmem+0x118>
  104a2e:	c7 44 24 0c 74 93 10 	movl   $0x109374,0xc(%esp)
  104a35:	00 
  104a36:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104a3d:	00 
  104a3e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  104a45:	00 
  104a46:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104a4d:	e8 e3 b9 ff ff       	call   100435 <__panic>
    assert((p1 = kmem_cache_alloc(cp0)) != NULL);
  104a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a55:	89 04 24             	mov    %eax,(%esp)
  104a58:	e8 38 08 00 00       	call   105295 <kmem_cache_alloc>
  104a5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104a60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104a64:	75 24                	jne    104a8a <check_kmem+0x150>
  104a66:	c7 44 24 0c 9c 93 10 	movl   $0x10939c,0xc(%esp)
  104a6d:	00 
  104a6e:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104a75:	00 
  104a76:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104a7d:	00 
  104a7e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104a85:	e8 ab b9 ff ff       	call   100435 <__panic>
    assert((p2 = kmem_cache_alloc(cp0)) != NULL);
  104a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a8d:	89 04 24             	mov    %eax,(%esp)
  104a90:	e8 00 08 00 00       	call   105295 <kmem_cache_alloc>
  104a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104a98:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104a9c:	75 24                	jne    104ac2 <check_kmem+0x188>
  104a9e:	c7 44 24 0c c4 93 10 	movl   $0x1093c4,0xc(%esp)
  104aa5:	00 
  104aa6:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104aad:	00 
  104aae:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  104ab5:	00 
  104ab6:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104abd:	e8 73 b9 ff ff       	call   100435 <__panic>
    assert((p3 = kmem_cache_alloc(cp0)) != NULL);
  104ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ac5:	89 04 24             	mov    %eax,(%esp)
  104ac8:	e8 c8 07 00 00       	call   105295 <kmem_cache_alloc>
  104acd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104ad0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  104ad4:	75 24                	jne    104afa <check_kmem+0x1c0>
  104ad6:	c7 44 24 0c ec 93 10 	movl   $0x1093ec,0xc(%esp)
  104add:	00 
  104ade:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104ae5:	00 
  104ae6:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  104aed:	00 
  104aee:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104af5:	e8 3b b9 ff ff       	call   100435 <__panic>
    assert((p4 = kmem_cache_alloc(cp0)) != NULL);
  104afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104afd:	89 04 24             	mov    %eax,(%esp)
  104b00:	e8 90 07 00 00       	call   105295 <kmem_cache_alloc>
  104b05:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104b08:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  104b0c:	75 24                	jne    104b32 <check_kmem+0x1f8>
  104b0e:	c7 44 24 0c 14 94 10 	movl   $0x109414,0xc(%esp)
  104b15:	00 
  104b16:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104b1d:	00 
  104b1e:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  104b25:	00 
  104b26:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104b2d:	e8 03 b9 ff ff       	call   100435 <__panic>
    p = (char *) p4;
  104b32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b35:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
  104b38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104b3f:	eb 36                	jmp    104b77 <check_kmem+0x23d>
        assert(p[i] == TEST_OBJECT_CTVAL);
  104b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104b47:	01 d0                	add    %edx,%eax
  104b49:	0f b6 00             	movzbl (%eax),%eax
  104b4c:	3c 22                	cmp    $0x22,%al
  104b4e:	74 24                	je     104b74 <check_kmem+0x23a>
  104b50:	c7 44 24 0c 39 94 10 	movl   $0x109439,0xc(%esp)
  104b57:	00 
  104b58:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104b5f:	00 
  104b60:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  104b67:	00 
  104b68:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104b6f:	e8 c1 b8 ff ff       	call   100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
  104b74:	ff 45 f4             	incl   -0xc(%ebp)
  104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b7a:	3d fd 07 00 00       	cmp    $0x7fd,%eax
  104b7f:	76 c0                	jbe    104b41 <check_kmem+0x207>
    assert((p5 = kmem_cache_zalloc(cp0)) != NULL);
  104b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b84:	89 04 24             	mov    %eax,(%esp)
  104b87:	e8 fb 08 00 00       	call   105487 <kmem_cache_zalloc>
  104b8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104b8f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104b93:	75 24                	jne    104bb9 <check_kmem+0x27f>
  104b95:	c7 44 24 0c 54 94 10 	movl   $0x109454,0xc(%esp)
  104b9c:	00 
  104b9d:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104ba4:	00 
  104ba5:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  104bac:	00 
  104bad:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104bb4:	e8 7c b8 ff ff       	call   100435 <__panic>
    p = (char *) p5;
  104bb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
  104bbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104bc6:	eb 36                	jmp    104bfe <check_kmem+0x2c4>
        assert(p[i] == 0);
  104bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104bce:	01 d0                	add    %edx,%eax
  104bd0:	0f b6 00             	movzbl (%eax),%eax
  104bd3:	84 c0                	test   %al,%al
  104bd5:	74 24                	je     104bfb <check_kmem+0x2c1>
  104bd7:	c7 44 24 0c 7a 94 10 	movl   $0x10947a,0xc(%esp)
  104bde:	00 
  104bdf:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104be6:	00 
  104be7:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  104bee:	00 
  104bef:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104bf6:	e8 3a b8 ff ff       	call   100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
  104bfb:	ff 45 f0             	incl   -0x10(%ebp)
  104bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c01:	3d fd 07 00 00       	cmp    $0x7fd,%eax
  104c06:	76 c0                	jbe    104bc8 <check_kmem+0x28e>
    assert(nr_free_pages()+3 == fp);
  104c08:	e8 fc e2 ff ff       	call   102f09 <nr_free_pages>
  104c0d:	83 c0 03             	add    $0x3,%eax
  104c10:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104c13:	74 24                	je     104c39 <check_kmem+0x2ff>
  104c15:	c7 44 24 0c 84 94 10 	movl   $0x109484,0xc(%esp)
  104c1c:	00 
  104c1d:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104c24:	00 
  104c25:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  104c2c:	00 
  104c2d:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104c34:	e8 fc b7 ff ff       	call   100435 <__panic>
    assert(list_empty(&(cp0->slabs_free)));
  104c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c3c:	83 c0 10             	add    $0x10,%eax
  104c3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return list->next == list;
  104c42:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104c45:	8b 40 04             	mov    0x4(%eax),%eax
  104c48:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
  104c4b:	0f 94 c0             	sete   %al
  104c4e:	0f b6 c0             	movzbl %al,%eax
  104c51:	85 c0                	test   %eax,%eax
  104c53:	75 24                	jne    104c79 <check_kmem+0x33f>
  104c55:	c7 44 24 0c 9c 94 10 	movl   $0x10949c,0xc(%esp)
  104c5c:	00 
  104c5d:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104c64:	00 
  104c65:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  104c6c:	00 
  104c6d:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104c74:	e8 bc b7 ff ff       	call   100435 <__panic>
    assert(list_empty(&(cp0->slabs_partial)));
  104c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c7c:	83 c0 08             	add    $0x8,%eax
  104c7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104c82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104c85:	8b 40 04             	mov    0x4(%eax),%eax
  104c88:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  104c8b:	0f 94 c0             	sete   %al
  104c8e:	0f b6 c0             	movzbl %al,%eax
  104c91:	85 c0                	test   %eax,%eax
  104c93:	75 24                	jne    104cb9 <check_kmem+0x37f>
  104c95:	c7 44 24 0c bc 94 10 	movl   $0x1094bc,0xc(%esp)
  104c9c:	00 
  104c9d:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104ca4:	00 
  104ca5:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  104cac:	00 
  104cad:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104cb4:	e8 7c b7 ff ff       	call   100435 <__panic>
    assert(list_length(&(cp0->slabs_full)) == 3);
  104cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cbc:	89 04 24             	mov    %eax,(%esp)
  104cbf:	e8 3e fc ff ff       	call   104902 <list_length>
  104cc4:	83 f8 03             	cmp    $0x3,%eax
  104cc7:	74 24                	je     104ced <check_kmem+0x3b3>
  104cc9:	c7 44 24 0c e0 94 10 	movl   $0x1094e0,0xc(%esp)
  104cd0:	00 
  104cd1:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104cd8:	00 
  104cd9:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  104ce0:	00 
  104ce1:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104ce8:	e8 48 b7 ff ff       	call   100435 <__panic>
    // Free three objects 
    kmem_cache_free(cp0, p3);
  104ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cf7:	89 04 24             	mov    %eax,(%esp)
  104cfa:	e8 c3 07 00 00       	call   1054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p4);
  104cff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d09:	89 04 24             	mov    %eax,(%esp)
  104d0c:	e8 b1 07 00 00       	call   1054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p5);
  104d11:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d1b:	89 04 24             	mov    %eax,(%esp)
  104d1e:	e8 9f 07 00 00       	call   1054c2 <kmem_cache_free>
    assert(list_length(&(cp0->slabs_free)) == 1);
  104d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d26:	83 c0 10             	add    $0x10,%eax
  104d29:	89 04 24             	mov    %eax,(%esp)
  104d2c:	e8 d1 fb ff ff       	call   104902 <list_length>
  104d31:	83 f8 01             	cmp    $0x1,%eax
  104d34:	74 24                	je     104d5a <check_kmem+0x420>
  104d36:	c7 44 24 0c 08 95 10 	movl   $0x109508,0xc(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104d45:	00 
  104d46:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  104d4d:	00 
  104d4e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104d55:	e8 db b6 ff ff       	call   100435 <__panic>
    assert(list_length(&(cp0->slabs_partial)) == 1);
  104d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d5d:	83 c0 08             	add    $0x8,%eax
  104d60:	89 04 24             	mov    %eax,(%esp)
  104d63:	e8 9a fb ff ff       	call   104902 <list_length>
  104d68:	83 f8 01             	cmp    $0x1,%eax
  104d6b:	74 24                	je     104d91 <check_kmem+0x457>
  104d6d:	c7 44 24 0c 30 95 10 	movl   $0x109530,0xc(%esp)
  104d74:	00 
  104d75:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104d7c:	00 
  104d7d:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  104d84:	00 
  104d85:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104d8c:	e8 a4 b6 ff ff       	call   100435 <__panic>
    assert(list_length(&(cp0->slabs_full)) == 1);
  104d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d94:	89 04 24             	mov    %eax,(%esp)
  104d97:	e8 66 fb ff ff       	call   104902 <list_length>
  104d9c:	83 f8 01             	cmp    $0x1,%eax
  104d9f:	74 24                	je     104dc5 <check_kmem+0x48b>
  104da1:	c7 44 24 0c 58 95 10 	movl   $0x109558,0xc(%esp)
  104da8:	00 
  104da9:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104db0:	00 
  104db1:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  104db8:	00 
  104db9:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104dc0:	e8 70 b6 ff ff       	call   100435 <__panic>
    // Shrink cache 
    assert(kmem_cache_shrink(cp0) == 1);
  104dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dc8:	89 04 24             	mov    %eax,(%esp)
  104dcb:	e8 b9 08 00 00       	call   105689 <kmem_cache_shrink>
  104dd0:	83 f8 01             	cmp    $0x1,%eax
  104dd3:	74 24                	je     104df9 <check_kmem+0x4bf>
  104dd5:	c7 44 24 0c 7d 95 10 	movl   $0x10957d,0xc(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104de4:	00 
  104de5:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  104dec:	00 
  104ded:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104df4:	e8 3c b6 ff ff       	call   100435 <__panic>
    assert(nr_free_pages()+2 == fp);
  104df9:	e8 0b e1 ff ff       	call   102f09 <nr_free_pages>
  104dfe:	83 c0 02             	add    $0x2,%eax
  104e01:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104e04:	74 24                	je     104e2a <check_kmem+0x4f0>
  104e06:	c7 44 24 0c 99 95 10 	movl   $0x109599,0xc(%esp)
  104e0d:	00 
  104e0e:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104e15:	00 
  104e16:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
  104e1d:	00 
  104e1e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104e25:	e8 0b b6 ff ff       	call   100435 <__panic>
    assert(list_empty(&(cp0->slabs_free)));
  104e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e2d:	83 c0 10             	add    $0x10,%eax
  104e30:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104e33:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104e36:	8b 40 04             	mov    0x4(%eax),%eax
  104e39:	39 45 bc             	cmp    %eax,-0x44(%ebp)
  104e3c:	0f 94 c0             	sete   %al
  104e3f:	0f b6 c0             	movzbl %al,%eax
  104e42:	85 c0                	test   %eax,%eax
  104e44:	75 24                	jne    104e6a <check_kmem+0x530>
  104e46:	c7 44 24 0c 9c 94 10 	movl   $0x10949c,0xc(%esp)
  104e4d:	00 
  104e4e:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104e55:	00 
  104e56:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  104e5d:	00 
  104e5e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104e65:	e8 cb b5 ff ff       	call   100435 <__panic>
    p = (char *) p4;
  104e6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104e6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
  104e70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104e77:	eb 36                	jmp    104eaf <check_kmem+0x575>
        assert(p[i] == TEST_OBJECT_DTVAL);
  104e79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104e7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104e7f:	01 d0                	add    %edx,%eax
  104e81:	0f b6 00             	movzbl (%eax),%eax
  104e84:	3c 11                	cmp    $0x11,%al
  104e86:	74 24                	je     104eac <check_kmem+0x572>
  104e88:	c7 44 24 0c b1 95 10 	movl   $0x1095b1,0xc(%esp)
  104e8f:	00 
  104e90:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104e97:	00 
  104e98:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  104e9f:	00 
  104ea0:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104ea7:	e8 89 b5 ff ff       	call   100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
  104eac:	ff 45 ec             	incl   -0x14(%ebp)
  104eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104eb2:	3d fd 07 00 00       	cmp    $0x7fd,%eax
  104eb7:	76 c0                	jbe    104e79 <check_kmem+0x53f>
    // Reap cache 
    kmem_cache_free(cp0, p0);
  104eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ec3:	89 04 24             	mov    %eax,(%esp)
  104ec6:	e8 f7 05 00 00       	call   1054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p1);
  104ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ed5:	89 04 24             	mov    %eax,(%esp)
  104ed8:	e8 e5 05 00 00       	call   1054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p2);
  104edd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ee7:	89 04 24             	mov    %eax,(%esp)
  104eea:	e8 d3 05 00 00       	call   1054c2 <kmem_cache_free>
    assert(kmem_cache_reap() == 2);
  104eef:	e8 f7 07 00 00       	call   1056eb <kmem_cache_reap>
  104ef4:	83 f8 02             	cmp    $0x2,%eax
  104ef7:	74 24                	je     104f1d <check_kmem+0x5e3>
  104ef9:	c7 44 24 0c cb 95 10 	movl   $0x1095cb,0xc(%esp)
  104f00:	00 
  104f01:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104f08:	00 
  104f09:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  104f10:	00 
  104f11:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104f18:	e8 18 b5 ff ff       	call   100435 <__panic>
    assert(nr_free_pages() == fp);
  104f1d:	e8 e7 df ff ff       	call   102f09 <nr_free_pages>
  104f22:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104f25:	74 24                	je     104f4b <check_kmem+0x611>
  104f27:	c7 44 24 0c e2 95 10 	movl   $0x1095e2,0xc(%esp)
  104f2e:	00 
  104f2f:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104f36:	00 
  104f37:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  104f3e:	00 
  104f3f:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104f46:	e8 ea b4 ff ff       	call   100435 <__panic>
    // Destory a cache 
    kmem_cache_destroy(cp0);
  104f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f4e:	89 04 24             	mov    %eax,(%esp)
  104f51:	e8 3e 02 00 00       	call   105194 <kmem_cache_destroy>

    // Sized alloc 
    assert((p0 = kmalloc(2048)) != NULL);
  104f56:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  104f5d:	e8 d1 07 00 00       	call   105733 <kmalloc>
  104f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104f65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104f69:	75 24                	jne    104f8f <check_kmem+0x655>
  104f6b:	c7 44 24 0c f8 95 10 	movl   $0x1095f8,0xc(%esp)
  104f72:	00 
  104f73:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104f7a:	00 
  104f7b:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  104f82:	00 
  104f83:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104f8a:	e8 a6 b4 ff ff       	call   100435 <__panic>
    assert(nr_free_pages()+1 == fp);
  104f8f:	e8 75 df ff ff       	call   102f09 <nr_free_pages>
  104f94:	40                   	inc    %eax
  104f95:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104f98:	74 24                	je     104fbe <check_kmem+0x684>
  104f9a:	c7 44 24 0c 15 96 10 	movl   $0x109615,0xc(%esp)
  104fa1:	00 
  104fa2:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104fa9:	00 
  104faa:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  104fb1:	00 
  104fb2:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104fb9:	e8 77 b4 ff ff       	call   100435 <__panic>
    kfree(p0);
  104fbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fc1:	89 04 24             	mov    %eax,(%esp)
  104fc4:	e8 bd 07 00 00       	call   105786 <kfree>
    assert(kmem_cache_reap() == 1);
  104fc9:	e8 1d 07 00 00       	call   1056eb <kmem_cache_reap>
  104fce:	83 f8 01             	cmp    $0x1,%eax
  104fd1:	74 24                	je     104ff7 <check_kmem+0x6bd>
  104fd3:	c7 44 24 0c 2d 96 10 	movl   $0x10962d,0xc(%esp)
  104fda:	00 
  104fdb:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  104fe2:	00 
  104fe3:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  104fea:	00 
  104feb:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  104ff2:	e8 3e b4 ff ff       	call   100435 <__panic>
    assert(nr_free_pages() == fp);
  104ff7:	e8 0d df ff ff       	call   102f09 <nr_free_pages>
  104ffc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104fff:	74 24                	je     105025 <check_kmem+0x6eb>
  105001:	c7 44 24 0c e2 95 10 	movl   $0x1095e2,0xc(%esp)
  105008:	00 
  105009:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  105010:	00 
  105011:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  105018:	00 
  105019:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  105020:	e8 10 b4 ff ff       	call   100435 <__panic>

    cprintf("check_kmem() succeeded!\n");
  105025:	c7 04 24 44 96 10 00 	movl   $0x109644,(%esp)
  10502c:	e8 98 b2 ff ff       	call   1002c9 <cprintf>

}
  105031:	90                   	nop
  105032:	83 c4 54             	add    $0x54,%esp
  105035:	5b                   	pop    %ebx
  105036:	5d                   	pop    %ebp
  105037:	c3                   	ret    

00105038 <kmem_cache_create>:
// ! End of test code

// kmem_cache_create - create a kmem_cache
struct kmem_cache_t * kmem_cache_create(const char *name, size_t size,
                       void (*ctor)(void*, struct kmem_cache_t *, size_t),
                       void (*dtor)(void*, struct kmem_cache_t *, size_t)) {
  105038:	f3 0f 1e fb          	endbr32 
  10503c:	55                   	push   %ebp
  10503d:	89 e5                	mov    %esp,%ebp
  10503f:	83 ec 48             	sub    $0x48,%esp
    assert(size <= (PGSIZE - 2));
  105042:	81 7d 0c fe 0f 00 00 	cmpl   $0xffe,0xc(%ebp)
  105049:	76 24                	jbe    10506f <kmem_cache_create+0x37>
  10504b:	c7 44 24 0c 5d 96 10 	movl   $0x10965d,0xc(%esp)
  105052:	00 
  105053:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  10505a:	00 
  10505b:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  105062:	00 
  105063:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  10506a:	e8 c6 b3 ff ff       	call   100435 <__panic>
    struct kmem_cache_t *cachep = kmem_cache_alloc(&(cache_cache));
  10506f:	c7 04 24 40 3f 12 00 	movl   $0x123f40,(%esp)
  105076:	e8 1a 02 00 00       	call   105295 <kmem_cache_alloc>
  10507b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (cachep != NULL) {
  10507e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105082:	0f 84 07 01 00 00    	je     10518f <kmem_cache_create+0x157>
        cachep->objsize = size;
  105088:	8b 45 0c             	mov    0xc(%ebp),%eax
  10508b:	0f b7 d0             	movzwl %ax,%edx
  10508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105091:	66 89 50 18          	mov    %dx,0x18(%eax)
        cachep->num = PGSIZE / (sizeof(int16_t) + size);
  105095:	8b 45 0c             	mov    0xc(%ebp),%eax
  105098:	8d 48 02             	lea    0x2(%eax),%ecx
  10509b:	b8 00 10 00 00       	mov    $0x1000,%eax
  1050a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1050a5:	f7 f1                	div    %ecx
  1050a7:	0f b7 d0             	movzwl %ax,%edx
  1050aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050ad:	66 89 50 1a          	mov    %dx,0x1a(%eax)
        cachep->ctor = ctor;
  1050b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050b4:	8b 55 10             	mov    0x10(%ebp),%edx
  1050b7:	89 50 1c             	mov    %edx,0x1c(%eax)
        cachep->dtor = dtor;
  1050ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050bd:	8b 55 14             	mov    0x14(%ebp),%edx
  1050c0:	89 50 20             	mov    %edx,0x20(%eax)
        memcpy(cachep->name, name, CACHE_NAMELEN);
  1050c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050c6:	8d 50 24             	lea    0x24(%eax),%edx
  1050c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1050d0:	00 
  1050d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1050d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050d8:	89 14 24             	mov    %edx,(%esp)
  1050db:	e8 b2 2c 00 00       	call   107d92 <memcpy>
        list_init(&(cachep->slabs_full));
  1050e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    elm->prev = elm->next = elm;
  1050e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1050e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1050ec:	89 50 04             	mov    %edx,0x4(%eax)
  1050ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1050f2:	8b 50 04             	mov    0x4(%eax),%edx
  1050f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1050f8:	89 10                	mov    %edx,(%eax)
}
  1050fa:	90                   	nop
        list_init(&(cachep->slabs_partial));
  1050fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050fe:	83 c0 08             	add    $0x8,%eax
  105101:	89 45 d0             	mov    %eax,-0x30(%ebp)
    elm->prev = elm->next = elm;
  105104:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105107:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10510a:	89 50 04             	mov    %edx,0x4(%eax)
  10510d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105110:	8b 50 04             	mov    0x4(%eax),%edx
  105113:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105116:	89 10                	mov    %edx,(%eax)
}
  105118:	90                   	nop
        list_init(&(cachep->slabs_free));
  105119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10511c:	83 c0 10             	add    $0x10,%eax
  10511f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    elm->prev = elm->next = elm;
  105122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105125:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105128:	89 50 04             	mov    %edx,0x4(%eax)
  10512b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10512e:	8b 50 04             	mov    0x4(%eax),%edx
  105131:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105134:	89 10                	mov    %edx,(%eax)
}
  105136:	90                   	nop
        list_add(&(cache_chain), &(cachep->cache_link));
  105137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10513a:	83 c0 34             	add    $0x34,%eax
  10513d:	c7 45 f0 20 3f 12 00 	movl   $0x123f20,-0x10(%ebp)
  105144:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10514a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10514d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_add(elm, listelm, listelm->next);
  105153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105156:	8b 40 04             	mov    0x4(%eax),%eax
  105159:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10515c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10515f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105162:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105165:	89 45 d8             	mov    %eax,-0x28(%ebp)
    prev->next = next->prev = elm;
  105168:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10516b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10516e:	89 10                	mov    %edx,(%eax)
  105170:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105173:	8b 10                	mov    (%eax),%edx
  105175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105178:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10517b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10517e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105181:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105187:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10518a:	89 10                	mov    %edx,(%eax)
}
  10518c:	90                   	nop
}
  10518d:	90                   	nop
}
  10518e:	90                   	nop
    }
    return cachep;
  10518f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105192:	c9                   	leave  
  105193:	c3                   	ret    

00105194 <kmem_cache_destroy>:

// kmem_cache_destroy - destroy a kmem_cache
void kmem_cache_destroy(struct kmem_cache_t *cachep) {
  105194:	f3 0f 1e fb          	endbr32 
  105198:	55                   	push   %ebp
  105199:	89 e5                	mov    %esp,%ebp
  10519b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head, *le;
    // Destory full slabs
    head = &(cachep->slabs_full);
  10519e:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1051a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
  1051aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051ad:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
  1051b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
  1051b3:	eb 2a                	jmp    1051df <kmem_cache_destroy+0x4b>
        list_entry_t *temp = le;
  1051b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051be:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1051c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051c4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1051c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
  1051ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051cd:	83 e8 0c             	sub    $0xc,%eax
  1051d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1051d7:	89 04 24             	mov    %eax,(%esp)
  1051da:	e8 6d f5 ff ff       	call   10474c <kmem_slab_destroy>
    while (le != head) {
  1051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1051e5:	75 ce                	jne    1051b5 <kmem_cache_destroy+0x21>
    }
    // Destory partial slabs 
    head = &(cachep->slabs_partial);
  1051e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1051ea:	83 c0 08             	add    $0x8,%eax
  1051ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1051f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1051f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1051f9:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
  1051fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
  1051ff:	eb 2a                	jmp    10522b <kmem_cache_destroy+0x97>
        list_entry_t *temp = le;
  105201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105204:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10520a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10520d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105210:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  105213:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
  105216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105219:	83 e8 0c             	sub    $0xc,%eax
  10521c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105220:	8b 45 08             	mov    0x8(%ebp),%eax
  105223:	89 04 24             	mov    %eax,(%esp)
  105226:	e8 21 f5 ff ff       	call   10474c <kmem_slab_destroy>
    while (le != head) {
  10522b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10522e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  105231:	75 ce                	jne    105201 <kmem_cache_destroy+0x6d>
    }
    // Destory free slabs 
    head = &(cachep->slabs_free);
  105233:	8b 45 08             	mov    0x8(%ebp),%eax
  105236:	83 c0 10             	add    $0x10,%eax
  105239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10523c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10523f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105245:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
  105248:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
  10524b:	eb 2a                	jmp    105277 <kmem_cache_destroy+0xe3>
        list_entry_t *temp = le;
  10524d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105250:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105256:	89 45 cc             	mov    %eax,-0x34(%ebp)
  105259:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10525c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  10525f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
  105262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105265:	83 e8 0c             	sub    $0xc,%eax
  105268:	89 44 24 04          	mov    %eax,0x4(%esp)
  10526c:	8b 45 08             	mov    0x8(%ebp),%eax
  10526f:	89 04 24             	mov    %eax,(%esp)
  105272:	e8 d5 f4 ff ff       	call   10474c <kmem_slab_destroy>
    while (le != head) {
  105277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10527a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10527d:	75 ce                	jne    10524d <kmem_cache_destroy+0xb9>
    }
    // Free kmem_cache 
    kmem_cache_free(&(cache_cache), cachep);
  10527f:	8b 45 08             	mov    0x8(%ebp),%eax
  105282:	89 44 24 04          	mov    %eax,0x4(%esp)
  105286:	c7 04 24 40 3f 12 00 	movl   $0x123f40,(%esp)
  10528d:	e8 30 02 00 00       	call   1054c2 <kmem_cache_free>
}   
  105292:	90                   	nop
  105293:	c9                   	leave  
  105294:	c3                   	ret    

00105295 <kmem_cache_alloc>:

// kmem_cache_alloc - allocate an object
void * kmem_cache_alloc(struct kmem_cache_t *cachep) {
  105295:	f3 0f 1e fb          	endbr32 
  105299:	55                   	push   %ebp
  10529a:	89 e5                	mov    %esp,%ebp
  10529c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    list_entry_t *le = NULL;
  1052a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    // Find in partial list 
    if (!list_empty(&(cachep->slabs_partial)))
  1052a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ac:	83 c0 08             	add    $0x8,%eax
  1052af:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return list->next == list;
  1052b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052b5:	8b 40 04             	mov    0x4(%eax),%eax
  1052b8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1052bb:	0f 94 c0             	sete   %al
  1052be:	0f b6 c0             	movzbl %al,%eax
  1052c1:	85 c0                	test   %eax,%eax
  1052c3:	75 14                	jne    1052d9 <kmem_cache_alloc+0x44>
        le = list_next(&(cachep->slabs_partial));
  1052c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1052c8:	83 c0 08             	add    $0x8,%eax
  1052cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return listelm->next;
  1052ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1052d1:	8b 40 04             	mov    0x4(%eax),%eax
  1052d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052d7:	eb 47                	jmp    105320 <kmem_cache_alloc+0x8b>
    // Find in empty list 
    else {
        if (list_empty(&(cachep->slabs_free)) && kmem_cache_grow(cachep) == NULL)
  1052d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1052dc:	83 c0 10             	add    $0x10,%eax
  1052df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return list->next == list;
  1052e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1052e5:	8b 40 04             	mov    0x4(%eax),%eax
  1052e8:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  1052eb:	0f 94 c0             	sete   %al
  1052ee:	0f b6 c0             	movzbl %al,%eax
  1052f1:	85 c0                	test   %eax,%eax
  1052f3:	74 19                	je     10530e <kmem_cache_alloc+0x79>
  1052f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f8:	89 04 24             	mov    %eax,(%esp)
  1052fb:	e8 e5 f2 ff ff       	call   1045e5 <kmem_cache_grow>
  105300:	85 c0                	test   %eax,%eax
  105302:	75 0a                	jne    10530e <kmem_cache_alloc+0x79>
            return NULL;
  105304:	b8 00 00 00 00       	mov    $0x0,%eax
  105309:	e9 77 01 00 00       	jmp    105485 <kmem_cache_alloc+0x1f0>
        le = list_next(&(cachep->slabs_free));
  10530e:	8b 45 08             	mov    0x8(%ebp),%eax
  105311:	83 c0 10             	add    $0x10,%eax
  105314:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
  105317:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10531a:	8b 40 04             	mov    0x4(%eax),%eax
  10531d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105323:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_del(listelm->prev, listelm->next);
  105326:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105329:	8b 40 04             	mov    0x4(%eax),%eax
  10532c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10532f:	8b 12                	mov    (%edx),%edx
  105331:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105334:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next;
  105337:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10533a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10533d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105340:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105343:	8b 55 c8             	mov    -0x38(%ebp),%edx
  105346:	89 10                	mov    %edx,(%eax)
}
  105348:	90                   	nop
}
  105349:	90                   	nop
    }
    // Alloc 
    list_del(le);
    struct slab_t *slab = le2slab(le, page_link);
  10534a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10534d:	83 e8 0c             	sub    $0xc,%eax
  105350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *kva = slab2kva(slab);
  105353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105356:	89 04 24             	mov    %eax,(%esp)
  105359:	e8 33 f2 ff ff       	call   104591 <page2kva>
  10535e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int16_t *bufctl = kva;
  105361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105364:	89 45 e8             	mov    %eax,-0x18(%ebp)
    void *buf = bufctl + cachep->num;
  105367:	8b 45 08             	mov    0x8(%ebp),%eax
  10536a:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  10536e:	8d 14 00             	lea    (%eax,%eax,1),%edx
  105371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105374:	01 d0                	add    %edx,%eax
  105376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    void *objp = buf + slab->free * cachep->objsize;
  105379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10537c:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
  105380:	89 c2                	mov    %eax,%edx
  105382:	8b 45 08             	mov    0x8(%ebp),%eax
  105385:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  105389:	0f af c2             	imul   %edx,%eax
  10538c:	89 c2                	mov    %eax,%edx
  10538e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105391:	01 d0                	add    %edx,%eax
  105393:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Update slab
    slab->inuse ++;
  105396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105399:	0f b7 40 08          	movzwl 0x8(%eax),%eax
  10539d:	40                   	inc    %eax
  10539e:	0f b7 d0             	movzwl %ax,%edx
  1053a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053a4:	66 89 50 08          	mov    %dx,0x8(%eax)
    slab->free = bufctl[slab->free];
  1053a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053ab:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
  1053af:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1053b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053b5:	01 d0                	add    %edx,%eax
  1053b7:	0f bf 00             	movswl (%eax),%eax
  1053ba:	0f b7 d0             	movzwl %ax,%edx
  1053bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c0:	66 89 50 0a          	mov    %dx,0xa(%eax)
    if (slab->inuse == cachep->num)
  1053c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c7:	0f b7 50 08          	movzwl 0x8(%eax),%edx
  1053cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ce:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  1053d2:	39 c2                	cmp    %eax,%edx
  1053d4:	75 55                	jne    10542b <kmem_cache_alloc+0x196>
        list_add(&(cachep->slabs_full), le);
  1053d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1053dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053df:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1053e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1053e5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1053e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1053eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_add(elm, listelm, listelm->next);
  1053ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1053f1:	8b 40 04             	mov    0x4(%eax),%eax
  1053f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1053f7:	89 55 b0             	mov    %edx,-0x50(%ebp)
  1053fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1053fd:	89 55 ac             	mov    %edx,-0x54(%ebp)
  105400:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next->prev = elm;
  105403:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105406:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105409:	89 10                	mov    %edx,(%eax)
  10540b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10540e:	8b 10                	mov    (%eax),%edx
  105410:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105413:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105416:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105419:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10541c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10541f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105422:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105425:	89 10                	mov    %edx,(%eax)
}
  105427:	90                   	nop
}
  105428:	90                   	nop
}
  105429:	eb 57                	jmp    105482 <kmem_cache_alloc+0x1ed>
    else 
        list_add(&(cachep->slabs_partial), le);
  10542b:	8b 45 08             	mov    0x8(%ebp),%eax
  10542e:	83 c0 08             	add    $0x8,%eax
  105431:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  105434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105437:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10543a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10543d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  105440:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105443:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_add(elm, listelm, listelm->next);
  105446:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105449:	8b 40 04             	mov    0x4(%eax),%eax
  10544c:	8b 55 98             	mov    -0x68(%ebp),%edx
  10544f:	89 55 94             	mov    %edx,-0x6c(%ebp)
  105452:	8b 55 9c             	mov    -0x64(%ebp),%edx
  105455:	89 55 90             	mov    %edx,-0x70(%ebp)
  105458:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  10545b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10545e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105461:	89 10                	mov    %edx,(%eax)
  105463:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105466:	8b 10                	mov    (%eax),%edx
  105468:	8b 45 90             	mov    -0x70(%ebp),%eax
  10546b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10546e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105471:	8b 55 8c             	mov    -0x74(%ebp),%edx
  105474:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105477:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10547a:	8b 55 90             	mov    -0x70(%ebp),%edx
  10547d:	89 10                	mov    %edx,(%eax)
}
  10547f:	90                   	nop
}
  105480:	90                   	nop
}
  105481:	90                   	nop
    return objp;
  105482:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
  105485:	c9                   	leave  
  105486:	c3                   	ret    

00105487 <kmem_cache_zalloc>:

// kmem_cache_zalloc - allocate an object and fill it with zero
void * kmem_cache_zalloc(struct kmem_cache_t *cachep) {
  105487:	f3 0f 1e fb          	endbr32 
  10548b:	55                   	push   %ebp
  10548c:	89 e5                	mov    %esp,%ebp
  10548e:	83 ec 28             	sub    $0x28,%esp
    void *objp = kmem_cache_alloc(cachep);
  105491:	8b 45 08             	mov    0x8(%ebp),%eax
  105494:	89 04 24             	mov    %eax,(%esp)
  105497:	e8 f9 fd ff ff       	call   105295 <kmem_cache_alloc>
  10549c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memset(objp, 0, cachep->objsize);
  10549f:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a2:	0f b7 40 18          	movzwl 0x18(%eax),%eax
  1054a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054b1:	00 
  1054b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054b5:	89 04 24             	mov    %eax,(%esp)
  1054b8:	e8 eb 27 00 00       	call   107ca8 <memset>
    return objp;
  1054bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1054c0:	c9                   	leave  
  1054c1:	c3                   	ret    

001054c2 <kmem_cache_free>:

// kmem_cache_free - free an object
void kmem_cache_free(struct kmem_cache_t *cachep, void *objp) {
  1054c2:	f3 0f 1e fb          	endbr32 
  1054c6:	55                   	push   %ebp
  1054c7:	89 e5                	mov    %esp,%ebp
  1054c9:	83 ec 78             	sub    $0x78,%esp
    // Get slab of object 
    void *base = page2kva(pages);
  1054cc:	a1 18 40 12 00       	mov    0x124018,%eax
  1054d1:	89 04 24             	mov    %eax,(%esp)
  1054d4:	e8 b8 f0 ff ff       	call   104591 <page2kva>
  1054d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *kva = ROUNDDOWN(objp, PGSIZE);
  1054dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1054ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct slab_t *slab = (struct slab_t *) &pages[(kva-base)/PGSIZE];
  1054ed:	8b 0d 18 40 12 00    	mov    0x124018,%ecx
  1054f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054f6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1054f9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  1054ff:	85 c0                	test   %eax,%eax
  105501:	0f 48 c2             	cmovs  %edx,%eax
  105504:	c1 f8 0c             	sar    $0xc,%eax
  105507:	89 c2                	mov    %eax,%edx
  105509:	89 d0                	mov    %edx,%eax
  10550b:	c1 e0 02             	shl    $0x2,%eax
  10550e:	01 d0                	add    %edx,%eax
  105510:	c1 e0 02             	shl    $0x2,%eax
  105513:	01 c8                	add    %ecx,%eax
  105515:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // Get offset in slab
    int16_t *bufctl = kva;
  105518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10551b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    void *buf = bufctl + cachep->num;
  10551e:	8b 45 08             	mov    0x8(%ebp),%eax
  105521:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
  105525:	8d 14 00             	lea    (%eax,%eax,1),%edx
  105528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10552b:	01 d0                	add    %edx,%eax
  10552d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    int offset = (objp - buf) / cachep->objsize;
  105530:	8b 45 0c             	mov    0xc(%ebp),%eax
  105533:	2b 45 e0             	sub    -0x20(%ebp),%eax
  105536:	8b 55 08             	mov    0x8(%ebp),%edx
  105539:	0f b7 52 18          	movzwl 0x18(%edx),%edx
  10553d:	89 d1                	mov    %edx,%ecx
  10553f:	99                   	cltd   
  105540:	f7 f9                	idiv   %ecx
  105542:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Update slab 
    list_del(&(slab->slab_link));
  105545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105548:	83 c0 0c             	add    $0xc,%eax
  10554b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_del(listelm->prev, listelm->next);
  10554e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105551:	8b 40 04             	mov    0x4(%eax),%eax
  105554:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105557:	8b 12                	mov    (%edx),%edx
  105559:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10555c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next;
  10555f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105562:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105565:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105568:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10556b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10556e:	89 10                	mov    %edx,(%eax)
}
  105570:	90                   	nop
}
  105571:	90                   	nop
    bufctl[offset] = slab->free;
  105572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105575:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
  105579:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10557c:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
  10557f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105582:	01 ca                	add    %ecx,%edx
  105584:	98                   	cwtl   
  105585:	66 89 02             	mov    %ax,(%edx)
    slab->inuse --;
  105588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10558b:	0f b7 40 08          	movzwl 0x8(%eax),%eax
  10558f:	48                   	dec    %eax
  105590:	0f b7 d0             	movzwl %ax,%edx
  105593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105596:	66 89 50 08          	mov    %dx,0x8(%eax)
    slab->free = offset;
  10559a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10559d:	0f b7 d0             	movzwl %ax,%edx
  1055a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055a3:	66 89 50 0a          	mov    %dx,0xa(%eax)
    if (slab->inuse == 0)
  1055a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055aa:	0f b7 40 08          	movzwl 0x8(%eax),%eax
  1055ae:	85 c0                	test   %eax,%eax
  1055b0:	75 5b                	jne    10560d <kmem_cache_free+0x14b>
        list_add(&(cachep->slabs_free), &(slab->slab_link));
  1055b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055b5:	83 c0 0c             	add    $0xc,%eax
  1055b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055bb:	83 c2 10             	add    $0x10,%edx
  1055be:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1055c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1055c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1055c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1055ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1055cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_add(elm, listelm, listelm->next);
  1055d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1055d3:	8b 40 04             	mov    0x4(%eax),%eax
  1055d6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1055d9:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1055dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1055df:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1055e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next->prev = elm;
  1055e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1055e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1055eb:	89 10                	mov    %edx,(%eax)
  1055ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1055f0:	8b 10                	mov    (%eax),%edx
  1055f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1055f5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1055f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1055fb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1055fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105601:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105604:	8b 55 b8             	mov    -0x48(%ebp),%edx
  105607:	89 10                	mov    %edx,(%eax)
}
  105609:	90                   	nop
}
  10560a:	90                   	nop
}
  10560b:	eb 5a                	jmp    105667 <kmem_cache_free+0x1a5>
    else 
        list_add(&(cachep->slabs_partial), &(slab->slab_link));
  10560d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105610:	83 c0 0c             	add    $0xc,%eax
  105613:	8b 55 08             	mov    0x8(%ebp),%edx
  105616:	83 c2 08             	add    $0x8,%edx
  105619:	89 55 b0             	mov    %edx,-0x50(%ebp)
  10561c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10561f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105622:	89 45 a8             	mov    %eax,-0x58(%ebp)
  105625:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105628:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_add(elm, listelm, listelm->next);
  10562b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10562e:	8b 40 04             	mov    0x4(%eax),%eax
  105631:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  105634:	89 55 a0             	mov    %edx,-0x60(%ebp)
  105637:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10563a:	89 55 9c             	mov    %edx,-0x64(%ebp)
  10563d:	89 45 98             	mov    %eax,-0x68(%ebp)
    prev->next = next->prev = elm;
  105640:	8b 45 98             	mov    -0x68(%ebp),%eax
  105643:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105646:	89 10                	mov    %edx,(%eax)
  105648:	8b 45 98             	mov    -0x68(%ebp),%eax
  10564b:	8b 10                	mov    (%eax),%edx
  10564d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105650:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105653:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105656:	8b 55 98             	mov    -0x68(%ebp),%edx
  105659:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10565c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10565f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  105662:	89 10                	mov    %edx,(%eax)
}
  105664:	90                   	nop
}
  105665:	90                   	nop
}
  105666:	90                   	nop
}
  105667:	90                   	nop
  105668:	c9                   	leave  
  105669:	c3                   	ret    

0010566a <kmem_cache_size>:

// kmem_cache_size - get object size
size_t kmem_cache_size(struct kmem_cache_t *cachep) {
  10566a:	f3 0f 1e fb          	endbr32 
  10566e:	55                   	push   %ebp
  10566f:	89 e5                	mov    %esp,%ebp
    return cachep->objsize;
  105671:	8b 45 08             	mov    0x8(%ebp),%eax
  105674:	0f b7 40 18          	movzwl 0x18(%eax),%eax
}
  105678:	5d                   	pop    %ebp
  105679:	c3                   	ret    

0010567a <kmem_cache_name>:

// kmem_cache_name - get cache name
const char * kmem_cache_name(struct kmem_cache_t *cachep) {
  10567a:	f3 0f 1e fb          	endbr32 
  10567e:	55                   	push   %ebp
  10567f:	89 e5                	mov    %esp,%ebp
    return cachep->name;
  105681:	8b 45 08             	mov    0x8(%ebp),%eax
  105684:	83 c0 24             	add    $0x24,%eax
}
  105687:	5d                   	pop    %ebp
  105688:	c3                   	ret    

00105689 <kmem_cache_shrink>:

// kmem_cache_shrink - destroy all slabs in free list 
int kmem_cache_shrink(struct kmem_cache_t *cachep) {
  105689:	f3 0f 1e fb          	endbr32 
  10568d:	55                   	push   %ebp
  10568e:	89 e5                	mov    %esp,%ebp
  105690:	83 ec 38             	sub    $0x38,%esp
    int count = 0;
  105693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = list_next(&(cachep->slabs_free));
  10569a:	8b 45 08             	mov    0x8(%ebp),%eax
  10569d:	83 c0 10             	add    $0x10,%eax
  1056a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return listelm->next;
  1056a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056a6:	8b 40 04             	mov    0x4(%eax),%eax
  1056a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &(cachep->slabs_free)) {
  1056ac:	eb 2d                	jmp    1056db <kmem_cache_shrink+0x52>
        list_entry_t *temp = le;
  1056ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056bd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1056c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
  1056c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1056c6:	83 e8 0c             	sub    $0xc,%eax
  1056c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d0:	89 04 24             	mov    %eax,(%esp)
  1056d3:	e8 74 f0 ff ff       	call   10474c <kmem_slab_destroy>
        count ++;
  1056d8:	ff 45 f4             	incl   -0xc(%ebp)
    while (le != &(cachep->slabs_free)) {
  1056db:	8b 45 08             	mov    0x8(%ebp),%eax
  1056de:	83 c0 10             	add    $0x10,%eax
  1056e1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1056e4:	75 c8                	jne    1056ae <kmem_cache_shrink+0x25>
    }
    return count;
  1056e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1056e9:	c9                   	leave  
  1056ea:	c3                   	ret    

001056eb <kmem_cache_reap>:

// kmem_cache_reap - reap all free slabs 
int kmem_cache_reap() {
  1056eb:	f3 0f 1e fb          	endbr32 
  1056ef:	55                   	push   %ebp
  1056f0:	89 e5                	mov    %esp,%ebp
  1056f2:	83 ec 28             	sub    $0x28,%esp
    int count = 0;
  1056f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &(cache_chain);
  1056fc:	c7 45 f0 20 3f 12 00 	movl   $0x123f20,-0x10(%ebp)
    while ((le = list_next(le)) != &(cache_chain))
  105703:	eb 11                	jmp    105716 <kmem_cache_reap+0x2b>
        count += kmem_cache_shrink(to_struct(le, struct kmem_cache_t, cache_link));
  105705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105708:	83 e8 34             	sub    $0x34,%eax
  10570b:	89 04 24             	mov    %eax,(%esp)
  10570e:	e8 76 ff ff ff       	call   105689 <kmem_cache_shrink>
  105713:	01 45 f4             	add    %eax,-0xc(%ebp)
  105716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105719:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10571c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10571f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &(cache_chain))
  105722:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105725:	81 7d f0 20 3f 12 00 	cmpl   $0x123f20,-0x10(%ebp)
  10572c:	75 d7                	jne    105705 <kmem_cache_reap+0x1a>
    return count;
  10572e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105731:	c9                   	leave  
  105732:	c3                   	ret    

00105733 <kmalloc>:

void * kmalloc(size_t size) {
  105733:	f3 0f 1e fb          	endbr32 
  105737:	55                   	push   %ebp
  105738:	89 e5                	mov    %esp,%ebp
  10573a:	83 ec 18             	sub    $0x18,%esp
    assert(size <= SIZED_CACHE_MAX);
  10573d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  105744:	76 24                	jbe    10576a <kmalloc+0x37>
  105746:	c7 44 24 0c 72 96 10 	movl   $0x109672,0xc(%esp)
  10574d:	00 
  10574e:	c7 44 24 08 e6 92 10 	movl   $0x1092e6,0x8(%esp)
  105755:	00 
  105756:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  10575d:	00 
  10575e:	c7 04 24 fb 92 10 00 	movl   $0x1092fb,(%esp)
  105765:	e8 cb ac ff ff       	call   100435 <__panic>
    return kmem_cache_alloc(sized_caches[kmem_sized_index(size)]);
  10576a:	8b 45 08             	mov    0x8(%ebp),%eax
  10576d:	89 04 24             	mov    %eax,(%esp)
  105770:	e8 bb f0 ff ff       	call   104830 <kmem_sized_index>
  105775:	8b 04 85 80 3f 12 00 	mov    0x123f80(,%eax,4),%eax
  10577c:	89 04 24             	mov    %eax,(%esp)
  10577f:	e8 11 fb ff ff       	call   105295 <kmem_cache_alloc>
}
  105784:	c9                   	leave  
  105785:	c3                   	ret    

00105786 <kfree>:

void kfree(void *objp) {
  105786:	f3 0f 1e fb          	endbr32 
  10578a:	55                   	push   %ebp
  10578b:	89 e5                	mov    %esp,%ebp
  10578d:	83 ec 28             	sub    $0x28,%esp
    void *base = slab2kva(pages);
  105790:	a1 18 40 12 00       	mov    0x124018,%eax
  105795:	89 04 24             	mov    %eax,(%esp)
  105798:	e8 f4 ed ff ff       	call   104591 <page2kva>
  10579d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *kva = ROUNDDOWN(objp, PGSIZE);
  1057a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1057ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct slab_t *slab = (struct slab_t *) &pages[(kva-base)/PGSIZE];
  1057b1:	8b 0d 18 40 12 00    	mov    0x124018,%ecx
  1057b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057ba:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1057bd:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  1057c3:	85 c0                	test   %eax,%eax
  1057c5:	0f 48 c2             	cmovs  %edx,%eax
  1057c8:	c1 f8 0c             	sar    $0xc,%eax
  1057cb:	89 c2                	mov    %eax,%edx
  1057cd:	89 d0                	mov    %edx,%eax
  1057cf:	c1 e0 02             	shl    $0x2,%eax
  1057d2:	01 d0                	add    %edx,%eax
  1057d4:	c1 e0 02             	shl    $0x2,%eax
  1057d7:	01 c8                	add    %ecx,%eax
  1057d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    kmem_cache_free(slab->cachep, objp);
  1057dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057df:	8b 40 04             	mov    0x4(%eax),%eax
  1057e2:	8b 55 08             	mov    0x8(%ebp),%edx
  1057e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057e9:	89 04 24             	mov    %eax,(%esp)
  1057ec:	e8 d1 fc ff ff       	call   1054c2 <kmem_cache_free>
}
  1057f1:	90                   	nop
  1057f2:	c9                   	leave  
  1057f3:	c3                   	ret    

001057f4 <kmem_int>:

void kmem_int() {
  1057f4:	f3 0f 1e fb          	endbr32 
  1057f8:	55                   	push   %ebp
  1057f9:	89 e5                	mov    %esp,%ebp
  1057fb:	83 ec 58             	sub    $0x58,%esp

    // Init cache for kmem_cache
    cache_cache.objsize = sizeof(struct kmem_cache_t);
  1057fe:	66 c7 05 58 3f 12 00 	movw   $0x3c,0x123f58
  105805:	3c 00 
    cache_cache.num = PGSIZE / (sizeof(int16_t) + sizeof(struct kmem_cache_t));
  105807:	66 c7 05 5a 3f 12 00 	movw   $0x42,0x123f5a
  10580e:	42 00 
    cache_cache.ctor = NULL;
  105810:	c7 05 5c 3f 12 00 00 	movl   $0x0,0x123f5c
  105817:	00 00 00 
    cache_cache.dtor = NULL;
  10581a:	c7 05 60 3f 12 00 00 	movl   $0x0,0x123f60
  105821:	00 00 00 
    memcpy(cache_cache.name, cache_cache_name, CACHE_NAMELEN);
  105824:	a1 38 0a 12 00       	mov    0x120a38,%eax
  105829:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105830:	00 
  105831:	89 44 24 04          	mov    %eax,0x4(%esp)
  105835:	c7 04 24 64 3f 12 00 	movl   $0x123f64,(%esp)
  10583c:	e8 51 25 00 00       	call   107d92 <memcpy>
  105841:	c7 45 c4 40 3f 12 00 	movl   $0x123f40,-0x3c(%ebp)
    elm->prev = elm->next = elm;
  105848:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10584b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10584e:	89 50 04             	mov    %edx,0x4(%eax)
  105851:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105854:	8b 50 04             	mov    0x4(%eax),%edx
  105857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10585a:	89 10                	mov    %edx,(%eax)
}
  10585c:	90                   	nop
  10585d:	c7 45 c8 48 3f 12 00 	movl   $0x123f48,-0x38(%ebp)
    elm->prev = elm->next = elm;
  105864:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105867:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10586a:	89 50 04             	mov    %edx,0x4(%eax)
  10586d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105870:	8b 50 04             	mov    0x4(%eax),%edx
  105873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105876:	89 10                	mov    %edx,(%eax)
}
  105878:	90                   	nop
  105879:	c7 45 cc 50 3f 12 00 	movl   $0x123f50,-0x34(%ebp)
    elm->prev = elm->next = elm;
  105880:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105883:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105886:	89 50 04             	mov    %edx,0x4(%eax)
  105889:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10588c:	8b 50 04             	mov    0x4(%eax),%edx
  10588f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105892:	89 10                	mov    %edx,(%eax)
}
  105894:	90                   	nop
  105895:	c7 45 d0 20 3f 12 00 	movl   $0x123f20,-0x30(%ebp)
    elm->prev = elm->next = elm;
  10589c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10589f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1058a2:	89 50 04             	mov    %edx,0x4(%eax)
  1058a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058a8:	8b 50 04             	mov    0x4(%eax),%edx
  1058ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058ae:	89 10                	mov    %edx,(%eax)
}
  1058b0:	90                   	nop
  1058b1:	c7 45 ec 20 3f 12 00 	movl   $0x123f20,-0x14(%ebp)
  1058b8:	c7 45 e8 74 3f 12 00 	movl   $0x123f74,-0x18(%ebp)
  1058bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
  1058cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058ce:	8b 40 04             	mov    0x4(%eax),%eax
  1058d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1058d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1058d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058da:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1058dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
  1058e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1058e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1058e6:	89 10                	mov    %edx,(%eax)
  1058e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1058eb:	8b 10                	mov    (%eax),%edx
  1058ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1058f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1058f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1058f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1058fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105902:	89 10                	mov    %edx,(%eax)
}
  105904:	90                   	nop
}
  105905:	90                   	nop
}
  105906:	90                   	nop
    list_init(&(cache_cache.slabs_free));
    list_init(&(cache_chain));
    list_add(&(cache_chain), &(cache_cache.cache_link));

    // Init sized cache 
    for (int i = 0, size = 16; i < SIZED_CACHE_NUM; i++, size *= 2)
  105907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10590e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
  105915:	eb 34                	jmp    10594b <kmem_int+0x157>
        sized_caches[i] = kmem_cache_create(sized_cache_name, size, NULL, NULL); 
  105917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10591a:	a1 3c 0a 12 00       	mov    0x120a3c,%eax
  10591f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105926:	00 
  105927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10592e:	00 
  10592f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105933:	89 04 24             	mov    %eax,(%esp)
  105936:	e8 fd f6 ff ff       	call   105038 <kmem_cache_create>
  10593b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10593e:	89 04 95 80 3f 12 00 	mov    %eax,0x123f80(,%edx,4)
    for (int i = 0, size = 16; i < SIZED_CACHE_NUM; i++, size *= 2)
  105945:	ff 45 f4             	incl   -0xc(%ebp)
  105948:	d1 65 f0             	shll   -0x10(%ebp)
  10594b:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  10594f:	7e c6                	jle    105917 <kmem_int+0x123>

    check_kmem();
  105951:	e8 e4 ef ff ff       	call   10493a <check_kmem>
  105956:	90                   	nop
  105957:	c9                   	leave  
  105958:	c3                   	ret    

00105959 <page2ppn>:
page2ppn(struct Page *page) {
  105959:	55                   	push   %ebp
  10595a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10595c:	a1 18 40 12 00       	mov    0x124018,%eax
  105961:	8b 55 08             	mov    0x8(%ebp),%edx
  105964:	29 c2                	sub    %eax,%edx
  105966:	89 d0                	mov    %edx,%eax
  105968:	c1 f8 02             	sar    $0x2,%eax
  10596b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  105971:	5d                   	pop    %ebp
  105972:	c3                   	ret    

00105973 <page2pa>:
page2pa(struct Page *page) {
  105973:	55                   	push   %ebp
  105974:	89 e5                	mov    %esp,%ebp
  105976:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  105979:	8b 45 08             	mov    0x8(%ebp),%eax
  10597c:	89 04 24             	mov    %eax,(%esp)
  10597f:	e8 d5 ff ff ff       	call   105959 <page2ppn>
  105984:	c1 e0 0c             	shl    $0xc,%eax
}
  105987:	c9                   	leave  
  105988:	c3                   	ret    

00105989 <page_ref>:
page_ref(struct Page *page) {
  105989:	55                   	push   %ebp
  10598a:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10598c:	8b 45 08             	mov    0x8(%ebp),%eax
  10598f:	8b 00                	mov    (%eax),%eax
}
  105991:	5d                   	pop    %ebp
  105992:	c3                   	ret    

00105993 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  105993:	55                   	push   %ebp
  105994:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  105996:	8b 45 08             	mov    0x8(%ebp),%eax
  105999:	8b 55 0c             	mov    0xc(%ebp),%edx
  10599c:	89 10                	mov    %edx,(%eax)
}
  10599e:	90                   	nop
  10599f:	5d                   	pop    %ebp
  1059a0:	c3                   	ret    

001059a1 <default_init>:
#define free_list (free_area.free_list)             //双向链表指针
#define nr_free (free_area.nr_free)                 //记录当前空闲页的个数的无符号整型变量nr_free

//对free_area_t的双向链表和空闲块的数目进行初始化
static void
default_init(void) {
  1059a1:	f3 0f 1e fb          	endbr32 
  1059a5:	55                   	push   %ebp
  1059a6:	89 e5                	mov    %esp,%ebp
  1059a8:	83 ec 10             	sub    $0x10,%esp
  1059ab:	c7 45 fc 1c 40 12 00 	movl   $0x12401c,-0x4(%ebp)
    elm->prev = elm->next = elm;
  1059b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1059b8:	89 50 04             	mov    %edx,0x4(%eax)
  1059bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059be:	8b 50 04             	mov    0x4(%eax),%edx
  1059c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059c4:	89 10                	mov    %edx,(%eax)
}
  1059c6:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1059c7:	c7 05 24 40 12 00 00 	movl   $0x0,0x124024
  1059ce:	00 00 00 
}
  1059d1:	90                   	nop
  1059d2:	c9                   	leave  
  1059d3:	c3                   	ret    

001059d4 <default_init_memmap>:
然后对每一块物理页进行设置：先判断是否为保留页，如果不是，则进行下一步。
将标志位清0，连续空页个数清0，然后将标志位设置为1，将引用此物理页的虚拟页的个数清0。
然后再加入空闲链表。最后计算空闲页的个数，修改物理基地址页的property的个数为n
*/
static void
default_init_memmap(struct Page *base, size_t n) {  //基地址和物理页数量
  1059d4:	f3 0f 1e fb          	endbr32 
  1059d8:	55                   	push   %ebp
  1059d9:	89 e5                	mov    %esp,%ebp
  1059db:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1059de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059e2:	75 24                	jne    105a08 <default_init_memmap+0x34>
  1059e4:	c7 44 24 0c 8c 96 10 	movl   $0x10968c,0xc(%esp)
  1059eb:	00 
  1059ec:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1059f3:	00 
  1059f4:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  1059fb:	00 
  1059fc:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105a03:	e8 2d aa ff ff       	call   100435 <__panic>
    struct Page *p = base;
  105a08:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {                   //处理每一页
  105a0e:	eb 7d                	jmp    105a8d <default_init_memmap+0xb9>
        assert(PageReserved(p));                    //是否为保留页
  105a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a13:	83 c0 04             	add    $0x4,%eax
  105a16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  105a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a26:	0f a3 10             	bt     %edx,(%eax)
  105a29:	19 c0                	sbb    %eax,%eax
  105a2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  105a2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a32:	0f 95 c0             	setne  %al
  105a35:	0f b6 c0             	movzbl %al,%eax
  105a38:	85 c0                	test   %eax,%eax
  105a3a:	75 24                	jne    105a60 <default_init_memmap+0x8c>
  105a3c:	c7 44 24 0c bd 96 10 	movl   $0x1096bd,0xc(%esp)
  105a43:	00 
  105a44:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  105a4b:	00 
  105a4c:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  105a53:	00 
  105a54:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105a5b:	e8 d5 a9 ff ff       	call   100435 <__panic>
        p->flags = p->property = 0;                 //标志位清零, 空闲块数量
  105a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a6d:	8b 50 08             	mov    0x8(%eax),%edx
  105a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a73:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);                         //将引用此物理页的虚拟页的个数清0
  105a76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105a7d:	00 
  105a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a81:	89 04 24             	mov    %eax,(%esp)
  105a84:	e8 0a ff ff ff       	call   105993 <set_page_ref>
    for (; p != base + n; p ++) {                   //处理每一页
  105a89:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  105a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a90:	89 d0                	mov    %edx,%eax
  105a92:	c1 e0 02             	shl    $0x2,%eax
  105a95:	01 d0                	add    %edx,%eax
  105a97:	c1 e0 02             	shl    $0x2,%eax
  105a9a:	89 c2                	mov    %eax,%edx
  105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9f:	01 d0                	add    %edx,%eax
  105aa1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105aa4:	0f 85 66 ff ff ff    	jne    105a10 <default_init_memmap+0x3c>
    }
    base->property = n;                             //开头页面的空闲块数量设置为n
  105aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  105aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ab0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);      
  105ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab6:	83 c0 04             	add    $0x4,%eax
  105ab9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105ac0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105ac3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105ac6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105ac9:	0f ab 10             	bts    %edx,(%eax)
}
  105acc:	90                   	nop
    nr_free += n;                                   //新增空闲页个数nr_free
  105acd:	8b 15 24 40 12 00    	mov    0x124024,%edx
  105ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad6:	01 d0                	add    %edx,%eax
  105ad8:	a3 24 40 12 00       	mov    %eax,0x124024
    list_add_before(&free_list, &(base->page_link));//将新增的Page加在双向链表指针中
  105add:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae0:	83 c0 0c             	add    $0xc,%eax
  105ae3:	c7 45 e4 1c 40 12 00 	movl   $0x12401c,-0x1c(%ebp)
  105aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm->prev, listelm);
  105aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105af0:	8b 00                	mov    (%eax),%eax
  105af2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105af5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105af8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105afe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
  105b01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105b04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105b07:	89 10                	mov    %edx,(%eax)
  105b09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105b0c:	8b 10                	mov    (%eax),%edx
  105b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b11:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105b14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105b1a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105b1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b20:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105b23:	89 10                	mov    %edx,(%eax)
}
  105b25:	90                   	nop
}
  105b26:	90                   	nop
}
  105b27:	90                   	nop
  105b28:	c9                   	leave  
  105b29:	c3                   	ret    

00105b2a <default_alloc_pages>:
如果当前空闲页的大小大于所需大小。则分割页块。具体操作就是，刚刚分配了n个页，如果分配完了，还有连续的空间，
则在最后分配的那个页的下一个页（未分配），更新它的连续空闲页值。如果正好合适，则不进行操作。
最后计算剩余空闲页个数并返回分配的页块地址。
*/
static struct Page *
default_alloc_pages(size_t n) {
  105b2a:	f3 0f 1e fb          	endbr32 
  105b2e:	55                   	push   %ebp
  105b2f:	89 e5                	mov    %esp,%ebp
  105b31:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);                                              
  105b34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b38:	75 24                	jne    105b5e <default_alloc_pages+0x34>
  105b3a:	c7 44 24 0c 8c 96 10 	movl   $0x10968c,0xc(%esp)
  105b41:	00 
  105b42:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  105b49:	00 
  105b4a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  105b51:	00 
  105b52:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105b59:	e8 d7 a8 ff ff       	call   100435 <__panic>
    if (n > nr_free) {                                              //检查空闲页的大小是否大于所需的页块大小
  105b5e:	a1 24 40 12 00       	mov    0x124024,%eax
  105b63:	39 45 08             	cmp    %eax,0x8(%ebp)
  105b66:	76 0a                	jbe    105b72 <default_alloc_pages+0x48>
        return NULL;
  105b68:	b8 00 00 00 00       	mov    $0x0,%eax
  105b6d:	e9 43 01 00 00       	jmp    105cb5 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  105b72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  105b79:	c7 45 f0 1c 40 12 00 	movl   $0x12401c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {                    //遍历链表找到合适的空闲页
  105b80:	eb 1c                	jmp    105b9e <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  105b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b85:	83 e8 0c             	sub    $0xc,%eax
  105b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {                                     //第一个目标页
  105b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b8e:	8b 40 08             	mov    0x8(%eax),%eax
  105b91:	39 45 08             	cmp    %eax,0x8(%ebp)
  105b94:	77 08                	ja     105b9e <default_alloc_pages+0x74>
            page = p;
  105b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  105b9c:	eb 18                	jmp    105bb6 <default_alloc_pages+0x8c>
  105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  105ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ba7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {                    //遍历链表找到合适的空闲页
  105baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bad:	81 7d f0 1c 40 12 00 	cmpl   $0x12401c,-0x10(%ebp)
  105bb4:	75 cc                	jne    105b82 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {                                             //如果页的空闲块数量大于n 执行分割
  105bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105bba:	0f 84 f2 00 00 00    	je     105cb2 <default_alloc_pages+0x188>
        if (page->property > n) {
  105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bc3:	8b 40 08             	mov    0x8(%eax),%eax
  105bc6:	39 45 08             	cmp    %eax,0x8(%ebp)
  105bc9:	0f 83 8f 00 00 00    	jae    105c5e <default_alloc_pages+0x134>
            struct Page *p = page + n;                              //指针后移n单位
  105bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  105bd2:	89 d0                	mov    %edx,%eax
  105bd4:	c1 e0 02             	shl    $0x2,%eax
  105bd7:	01 d0                	add    %edx,%eax
  105bd9:	c1 e0 02             	shl    $0x2,%eax
  105bdc:	89 c2                	mov    %eax,%edx
  105bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105be1:	01 d0                	add    %edx,%eax
  105be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;                       //数量减n
  105be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105be9:	8b 40 08             	mov    0x8(%eax),%eax
  105bec:	2b 45 08             	sub    0x8(%ebp),%eax
  105bef:	89 c2                	mov    %eax,%edx
  105bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bf4:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                                     //调SetPageProperty设置当前页面预留
  105bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bfa:	83 c0 04             	add    $0x4,%eax
  105bfd:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  105c04:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105c07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105c0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105c0d:	0f ab 10             	bts    %edx,(%eax)
}
  105c10:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));    //链接被分割之后剩下的空闲块地址
  105c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c14:	83 c0 0c             	add    $0xc,%eax
  105c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c1a:	83 c2 0c             	add    $0xc,%edx
  105c1d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  105c20:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  105c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c26:	8b 40 04             	mov    0x4(%eax),%eax
  105c29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105c2c:	89 55 d8             	mov    %edx,-0x28(%ebp)
  105c2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105c32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105c35:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  105c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105c3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105c3e:	89 10                	mov    %edx,(%eax)
  105c40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105c43:	8b 10                	mov    (%eax),%edx
  105c45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105c48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105c4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105c51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c5a:	89 10                	mov    %edx,(%eax)
}
  105c5c:	90                   	nop
}
  105c5d:	90                   	nop
        }
        list_del(&(page->page_link));                               //删除pageLink链接
  105c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c61:	83 c0 0c             	add    $0xc,%eax
  105c64:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  105c67:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105c6a:	8b 40 04             	mov    0x4(%eax),%eax
  105c6d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105c70:	8b 12                	mov    (%edx),%edx
  105c72:	89 55 b8             	mov    %edx,-0x48(%ebp)
  105c75:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
  105c78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105c7b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  105c7e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105c81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105c84:	8b 55 b8             	mov    -0x48(%ebp),%edx
  105c87:	89 10                	mov    %edx,(%eax)
}
  105c89:	90                   	nop
}
  105c8a:	90                   	nop
        nr_free -= n;                                               //更新空闲页个数
  105c8b:	a1 24 40 12 00       	mov    0x124024,%eax
  105c90:	2b 45 08             	sub    0x8(%ebp),%eax
  105c93:	a3 24 40 12 00       	mov    %eax,0x124024
        ClearPageProperty(page);                                    //清空该页面的连续空闲页面数量值
  105c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c9b:	83 c0 04             	add    $0x4,%eax
  105c9e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  105ca5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105ca8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105cab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105cae:	0f b3 10             	btr    %edx,(%eax)
}
  105cb1:	90                   	nop
    }
    return page;
  105cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105cb5:	c9                   	leave  
  105cb6:	c3                   	ret    

00105cb7 <default_free_pages>:
接着，声明一个页p，p遍历一遍整个物理空间，直到遍历到base所在位置停止，开始释放操作
找到了这个基地址之后，将空闲页重新加进来（之前在分配的时候删除），设置一系列标记位
检查合并, 如果插入基地址附近的高地址或低地址可以合并，那么需要更新相应的连续空闲页数量，向高合并和向低合并。
*/
static void
default_free_pages(struct Page *base, size_t n) {
  105cb7:	f3 0f 1e fb          	endbr32 
  105cbb:	55                   	push   %ebp
  105cbc:	89 e5                	mov    %esp,%ebp
  105cbe:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0); 
  105cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105cc8:	75 24                	jne    105cee <default_free_pages+0x37>
  105cca:	c7 44 24 0c 8c 96 10 	movl   $0x10968c,0xc(%esp)
  105cd1:	00 
  105cd2:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  105cd9:	00 
  105cda:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  105ce1:	00 
  105ce2:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105ce9:	e8 47 a7 ff ff       	call   100435 <__panic>
    //assert(PageReserved(base));                         //检查基地址所在的页是否为预留                                  
    struct Page *p = base;
  105cee:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {                       //遍历整个物理空间
  105cf4:	e9 9d 00 00 00       	jmp    105d96 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));   //检查是否是预留或者head页,内核保留无法分配释放, 只有PageProperty有效才是!free状态
  105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cfc:	83 c0 04             	add    $0x4,%eax
  105cff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  105d06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d0f:	0f a3 10             	bt     %edx,(%eax)
  105d12:	19 c0                	sbb    %eax,%eax
  105d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  105d17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105d1b:	0f 95 c0             	setne  %al
  105d1e:	0f b6 c0             	movzbl %al,%eax
  105d21:	85 c0                	test   %eax,%eax
  105d23:	75 2c                	jne    105d51 <default_free_pages+0x9a>
  105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d28:	83 c0 04             	add    $0x4,%eax
  105d2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  105d32:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105d3b:	0f a3 10             	bt     %edx,(%eax)
  105d3e:	19 c0                	sbb    %eax,%eax
  105d40:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  105d43:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  105d47:	0f 95 c0             	setne  %al
  105d4a:	0f b6 c0             	movzbl %al,%eax
  105d4d:	85 c0                	test   %eax,%eax
  105d4f:	74 24                	je     105d75 <default_free_pages+0xbe>
  105d51:	c7 44 24 0c d0 96 10 	movl   $0x1096d0,0xc(%esp)
  105d58:	00 
  105d59:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  105d60:	00 
  105d61:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  105d68:	00 
  105d69:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105d70:	e8 c0 a6 ff ff       	call   100435 <__panic>
        p->flags = 0;                                   //设置flage标志
  105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);                             //将引用此物理页的虚拟页的个数清0, 这里类似与初始化的设置
  105d7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105d86:	00 
  105d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d8a:	89 04 24             	mov    %eax,(%esp)
  105d8d:	e8 01 fc ff ff       	call   105993 <set_page_ref>
    for (; p != base + n; p ++) {                       //遍历整个物理空间
  105d92:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  105d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d99:	89 d0                	mov    %edx,%eax
  105d9b:	c1 e0 02             	shl    $0x2,%eax
  105d9e:	01 d0                	add    %edx,%eax
  105da0:	c1 e0 02             	shl    $0x2,%eax
  105da3:	89 c2                	mov    %eax,%edx
  105da5:	8b 45 08             	mov    0x8(%ebp),%eax
  105da8:	01 d0                	add    %edx,%eax
  105daa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105dad:	0f 85 46 ff ff ff    	jne    105cf9 <default_free_pages+0x42>
    }
    base->property = n;                                 //设置空闲块数量
  105db3:	8b 45 08             	mov    0x8(%ebp),%eax
  105db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  105db9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);                              //调SetPageProperty设置当前页面预留仅仅head
  105dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105dbf:	83 c0 04             	add    $0x4,%eax
  105dc2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105dc9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105dcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105dcf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105dd2:	0f ab 10             	bts    %edx,(%eax)
}
  105dd5:	90                   	nop
  105dd6:	c7 45 d4 1c 40 12 00 	movl   $0x12401c,-0x2c(%ebp)
    return listelm->next;
  105ddd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105de0:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);           //新建一个管理结构,为链表头的子节点
  105de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          //遍历
  105de6:	e9 0e 01 00 00       	jmp    105ef9 <default_free_pages+0x242>
        p = le2page(le, page_link);                     //新页le2page就是初始化为一个Page结构
  105deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dee:	83 e8 0c             	sub    $0xc,%eax
  105df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105df7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105dfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105dfd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);                             //取下一个节点
  105e00:	89 45 f0             	mov    %eax,-0x10(%ebp)

        //向高地址合并
        if (base + base->property == p) {               //如果到达当前页的尾部地址,执行合并
  105e03:	8b 45 08             	mov    0x8(%ebp),%eax
  105e06:	8b 50 08             	mov    0x8(%eax),%edx
  105e09:	89 d0                	mov    %edx,%eax
  105e0b:	c1 e0 02             	shl    $0x2,%eax
  105e0e:	01 d0                	add    %edx,%eax
  105e10:	c1 e0 02             	shl    $0x2,%eax
  105e13:	89 c2                	mov    %eax,%edx
  105e15:	8b 45 08             	mov    0x8(%ebp),%eax
  105e18:	01 d0                	add    %edx,%eax
  105e1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105e1d:	75 5d                	jne    105e7c <default_free_pages+0x1c5>
            base->property += p->property;              //增加头页的property
  105e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e22:	8b 50 08             	mov    0x8(%eax),%edx
  105e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e28:	8b 40 08             	mov    0x8(%eax),%eax
  105e2b:	01 c2                	add    %eax,%edx
  105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e30:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);                       //清空该页面的连续空闲页面数量值
  105e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e36:	83 c0 04             	add    $0x4,%eax
  105e39:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  105e40:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105e43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105e46:	8b 55 b8             	mov    -0x48(%ebp),%edx
  105e49:	0f b3 10             	btr    %edx,(%eax)
}
  105e4c:	90                   	nop
            list_del(&(p->page_link));                  //删除旧的索引
  105e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e50:	83 c0 0c             	add    $0xc,%eax
  105e53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  105e56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105e59:	8b 40 04             	mov    0x4(%eax),%eax
  105e5c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105e5f:	8b 12                	mov    (%edx),%edx
  105e61:	89 55 c0             	mov    %edx,-0x40(%ebp)
  105e64:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  105e67:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105e6a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105e6d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105e70:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105e73:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105e76:	89 10                	mov    %edx,(%eax)
}
  105e78:	90                   	nop
}
  105e79:	90                   	nop
  105e7a:	eb 7d                	jmp    105ef9 <default_free_pages+0x242>
        }
        //向低地址合并
        else if (p + p->property == base) {             //同上
  105e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e7f:	8b 50 08             	mov    0x8(%eax),%edx
  105e82:	89 d0                	mov    %edx,%eax
  105e84:	c1 e0 02             	shl    $0x2,%eax
  105e87:	01 d0                	add    %edx,%eax
  105e89:	c1 e0 02             	shl    $0x2,%eax
  105e8c:	89 c2                	mov    %eax,%edx
  105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e91:	01 d0                	add    %edx,%eax
  105e93:	39 45 08             	cmp    %eax,0x8(%ebp)
  105e96:	75 61                	jne    105ef9 <default_free_pages+0x242>
            p->property += base->property;              //增加头页的property
  105e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e9b:	8b 50 08             	mov    0x8(%eax),%edx
  105e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea1:	8b 40 08             	mov    0x8(%eax),%eax
  105ea4:	01 c2                	add    %eax,%edx
  105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ea9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);                    //clear 
  105eac:	8b 45 08             	mov    0x8(%ebp),%eax
  105eaf:	83 c0 04             	add    $0x4,%eax
  105eb2:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  105eb9:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105ebc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105ebf:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  105ec2:	0f b3 10             	btr    %edx,(%eax)
}
  105ec5:	90                   	nop
            base = p;                                   //迭代交换base
  105ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ec9:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));                  //删除旧的索引
  105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ecf:	83 c0 0c             	add    $0xc,%eax
  105ed2:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  105ed5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105ed8:	8b 40 04             	mov    0x4(%eax),%eax
  105edb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105ede:	8b 12                	mov    (%edx),%edx
  105ee0:	89 55 ac             	mov    %edx,-0x54(%ebp)
  105ee3:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  105ee6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105ee9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  105eec:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105eef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105ef2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105ef5:	89 10                	mov    %edx,(%eax)
}
  105ef7:	90                   	nop
}
  105ef8:	90                   	nop
    while (le != &free_list) {                          //遍历
  105ef9:	81 7d f0 1c 40 12 00 	cmpl   $0x12401c,-0x10(%ebp)
  105f00:	0f 85 e5 fe ff ff    	jne    105deb <default_free_pages+0x134>
        }
    }

    //检查合并结果是否发生了错误
    nr_free += n;                                       //新增空闲快数量
  105f06:	8b 15 24 40 12 00    	mov    0x124024,%edx
  105f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f0f:	01 d0                	add    %edx,%eax
  105f11:	a3 24 40 12 00       	mov    %eax,0x124024
  105f16:	c7 45 9c 1c 40 12 00 	movl   $0x12401c,-0x64(%ebp)
    return listelm->next;
  105f1d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105f20:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);                         
  105f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          
  105f26:	eb 74                	jmp    105f9c <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  105f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f2b:	83 e8 0c             	sub    $0xc,%eax
  105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {               //如果当前页的尾部地址小于等于p
  105f31:	8b 45 08             	mov    0x8(%ebp),%eax
  105f34:	8b 50 08             	mov    0x8(%eax),%edx
  105f37:	89 d0                	mov    %edx,%eax
  105f39:	c1 e0 02             	shl    $0x2,%eax
  105f3c:	01 d0                	add    %edx,%eax
  105f3e:	c1 e0 02             	shl    $0x2,%eax
  105f41:	89 c2                	mov    %eax,%edx
  105f43:	8b 45 08             	mov    0x8(%ebp),%eax
  105f46:	01 d0                	add    %edx,%eax
  105f48:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105f4b:	72 40                	jb     105f8d <default_free_pages+0x2d6>
            assert(base + base->property != p);         //检查是否不等于p
  105f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f50:	8b 50 08             	mov    0x8(%eax),%edx
  105f53:	89 d0                	mov    %edx,%eax
  105f55:	c1 e0 02             	shl    $0x2,%eax
  105f58:	01 d0                	add    %edx,%eax
  105f5a:	c1 e0 02             	shl    $0x2,%eax
  105f5d:	89 c2                	mov    %eax,%edx
  105f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f62:	01 d0                	add    %edx,%eax
  105f64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105f67:	75 3e                	jne    105fa7 <default_free_pages+0x2f0>
  105f69:	c7 44 24 0c f5 96 10 	movl   $0x1096f5,0xc(%esp)
  105f70:	00 
  105f71:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  105f78:	00 
  105f79:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  105f80:	00 
  105f81:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  105f88:	e8 a8 a4 ff ff       	call   100435 <__panic>
  105f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f90:	89 45 98             	mov    %eax,-0x68(%ebp)
  105f93:	8b 45 98             	mov    -0x68(%ebp),%eax
  105f96:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  105f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          
  105f9c:	81 7d f0 1c 40 12 00 	cmpl   $0x12401c,-0x10(%ebp)
  105fa3:	75 83                	jne    105f28 <default_free_pages+0x271>
  105fa5:	eb 01                	jmp    105fa8 <default_free_pages+0x2f1>
            break;
  105fa7:	90                   	nop
    }
    list_add_before(le, &(base->page_link));            //将新增的Page加在双向链表指针中
  105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fab:	8d 50 0c             	lea    0xc(%eax),%edx
  105fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fb1:	89 45 94             	mov    %eax,-0x6c(%ebp)
  105fb4:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  105fb7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105fba:	8b 00                	mov    (%eax),%eax
  105fbc:	8b 55 90             	mov    -0x70(%ebp),%edx
  105fbf:	89 55 8c             	mov    %edx,-0x74(%ebp)
  105fc2:	89 45 88             	mov    %eax,-0x78(%ebp)
  105fc5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105fc8:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  105fcb:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105fce:	8b 55 8c             	mov    -0x74(%ebp),%edx
  105fd1:	89 10                	mov    %edx,(%eax)
  105fd3:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105fd6:	8b 10                	mov    (%eax),%edx
  105fd8:	8b 45 88             	mov    -0x78(%ebp),%eax
  105fdb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105fde:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105fe1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105fe4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105fe7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105fea:	8b 55 88             	mov    -0x78(%ebp),%edx
  105fed:	89 10                	mov    %edx,(%eax)
}
  105fef:	90                   	nop
}
  105ff0:	90                   	nop
}
  105ff1:	90                   	nop
  105ff2:	c9                   	leave  
  105ff3:	c3                   	ret    

00105ff4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  105ff4:	f3 0f 1e fb          	endbr32 
  105ff8:	55                   	push   %ebp
  105ff9:	89 e5                	mov    %esp,%ebp
    return nr_free;
  105ffb:	a1 24 40 12 00       	mov    0x124024,%eax
}
  106000:	5d                   	pop    %ebp
  106001:	c3                   	ret    

00106002 <basic_check>:



static void
basic_check(void) {
  106002:	f3 0f 1e fb          	endbr32 
  106006:	55                   	push   %ebp
  106007:	89 e5                	mov    %esp,%ebp
  106009:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10600c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  106013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10601c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10601f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106026:	e8 6b ce ff ff       	call   102e96 <alloc_pages>
  10602b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10602e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  106032:	75 24                	jne    106058 <basic_check+0x56>
  106034:	c7 44 24 0c 10 97 10 	movl   $0x109710,0xc(%esp)
  10603b:	00 
  10603c:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106043:	00 
  106044:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  10604b:	00 
  10604c:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106053:	e8 dd a3 ff ff       	call   100435 <__panic>
    assert((p1 = alloc_page()) != NULL);
  106058:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10605f:	e8 32 ce ff ff       	call   102e96 <alloc_pages>
  106064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10606b:	75 24                	jne    106091 <basic_check+0x8f>
  10606d:	c7 44 24 0c 2c 97 10 	movl   $0x10972c,0xc(%esp)
  106074:	00 
  106075:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10607c:	00 
  10607d:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  106084:	00 
  106085:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10608c:	e8 a4 a3 ff ff       	call   100435 <__panic>
    assert((p2 = alloc_page()) != NULL);
  106091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106098:	e8 f9 cd ff ff       	call   102e96 <alloc_pages>
  10609d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1060a4:	75 24                	jne    1060ca <basic_check+0xc8>
  1060a6:	c7 44 24 0c 48 97 10 	movl   $0x109748,0xc(%esp)
  1060ad:	00 
  1060ae:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1060b5:	00 
  1060b6:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  1060bd:	00 
  1060be:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1060c5:	e8 6b a3 ff ff       	call   100435 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1060ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1060d0:	74 10                	je     1060e2 <basic_check+0xe0>
  1060d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1060d8:	74 08                	je     1060e2 <basic_check+0xe0>
  1060da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1060e0:	75 24                	jne    106106 <basic_check+0x104>
  1060e2:	c7 44 24 0c 64 97 10 	movl   $0x109764,0xc(%esp)
  1060e9:	00 
  1060ea:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1060f1:	00 
  1060f2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  1060f9:	00 
  1060fa:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106101:	e8 2f a3 ff ff       	call   100435 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  106106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106109:	89 04 24             	mov    %eax,(%esp)
  10610c:	e8 78 f8 ff ff       	call   105989 <page_ref>
  106111:	85 c0                	test   %eax,%eax
  106113:	75 1e                	jne    106133 <basic_check+0x131>
  106115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106118:	89 04 24             	mov    %eax,(%esp)
  10611b:	e8 69 f8 ff ff       	call   105989 <page_ref>
  106120:	85 c0                	test   %eax,%eax
  106122:	75 0f                	jne    106133 <basic_check+0x131>
  106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106127:	89 04 24             	mov    %eax,(%esp)
  10612a:	e8 5a f8 ff ff       	call   105989 <page_ref>
  10612f:	85 c0                	test   %eax,%eax
  106131:	74 24                	je     106157 <basic_check+0x155>
  106133:	c7 44 24 0c 88 97 10 	movl   $0x109788,0xc(%esp)
  10613a:	00 
  10613b:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106142:	00 
  106143:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  10614a:	00 
  10614b:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106152:	e8 de a2 ff ff       	call   100435 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  106157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10615a:	89 04 24             	mov    %eax,(%esp)
  10615d:	e8 11 f8 ff ff       	call   105973 <page2pa>
  106162:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  106168:	c1 e2 0c             	shl    $0xc,%edx
  10616b:	39 d0                	cmp    %edx,%eax
  10616d:	72 24                	jb     106193 <basic_check+0x191>
  10616f:	c7 44 24 0c c4 97 10 	movl   $0x1097c4,0xc(%esp)
  106176:	00 
  106177:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10617e:	00 
  10617f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  106186:	00 
  106187:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10618e:	e8 a2 a2 ff ff       	call   100435 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  106193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106196:	89 04 24             	mov    %eax,(%esp)
  106199:	e8 d5 f7 ff ff       	call   105973 <page2pa>
  10619e:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  1061a4:	c1 e2 0c             	shl    $0xc,%edx
  1061a7:	39 d0                	cmp    %edx,%eax
  1061a9:	72 24                	jb     1061cf <basic_check+0x1cd>
  1061ab:	c7 44 24 0c e1 97 10 	movl   $0x1097e1,0xc(%esp)
  1061b2:	00 
  1061b3:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1061ba:	00 
  1061bb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  1061c2:	00 
  1061c3:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1061ca:	e8 66 a2 ff ff       	call   100435 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1061cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1061d2:	89 04 24             	mov    %eax,(%esp)
  1061d5:	e8 99 f7 ff ff       	call   105973 <page2pa>
  1061da:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  1061e0:	c1 e2 0c             	shl    $0xc,%edx
  1061e3:	39 d0                	cmp    %edx,%eax
  1061e5:	72 24                	jb     10620b <basic_check+0x209>
  1061e7:	c7 44 24 0c fe 97 10 	movl   $0x1097fe,0xc(%esp)
  1061ee:	00 
  1061ef:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1061f6:	00 
  1061f7:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  1061fe:	00 
  1061ff:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106206:	e8 2a a2 ff ff       	call   100435 <__panic>

    list_entry_t free_list_store = free_list;
  10620b:	a1 1c 40 12 00       	mov    0x12401c,%eax
  106210:	8b 15 20 40 12 00    	mov    0x124020,%edx
  106216:	89 45 d0             	mov    %eax,-0x30(%ebp)
  106219:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10621c:	c7 45 dc 1c 40 12 00 	movl   $0x12401c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  106223:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106226:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106229:	89 50 04             	mov    %edx,0x4(%eax)
  10622c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10622f:	8b 50 04             	mov    0x4(%eax),%edx
  106232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106235:	89 10                	mov    %edx,(%eax)
}
  106237:	90                   	nop
  106238:	c7 45 e0 1c 40 12 00 	movl   $0x12401c,-0x20(%ebp)
    return list->next == list;
  10623f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106242:	8b 40 04             	mov    0x4(%eax),%eax
  106245:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  106248:	0f 94 c0             	sete   %al
  10624b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10624e:	85 c0                	test   %eax,%eax
  106250:	75 24                	jne    106276 <basic_check+0x274>
  106252:	c7 44 24 0c 1b 98 10 	movl   $0x10981b,0xc(%esp)
  106259:	00 
  10625a:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106261:	00 
  106262:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  106269:	00 
  10626a:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106271:	e8 bf a1 ff ff       	call   100435 <__panic>

    unsigned int nr_free_store = nr_free;
  106276:	a1 24 40 12 00       	mov    0x124024,%eax
  10627b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10627e:	c7 05 24 40 12 00 00 	movl   $0x0,0x124024
  106285:	00 00 00 

    assert(alloc_page() == NULL);
  106288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10628f:	e8 02 cc ff ff       	call   102e96 <alloc_pages>
  106294:	85 c0                	test   %eax,%eax
  106296:	74 24                	je     1062bc <basic_check+0x2ba>
  106298:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  10629f:	00 
  1062a0:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1062a7:	00 
  1062a8:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  1062af:	00 
  1062b0:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1062b7:	e8 79 a1 ff ff       	call   100435 <__panic>

    free_page(p0);
  1062bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1062c3:	00 
  1062c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1062c7:	89 04 24             	mov    %eax,(%esp)
  1062ca:	e8 03 cc ff ff       	call   102ed2 <free_pages>
    free_page(p1);
  1062cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1062d6:	00 
  1062d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062da:	89 04 24             	mov    %eax,(%esp)
  1062dd:	e8 f0 cb ff ff       	call   102ed2 <free_pages>
    free_page(p2);
  1062e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1062e9:	00 
  1062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1062ed:	89 04 24             	mov    %eax,(%esp)
  1062f0:	e8 dd cb ff ff       	call   102ed2 <free_pages>
    assert(nr_free == 3);
  1062f5:	a1 24 40 12 00       	mov    0x124024,%eax
  1062fa:	83 f8 03             	cmp    $0x3,%eax
  1062fd:	74 24                	je     106323 <basic_check+0x321>
  1062ff:	c7 44 24 0c 47 98 10 	movl   $0x109847,0xc(%esp)
  106306:	00 
  106307:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10630e:	00 
  10630f:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  106316:	00 
  106317:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10631e:	e8 12 a1 ff ff       	call   100435 <__panic>

    assert((p0 = alloc_page()) != NULL);
  106323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10632a:	e8 67 cb ff ff       	call   102e96 <alloc_pages>
  10632f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106332:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  106336:	75 24                	jne    10635c <basic_check+0x35a>
  106338:	c7 44 24 0c 10 97 10 	movl   $0x109710,0xc(%esp)
  10633f:	00 
  106340:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106347:	00 
  106348:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  10634f:	00 
  106350:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106357:	e8 d9 a0 ff ff       	call   100435 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10635c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106363:	e8 2e cb ff ff       	call   102e96 <alloc_pages>
  106368:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10636b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10636f:	75 24                	jne    106395 <basic_check+0x393>
  106371:	c7 44 24 0c 2c 97 10 	movl   $0x10972c,0xc(%esp)
  106378:	00 
  106379:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106380:	00 
  106381:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  106388:	00 
  106389:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106390:	e8 a0 a0 ff ff       	call   100435 <__panic>
    assert((p2 = alloc_page()) != NULL);
  106395:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10639c:	e8 f5 ca ff ff       	call   102e96 <alloc_pages>
  1063a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1063a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1063a8:	75 24                	jne    1063ce <basic_check+0x3cc>
  1063aa:	c7 44 24 0c 48 97 10 	movl   $0x109748,0xc(%esp)
  1063b1:	00 
  1063b2:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1063b9:	00 
  1063ba:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  1063c1:	00 
  1063c2:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1063c9:	e8 67 a0 ff ff       	call   100435 <__panic>

    assert(alloc_page() == NULL);
  1063ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1063d5:	e8 bc ca ff ff       	call   102e96 <alloc_pages>
  1063da:	85 c0                	test   %eax,%eax
  1063dc:	74 24                	je     106402 <basic_check+0x400>
  1063de:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  1063e5:	00 
  1063e6:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1063ed:	00 
  1063ee:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  1063f5:	00 
  1063f6:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1063fd:	e8 33 a0 ff ff       	call   100435 <__panic>

    free_page(p0);
  106402:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106409:	00 
  10640a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10640d:	89 04 24             	mov    %eax,(%esp)
  106410:	e8 bd ca ff ff       	call   102ed2 <free_pages>
  106415:	c7 45 d8 1c 40 12 00 	movl   $0x12401c,-0x28(%ebp)
  10641c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10641f:	8b 40 04             	mov    0x4(%eax),%eax
  106422:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  106425:	0f 94 c0             	sete   %al
  106428:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10642b:	85 c0                	test   %eax,%eax
  10642d:	74 24                	je     106453 <basic_check+0x451>
  10642f:	c7 44 24 0c 54 98 10 	movl   $0x109854,0xc(%esp)
  106436:	00 
  106437:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10643e:	00 
  10643f:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  106446:	00 
  106447:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10644e:	e8 e2 9f ff ff       	call   100435 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  106453:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10645a:	e8 37 ca ff ff       	call   102e96 <alloc_pages>
  10645f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106465:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106468:	74 24                	je     10648e <basic_check+0x48c>
  10646a:	c7 44 24 0c 6c 98 10 	movl   $0x10986c,0xc(%esp)
  106471:	00 
  106472:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106479:	00 
  10647a:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  106481:	00 
  106482:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106489:	e8 a7 9f ff ff       	call   100435 <__panic>
    assert(alloc_page() == NULL);
  10648e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106495:	e8 fc c9 ff ff       	call   102e96 <alloc_pages>
  10649a:	85 c0                	test   %eax,%eax
  10649c:	74 24                	je     1064c2 <basic_check+0x4c0>
  10649e:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  1064a5:	00 
  1064a6:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1064ad:	00 
  1064ae:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  1064b5:	00 
  1064b6:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1064bd:	e8 73 9f ff ff       	call   100435 <__panic>

    assert(nr_free == 0);
  1064c2:	a1 24 40 12 00       	mov    0x124024,%eax
  1064c7:	85 c0                	test   %eax,%eax
  1064c9:	74 24                	je     1064ef <basic_check+0x4ed>
  1064cb:	c7 44 24 0c 85 98 10 	movl   $0x109885,0xc(%esp)
  1064d2:	00 
  1064d3:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1064da:	00 
  1064db:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  1064e2:	00 
  1064e3:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1064ea:	e8 46 9f ff ff       	call   100435 <__panic>
    free_list = free_list_store;
  1064ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1064f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1064f5:	a3 1c 40 12 00       	mov    %eax,0x12401c
  1064fa:	89 15 20 40 12 00    	mov    %edx,0x124020
    nr_free = nr_free_store;
  106500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106503:	a3 24 40 12 00       	mov    %eax,0x124024

    free_page(p);
  106508:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10650f:	00 
  106510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106513:	89 04 24             	mov    %eax,(%esp)
  106516:	e8 b7 c9 ff ff       	call   102ed2 <free_pages>
    free_page(p1);
  10651b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106522:	00 
  106523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106526:	89 04 24             	mov    %eax,(%esp)
  106529:	e8 a4 c9 ff ff       	call   102ed2 <free_pages>
    free_page(p2);
  10652e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106535:	00 
  106536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106539:	89 04 24             	mov    %eax,(%esp)
  10653c:	e8 91 c9 ff ff       	call   102ed2 <free_pages>
}
  106541:	90                   	nop
  106542:	c9                   	leave  
  106543:	c3                   	ret    

00106544 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  106544:	f3 0f 1e fb          	endbr32 
  106548:	55                   	push   %ebp
  106549:	89 e5                	mov    %esp,%ebp
  10654b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  106551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  106558:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10655f:	c7 45 ec 1c 40 12 00 	movl   $0x12401c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  106566:	eb 6a                	jmp    1065d2 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  106568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10656b:	83 e8 0c             	sub    $0xc,%eax
  10656e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  106571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106574:	83 c0 04             	add    $0x4,%eax
  106577:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10657e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  106581:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106584:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106587:	0f a3 10             	bt     %edx,(%eax)
  10658a:	19 c0                	sbb    %eax,%eax
  10658c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10658f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  106593:	0f 95 c0             	setne  %al
  106596:	0f b6 c0             	movzbl %al,%eax
  106599:	85 c0                	test   %eax,%eax
  10659b:	75 24                	jne    1065c1 <default_check+0x7d>
  10659d:	c7 44 24 0c 92 98 10 	movl   $0x109892,0xc(%esp)
  1065a4:	00 
  1065a5:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1065ac:	00 
  1065ad:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1065b4:	00 
  1065b5:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1065bc:	e8 74 9e ff ff       	call   100435 <__panic>
        count ++, total += p->property;
  1065c1:	ff 45 f4             	incl   -0xc(%ebp)
  1065c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1065c7:	8b 50 08             	mov    0x8(%eax),%edx
  1065ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1065cd:	01 d0                	add    %edx,%eax
  1065cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1065d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1065d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1065d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1065db:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1065de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1065e1:	81 7d ec 1c 40 12 00 	cmpl   $0x12401c,-0x14(%ebp)
  1065e8:	0f 85 7a ff ff ff    	jne    106568 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  1065ee:	e8 16 c9 ff ff       	call   102f09 <nr_free_pages>
  1065f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1065f6:	39 d0                	cmp    %edx,%eax
  1065f8:	74 24                	je     10661e <default_check+0xda>
  1065fa:	c7 44 24 0c a2 98 10 	movl   $0x1098a2,0xc(%esp)
  106601:	00 
  106602:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106609:	00 
  10660a:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  106611:	00 
  106612:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106619:	e8 17 9e ff ff       	call   100435 <__panic>

    basic_check();
  10661e:	e8 df f9 ff ff       	call   106002 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  106623:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10662a:	e8 67 c8 ff ff       	call   102e96 <alloc_pages>
  10662f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  106632:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106636:	75 24                	jne    10665c <default_check+0x118>
  106638:	c7 44 24 0c bb 98 10 	movl   $0x1098bb,0xc(%esp)
  10663f:	00 
  106640:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106647:	00 
  106648:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  10664f:	00 
  106650:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106657:	e8 d9 9d ff ff       	call   100435 <__panic>
    assert(!PageProperty(p0));
  10665c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10665f:	83 c0 04             	add    $0x4,%eax
  106662:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  106669:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10666c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10666f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  106672:	0f a3 10             	bt     %edx,(%eax)
  106675:	19 c0                	sbb    %eax,%eax
  106677:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10667a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10667e:	0f 95 c0             	setne  %al
  106681:	0f b6 c0             	movzbl %al,%eax
  106684:	85 c0                	test   %eax,%eax
  106686:	74 24                	je     1066ac <default_check+0x168>
  106688:	c7 44 24 0c c6 98 10 	movl   $0x1098c6,0xc(%esp)
  10668f:	00 
  106690:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106697:	00 
  106698:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  10669f:	00 
  1066a0:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1066a7:	e8 89 9d ff ff       	call   100435 <__panic>

    list_entry_t free_list_store = free_list;
  1066ac:	a1 1c 40 12 00       	mov    0x12401c,%eax
  1066b1:	8b 15 20 40 12 00    	mov    0x124020,%edx
  1066b7:	89 45 80             	mov    %eax,-0x80(%ebp)
  1066ba:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1066bd:	c7 45 b0 1c 40 12 00 	movl   $0x12401c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1066c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1066c7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1066ca:	89 50 04             	mov    %edx,0x4(%eax)
  1066cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1066d0:	8b 50 04             	mov    0x4(%eax),%edx
  1066d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1066d6:	89 10                	mov    %edx,(%eax)
}
  1066d8:	90                   	nop
  1066d9:	c7 45 b4 1c 40 12 00 	movl   $0x12401c,-0x4c(%ebp)
    return list->next == list;
  1066e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1066e3:	8b 40 04             	mov    0x4(%eax),%eax
  1066e6:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1066e9:	0f 94 c0             	sete   %al
  1066ec:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1066ef:	85 c0                	test   %eax,%eax
  1066f1:	75 24                	jne    106717 <default_check+0x1d3>
  1066f3:	c7 44 24 0c 1b 98 10 	movl   $0x10981b,0xc(%esp)
  1066fa:	00 
  1066fb:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106702:	00 
  106703:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  10670a:	00 
  10670b:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106712:	e8 1e 9d ff ff       	call   100435 <__panic>
    assert(alloc_page() == NULL);
  106717:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10671e:	e8 73 c7 ff ff       	call   102e96 <alloc_pages>
  106723:	85 c0                	test   %eax,%eax
  106725:	74 24                	je     10674b <default_check+0x207>
  106727:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  10672e:	00 
  10672f:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106736:	00 
  106737:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  10673e:	00 
  10673f:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106746:	e8 ea 9c ff ff       	call   100435 <__panic>

    unsigned int nr_free_store = nr_free;
  10674b:	a1 24 40 12 00       	mov    0x124024,%eax
  106750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  106753:	c7 05 24 40 12 00 00 	movl   $0x0,0x124024
  10675a:	00 00 00 

    free_pages(p0 + 2, 3);
  10675d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106760:	83 c0 28             	add    $0x28,%eax
  106763:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10676a:	00 
  10676b:	89 04 24             	mov    %eax,(%esp)
  10676e:	e8 5f c7 ff ff       	call   102ed2 <free_pages>
    assert(alloc_pages(4) == NULL);
  106773:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10677a:	e8 17 c7 ff ff       	call   102e96 <alloc_pages>
  10677f:	85 c0                	test   %eax,%eax
  106781:	74 24                	je     1067a7 <default_check+0x263>
  106783:	c7 44 24 0c d8 98 10 	movl   $0x1098d8,0xc(%esp)
  10678a:	00 
  10678b:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106792:	00 
  106793:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  10679a:	00 
  10679b:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1067a2:	e8 8e 9c ff ff       	call   100435 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1067a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1067aa:	83 c0 28             	add    $0x28,%eax
  1067ad:	83 c0 04             	add    $0x4,%eax
  1067b0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1067b7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1067ba:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1067bd:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1067c0:	0f a3 10             	bt     %edx,(%eax)
  1067c3:	19 c0                	sbb    %eax,%eax
  1067c5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1067c8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1067cc:	0f 95 c0             	setne  %al
  1067cf:	0f b6 c0             	movzbl %al,%eax
  1067d2:	85 c0                	test   %eax,%eax
  1067d4:	74 0e                	je     1067e4 <default_check+0x2a0>
  1067d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1067d9:	83 c0 28             	add    $0x28,%eax
  1067dc:	8b 40 08             	mov    0x8(%eax),%eax
  1067df:	83 f8 03             	cmp    $0x3,%eax
  1067e2:	74 24                	je     106808 <default_check+0x2c4>
  1067e4:	c7 44 24 0c f0 98 10 	movl   $0x1098f0,0xc(%esp)
  1067eb:	00 
  1067ec:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1067f3:	00 
  1067f4:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1067fb:	00 
  1067fc:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106803:	e8 2d 9c ff ff       	call   100435 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  106808:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10680f:	e8 82 c6 ff ff       	call   102e96 <alloc_pages>
  106814:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10681b:	75 24                	jne    106841 <default_check+0x2fd>
  10681d:	c7 44 24 0c 1c 99 10 	movl   $0x10991c,0xc(%esp)
  106824:	00 
  106825:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10682c:	00 
  10682d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  106834:	00 
  106835:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10683c:	e8 f4 9b ff ff       	call   100435 <__panic>
    assert(alloc_page() == NULL);
  106841:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106848:	e8 49 c6 ff ff       	call   102e96 <alloc_pages>
  10684d:	85 c0                	test   %eax,%eax
  10684f:	74 24                	je     106875 <default_check+0x331>
  106851:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  106858:	00 
  106859:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106860:	00 
  106861:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  106868:	00 
  106869:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106870:	e8 c0 9b ff ff       	call   100435 <__panic>
    assert(p0 + 2 == p1);
  106875:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106878:	83 c0 28             	add    $0x28,%eax
  10687b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10687e:	74 24                	je     1068a4 <default_check+0x360>
  106880:	c7 44 24 0c 3a 99 10 	movl   $0x10993a,0xc(%esp)
  106887:	00 
  106888:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  10688f:	00 
  106890:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  106897:	00 
  106898:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  10689f:	e8 91 9b ff ff       	call   100435 <__panic>

    p2 = p0 + 1;
  1068a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1068a7:	83 c0 14             	add    $0x14,%eax
  1068aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1068ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1068b4:	00 
  1068b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1068b8:	89 04 24             	mov    %eax,(%esp)
  1068bb:	e8 12 c6 ff ff       	call   102ed2 <free_pages>
    free_pages(p1, 3);
  1068c0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1068c7:	00 
  1068c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1068cb:	89 04 24             	mov    %eax,(%esp)
  1068ce:	e8 ff c5 ff ff       	call   102ed2 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1068d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1068d6:	83 c0 04             	add    $0x4,%eax
  1068d9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1068e0:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1068e3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1068e6:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1068e9:	0f a3 10             	bt     %edx,(%eax)
  1068ec:	19 c0                	sbb    %eax,%eax
  1068ee:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1068f1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1068f5:	0f 95 c0             	setne  %al
  1068f8:	0f b6 c0             	movzbl %al,%eax
  1068fb:	85 c0                	test   %eax,%eax
  1068fd:	74 0b                	je     10690a <default_check+0x3c6>
  1068ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106902:	8b 40 08             	mov    0x8(%eax),%eax
  106905:	83 f8 01             	cmp    $0x1,%eax
  106908:	74 24                	je     10692e <default_check+0x3ea>
  10690a:	c7 44 24 0c 48 99 10 	movl   $0x109948,0xc(%esp)
  106911:	00 
  106912:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106919:	00 
  10691a:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  106921:	00 
  106922:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106929:	e8 07 9b ff ff       	call   100435 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10692e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106931:	83 c0 04             	add    $0x4,%eax
  106934:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10693b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10693e:	8b 45 90             	mov    -0x70(%ebp),%eax
  106941:	8b 55 94             	mov    -0x6c(%ebp),%edx
  106944:	0f a3 10             	bt     %edx,(%eax)
  106947:	19 c0                	sbb    %eax,%eax
  106949:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10694c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  106950:	0f 95 c0             	setne  %al
  106953:	0f b6 c0             	movzbl %al,%eax
  106956:	85 c0                	test   %eax,%eax
  106958:	74 0b                	je     106965 <default_check+0x421>
  10695a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10695d:	8b 40 08             	mov    0x8(%eax),%eax
  106960:	83 f8 03             	cmp    $0x3,%eax
  106963:	74 24                	je     106989 <default_check+0x445>
  106965:	c7 44 24 0c 70 99 10 	movl   $0x109970,0xc(%esp)
  10696c:	00 
  10696d:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106974:	00 
  106975:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  10697c:	00 
  10697d:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106984:	e8 ac 9a ff ff       	call   100435 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  106989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106990:	e8 01 c5 ff ff       	call   102e96 <alloc_pages>
  106995:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106998:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10699b:	83 e8 14             	sub    $0x14,%eax
  10699e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1069a1:	74 24                	je     1069c7 <default_check+0x483>
  1069a3:	c7 44 24 0c 96 99 10 	movl   $0x109996,0xc(%esp)
  1069aa:	00 
  1069ab:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  1069b2:	00 
  1069b3:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1069ba:	00 
  1069bb:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  1069c2:	e8 6e 9a ff ff       	call   100435 <__panic>
    free_page(p0);
  1069c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1069ce:	00 
  1069cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1069d2:	89 04 24             	mov    %eax,(%esp)
  1069d5:	e8 f8 c4 ff ff       	call   102ed2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1069da:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1069e1:	e8 b0 c4 ff ff       	call   102e96 <alloc_pages>
  1069e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1069e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1069ec:	83 c0 14             	add    $0x14,%eax
  1069ef:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1069f2:	74 24                	je     106a18 <default_check+0x4d4>
  1069f4:	c7 44 24 0c b4 99 10 	movl   $0x1099b4,0xc(%esp)
  1069fb:	00 
  1069fc:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106a03:	00 
  106a04:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  106a0b:	00 
  106a0c:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106a13:	e8 1d 9a ff ff       	call   100435 <__panic>

    free_pages(p0, 2);
  106a18:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  106a1f:	00 
  106a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106a23:	89 04 24             	mov    %eax,(%esp)
  106a26:	e8 a7 c4 ff ff       	call   102ed2 <free_pages>
    free_page(p2);
  106a2b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106a32:	00 
  106a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106a36:	89 04 24             	mov    %eax,(%esp)
  106a39:	e8 94 c4 ff ff       	call   102ed2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  106a3e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  106a45:	e8 4c c4 ff ff       	call   102e96 <alloc_pages>
  106a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106a4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106a51:	75 24                	jne    106a77 <default_check+0x533>
  106a53:	c7 44 24 0c d4 99 10 	movl   $0x1099d4,0xc(%esp)
  106a5a:	00 
  106a5b:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106a62:	00 
  106a63:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  106a6a:	00 
  106a6b:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106a72:	e8 be 99 ff ff       	call   100435 <__panic>
    assert(alloc_page() == NULL);
  106a77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106a7e:	e8 13 c4 ff ff       	call   102e96 <alloc_pages>
  106a83:	85 c0                	test   %eax,%eax
  106a85:	74 24                	je     106aab <default_check+0x567>
  106a87:	c7 44 24 0c 32 98 10 	movl   $0x109832,0xc(%esp)
  106a8e:	00 
  106a8f:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106a96:	00 
  106a97:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  106a9e:	00 
  106a9f:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106aa6:	e8 8a 99 ff ff       	call   100435 <__panic>

    assert(nr_free == 0);
  106aab:	a1 24 40 12 00       	mov    0x124024,%eax
  106ab0:	85 c0                	test   %eax,%eax
  106ab2:	74 24                	je     106ad8 <default_check+0x594>
  106ab4:	c7 44 24 0c 85 98 10 	movl   $0x109885,0xc(%esp)
  106abb:	00 
  106abc:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106ac3:	00 
  106ac4:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  106acb:	00 
  106acc:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106ad3:	e8 5d 99 ff ff       	call   100435 <__panic>
    nr_free = nr_free_store;
  106ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106adb:	a3 24 40 12 00       	mov    %eax,0x124024

    free_list = free_list_store;
  106ae0:	8b 45 80             	mov    -0x80(%ebp),%eax
  106ae3:	8b 55 84             	mov    -0x7c(%ebp),%edx
  106ae6:	a3 1c 40 12 00       	mov    %eax,0x12401c
  106aeb:	89 15 20 40 12 00    	mov    %edx,0x124020
    free_pages(p0, 5);
  106af1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  106af8:	00 
  106af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106afc:	89 04 24             	mov    %eax,(%esp)
  106aff:	e8 ce c3 ff ff       	call   102ed2 <free_pages>

    le = &free_list;
  106b04:	c7 45 ec 1c 40 12 00 	movl   $0x12401c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  106b0b:	eb 1c                	jmp    106b29 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  106b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106b10:	83 e8 0c             	sub    $0xc,%eax
  106b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  106b16:	ff 4d f4             	decl   -0xc(%ebp)
  106b19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106b1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106b1f:	8b 40 08             	mov    0x8(%eax),%eax
  106b22:	29 c2                	sub    %eax,%edx
  106b24:	89 d0                	mov    %edx,%eax
  106b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106b2c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  106b2f:	8b 45 88             	mov    -0x78(%ebp),%eax
  106b32:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  106b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106b38:	81 7d ec 1c 40 12 00 	cmpl   $0x12401c,-0x14(%ebp)
  106b3f:	75 cc                	jne    106b0d <default_check+0x5c9>
    }
    assert(count == 0);
  106b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  106b45:	74 24                	je     106b6b <default_check+0x627>
  106b47:	c7 44 24 0c f2 99 10 	movl   $0x1099f2,0xc(%esp)
  106b4e:	00 
  106b4f:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106b56:	00 
  106b57:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  106b5e:	00 
  106b5f:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106b66:	e8 ca 98 ff ff       	call   100435 <__panic>
    assert(total == 0);
  106b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106b6f:	74 24                	je     106b95 <default_check+0x651>
  106b71:	c7 44 24 0c fd 99 10 	movl   $0x1099fd,0xc(%esp)
  106b78:	00 
  106b79:	c7 44 24 08 92 96 10 	movl   $0x109692,0x8(%esp)
  106b80:	00 
  106b81:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  106b88:	00 
  106b89:	c7 04 24 a7 96 10 00 	movl   $0x1096a7,(%esp)
  106b90:	e8 a0 98 ff ff       	call   100435 <__panic>
}
  106b95:	90                   	nop
  106b96:	c9                   	leave  
  106b97:	c3                   	ret    

00106b98 <page_ref>:
page_ref(struct Page *page) {
  106b98:	55                   	push   %ebp
  106b99:	89 e5                	mov    %esp,%ebp
    return page->ref;
  106b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  106b9e:	8b 00                	mov    (%eax),%eax
}
  106ba0:	5d                   	pop    %ebp
  106ba1:	c3                   	ret    

00106ba2 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  106ba2:	55                   	push   %ebp
  106ba3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  106ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  106ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  106bab:	89 10                	mov    %edx,(%eax)
}
  106bad:	90                   	nop
  106bae:	5d                   	pop    %ebp
  106baf:	c3                   	ret    

00106bb0 <fixsize>:
#define UINT32_MASK(a)          (UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(a,1),2),4),8),16))    
//大于a的一个最小的2^k
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))//小于a的最大的2^k

static unsigned fixsize(unsigned size) {
  106bb0:	f3 0f 1e fb          	endbr32 
  106bb4:	55                   	push   %ebp
  106bb5:	89 e5                	mov    %esp,%ebp
  size |= size >> 1;
  106bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  106bba:	d1 e8                	shr    %eax
  106bbc:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 2;
  106bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  106bc2:	c1 e8 02             	shr    $0x2,%eax
  106bc5:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 4;
  106bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  106bcb:	c1 e8 04             	shr    $0x4,%eax
  106bce:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 8;
  106bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  106bd4:	c1 e8 08             	shr    $0x8,%eax
  106bd7:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 16;
  106bda:	8b 45 08             	mov    0x8(%ebp),%eax
  106bdd:	c1 e8 10             	shr    $0x10,%eax
  106be0:	09 45 08             	or     %eax,0x8(%ebp)
  return size+1;
  106be3:	8b 45 08             	mov    0x8(%ebp),%eax
  106be6:	40                   	inc    %eax
}
  106be7:	5d                   	pop    %ebp
  106be8:	c3                   	ret    

00106be9 <buddy_init>:

struct allocRecord rec[80000];//存放偏移量的数组
int nr_block;//已分配的块数

static void buddy_init()
{
  106be9:	f3 0f 1e fb          	endbr32 
  106bed:	55                   	push   %ebp
  106bee:	89 e5                	mov    %esp,%ebp
  106bf0:	83 ec 10             	sub    $0x10,%esp
  106bf3:	c7 45 fc 1c 40 12 00 	movl   $0x12401c,-0x4(%ebp)
    elm->prev = elm->next = elm;
  106bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106bfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  106c00:	89 50 04             	mov    %edx,0x4(%eax)
  106c03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106c06:	8b 50 04             	mov    0x4(%eax),%edx
  106c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106c0c:	89 10                	mov    %edx,(%eax)
}
  106c0e:	90                   	nop
    list_init(&free_list);
    nr_free=0;
  106c0f:	c7 05 24 40 12 00 00 	movl   $0x0,0x124024
  106c16:	00 00 00 
}
  106c19:	90                   	nop
  106c1a:	c9                   	leave  
  106c1b:	c3                   	ret    

00106c1c <buddy2_new>:

//初始化二叉树上的节点
void buddy2_new( int size ) {
  106c1c:	f3 0f 1e fb          	endbr32 
  106c20:	55                   	push   %ebp
  106c21:	89 e5                	mov    %esp,%ebp
  106c23:	83 ec 10             	sub    $0x10,%esp
  unsigned node_size;
  int i;
  nr_block=0;
  106c26:	c7 05 40 40 12 00 00 	movl   $0x0,0x124040
  106c2d:	00 00 00 
  if (size < 1 || !IS_POWER_OF_2(size))
  106c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106c34:	7e 54                	jle    106c8a <buddy2_new+0x6e>
  106c36:	8b 45 08             	mov    0x8(%ebp),%eax
  106c39:	48                   	dec    %eax
  106c3a:	23 45 08             	and    0x8(%ebp),%eax
  106c3d:	85 c0                	test   %eax,%eax
  106c3f:	75 49                	jne    106c8a <buddy2_new+0x6e>
    return;

  root[0].size = size;
  106c41:	8b 45 08             	mov    0x8(%ebp),%eax
  106c44:	a3 60 40 12 00       	mov    %eax,0x124060
  node_size = size * 2;
  106c49:	8b 45 08             	mov    0x8(%ebp),%eax
  106c4c:	01 c0                	add    %eax,%eax
  106c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  for (i = 0; i < 2 * size - 1; ++i) {
  106c51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  106c58:	eb 23                	jmp    106c7d <buddy2_new+0x61>
    if (IS_POWER_OF_2(i+1))
  106c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106c5d:	40                   	inc    %eax
  106c5e:	23 45 f8             	and    -0x8(%ebp),%eax
  106c61:	85 c0                	test   %eax,%eax
  106c63:	75 08                	jne    106c6d <buddy2_new+0x51>
      node_size /= 2;
  106c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106c68:	d1 e8                	shr    %eax
  106c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    root[i].longest = node_size;
  106c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106c70:	8b 55 fc             	mov    -0x4(%ebp),%edx
  106c73:	89 14 c5 64 40 12 00 	mov    %edx,0x124064(,%eax,8)
  for (i = 0; i < 2 * size - 1; ++i) {
  106c7a:	ff 45 f8             	incl   -0x8(%ebp)
  106c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  106c80:	01 c0                	add    %eax,%eax
  106c82:	48                   	dec    %eax
  106c83:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  106c86:	7c d2                	jl     106c5a <buddy2_new+0x3e>
  }
  return;
  106c88:	eb 01                	jmp    106c8b <buddy2_new+0x6f>
    return;
  106c8a:	90                   	nop
}
  106c8b:	c9                   	leave  
  106c8c:	c3                   	ret    

00106c8d <buddy_init_memmap>:

//初始化内存映射关系
static void
buddy_init_memmap(struct Page *base, size_t n)
{
  106c8d:	f3 0f 1e fb          	endbr32 
  106c91:	55                   	push   %ebp
  106c92:	89 e5                	mov    %esp,%ebp
  106c94:	56                   	push   %esi
  106c95:	53                   	push   %ebx
  106c96:	83 ec 40             	sub    $0x40,%esp
    assert(n>0);
  106c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106c9d:	75 24                	jne    106cc3 <buddy_init_memmap+0x36>
  106c9f:	c7 44 24 0c 38 9a 10 	movl   $0x109a38,0xc(%esp)
  106ca6:	00 
  106ca7:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  106cae:	00 
  106caf:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  106cb6:	00 
  106cb7:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  106cbe:	e8 72 97 ff ff       	call   100435 <__panic>
    struct Page* p=base;
  106cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  106cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;p!=base + n;p++)
  106cc9:	e9 df 00 00 00       	jmp    106dad <buddy_init_memmap+0x120>
    {
        assert(PageReserved(p));
  106cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106cd1:	83 c0 04             	add    $0x4,%eax
  106cd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  106cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  106cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106ce1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106ce4:	0f a3 10             	bt     %edx,(%eax)
  106ce7:	19 c0                	sbb    %eax,%eax
  106ce9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  106cec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106cf0:	0f 95 c0             	setne  %al
  106cf3:	0f b6 c0             	movzbl %al,%eax
  106cf6:	85 c0                	test   %eax,%eax
  106cf8:	75 24                	jne    106d1e <buddy_init_memmap+0x91>
  106cfa:	c7 44 24 0c 65 9a 10 	movl   $0x109a65,0xc(%esp)
  106d01:	00 
  106d02:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  106d09:	00 
  106d0a:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  106d11:	00 
  106d12:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  106d19:	e8 17 97 ff ff       	call   100435 <__panic>
        p->flags = 0;
  106d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 1;
  106d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d2b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
        set_page_ref(p, 0);   
  106d32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106d39:	00 
  106d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d3d:	89 04 24             	mov    %eax,(%esp)
  106d40:	e8 5d fe ff ff       	call   106ba2 <set_page_ref>
        SetPageProperty(p);
  106d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d48:	83 c0 04             	add    $0x4,%eax
  106d4b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  106d52:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  106d55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  106d58:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106d5b:	0f ab 10             	bts    %edx,(%eax)
}
  106d5e:	90                   	nop
        list_add_before(&free_list,&(p->page_link));     
  106d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d62:	83 c0 0c             	add    $0xc,%eax
  106d65:	c7 45 e0 1c 40 12 00 	movl   $0x12401c,-0x20(%ebp)
  106d6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm->prev, listelm);
  106d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d72:	8b 00                	mov    (%eax),%eax
  106d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106d77:	89 55 d8             	mov    %edx,-0x28(%ebp)
  106d7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  106d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d80:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  106d83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106d89:	89 10                	mov    %edx,(%eax)
  106d8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d8e:	8b 10                	mov    (%eax),%edx
  106d90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106d93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106d96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106d99:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106d9c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  106d9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106da2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106da5:	89 10                	mov    %edx,(%eax)
}
  106da7:	90                   	nop
}
  106da8:	90                   	nop
    for(;p!=base + n;p++)
  106da9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  106dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  106db0:	89 d0                	mov    %edx,%eax
  106db2:	c1 e0 02             	shl    $0x2,%eax
  106db5:	01 d0                	add    %edx,%eax
  106db7:	c1 e0 02             	shl    $0x2,%eax
  106dba:	89 c2                	mov    %eax,%edx
  106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  106dbf:	01 d0                	add    %edx,%eax
  106dc1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  106dc4:	0f 85 04 ff ff ff    	jne    106cce <buddy_init_memmap+0x41>
    }
    nr_free += n;
  106dca:	8b 15 24 40 12 00    	mov    0x124024,%edx
  106dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dd3:	01 d0                	add    %edx,%eax
  106dd5:	a3 24 40 12 00       	mov    %eax,0x124024
    int allocpages=UINT32_ROUND_DOWN(n);
  106dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ddd:	d1 e8                	shr    %eax
  106ddf:	0b 45 0c             	or     0xc(%ebp),%eax
  106de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  106de5:	d1 ea                	shr    %edx
  106de7:	0b 55 0c             	or     0xc(%ebp),%edx
  106dea:	c1 ea 02             	shr    $0x2,%edx
  106ded:	09 d0                	or     %edx,%eax
  106def:	89 c1                	mov    %eax,%ecx
  106df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  106df4:	d1 e8                	shr    %eax
  106df6:	0b 45 0c             	or     0xc(%ebp),%eax
  106df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  106dfc:	d1 ea                	shr    %edx
  106dfe:	0b 55 0c             	or     0xc(%ebp),%edx
  106e01:	c1 ea 02             	shr    $0x2,%edx
  106e04:	09 d0                	or     %edx,%eax
  106e06:	c1 e8 04             	shr    $0x4,%eax
  106e09:	09 c1                	or     %eax,%ecx
  106e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e0e:	d1 e8                	shr    %eax
  106e10:	0b 45 0c             	or     0xc(%ebp),%eax
  106e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e16:	d1 ea                	shr    %edx
  106e18:	0b 55 0c             	or     0xc(%ebp),%edx
  106e1b:	c1 ea 02             	shr    $0x2,%edx
  106e1e:	09 d0                	or     %edx,%eax
  106e20:	89 c3                	mov    %eax,%ebx
  106e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e25:	d1 e8                	shr    %eax
  106e27:	0b 45 0c             	or     0xc(%ebp),%eax
  106e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e2d:	d1 ea                	shr    %edx
  106e2f:	0b 55 0c             	or     0xc(%ebp),%edx
  106e32:	c1 ea 02             	shr    $0x2,%edx
  106e35:	09 d0                	or     %edx,%eax
  106e37:	c1 e8 04             	shr    $0x4,%eax
  106e3a:	09 d8                	or     %ebx,%eax
  106e3c:	c1 e8 08             	shr    $0x8,%eax
  106e3f:	09 c1                	or     %eax,%ecx
  106e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e44:	d1 e8                	shr    %eax
  106e46:	0b 45 0c             	or     0xc(%ebp),%eax
  106e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e4c:	d1 ea                	shr    %edx
  106e4e:	0b 55 0c             	or     0xc(%ebp),%edx
  106e51:	c1 ea 02             	shr    $0x2,%edx
  106e54:	09 d0                	or     %edx,%eax
  106e56:	89 c3                	mov    %eax,%ebx
  106e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e5b:	d1 e8                	shr    %eax
  106e5d:	0b 45 0c             	or     0xc(%ebp),%eax
  106e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e63:	d1 ea                	shr    %edx
  106e65:	0b 55 0c             	or     0xc(%ebp),%edx
  106e68:	c1 ea 02             	shr    $0x2,%edx
  106e6b:	09 d0                	or     %edx,%eax
  106e6d:	c1 e8 04             	shr    $0x4,%eax
  106e70:	09 c3                	or     %eax,%ebx
  106e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e75:	d1 e8                	shr    %eax
  106e77:	0b 45 0c             	or     0xc(%ebp),%eax
  106e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e7d:	d1 ea                	shr    %edx
  106e7f:	0b 55 0c             	or     0xc(%ebp),%edx
  106e82:	c1 ea 02             	shr    $0x2,%edx
  106e85:	09 d0                	or     %edx,%eax
  106e87:	89 c6                	mov    %eax,%esi
  106e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e8c:	d1 e8                	shr    %eax
  106e8e:	0b 45 0c             	or     0xc(%ebp),%eax
  106e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e94:	d1 ea                	shr    %edx
  106e96:	0b 55 0c             	or     0xc(%ebp),%edx
  106e99:	c1 ea 02             	shr    $0x2,%edx
  106e9c:	09 d0                	or     %edx,%eax
  106e9e:	c1 e8 04             	shr    $0x4,%eax
  106ea1:	09 f0                	or     %esi,%eax
  106ea3:	c1 e8 08             	shr    $0x8,%eax
  106ea6:	09 d8                	or     %ebx,%eax
  106ea8:	c1 e8 10             	shr    $0x10,%eax
  106eab:	09 c8                	or     %ecx,%eax
  106ead:	d1 e8                	shr    %eax
  106eaf:	23 45 0c             	and    0xc(%ebp),%eax
  106eb2:	85 c0                	test   %eax,%eax
  106eb4:	0f 84 dc 00 00 00    	je     106f96 <buddy_init_memmap+0x309>
  106eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ebd:	d1 e8                	shr    %eax
  106ebf:	0b 45 0c             	or     0xc(%ebp),%eax
  106ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  106ec5:	d1 ea                	shr    %edx
  106ec7:	0b 55 0c             	or     0xc(%ebp),%edx
  106eca:	c1 ea 02             	shr    $0x2,%edx
  106ecd:	09 d0                	or     %edx,%eax
  106ecf:	89 c1                	mov    %eax,%ecx
  106ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ed4:	d1 e8                	shr    %eax
  106ed6:	0b 45 0c             	or     0xc(%ebp),%eax
  106ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  106edc:	d1 ea                	shr    %edx
  106ede:	0b 55 0c             	or     0xc(%ebp),%edx
  106ee1:	c1 ea 02             	shr    $0x2,%edx
  106ee4:	09 d0                	or     %edx,%eax
  106ee6:	c1 e8 04             	shr    $0x4,%eax
  106ee9:	09 c1                	or     %eax,%ecx
  106eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  106eee:	d1 e8                	shr    %eax
  106ef0:	0b 45 0c             	or     0xc(%ebp),%eax
  106ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  106ef6:	d1 ea                	shr    %edx
  106ef8:	0b 55 0c             	or     0xc(%ebp),%edx
  106efb:	c1 ea 02             	shr    $0x2,%edx
  106efe:	09 d0                	or     %edx,%eax
  106f00:	89 c3                	mov    %eax,%ebx
  106f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f05:	d1 e8                	shr    %eax
  106f07:	0b 45 0c             	or     0xc(%ebp),%eax
  106f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  106f0d:	d1 ea                	shr    %edx
  106f0f:	0b 55 0c             	or     0xc(%ebp),%edx
  106f12:	c1 ea 02             	shr    $0x2,%edx
  106f15:	09 d0                	or     %edx,%eax
  106f17:	c1 e8 04             	shr    $0x4,%eax
  106f1a:	09 d8                	or     %ebx,%eax
  106f1c:	c1 e8 08             	shr    $0x8,%eax
  106f1f:	09 c1                	or     %eax,%ecx
  106f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f24:	d1 e8                	shr    %eax
  106f26:	0b 45 0c             	or     0xc(%ebp),%eax
  106f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  106f2c:	d1 ea                	shr    %edx
  106f2e:	0b 55 0c             	or     0xc(%ebp),%edx
  106f31:	c1 ea 02             	shr    $0x2,%edx
  106f34:	09 d0                	or     %edx,%eax
  106f36:	89 c3                	mov    %eax,%ebx
  106f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f3b:	d1 e8                	shr    %eax
  106f3d:	0b 45 0c             	or     0xc(%ebp),%eax
  106f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  106f43:	d1 ea                	shr    %edx
  106f45:	0b 55 0c             	or     0xc(%ebp),%edx
  106f48:	c1 ea 02             	shr    $0x2,%edx
  106f4b:	09 d0                	or     %edx,%eax
  106f4d:	c1 e8 04             	shr    $0x4,%eax
  106f50:	09 c3                	or     %eax,%ebx
  106f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f55:	d1 e8                	shr    %eax
  106f57:	0b 45 0c             	or     0xc(%ebp),%eax
  106f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  106f5d:	d1 ea                	shr    %edx
  106f5f:	0b 55 0c             	or     0xc(%ebp),%edx
  106f62:	c1 ea 02             	shr    $0x2,%edx
  106f65:	09 d0                	or     %edx,%eax
  106f67:	89 c6                	mov    %eax,%esi
  106f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f6c:	d1 e8                	shr    %eax
  106f6e:	0b 45 0c             	or     0xc(%ebp),%eax
  106f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  106f74:	d1 ea                	shr    %edx
  106f76:	0b 55 0c             	or     0xc(%ebp),%edx
  106f79:	c1 ea 02             	shr    $0x2,%edx
  106f7c:	09 d0                	or     %edx,%eax
  106f7e:	c1 e8 04             	shr    $0x4,%eax
  106f81:	09 f0                	or     %esi,%eax
  106f83:	c1 e8 08             	shr    $0x8,%eax
  106f86:	09 d8                	or     %ebx,%eax
  106f88:	c1 e8 10             	shr    $0x10,%eax
  106f8b:	09 c8                	or     %ecx,%eax
  106f8d:	d1 e8                	shr    %eax
  106f8f:	f7 d0                	not    %eax
  106f91:	23 45 0c             	and    0xc(%ebp),%eax
  106f94:	eb 03                	jmp    106f99 <buddy_init_memmap+0x30c>
  106f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy2_new(allocpages);
  106f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106f9f:	89 04 24             	mov    %eax,(%esp)
  106fa2:	e8 75 fc ff ff       	call   106c1c <buddy2_new>
}
  106fa7:	90                   	nop
  106fa8:	83 c4 40             	add    $0x40,%esp
  106fab:	5b                   	pop    %ebx
  106fac:	5e                   	pop    %esi
  106fad:	5d                   	pop    %ebp
  106fae:	c3                   	ret    

00106faf <buddy2_alloc>:
//内存分配
int buddy2_alloc(struct buddy2* self, int size) {
  106faf:	f3 0f 1e fb          	endbr32 
  106fb3:	55                   	push   %ebp
  106fb4:	89 e5                	mov    %esp,%ebp
  106fb6:	53                   	push   %ebx
  106fb7:	83 ec 14             	sub    $0x14,%esp
  unsigned index = 0;//节点的标号
  106fba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  unsigned node_size;
  unsigned offset = 0;
  106fc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if (self==NULL)//无法分配
  106fc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106fcc:	75 0a                	jne    106fd8 <buddy2_alloc+0x29>
    return -1;
  106fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  106fd3:	e9 63 01 00 00       	jmp    10713b <buddy2_alloc+0x18c>

  if (size <= 0)//分配不合理
  106fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106fdc:	7f 09                	jg     106fe7 <buddy2_alloc+0x38>
    size = 1;
  106fde:	c7 45 0c 01 00 00 00 	movl   $0x1,0xc(%ebp)
  106fe5:	eb 19                	jmp    107000 <buddy2_alloc+0x51>
  else if (!IS_POWER_OF_2(size))//不为2的幂时，取比size更大的2的n次幂
  106fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fea:	48                   	dec    %eax
  106feb:	23 45 0c             	and    0xc(%ebp),%eax
  106fee:	85 c0                	test   %eax,%eax
  106ff0:	74 0e                	je     107000 <buddy2_alloc+0x51>
    size = fixsize(size);
  106ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ff5:	89 04 24             	mov    %eax,(%esp)
  106ff8:	e8 b3 fb ff ff       	call   106bb0 <fixsize>
  106ffd:	89 45 0c             	mov    %eax,0xc(%ebp)

  if (self[index].longest < size)//可分配内存不足
  107000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107003:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  10700a:	8b 45 08             	mov    0x8(%ebp),%eax
  10700d:	01 d0                	add    %edx,%eax
  10700f:	8b 50 04             	mov    0x4(%eax),%edx
  107012:	8b 45 0c             	mov    0xc(%ebp),%eax
  107015:	39 c2                	cmp    %eax,%edx
  107017:	73 0a                	jae    107023 <buddy2_alloc+0x74>
    return -1;
  107019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10701e:	e9 18 01 00 00       	jmp    10713b <buddy2_alloc+0x18c>

  for(node_size = self->size; node_size != size; node_size /= 2 ) {
  107023:	8b 45 08             	mov    0x8(%ebp),%eax
  107026:	8b 00                	mov    (%eax),%eax
  107028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10702b:	e9 85 00 00 00       	jmp    1070b5 <buddy2_alloc+0x106>
    if (self[LEFT_LEAF(index)].longest >= size)
  107030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107033:	c1 e0 04             	shl    $0x4,%eax
  107036:	8d 50 08             	lea    0x8(%eax),%edx
  107039:	8b 45 08             	mov    0x8(%ebp),%eax
  10703c:	01 d0                	add    %edx,%eax
  10703e:	8b 50 04             	mov    0x4(%eax),%edx
  107041:	8b 45 0c             	mov    0xc(%ebp),%eax
  107044:	39 c2                	cmp    %eax,%edx
  107046:	72 5c                	jb     1070a4 <buddy2_alloc+0xf5>
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
  107048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10704b:	40                   	inc    %eax
  10704c:	c1 e0 04             	shl    $0x4,%eax
  10704f:	89 c2                	mov    %eax,%edx
  107051:	8b 45 08             	mov    0x8(%ebp),%eax
  107054:	01 d0                	add    %edx,%eax
  107056:	8b 50 04             	mov    0x4(%eax),%edx
  107059:	8b 45 0c             	mov    0xc(%ebp),%eax
  10705c:	39 c2                	cmp    %eax,%edx
  10705e:	72 39                	jb     107099 <buddy2_alloc+0xea>
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
  107060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107063:	c1 e0 04             	shl    $0x4,%eax
  107066:	8d 50 08             	lea    0x8(%eax),%edx
  107069:	8b 45 08             	mov    0x8(%ebp),%eax
  10706c:	01 d0                	add    %edx,%eax
  10706e:	8b 50 04             	mov    0x4(%eax),%edx
  107071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107074:	40                   	inc    %eax
  107075:	c1 e0 04             	shl    $0x4,%eax
  107078:	89 c1                	mov    %eax,%ecx
  10707a:	8b 45 08             	mov    0x8(%ebp),%eax
  10707d:	01 c8                	add    %ecx,%eax
  10707f:	8b 40 04             	mov    0x4(%eax),%eax
  107082:	39 c2                	cmp    %eax,%edx
  107084:	77 08                	ja     10708e <buddy2_alloc+0xdf>
  107086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107089:	01 c0                	add    %eax,%eax
  10708b:	40                   	inc    %eax
  10708c:	eb 06                	jmp    107094 <buddy2_alloc+0xe5>
  10708e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107091:	40                   	inc    %eax
  107092:	01 c0                	add    %eax,%eax
  107094:	89 45 f8             	mov    %eax,-0x8(%ebp)
  107097:	eb 14                	jmp    1070ad <buddy2_alloc+0xfe>
         //找到两个相符合的节点中内存较小的结点
        }
       else
       {
         index=LEFT_LEAF(index);
  107099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10709c:	01 c0                	add    %eax,%eax
  10709e:	40                   	inc    %eax
  10709f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1070a2:	eb 09                	jmp    1070ad <buddy2_alloc+0xfe>
       }  
    }
    else
      index = RIGHT_LEAF(index);
  1070a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1070a7:	40                   	inc    %eax
  1070a8:	01 c0                	add    %eax,%eax
  1070aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(node_size = self->size; node_size != size; node_size /= 2 ) {
  1070ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1070b0:	d1 e8                	shr    %eax
  1070b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1070b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1070b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1070bb:	0f 85 6f ff ff ff    	jne    107030 <buddy2_alloc+0x81>
  }

  self[index].longest = 0;//标记节点为已使用
  1070c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1070c4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1070cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1070ce:	01 d0                	add    %edx,%eax
  1070d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  offset = (index + 1) * node_size - self->size;
  1070d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1070da:	40                   	inc    %eax
  1070db:	0f af 45 f4          	imul   -0xc(%ebp),%eax
  1070df:	89 c2                	mov    %eax,%edx
  1070e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1070e4:	8b 00                	mov    (%eax),%eax
  1070e6:	29 c2                	sub    %eax,%edx
  1070e8:	89 d0                	mov    %edx,%eax
  1070ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (index) {
  1070ed:	eb 43                	jmp    107132 <buddy2_alloc+0x183>
    index = PARENT(index);
  1070ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1070f2:	40                   	inc    %eax
  1070f3:	d1 e8                	shr    %eax
  1070f5:	48                   	dec    %eax
  1070f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
  1070f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1070fc:	40                   	inc    %eax
  1070fd:	c1 e0 04             	shl    $0x4,%eax
  107100:	89 c2                	mov    %eax,%edx
  107102:	8b 45 08             	mov    0x8(%ebp),%eax
  107105:	01 d0                	add    %edx,%eax
  107107:	8b 50 04             	mov    0x4(%eax),%edx
  10710a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10710d:	c1 e0 04             	shl    $0x4,%eax
  107110:	8d 48 08             	lea    0x8(%eax),%ecx
  107113:	8b 45 08             	mov    0x8(%ebp),%eax
  107116:	01 c8                	add    %ecx,%eax
  107118:	8b 40 04             	mov    0x4(%eax),%eax
    self[index].longest = 
  10711b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  10711e:	8d 1c cd 00 00 00 00 	lea    0x0(,%ecx,8),%ebx
  107125:	8b 4d 08             	mov    0x8(%ebp),%ecx
  107128:	01 d9                	add    %ebx,%ecx
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
  10712a:	39 c2                	cmp    %eax,%edx
  10712c:	0f 43 c2             	cmovae %edx,%eax
    self[index].longest = 
  10712f:	89 41 04             	mov    %eax,0x4(%ecx)
  while (index) {
  107132:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  107136:	75 b7                	jne    1070ef <buddy2_alloc+0x140>
  }
//向上刷新，修改先祖结点的数值
  return offset;
  107138:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10713b:	83 c4 14             	add    $0x14,%esp
  10713e:	5b                   	pop    %ebx
  10713f:	5d                   	pop    %ebp
  107140:	c3                   	ret    

00107141 <buddy_alloc_pages>:

static struct Page*
buddy_alloc_pages(size_t n){
  107141:	f3 0f 1e fb          	endbr32 
  107145:	55                   	push   %ebp
  107146:	89 e5                	mov    %esp,%ebp
  107148:	53                   	push   %ebx
  107149:	83 ec 44             	sub    $0x44,%esp
  assert(n>0);
  10714c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  107150:	75 24                	jne    107176 <buddy_alloc_pages+0x35>
  107152:	c7 44 24 0c 38 9a 10 	movl   $0x109a38,0xc(%esp)
  107159:	00 
  10715a:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107161:	00 
  107162:	c7 44 24 04 8d 00 00 	movl   $0x8d,0x4(%esp)
  107169:	00 
  10716a:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  107171:	e8 bf 92 ff ff       	call   100435 <__panic>
  if(n>nr_free)
  107176:	a1 24 40 12 00       	mov    0x124024,%eax
  10717b:	39 45 08             	cmp    %eax,0x8(%ebp)
  10717e:	76 0a                	jbe    10718a <buddy_alloc_pages+0x49>
   return NULL;
  107180:	b8 00 00 00 00       	mov    $0x0,%eax
  107185:	e9 41 01 00 00       	jmp    1072cb <buddy_alloc_pages+0x18a>
  struct Page* page=NULL;
  10718a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct Page* p;
  list_entry_t *le=&free_list,*len;
  107191:	c7 45 f4 1c 40 12 00 	movl   $0x12401c,-0xc(%ebp)
  rec[nr_block].offset=buddy2_alloc(root,n);//记录偏移量
  107198:	8b 45 08             	mov    0x8(%ebp),%eax
  10719b:	8b 1d 40 40 12 00    	mov    0x124040,%ebx
  1071a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1071a5:	c7 04 24 60 40 12 00 	movl   $0x124060,(%esp)
  1071ac:	e8 fe fd ff ff       	call   106faf <buddy2_alloc>
  1071b1:	89 c2                	mov    %eax,%edx
  1071b3:	89 d8                	mov    %ebx,%eax
  1071b5:	01 c0                	add    %eax,%eax
  1071b7:	01 d8                	add    %ebx,%eax
  1071b9:	c1 e0 02             	shl    $0x2,%eax
  1071bc:	05 64 04 1c 00       	add    $0x1c0464,%eax
  1071c1:	89 10                	mov    %edx,(%eax)
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)
  1071c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1071ca:	eb 12                	jmp    1071de <buddy_alloc_pages+0x9d>
  1071cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1071cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
  1071d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1071d5:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(le);
  1071d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<rec[nr_block].offset+1;i++)
  1071db:	ff 45 f0             	incl   -0x10(%ebp)
  1071de:	8b 15 40 40 12 00    	mov    0x124040,%edx
  1071e4:	89 d0                	mov    %edx,%eax
  1071e6:	01 c0                	add    %eax,%eax
  1071e8:	01 d0                	add    %edx,%eax
  1071ea:	c1 e0 02             	shl    $0x2,%eax
  1071ed:	05 64 04 1c 00       	add    $0x1c0464,%eax
  1071f2:	8b 00                	mov    (%eax),%eax
  1071f4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1071f7:	7e d3                	jle    1071cc <buddy_alloc_pages+0x8b>
  page=le2page(le,page_link);
  1071f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1071fc:	83 e8 0c             	sub    $0xc,%eax
  1071ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int allocpages;
  if(!IS_POWER_OF_2(n))
  107202:	8b 45 08             	mov    0x8(%ebp),%eax
  107205:	48                   	dec    %eax
  107206:	23 45 08             	and    0x8(%ebp),%eax
  107209:	85 c0                	test   %eax,%eax
  10720b:	74 10                	je     10721d <buddy_alloc_pages+0xdc>
   allocpages=fixsize(n);
  10720d:	8b 45 08             	mov    0x8(%ebp),%eax
  107210:	89 04 24             	mov    %eax,(%esp)
  107213:	e8 98 f9 ff ff       	call   106bb0 <fixsize>
  107218:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10721b:	eb 06                	jmp    107223 <buddy_alloc_pages+0xe2>
  else
  {
     allocpages=n;
  10721d:	8b 45 08             	mov    0x8(%ebp),%eax
  107220:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  //根据需求n得到块大小
  rec[nr_block].base=page;//记录分配块首页
  107223:	8b 15 40 40 12 00    	mov    0x124040,%edx
  107229:	89 d0                	mov    %edx,%eax
  10722b:	01 c0                	add    %eax,%eax
  10722d:	01 d0                	add    %edx,%eax
  10722f:	c1 e0 02             	shl    $0x2,%eax
  107232:	8d 90 60 04 1c 00    	lea    0x1c0460(%eax),%edx
  107238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10723b:	89 02                	mov    %eax,(%edx)
  rec[nr_block].nr=allocpages;//记录分配的页数
  10723d:	8b 15 40 40 12 00    	mov    0x124040,%edx
  107243:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  107246:	89 d0                	mov    %edx,%eax
  107248:	01 c0                	add    %eax,%eax
  10724a:	01 d0                	add    %edx,%eax
  10724c:	c1 e0 02             	shl    $0x2,%eax
  10724f:	05 68 04 1c 00       	add    $0x1c0468,%eax
  107254:	89 08                	mov    %ecx,(%eax)
  nr_block++;
  107256:	a1 40 40 12 00       	mov    0x124040,%eax
  10725b:	40                   	inc    %eax
  10725c:	a3 40 40 12 00       	mov    %eax,0x124040
  for(i=0;i<allocpages;i++)
  107261:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  107268:	eb 3b                	jmp    1072a5 <buddy_alloc_pages+0x164>
  10726a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10726d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  107270:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107273:	8b 40 04             	mov    0x4(%eax),%eax
  {
    len=list_next(le);
  107276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p=le2page(le,page_link);
  107279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10727c:	83 e8 0c             	sub    $0xc,%eax
  10727f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    ClearPageProperty(p);
  107282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107285:	83 c0 04             	add    $0x4,%eax
  107288:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  10728f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  107292:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  107295:	8b 55 d8             	mov    -0x28(%ebp),%edx
  107298:	0f b3 10             	btr    %edx,(%eax)
}
  10729b:	90                   	nop
    le=len;
  10729c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10729f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<allocpages;i++)
  1072a2:	ff 45 f0             	incl   -0x10(%ebp)
  1072a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1072a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1072ab:	7c bd                	jl     10726a <buddy_alloc_pages+0x129>
  }//修改每一页的状态
  nr_free-=allocpages;//减去已被分配的页数
  1072ad:	8b 15 24 40 12 00    	mov    0x124024,%edx
  1072b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1072b6:	29 c2                	sub    %eax,%edx
  1072b8:	89 d0                	mov    %edx,%eax
  1072ba:	a3 24 40 12 00       	mov    %eax,0x124024
  page->property=n;
  1072bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1072c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1072c5:	89 50 08             	mov    %edx,0x8(%eax)
  return page;
  1072c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  1072cb:	83 c4 44             	add    $0x44,%esp
  1072ce:	5b                   	pop    %ebx
  1072cf:	5d                   	pop    %ebp
  1072d0:	c3                   	ret    

001072d1 <buddy_free_pages>:

void buddy_free_pages(struct Page* base, size_t n) {
  1072d1:	f3 0f 1e fb          	endbr32 
  1072d5:	55                   	push   %ebp
  1072d6:	89 e5                	mov    %esp,%ebp
  1072d8:	83 ec 58             	sub    $0x58,%esp
  unsigned node_size, index = 0;
  1072db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
  1072e2:	c7 45 e0 60 40 12 00 	movl   $0x124060,-0x20(%ebp)
  1072e9:	c7 45 c8 1c 40 12 00 	movl   $0x12401c,-0x38(%ebp)
  1072f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1072f3:	8b 40 04             	mov    0x4(%eax),%eax
  
  list_entry_t *le=list_next(&free_list);
  1072f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i=0;
  1072f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(i=0;i<nr_block;i++)//找到块
  107300:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  107307:	eb 1b                	jmp    107324 <buddy_free_pages+0x53>
  {
    if(rec[i].base==base)
  107309:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10730c:	89 d0                	mov    %edx,%eax
  10730e:	01 c0                	add    %eax,%eax
  107310:	01 d0                	add    %edx,%eax
  107312:	c1 e0 02             	shl    $0x2,%eax
  107315:	05 60 04 1c 00       	add    $0x1c0460,%eax
  10731a:	8b 00                	mov    (%eax),%eax
  10731c:	39 45 08             	cmp    %eax,0x8(%ebp)
  10731f:	74 0f                	je     107330 <buddy_free_pages+0x5f>
  for(i=0;i<nr_block;i++)//找到块
  107321:	ff 45 e8             	incl   -0x18(%ebp)
  107324:	a1 40 40 12 00       	mov    0x124040,%eax
  107329:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10732c:	7c db                	jl     107309 <buddy_free_pages+0x38>
  10732e:	eb 01                	jmp    107331 <buddy_free_pages+0x60>
     break;
  107330:	90                   	nop
  }
  int offset=rec[i].offset;
  107331:	8b 55 e8             	mov    -0x18(%ebp),%edx
  107334:	89 d0                	mov    %edx,%eax
  107336:	01 c0                	add    %eax,%eax
  107338:	01 d0                	add    %edx,%eax
  10733a:	c1 e0 02             	shl    $0x2,%eax
  10733d:	05 64 04 1c 00       	add    $0x1c0464,%eax
  107342:	8b 00                	mov    (%eax),%eax
  107344:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int pos=i;//暂存i
  107347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10734a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  i=0;
  10734d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  while(i<offset)
  107354:	eb 12                	jmp    107368 <buddy_free_pages+0x97>
  107356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107359:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  10735c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10735f:	8b 40 04             	mov    0x4(%eax),%eax
  {
    le=list_next(le);
  107362:	89 45 ec             	mov    %eax,-0x14(%ebp)
    i++;
  107365:	ff 45 e8             	incl   -0x18(%ebp)
  while(i<offset)
  107368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10736b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10736e:	7c e6                	jl     107356 <buddy_free_pages+0x85>
  }
  int allocpages;
  if(!IS_POWER_OF_2(n))
  107370:	8b 45 0c             	mov    0xc(%ebp),%eax
  107373:	48                   	dec    %eax
  107374:	23 45 0c             	and    0xc(%ebp),%eax
  107377:	85 c0                	test   %eax,%eax
  107379:	74 10                	je     10738b <buddy_free_pages+0xba>
   allocpages=fixsize(n);
  10737b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10737e:	89 04 24             	mov    %eax,(%esp)
  107381:	e8 2a f8 ff ff       	call   106bb0 <fixsize>
  107386:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107389:	eb 06                	jmp    107391 <buddy_free_pages+0xc0>
  else
  {
     allocpages=n;
  10738b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10738e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  assert(self && offset >= 0 && offset < self->size);//是否合法
  107391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  107395:	74 12                	je     1073a9 <buddy_free_pages+0xd8>
  107397:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10739b:	78 0c                	js     1073a9 <buddy_free_pages+0xd8>
  10739d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1073a0:	8b 10                	mov    (%eax),%edx
  1073a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1073a5:	39 c2                	cmp    %eax,%edx
  1073a7:	77 24                	ja     1073cd <buddy_free_pages+0xfc>
  1073a9:	c7 44 24 0c 78 9a 10 	movl   $0x109a78,0xc(%esp)
  1073b0:	00 
  1073b1:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  1073b8:	00 
  1073b9:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  1073c0:	00 
  1073c1:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1073c8:	e8 68 90 ff ff       	call   100435 <__panic>
  node_size = 1;
  1073cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  index = offset + self->size - 1;
  1073d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1073d7:	8b 10                	mov    (%eax),%edx
  1073d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1073dc:	01 d0                	add    %edx,%eax
  1073de:	48                   	dec    %eax
  1073df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  nr_free+=allocpages;//更新空闲页的数量
  1073e2:	8b 15 24 40 12 00    	mov    0x124024,%edx
  1073e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1073eb:	01 d0                	add    %edx,%eax
  1073ed:	a3 24 40 12 00       	mov    %eax,0x124024
  struct Page* p;
  self[index].longest = allocpages;
  1073f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1073f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1073fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1073ff:	01 c2                	add    %eax,%edx
  107401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107404:	89 42 04             	mov    %eax,0x4(%edx)
  for(i=0;i<allocpages;i++)//回收已分配的页
  107407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10740e:	eb 49                	jmp    107459 <buddy_free_pages+0x188>
  {
     p=le2page(le,page_link);
  107410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107413:	83 e8 0c             	sub    $0xc,%eax
  107416:	89 45 cc             	mov    %eax,-0x34(%ebp)
     p->flags=0;
  107419:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10741c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     p->property=1;
  107423:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107426:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
     SetPageProperty(p);
  10742d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107430:	83 c0 04             	add    $0x4,%eax
  107433:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  10743a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10743d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  107440:	8b 55 bc             	mov    -0x44(%ebp),%edx
  107443:	0f ab 10             	bts    %edx,(%eax)
}
  107446:	90                   	nop
  107447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10744a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  10744d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  107450:	8b 40 04             	mov    0x4(%eax),%eax
     le=list_next(le);
  107453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(i=0;i<allocpages;i++)//回收已分配的页
  107456:	ff 45 e8             	incl   -0x18(%ebp)
  107459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10745c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  10745f:	7c af                	jl     107410 <buddy_free_pages+0x13f>
  }
  while (index) {//向上合并，修改先祖节点的记录值
  107461:	eb 75                	jmp    1074d8 <buddy_free_pages+0x207>
    index = PARENT(index);
  107463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107466:	40                   	inc    %eax
  107467:	d1 e8                	shr    %eax
  107469:	48                   	dec    %eax
  10746a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
  10746d:	d1 65 f4             	shll   -0xc(%ebp)

    left_longest = self[LEFT_LEAF(index)].longest;
  107470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107473:	c1 e0 04             	shl    $0x4,%eax
  107476:	8d 50 08             	lea    0x8(%eax),%edx
  107479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10747c:	01 d0                	add    %edx,%eax
  10747e:	8b 40 04             	mov    0x4(%eax),%eax
  107481:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    right_longest = self[RIGHT_LEAF(index)].longest;
  107484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107487:	40                   	inc    %eax
  107488:	c1 e0 04             	shl    $0x4,%eax
  10748b:	89 c2                	mov    %eax,%edx
  10748d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107490:	01 d0                	add    %edx,%eax
  107492:	8b 40 04             	mov    0x4(%eax),%eax
  107495:	89 45 d0             	mov    %eax,-0x30(%ebp)
    
    if (left_longest + right_longest == node_size) 
  107498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10749b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10749e:	01 d0                	add    %edx,%eax
  1074a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1074a3:	75 17                	jne    1074bc <buddy_free_pages+0x1eb>
      self[index].longest = node_size;
  1074a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1074a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1074af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1074b2:	01 c2                	add    %eax,%edx
  1074b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1074b7:	89 42 04             	mov    %eax,0x4(%edx)
  1074ba:	eb 1c                	jmp    1074d8 <buddy_free_pages+0x207>
    else
      self[index].longest = MAX(left_longest, right_longest);
  1074bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1074bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1074c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1074c9:	01 c2                	add    %eax,%edx
  1074cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1074ce:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1074d1:	0f 43 45 d0          	cmovae -0x30(%ebp),%eax
  1074d5:	89 42 04             	mov    %eax,0x4(%edx)
  while (index) {//向上合并，修改先祖节点的记录值
  1074d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1074dc:	75 85                	jne    107463 <buddy_free_pages+0x192>
  }
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
  1074de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1074e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1074e4:	eb 39                	jmp    10751f <buddy_free_pages+0x24e>
  {
    rec[i]=rec[i+1];
  1074e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1074e9:	8d 48 01             	lea    0x1(%eax),%ecx
  1074ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1074ef:	89 d0                	mov    %edx,%eax
  1074f1:	01 c0                	add    %eax,%eax
  1074f3:	01 d0                	add    %edx,%eax
  1074f5:	c1 e0 02             	shl    $0x2,%eax
  1074f8:	8d 90 60 04 1c 00    	lea    0x1c0460(%eax),%edx
  1074fe:	89 c8                	mov    %ecx,%eax
  107500:	01 c0                	add    %eax,%eax
  107502:	01 c8                	add    %ecx,%eax
  107504:	c1 e0 02             	shl    $0x2,%eax
  107507:	05 60 04 1c 00       	add    $0x1c0460,%eax
  10750c:	8b 08                	mov    (%eax),%ecx
  10750e:	89 0a                	mov    %ecx,(%edx)
  107510:	8b 48 04             	mov    0x4(%eax),%ecx
  107513:	89 4a 04             	mov    %ecx,0x4(%edx)
  107516:	8b 40 08             	mov    0x8(%eax),%eax
  107519:	89 42 08             	mov    %eax,0x8(%edx)
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
  10751c:	ff 45 e8             	incl   -0x18(%ebp)
  10751f:	a1 40 40 12 00       	mov    0x124040,%eax
  107524:	48                   	dec    %eax
  107525:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  107528:	7c bc                	jl     1074e6 <buddy_free_pages+0x215>
  }
  nr_block--;//更新分配块数的值
  10752a:	a1 40 40 12 00       	mov    0x124040,%eax
  10752f:	48                   	dec    %eax
  107530:	a3 40 40 12 00       	mov    %eax,0x124040
}
  107535:	90                   	nop
  107536:	c9                   	leave  
  107537:	c3                   	ret    

00107538 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  107538:	f3 0f 1e fb          	endbr32 
  10753c:	55                   	push   %ebp
  10753d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10753f:	a1 24 40 12 00       	mov    0x124024,%eax
}
  107544:	5d                   	pop    %ebp
  107545:	c3                   	ret    

00107546 <buddy_check>:

//以下是一个测试函数
static void

buddy_check(void) {
  107546:	f3 0f 1e fb          	endbr32 
  10754a:	55                   	push   %ebp
  10754b:	89 e5                	mov    %esp,%ebp
  10754d:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *A, *B,*C,*D;
    p0 = A = B = C = D =NULL;
  107550:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  107557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10755a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10755d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107560:	89 45 ec             	mov    %eax,-0x14(%ebp)
  107563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107566:	89 45 e8             	mov    %eax,-0x18(%ebp)
  107569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10756c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
  10756f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107576:	e8 1b b9 ff ff       	call   102e96 <alloc_pages>
  10757b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10757e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  107582:	75 24                	jne    1075a8 <buddy_check+0x62>
  107584:	c7 44 24 0c a3 9a 10 	movl   $0x109aa3,0xc(%esp)
  10758b:	00 
  10758c:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107593:	00 
  107594:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  10759b:	00 
  10759c:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1075a3:	e8 8d 8e ff ff       	call   100435 <__panic>
    assert((A = alloc_page()) != NULL);
  1075a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1075af:	e8 e2 b8 ff ff       	call   102e96 <alloc_pages>
  1075b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1075b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1075bb:	75 24                	jne    1075e1 <buddy_check+0x9b>
  1075bd:	c7 44 24 0c bf 9a 10 	movl   $0x109abf,0xc(%esp)
  1075c4:	00 
  1075c5:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  1075cc:	00 
  1075cd:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1075d4:	00 
  1075d5:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1075dc:	e8 54 8e ff ff       	call   100435 <__panic>
    assert((B = alloc_page()) != NULL);
  1075e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1075e8:	e8 a9 b8 ff ff       	call   102e96 <alloc_pages>
  1075ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1075f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1075f4:	75 24                	jne    10761a <buddy_check+0xd4>
  1075f6:	c7 44 24 0c da 9a 10 	movl   $0x109ada,0xc(%esp)
  1075fd:	00 
  1075fe:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107605:	00 
  107606:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  10760d:	00 
  10760e:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  107615:	e8 1b 8e ff ff       	call   100435 <__panic>

    assert(p0 != A && p0 != B && A != B);
  10761a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10761d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  107620:	74 10                	je     107632 <buddy_check+0xec>
  107622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107625:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  107628:	74 08                	je     107632 <buddy_check+0xec>
  10762a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10762d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  107630:	75 24                	jne    107656 <buddy_check+0x110>
  107632:	c7 44 24 0c f5 9a 10 	movl   $0x109af5,0xc(%esp)
  107639:	00 
  10763a:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107641:	00 
  107642:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  107649:	00 
  10764a:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  107651:	e8 df 8d ff ff       	call   100435 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
  107656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107659:	89 04 24             	mov    %eax,(%esp)
  10765c:	e8 37 f5 ff ff       	call   106b98 <page_ref>
  107661:	85 c0                	test   %eax,%eax
  107663:	75 1e                	jne    107683 <buddy_check+0x13d>
  107665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107668:	89 04 24             	mov    %eax,(%esp)
  10766b:	e8 28 f5 ff ff       	call   106b98 <page_ref>
  107670:	85 c0                	test   %eax,%eax
  107672:	75 0f                	jne    107683 <buddy_check+0x13d>
  107674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107677:	89 04 24             	mov    %eax,(%esp)
  10767a:	e8 19 f5 ff ff       	call   106b98 <page_ref>
  10767f:	85 c0                	test   %eax,%eax
  107681:	74 24                	je     1076a7 <buddy_check+0x161>
  107683:	c7 44 24 0c 14 9b 10 	movl   $0x109b14,0xc(%esp)
  10768a:	00 
  10768b:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107692:	00 
  107693:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  10769a:	00 
  10769b:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1076a2:	e8 8e 8d ff ff       	call   100435 <__panic>
    free_page(p0);
  1076a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1076ae:	00 
  1076af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1076b2:	89 04 24             	mov    %eax,(%esp)
  1076b5:	e8 18 b8 ff ff       	call   102ed2 <free_pages>
    free_page(A);
  1076ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1076c1:	00 
  1076c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1076c5:	89 04 24             	mov    %eax,(%esp)
  1076c8:	e8 05 b8 ff ff       	call   102ed2 <free_pages>
    free_page(B);
  1076cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1076d4:	00 
  1076d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1076d8:	89 04 24             	mov    %eax,(%esp)
  1076db:	e8 f2 b7 ff ff       	call   102ed2 <free_pages>
    
    A=alloc_pages(500);
  1076e0:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  1076e7:	e8 aa b7 ff ff       	call   102e96 <alloc_pages>
  1076ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(500);
  1076ef:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  1076f6:	e8 9b b7 ff ff       	call   102e96 <alloc_pages>
  1076fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("A %p\n",A);
  1076fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107701:	89 44 24 04          	mov    %eax,0x4(%esp)
  107705:	c7 04 24 4e 9b 10 00 	movl   $0x109b4e,(%esp)
  10770c:	e8 b8 8b ff ff       	call   1002c9 <cprintf>
    cprintf("B %p\n",B);
  107711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107714:	89 44 24 04          	mov    %eax,0x4(%esp)
  107718:	c7 04 24 54 9b 10 00 	movl   $0x109b54,(%esp)
  10771f:	e8 a5 8b ff ff       	call   1002c9 <cprintf>
    free_pages(A,250);
  107724:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10772b:	00 
  10772c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10772f:	89 04 24             	mov    %eax,(%esp)
  107732:	e8 9b b7 ff ff       	call   102ed2 <free_pages>
    free_pages(B,500);
  107737:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  10773e:	00 
  10773f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107742:	89 04 24             	mov    %eax,(%esp)
  107745:	e8 88 b7 ff ff       	call   102ed2 <free_pages>
    free_pages(A+250,250);
  10774a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10774d:	05 88 13 00 00       	add    $0x1388,%eax
  107752:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  107759:	00 
  10775a:	89 04 24             	mov    %eax,(%esp)
  10775d:	e8 70 b7 ff ff       	call   102ed2 <free_pages>
    
    p0=alloc_pages(1024);
  107762:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  107769:	e8 28 b7 ff ff       	call   102e96 <alloc_pages>
  10776e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("p0 %p\n",p0);
  107771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107774:	89 44 24 04          	mov    %eax,0x4(%esp)
  107778:	c7 04 24 5a 9b 10 00 	movl   $0x109b5a,(%esp)
  10777f:	e8 45 8b ff ff       	call   1002c9 <cprintf>
    assert(p0 == A);
  107784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107787:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  10778a:	74 24                	je     1077b0 <buddy_check+0x26a>
  10778c:	c7 44 24 0c 61 9b 10 	movl   $0x109b61,0xc(%esp)
  107793:	00 
  107794:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  10779b:	00 
  10779c:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1077a3:	00 
  1077a4:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1077ab:	e8 85 8c ff ff       	call   100435 <__panic>
    //以下是根据链接中的样例测试编写的
    A=alloc_pages(70);  
  1077b0:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
  1077b7:	e8 da b6 ff ff       	call   102e96 <alloc_pages>
  1077bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(35);
  1077bf:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  1077c6:	e8 cb b6 ff ff       	call   102e96 <alloc_pages>
  1077cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(A+128==B);//检查是否相邻
  1077ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1077d1:	05 00 0a 00 00       	add    $0xa00,%eax
  1077d6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1077d9:	74 24                	je     1077ff <buddy_check+0x2b9>
  1077db:	c7 44 24 0c 69 9b 10 	movl   $0x109b69,0xc(%esp)
  1077e2:	00 
  1077e3:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  1077ea:	00 
  1077eb:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1077f2:	00 
  1077f3:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1077fa:	e8 36 8c ff ff       	call   100435 <__panic>
    cprintf("A %p\n",A);
  1077ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107802:	89 44 24 04          	mov    %eax,0x4(%esp)
  107806:	c7 04 24 4e 9b 10 00 	movl   $0x109b4e,(%esp)
  10780d:	e8 b7 8a ff ff       	call   1002c9 <cprintf>
    cprintf("B %p\n",B);
  107812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107815:	89 44 24 04          	mov    %eax,0x4(%esp)
  107819:	c7 04 24 54 9b 10 00 	movl   $0x109b54,(%esp)
  107820:	e8 a4 8a ff ff       	call   1002c9 <cprintf>
    C=alloc_pages(80);
  107825:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  10782c:	e8 65 b6 ff ff       	call   102e96 <alloc_pages>
  107831:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(A+256==C);//检查C有没有和A重叠
  107834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107837:	05 00 14 00 00       	add    $0x1400,%eax
  10783c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10783f:	74 24                	je     107865 <buddy_check+0x31f>
  107841:	c7 44 24 0c 72 9b 10 	movl   $0x109b72,0xc(%esp)
  107848:	00 
  107849:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  107850:	00 
  107851:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  107858:	00 
  107859:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  107860:	e8 d0 8b ff ff       	call   100435 <__panic>
    cprintf("C %p\n",C);
  107865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107868:	89 44 24 04          	mov    %eax,0x4(%esp)
  10786c:	c7 04 24 7b 9b 10 00 	movl   $0x109b7b,(%esp)
  107873:	e8 51 8a ff ff       	call   1002c9 <cprintf>
    free_pages(A,70);//释放A
  107878:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10787f:	00 
  107880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107883:	89 04 24             	mov    %eax,(%esp)
  107886:	e8 47 b6 ff ff       	call   102ed2 <free_pages>
    cprintf("B %p\n",B);
  10788b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10788e:	89 44 24 04          	mov    %eax,0x4(%esp)
  107892:	c7 04 24 54 9b 10 00 	movl   $0x109b54,(%esp)
  107899:	e8 2b 8a ff ff       	call   1002c9 <cprintf>
    D=alloc_pages(60);
  10789e:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
  1078a5:	e8 ec b5 ff ff       	call   102e96 <alloc_pages>
  1078aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n",D);
  1078ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1078b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1078b4:	c7 04 24 81 9b 10 00 	movl   $0x109b81,(%esp)
  1078bb:	e8 09 8a ff ff       	call   1002c9 <cprintf>
    assert(B+64==D);//检查B，D是否相邻
  1078c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1078c3:	05 00 05 00 00       	add    $0x500,%eax
  1078c8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1078cb:	74 24                	je     1078f1 <buddy_check+0x3ab>
  1078cd:	c7 44 24 0c 87 9b 10 	movl   $0x109b87,0xc(%esp)
  1078d4:	00 
  1078d5:	c7 44 24 08 3c 9a 10 	movl   $0x109a3c,0x8(%esp)
  1078dc:	00 
  1078dd:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  1078e4:	00 
  1078e5:	c7 04 24 51 9a 10 00 	movl   $0x109a51,(%esp)
  1078ec:	e8 44 8b ff ff       	call   100435 <__panic>
    free_pages(B,35);
  1078f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  1078f8:	00 
  1078f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1078fc:	89 04 24             	mov    %eax,(%esp)
  1078ff:	e8 ce b5 ff ff       	call   102ed2 <free_pages>
    cprintf("D %p\n",D);
  107904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107907:	89 44 24 04          	mov    %eax,0x4(%esp)
  10790b:	c7 04 24 81 9b 10 00 	movl   $0x109b81,(%esp)
  107912:	e8 b2 89 ff ff       	call   1002c9 <cprintf>
    free_pages(D,60);
  107917:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  10791e:	00 
  10791f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107922:	89 04 24             	mov    %eax,(%esp)
  107925:	e8 a8 b5 ff ff       	call   102ed2 <free_pages>
    cprintf("C %p\n",C);
  10792a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10792d:	89 44 24 04          	mov    %eax,0x4(%esp)
  107931:	c7 04 24 7b 9b 10 00 	movl   $0x109b7b,(%esp)
  107938:	e8 8c 89 ff ff       	call   1002c9 <cprintf>
    free_pages(C,80);
  10793d:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  107944:	00 
  107945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107948:	89 04 24             	mov    %eax,(%esp)
  10794b:	e8 82 b5 ff ff       	call   102ed2 <free_pages>
    free_pages(p0,1000);//全部释放
  107950:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  107957:	00 
  107958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10795b:	89 04 24             	mov    %eax,(%esp)
  10795e:	e8 6f b5 ff ff       	call   102ed2 <free_pages>
}
  107963:	90                   	nop
  107964:	c9                   	leave  
  107965:	c3                   	ret    

00107966 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  107966:	f3 0f 1e fb          	endbr32 
  10796a:	55                   	push   %ebp
  10796b:	89 e5                	mov    %esp,%ebp
  10796d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  107970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  107977:	eb 03                	jmp    10797c <strlen+0x16>
        cnt ++;
  107979:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  10797c:	8b 45 08             	mov    0x8(%ebp),%eax
  10797f:	8d 50 01             	lea    0x1(%eax),%edx
  107982:	89 55 08             	mov    %edx,0x8(%ebp)
  107985:	0f b6 00             	movzbl (%eax),%eax
  107988:	84 c0                	test   %al,%al
  10798a:	75 ed                	jne    107979 <strlen+0x13>
    }
    return cnt;
  10798c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10798f:	c9                   	leave  
  107990:	c3                   	ret    

00107991 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  107991:	f3 0f 1e fb          	endbr32 
  107995:	55                   	push   %ebp
  107996:	89 e5                	mov    %esp,%ebp
  107998:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10799b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1079a2:	eb 03                	jmp    1079a7 <strnlen+0x16>
        cnt ++;
  1079a4:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1079a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1079aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1079ad:	73 10                	jae    1079bf <strnlen+0x2e>
  1079af:	8b 45 08             	mov    0x8(%ebp),%eax
  1079b2:	8d 50 01             	lea    0x1(%eax),%edx
  1079b5:	89 55 08             	mov    %edx,0x8(%ebp)
  1079b8:	0f b6 00             	movzbl (%eax),%eax
  1079bb:	84 c0                	test   %al,%al
  1079bd:	75 e5                	jne    1079a4 <strnlen+0x13>
    }
    return cnt;
  1079bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1079c2:	c9                   	leave  
  1079c3:	c3                   	ret    

001079c4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1079c4:	f3 0f 1e fb          	endbr32 
  1079c8:	55                   	push   %ebp
  1079c9:	89 e5                	mov    %esp,%ebp
  1079cb:	57                   	push   %edi
  1079cc:	56                   	push   %esi
  1079cd:	83 ec 20             	sub    $0x20,%esp
  1079d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1079d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1079d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1079d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1079dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1079df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1079e2:	89 d1                	mov    %edx,%ecx
  1079e4:	89 c2                	mov    %eax,%edx
  1079e6:	89 ce                	mov    %ecx,%esi
  1079e8:	89 d7                	mov    %edx,%edi
  1079ea:	ac                   	lods   %ds:(%esi),%al
  1079eb:	aa                   	stos   %al,%es:(%edi)
  1079ec:	84 c0                	test   %al,%al
  1079ee:	75 fa                	jne    1079ea <strcpy+0x26>
  1079f0:	89 fa                	mov    %edi,%edx
  1079f2:	89 f1                	mov    %esi,%ecx
  1079f4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1079f7:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1079fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1079fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  107a00:	83 c4 20             	add    $0x20,%esp
  107a03:	5e                   	pop    %esi
  107a04:	5f                   	pop    %edi
  107a05:	5d                   	pop    %ebp
  107a06:	c3                   	ret    

00107a07 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  107a07:	f3 0f 1e fb          	endbr32 
  107a0b:	55                   	push   %ebp
  107a0c:	89 e5                	mov    %esp,%ebp
  107a0e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  107a11:	8b 45 08             	mov    0x8(%ebp),%eax
  107a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  107a17:	eb 1e                	jmp    107a37 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  107a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a1c:	0f b6 10             	movzbl (%eax),%edx
  107a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107a22:	88 10                	mov    %dl,(%eax)
  107a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107a27:	0f b6 00             	movzbl (%eax),%eax
  107a2a:	84 c0                	test   %al,%al
  107a2c:	74 03                	je     107a31 <strncpy+0x2a>
            src ++;
  107a2e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  107a31:	ff 45 fc             	incl   -0x4(%ebp)
  107a34:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  107a37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107a3b:	75 dc                	jne    107a19 <strncpy+0x12>
    }
    return dst;
  107a3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  107a40:	c9                   	leave  
  107a41:	c3                   	ret    

00107a42 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  107a42:	f3 0f 1e fb          	endbr32 
  107a46:	55                   	push   %ebp
  107a47:	89 e5                	mov    %esp,%ebp
  107a49:	57                   	push   %edi
  107a4a:	56                   	push   %esi
  107a4b:	83 ec 20             	sub    $0x20,%esp
  107a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  107a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  107a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  107a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107a60:	89 d1                	mov    %edx,%ecx
  107a62:	89 c2                	mov    %eax,%edx
  107a64:	89 ce                	mov    %ecx,%esi
  107a66:	89 d7                	mov    %edx,%edi
  107a68:	ac                   	lods   %ds:(%esi),%al
  107a69:	ae                   	scas   %es:(%edi),%al
  107a6a:	75 08                	jne    107a74 <strcmp+0x32>
  107a6c:	84 c0                	test   %al,%al
  107a6e:	75 f8                	jne    107a68 <strcmp+0x26>
  107a70:	31 c0                	xor    %eax,%eax
  107a72:	eb 04                	jmp    107a78 <strcmp+0x36>
  107a74:	19 c0                	sbb    %eax,%eax
  107a76:	0c 01                	or     $0x1,%al
  107a78:	89 fa                	mov    %edi,%edx
  107a7a:	89 f1                	mov    %esi,%ecx
  107a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  107a7f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  107a82:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  107a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  107a88:	83 c4 20             	add    $0x20,%esp
  107a8b:	5e                   	pop    %esi
  107a8c:	5f                   	pop    %edi
  107a8d:	5d                   	pop    %ebp
  107a8e:	c3                   	ret    

00107a8f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  107a8f:	f3 0f 1e fb          	endbr32 
  107a93:	55                   	push   %ebp
  107a94:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  107a96:	eb 09                	jmp    107aa1 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  107a98:	ff 4d 10             	decl   0x10(%ebp)
  107a9b:	ff 45 08             	incl   0x8(%ebp)
  107a9e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  107aa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107aa5:	74 1a                	je     107ac1 <strncmp+0x32>
  107aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  107aaa:	0f b6 00             	movzbl (%eax),%eax
  107aad:	84 c0                	test   %al,%al
  107aaf:	74 10                	je     107ac1 <strncmp+0x32>
  107ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  107ab4:	0f b6 10             	movzbl (%eax),%edx
  107ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  107aba:	0f b6 00             	movzbl (%eax),%eax
  107abd:	38 c2                	cmp    %al,%dl
  107abf:	74 d7                	je     107a98 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  107ac1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107ac5:	74 18                	je     107adf <strncmp+0x50>
  107ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  107aca:	0f b6 00             	movzbl (%eax),%eax
  107acd:	0f b6 d0             	movzbl %al,%edx
  107ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  107ad3:	0f b6 00             	movzbl (%eax),%eax
  107ad6:	0f b6 c0             	movzbl %al,%eax
  107ad9:	29 c2                	sub    %eax,%edx
  107adb:	89 d0                	mov    %edx,%eax
  107add:	eb 05                	jmp    107ae4 <strncmp+0x55>
  107adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107ae4:	5d                   	pop    %ebp
  107ae5:	c3                   	ret    

00107ae6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  107ae6:	f3 0f 1e fb          	endbr32 
  107aea:	55                   	push   %ebp
  107aeb:	89 e5                	mov    %esp,%ebp
  107aed:	83 ec 04             	sub    $0x4,%esp
  107af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  107af3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  107af6:	eb 13                	jmp    107b0b <strchr+0x25>
        if (*s == c) {
  107af8:	8b 45 08             	mov    0x8(%ebp),%eax
  107afb:	0f b6 00             	movzbl (%eax),%eax
  107afe:	38 45 fc             	cmp    %al,-0x4(%ebp)
  107b01:	75 05                	jne    107b08 <strchr+0x22>
            return (char *)s;
  107b03:	8b 45 08             	mov    0x8(%ebp),%eax
  107b06:	eb 12                	jmp    107b1a <strchr+0x34>
        }
        s ++;
  107b08:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  107b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  107b0e:	0f b6 00             	movzbl (%eax),%eax
  107b11:	84 c0                	test   %al,%al
  107b13:	75 e3                	jne    107af8 <strchr+0x12>
    }
    return NULL;
  107b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107b1a:	c9                   	leave  
  107b1b:	c3                   	ret    

00107b1c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  107b1c:	f3 0f 1e fb          	endbr32 
  107b20:	55                   	push   %ebp
  107b21:	89 e5                	mov    %esp,%ebp
  107b23:	83 ec 04             	sub    $0x4,%esp
  107b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  107b29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  107b2c:	eb 0e                	jmp    107b3c <strfind+0x20>
        if (*s == c) {
  107b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  107b31:	0f b6 00             	movzbl (%eax),%eax
  107b34:	38 45 fc             	cmp    %al,-0x4(%ebp)
  107b37:	74 0f                	je     107b48 <strfind+0x2c>
            break;
        }
        s ++;
  107b39:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  107b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  107b3f:	0f b6 00             	movzbl (%eax),%eax
  107b42:	84 c0                	test   %al,%al
  107b44:	75 e8                	jne    107b2e <strfind+0x12>
  107b46:	eb 01                	jmp    107b49 <strfind+0x2d>
            break;
  107b48:	90                   	nop
    }
    return (char *)s;
  107b49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  107b4c:	c9                   	leave  
  107b4d:	c3                   	ret    

00107b4e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  107b4e:	f3 0f 1e fb          	endbr32 
  107b52:	55                   	push   %ebp
  107b53:	89 e5                	mov    %esp,%ebp
  107b55:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  107b58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  107b5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  107b66:	eb 03                	jmp    107b6b <strtol+0x1d>
        s ++;
  107b68:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  107b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  107b6e:	0f b6 00             	movzbl (%eax),%eax
  107b71:	3c 20                	cmp    $0x20,%al
  107b73:	74 f3                	je     107b68 <strtol+0x1a>
  107b75:	8b 45 08             	mov    0x8(%ebp),%eax
  107b78:	0f b6 00             	movzbl (%eax),%eax
  107b7b:	3c 09                	cmp    $0x9,%al
  107b7d:	74 e9                	je     107b68 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  107b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  107b82:	0f b6 00             	movzbl (%eax),%eax
  107b85:	3c 2b                	cmp    $0x2b,%al
  107b87:	75 05                	jne    107b8e <strtol+0x40>
        s ++;
  107b89:	ff 45 08             	incl   0x8(%ebp)
  107b8c:	eb 14                	jmp    107ba2 <strtol+0x54>
    }
    else if (*s == '-') {
  107b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  107b91:	0f b6 00             	movzbl (%eax),%eax
  107b94:	3c 2d                	cmp    $0x2d,%al
  107b96:	75 0a                	jne    107ba2 <strtol+0x54>
        s ++, neg = 1;
  107b98:	ff 45 08             	incl   0x8(%ebp)
  107b9b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  107ba2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107ba6:	74 06                	je     107bae <strtol+0x60>
  107ba8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  107bac:	75 22                	jne    107bd0 <strtol+0x82>
  107bae:	8b 45 08             	mov    0x8(%ebp),%eax
  107bb1:	0f b6 00             	movzbl (%eax),%eax
  107bb4:	3c 30                	cmp    $0x30,%al
  107bb6:	75 18                	jne    107bd0 <strtol+0x82>
  107bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  107bbb:	40                   	inc    %eax
  107bbc:	0f b6 00             	movzbl (%eax),%eax
  107bbf:	3c 78                	cmp    $0x78,%al
  107bc1:	75 0d                	jne    107bd0 <strtol+0x82>
        s += 2, base = 16;
  107bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  107bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  107bce:	eb 29                	jmp    107bf9 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  107bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107bd4:	75 16                	jne    107bec <strtol+0x9e>
  107bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  107bd9:	0f b6 00             	movzbl (%eax),%eax
  107bdc:	3c 30                	cmp    $0x30,%al
  107bde:	75 0c                	jne    107bec <strtol+0x9e>
        s ++, base = 8;
  107be0:	ff 45 08             	incl   0x8(%ebp)
  107be3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  107bea:	eb 0d                	jmp    107bf9 <strtol+0xab>
    }
    else if (base == 0) {
  107bec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  107bf0:	75 07                	jne    107bf9 <strtol+0xab>
        base = 10;
  107bf2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  107bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  107bfc:	0f b6 00             	movzbl (%eax),%eax
  107bff:	3c 2f                	cmp    $0x2f,%al
  107c01:	7e 1b                	jle    107c1e <strtol+0xd0>
  107c03:	8b 45 08             	mov    0x8(%ebp),%eax
  107c06:	0f b6 00             	movzbl (%eax),%eax
  107c09:	3c 39                	cmp    $0x39,%al
  107c0b:	7f 11                	jg     107c1e <strtol+0xd0>
            dig = *s - '0';
  107c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  107c10:	0f b6 00             	movzbl (%eax),%eax
  107c13:	0f be c0             	movsbl %al,%eax
  107c16:	83 e8 30             	sub    $0x30,%eax
  107c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107c1c:	eb 48                	jmp    107c66 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  107c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  107c21:	0f b6 00             	movzbl (%eax),%eax
  107c24:	3c 60                	cmp    $0x60,%al
  107c26:	7e 1b                	jle    107c43 <strtol+0xf5>
  107c28:	8b 45 08             	mov    0x8(%ebp),%eax
  107c2b:	0f b6 00             	movzbl (%eax),%eax
  107c2e:	3c 7a                	cmp    $0x7a,%al
  107c30:	7f 11                	jg     107c43 <strtol+0xf5>
            dig = *s - 'a' + 10;
  107c32:	8b 45 08             	mov    0x8(%ebp),%eax
  107c35:	0f b6 00             	movzbl (%eax),%eax
  107c38:	0f be c0             	movsbl %al,%eax
  107c3b:	83 e8 57             	sub    $0x57,%eax
  107c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107c41:	eb 23                	jmp    107c66 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  107c43:	8b 45 08             	mov    0x8(%ebp),%eax
  107c46:	0f b6 00             	movzbl (%eax),%eax
  107c49:	3c 40                	cmp    $0x40,%al
  107c4b:	7e 3b                	jle    107c88 <strtol+0x13a>
  107c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  107c50:	0f b6 00             	movzbl (%eax),%eax
  107c53:	3c 5a                	cmp    $0x5a,%al
  107c55:	7f 31                	jg     107c88 <strtol+0x13a>
            dig = *s - 'A' + 10;
  107c57:	8b 45 08             	mov    0x8(%ebp),%eax
  107c5a:	0f b6 00             	movzbl (%eax),%eax
  107c5d:	0f be c0             	movsbl %al,%eax
  107c60:	83 e8 37             	sub    $0x37,%eax
  107c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  107c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  107c6c:	7d 19                	jge    107c87 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  107c6e:	ff 45 08             	incl   0x8(%ebp)
  107c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107c74:	0f af 45 10          	imul   0x10(%ebp),%eax
  107c78:	89 c2                	mov    %eax,%edx
  107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107c7d:	01 d0                	add    %edx,%eax
  107c7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  107c82:	e9 72 ff ff ff       	jmp    107bf9 <strtol+0xab>
            break;
  107c87:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  107c88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  107c8c:	74 08                	je     107c96 <strtol+0x148>
        *endptr = (char *) s;
  107c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  107c91:	8b 55 08             	mov    0x8(%ebp),%edx
  107c94:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  107c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  107c9a:	74 07                	je     107ca3 <strtol+0x155>
  107c9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107c9f:	f7 d8                	neg    %eax
  107ca1:	eb 03                	jmp    107ca6 <strtol+0x158>
  107ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  107ca6:	c9                   	leave  
  107ca7:	c3                   	ret    

00107ca8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  107ca8:	f3 0f 1e fb          	endbr32 
  107cac:	55                   	push   %ebp
  107cad:	89 e5                	mov    %esp,%ebp
  107caf:	57                   	push   %edi
  107cb0:	83 ec 24             	sub    $0x24,%esp
  107cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  107cb6:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  107cb9:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  107cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  107cc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  107cc3:	88 55 f7             	mov    %dl,-0x9(%ebp)
  107cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  107cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  107ccc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  107ccf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  107cd3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  107cd6:	89 d7                	mov    %edx,%edi
  107cd8:	f3 aa                	rep stos %al,%es:(%edi)
  107cda:	89 fa                	mov    %edi,%edx
  107cdc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  107cdf:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  107ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  107ce5:	83 c4 24             	add    $0x24,%esp
  107ce8:	5f                   	pop    %edi
  107ce9:	5d                   	pop    %ebp
  107cea:	c3                   	ret    

00107ceb <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  107ceb:	f3 0f 1e fb          	endbr32 
  107cef:	55                   	push   %ebp
  107cf0:	89 e5                	mov    %esp,%ebp
  107cf2:	57                   	push   %edi
  107cf3:	56                   	push   %esi
  107cf4:	53                   	push   %ebx
  107cf5:	83 ec 30             	sub    $0x30,%esp
  107cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  107cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  107d01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  107d04:	8b 45 10             	mov    0x10(%ebp),%eax
  107d07:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  107d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107d0d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  107d10:	73 42                	jae    107d54 <memmove+0x69>
  107d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107d1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107d21:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  107d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107d27:	c1 e8 02             	shr    $0x2,%eax
  107d2a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  107d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107d32:	89 d7                	mov    %edx,%edi
  107d34:	89 c6                	mov    %eax,%esi
  107d36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  107d38:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107d3b:	83 e1 03             	and    $0x3,%ecx
  107d3e:	74 02                	je     107d42 <memmove+0x57>
  107d40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  107d42:	89 f0                	mov    %esi,%eax
  107d44:	89 fa                	mov    %edi,%edx
  107d46:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  107d49:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  107d4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  107d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  107d52:	eb 36                	jmp    107d8a <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  107d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107d57:	8d 50 ff             	lea    -0x1(%eax),%edx
  107d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107d5d:	01 c2                	add    %eax,%edx
  107d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107d62:	8d 48 ff             	lea    -0x1(%eax),%ecx
  107d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107d68:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  107d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107d6e:	89 c1                	mov    %eax,%ecx
  107d70:	89 d8                	mov    %ebx,%eax
  107d72:	89 d6                	mov    %edx,%esi
  107d74:	89 c7                	mov    %eax,%edi
  107d76:	fd                   	std    
  107d77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  107d79:	fc                   	cld    
  107d7a:	89 f8                	mov    %edi,%eax
  107d7c:	89 f2                	mov    %esi,%edx
  107d7e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  107d81:	89 55 c8             	mov    %edx,-0x38(%ebp)
  107d84:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  107d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  107d8a:	83 c4 30             	add    $0x30,%esp
  107d8d:	5b                   	pop    %ebx
  107d8e:	5e                   	pop    %esi
  107d8f:	5f                   	pop    %edi
  107d90:	5d                   	pop    %ebp
  107d91:	c3                   	ret    

00107d92 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  107d92:	f3 0f 1e fb          	endbr32 
  107d96:	55                   	push   %ebp
  107d97:	89 e5                	mov    %esp,%ebp
  107d99:	57                   	push   %edi
  107d9a:	56                   	push   %esi
  107d9b:	83 ec 20             	sub    $0x20,%esp
  107d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  107da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  107da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107daa:	8b 45 10             	mov    0x10(%ebp),%eax
  107dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  107db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107db3:	c1 e8 02             	shr    $0x2,%eax
  107db6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  107db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  107dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107dbe:	89 d7                	mov    %edx,%edi
  107dc0:	89 c6                	mov    %eax,%esi
  107dc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  107dc4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  107dc7:	83 e1 03             	and    $0x3,%ecx
  107dca:	74 02                	je     107dce <memcpy+0x3c>
  107dcc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  107dce:	89 f0                	mov    %esi,%eax
  107dd0:	89 fa                	mov    %edi,%edx
  107dd2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  107dd5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  107dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  107ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  107dde:	83 c4 20             	add    $0x20,%esp
  107de1:	5e                   	pop    %esi
  107de2:	5f                   	pop    %edi
  107de3:	5d                   	pop    %ebp
  107de4:	c3                   	ret    

00107de5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  107de5:	f3 0f 1e fb          	endbr32 
  107de9:	55                   	push   %ebp
  107dea:	89 e5                	mov    %esp,%ebp
  107dec:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  107def:	8b 45 08             	mov    0x8(%ebp),%eax
  107df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  107df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  107df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  107dfb:	eb 2e                	jmp    107e2b <memcmp+0x46>
        if (*s1 != *s2) {
  107dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107e00:	0f b6 10             	movzbl (%eax),%edx
  107e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107e06:	0f b6 00             	movzbl (%eax),%eax
  107e09:	38 c2                	cmp    %al,%dl
  107e0b:	74 18                	je     107e25 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  107e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  107e10:	0f b6 00             	movzbl (%eax),%eax
  107e13:	0f b6 d0             	movzbl %al,%edx
  107e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107e19:	0f b6 00             	movzbl (%eax),%eax
  107e1c:	0f b6 c0             	movzbl %al,%eax
  107e1f:	29 c2                	sub    %eax,%edx
  107e21:	89 d0                	mov    %edx,%eax
  107e23:	eb 18                	jmp    107e3d <memcmp+0x58>
        }
        s1 ++, s2 ++;
  107e25:	ff 45 fc             	incl   -0x4(%ebp)
  107e28:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  107e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  107e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  107e31:	89 55 10             	mov    %edx,0x10(%ebp)
  107e34:	85 c0                	test   %eax,%eax
  107e36:	75 c5                	jne    107dfd <memcmp+0x18>
    }
    return 0;
  107e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107e3d:	c9                   	leave  
  107e3e:	c3                   	ret    

00107e3f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  107e3f:	f3 0f 1e fb          	endbr32 
  107e43:	55                   	push   %ebp
  107e44:	89 e5                	mov    %esp,%ebp
  107e46:	83 ec 58             	sub    $0x58,%esp
  107e49:	8b 45 10             	mov    0x10(%ebp),%eax
  107e4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  107e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  107e52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  107e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  107e5e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  107e61:	8b 45 18             	mov    0x18(%ebp),%eax
  107e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107e6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  107e6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107e70:	89 55 f0             	mov    %edx,-0x10(%ebp)
  107e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  107e7d:	74 1c                	je     107e9b <printnum+0x5c>
  107e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107e82:	ba 00 00 00 00       	mov    $0x0,%edx
  107e87:	f7 75 e4             	divl   -0x1c(%ebp)
  107e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  107e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107e90:	ba 00 00 00 00       	mov    $0x0,%edx
  107e95:	f7 75 e4             	divl   -0x1c(%ebp)
  107e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  107ea1:	f7 75 e4             	divl   -0x1c(%ebp)
  107ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107ea7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  107eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  107eb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  107eb3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  107eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107eb9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  107ebc:	8b 45 18             	mov    0x18(%ebp),%eax
  107ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  107ec4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  107ec7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  107eca:	19 d1                	sbb    %edx,%ecx
  107ecc:	72 4c                	jb     107f1a <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  107ece:	8b 45 1c             	mov    0x1c(%ebp),%eax
  107ed1:	8d 50 ff             	lea    -0x1(%eax),%edx
  107ed4:	8b 45 20             	mov    0x20(%ebp),%eax
  107ed7:	89 44 24 18          	mov    %eax,0x18(%esp)
  107edb:	89 54 24 14          	mov    %edx,0x14(%esp)
  107edf:	8b 45 18             	mov    0x18(%ebp),%eax
  107ee2:	89 44 24 10          	mov    %eax,0x10(%esp)
  107ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107ee9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  107eec:	89 44 24 08          	mov    %eax,0x8(%esp)
  107ef0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  107ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  107ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  107efb:	8b 45 08             	mov    0x8(%ebp),%eax
  107efe:	89 04 24             	mov    %eax,(%esp)
  107f01:	e8 39 ff ff ff       	call   107e3f <printnum>
  107f06:	eb 1b                	jmp    107f23 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  107f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  107f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  107f0f:	8b 45 20             	mov    0x20(%ebp),%eax
  107f12:	89 04 24             	mov    %eax,(%esp)
  107f15:	8b 45 08             	mov    0x8(%ebp),%eax
  107f18:	ff d0                	call   *%eax
        while (-- width > 0)
  107f1a:	ff 4d 1c             	decl   0x1c(%ebp)
  107f1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  107f21:	7f e5                	jg     107f08 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  107f23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107f26:	05 40 9c 10 00       	add    $0x109c40,%eax
  107f2b:	0f b6 00             	movzbl (%eax),%eax
  107f2e:	0f be c0             	movsbl %al,%eax
  107f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  107f34:	89 54 24 04          	mov    %edx,0x4(%esp)
  107f38:	89 04 24             	mov    %eax,(%esp)
  107f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  107f3e:	ff d0                	call   *%eax
}
  107f40:	90                   	nop
  107f41:	c9                   	leave  
  107f42:	c3                   	ret    

00107f43 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  107f43:	f3 0f 1e fb          	endbr32 
  107f47:	55                   	push   %ebp
  107f48:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  107f4a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  107f4e:	7e 14                	jle    107f64 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  107f50:	8b 45 08             	mov    0x8(%ebp),%eax
  107f53:	8b 00                	mov    (%eax),%eax
  107f55:	8d 48 08             	lea    0x8(%eax),%ecx
  107f58:	8b 55 08             	mov    0x8(%ebp),%edx
  107f5b:	89 0a                	mov    %ecx,(%edx)
  107f5d:	8b 50 04             	mov    0x4(%eax),%edx
  107f60:	8b 00                	mov    (%eax),%eax
  107f62:	eb 30                	jmp    107f94 <getuint+0x51>
    }
    else if (lflag) {
  107f64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  107f68:	74 16                	je     107f80 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  107f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  107f6d:	8b 00                	mov    (%eax),%eax
  107f6f:	8d 48 04             	lea    0x4(%eax),%ecx
  107f72:	8b 55 08             	mov    0x8(%ebp),%edx
  107f75:	89 0a                	mov    %ecx,(%edx)
  107f77:	8b 00                	mov    (%eax),%eax
  107f79:	ba 00 00 00 00       	mov    $0x0,%edx
  107f7e:	eb 14                	jmp    107f94 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  107f80:	8b 45 08             	mov    0x8(%ebp),%eax
  107f83:	8b 00                	mov    (%eax),%eax
  107f85:	8d 48 04             	lea    0x4(%eax),%ecx
  107f88:	8b 55 08             	mov    0x8(%ebp),%edx
  107f8b:	89 0a                	mov    %ecx,(%edx)
  107f8d:	8b 00                	mov    (%eax),%eax
  107f8f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  107f94:	5d                   	pop    %ebp
  107f95:	c3                   	ret    

00107f96 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  107f96:	f3 0f 1e fb          	endbr32 
  107f9a:	55                   	push   %ebp
  107f9b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  107f9d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  107fa1:	7e 14                	jle    107fb7 <getint+0x21>
        return va_arg(*ap, long long);
  107fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  107fa6:	8b 00                	mov    (%eax),%eax
  107fa8:	8d 48 08             	lea    0x8(%eax),%ecx
  107fab:	8b 55 08             	mov    0x8(%ebp),%edx
  107fae:	89 0a                	mov    %ecx,(%edx)
  107fb0:	8b 50 04             	mov    0x4(%eax),%edx
  107fb3:	8b 00                	mov    (%eax),%eax
  107fb5:	eb 28                	jmp    107fdf <getint+0x49>
    }
    else if (lflag) {
  107fb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  107fbb:	74 12                	je     107fcf <getint+0x39>
        return va_arg(*ap, long);
  107fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  107fc0:	8b 00                	mov    (%eax),%eax
  107fc2:	8d 48 04             	lea    0x4(%eax),%ecx
  107fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  107fc8:	89 0a                	mov    %ecx,(%edx)
  107fca:	8b 00                	mov    (%eax),%eax
  107fcc:	99                   	cltd   
  107fcd:	eb 10                	jmp    107fdf <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  107fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  107fd2:	8b 00                	mov    (%eax),%eax
  107fd4:	8d 48 04             	lea    0x4(%eax),%ecx
  107fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  107fda:	89 0a                	mov    %ecx,(%edx)
  107fdc:	8b 00                	mov    (%eax),%eax
  107fde:	99                   	cltd   
    }
}
  107fdf:	5d                   	pop    %ebp
  107fe0:	c3                   	ret    

00107fe1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  107fe1:	f3 0f 1e fb          	endbr32 
  107fe5:	55                   	push   %ebp
  107fe6:	89 e5                	mov    %esp,%ebp
  107fe8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  107feb:	8d 45 14             	lea    0x14(%ebp),%eax
  107fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  107ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  107ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
  107fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  108002:	89 44 24 04          	mov    %eax,0x4(%esp)
  108006:	8b 45 08             	mov    0x8(%ebp),%eax
  108009:	89 04 24             	mov    %eax,(%esp)
  10800c:	e8 03 00 00 00       	call   108014 <vprintfmt>
    va_end(ap);
}
  108011:	90                   	nop
  108012:	c9                   	leave  
  108013:	c3                   	ret    

00108014 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  108014:	f3 0f 1e fb          	endbr32 
  108018:	55                   	push   %ebp
  108019:	89 e5                	mov    %esp,%ebp
  10801b:	56                   	push   %esi
  10801c:	53                   	push   %ebx
  10801d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  108020:	eb 17                	jmp    108039 <vprintfmt+0x25>
            if (ch == '\0') {
  108022:	85 db                	test   %ebx,%ebx
  108024:	0f 84 c0 03 00 00    	je     1083ea <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10802a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10802d:	89 44 24 04          	mov    %eax,0x4(%esp)
  108031:	89 1c 24             	mov    %ebx,(%esp)
  108034:	8b 45 08             	mov    0x8(%ebp),%eax
  108037:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  108039:	8b 45 10             	mov    0x10(%ebp),%eax
  10803c:	8d 50 01             	lea    0x1(%eax),%edx
  10803f:	89 55 10             	mov    %edx,0x10(%ebp)
  108042:	0f b6 00             	movzbl (%eax),%eax
  108045:	0f b6 d8             	movzbl %al,%ebx
  108048:	83 fb 25             	cmp    $0x25,%ebx
  10804b:	75 d5                	jne    108022 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10804d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  108051:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  108058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10805b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10805e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  108065:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108068:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10806b:	8b 45 10             	mov    0x10(%ebp),%eax
  10806e:	8d 50 01             	lea    0x1(%eax),%edx
  108071:	89 55 10             	mov    %edx,0x10(%ebp)
  108074:	0f b6 00             	movzbl (%eax),%eax
  108077:	0f b6 d8             	movzbl %al,%ebx
  10807a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10807d:	83 f8 55             	cmp    $0x55,%eax
  108080:	0f 87 38 03 00 00    	ja     1083be <vprintfmt+0x3aa>
  108086:	8b 04 85 64 9c 10 00 	mov    0x109c64(,%eax,4),%eax
  10808d:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  108090:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  108094:	eb d5                	jmp    10806b <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  108096:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10809a:	eb cf                	jmp    10806b <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10809c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1080a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1080a6:	89 d0                	mov    %edx,%eax
  1080a8:	c1 e0 02             	shl    $0x2,%eax
  1080ab:	01 d0                	add    %edx,%eax
  1080ad:	01 c0                	add    %eax,%eax
  1080af:	01 d8                	add    %ebx,%eax
  1080b1:	83 e8 30             	sub    $0x30,%eax
  1080b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1080b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1080ba:	0f b6 00             	movzbl (%eax),%eax
  1080bd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1080c0:	83 fb 2f             	cmp    $0x2f,%ebx
  1080c3:	7e 38                	jle    1080fd <vprintfmt+0xe9>
  1080c5:	83 fb 39             	cmp    $0x39,%ebx
  1080c8:	7f 33                	jg     1080fd <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1080ca:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1080cd:	eb d4                	jmp    1080a3 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1080cf:	8b 45 14             	mov    0x14(%ebp),%eax
  1080d2:	8d 50 04             	lea    0x4(%eax),%edx
  1080d5:	89 55 14             	mov    %edx,0x14(%ebp)
  1080d8:	8b 00                	mov    (%eax),%eax
  1080da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1080dd:	eb 1f                	jmp    1080fe <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1080df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1080e3:	79 86                	jns    10806b <vprintfmt+0x57>
                width = 0;
  1080e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1080ec:	e9 7a ff ff ff       	jmp    10806b <vprintfmt+0x57>

        case '#':
            altflag = 1;
  1080f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1080f8:	e9 6e ff ff ff       	jmp    10806b <vprintfmt+0x57>
            goto process_precision;
  1080fd:	90                   	nop

        process_precision:
            if (width < 0)
  1080fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  108102:	0f 89 63 ff ff ff    	jns    10806b <vprintfmt+0x57>
                width = precision, precision = -1;
  108108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10810b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10810e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  108115:	e9 51 ff ff ff       	jmp    10806b <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10811a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10811d:	e9 49 ff ff ff       	jmp    10806b <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  108122:	8b 45 14             	mov    0x14(%ebp),%eax
  108125:	8d 50 04             	lea    0x4(%eax),%edx
  108128:	89 55 14             	mov    %edx,0x14(%ebp)
  10812b:	8b 00                	mov    (%eax),%eax
  10812d:	8b 55 0c             	mov    0xc(%ebp),%edx
  108130:	89 54 24 04          	mov    %edx,0x4(%esp)
  108134:	89 04 24             	mov    %eax,(%esp)
  108137:	8b 45 08             	mov    0x8(%ebp),%eax
  10813a:	ff d0                	call   *%eax
            break;
  10813c:	e9 a4 02 00 00       	jmp    1083e5 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  108141:	8b 45 14             	mov    0x14(%ebp),%eax
  108144:	8d 50 04             	lea    0x4(%eax),%edx
  108147:	89 55 14             	mov    %edx,0x14(%ebp)
  10814a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10814c:	85 db                	test   %ebx,%ebx
  10814e:	79 02                	jns    108152 <vprintfmt+0x13e>
                err = -err;
  108150:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  108152:	83 fb 06             	cmp    $0x6,%ebx
  108155:	7f 0b                	jg     108162 <vprintfmt+0x14e>
  108157:	8b 34 9d 24 9c 10 00 	mov    0x109c24(,%ebx,4),%esi
  10815e:	85 f6                	test   %esi,%esi
  108160:	75 23                	jne    108185 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  108162:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  108166:	c7 44 24 08 51 9c 10 	movl   $0x109c51,0x8(%esp)
  10816d:	00 
  10816e:	8b 45 0c             	mov    0xc(%ebp),%eax
  108171:	89 44 24 04          	mov    %eax,0x4(%esp)
  108175:	8b 45 08             	mov    0x8(%ebp),%eax
  108178:	89 04 24             	mov    %eax,(%esp)
  10817b:	e8 61 fe ff ff       	call   107fe1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  108180:	e9 60 02 00 00       	jmp    1083e5 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  108185:	89 74 24 0c          	mov    %esi,0xc(%esp)
  108189:	c7 44 24 08 5a 9c 10 	movl   $0x109c5a,0x8(%esp)
  108190:	00 
  108191:	8b 45 0c             	mov    0xc(%ebp),%eax
  108194:	89 44 24 04          	mov    %eax,0x4(%esp)
  108198:	8b 45 08             	mov    0x8(%ebp),%eax
  10819b:	89 04 24             	mov    %eax,(%esp)
  10819e:	e8 3e fe ff ff       	call   107fe1 <printfmt>
            break;
  1081a3:	e9 3d 02 00 00       	jmp    1083e5 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1081a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1081ab:	8d 50 04             	lea    0x4(%eax),%edx
  1081ae:	89 55 14             	mov    %edx,0x14(%ebp)
  1081b1:	8b 30                	mov    (%eax),%esi
  1081b3:	85 f6                	test   %esi,%esi
  1081b5:	75 05                	jne    1081bc <vprintfmt+0x1a8>
                p = "(null)";
  1081b7:	be 5d 9c 10 00       	mov    $0x109c5d,%esi
            }
            if (width > 0 && padc != '-') {
  1081bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1081c0:	7e 76                	jle    108238 <vprintfmt+0x224>
  1081c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1081c6:	74 70                	je     108238 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1081c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1081cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1081cf:	89 34 24             	mov    %esi,(%esp)
  1081d2:	e8 ba f7 ff ff       	call   107991 <strnlen>
  1081d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1081da:	29 c2                	sub    %eax,%edx
  1081dc:	89 d0                	mov    %edx,%eax
  1081de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1081e1:	eb 16                	jmp    1081f9 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  1081e3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1081e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1081ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  1081ee:	89 04 24             	mov    %eax,(%esp)
  1081f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1081f4:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1081f6:	ff 4d e8             	decl   -0x18(%ebp)
  1081f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1081fd:	7f e4                	jg     1081e3 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1081ff:	eb 37                	jmp    108238 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  108201:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  108205:	74 1f                	je     108226 <vprintfmt+0x212>
  108207:	83 fb 1f             	cmp    $0x1f,%ebx
  10820a:	7e 05                	jle    108211 <vprintfmt+0x1fd>
  10820c:	83 fb 7e             	cmp    $0x7e,%ebx
  10820f:	7e 15                	jle    108226 <vprintfmt+0x212>
                    putch('?', putdat);
  108211:	8b 45 0c             	mov    0xc(%ebp),%eax
  108214:	89 44 24 04          	mov    %eax,0x4(%esp)
  108218:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10821f:	8b 45 08             	mov    0x8(%ebp),%eax
  108222:	ff d0                	call   *%eax
  108224:	eb 0f                	jmp    108235 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  108226:	8b 45 0c             	mov    0xc(%ebp),%eax
  108229:	89 44 24 04          	mov    %eax,0x4(%esp)
  10822d:	89 1c 24             	mov    %ebx,(%esp)
  108230:	8b 45 08             	mov    0x8(%ebp),%eax
  108233:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  108235:	ff 4d e8             	decl   -0x18(%ebp)
  108238:	89 f0                	mov    %esi,%eax
  10823a:	8d 70 01             	lea    0x1(%eax),%esi
  10823d:	0f b6 00             	movzbl (%eax),%eax
  108240:	0f be d8             	movsbl %al,%ebx
  108243:	85 db                	test   %ebx,%ebx
  108245:	74 27                	je     10826e <vprintfmt+0x25a>
  108247:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10824b:	78 b4                	js     108201 <vprintfmt+0x1ed>
  10824d:	ff 4d e4             	decl   -0x1c(%ebp)
  108250:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  108254:	79 ab                	jns    108201 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  108256:	eb 16                	jmp    10826e <vprintfmt+0x25a>
                putch(' ', putdat);
  108258:	8b 45 0c             	mov    0xc(%ebp),%eax
  10825b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10825f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  108266:	8b 45 08             	mov    0x8(%ebp),%eax
  108269:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10826b:	ff 4d e8             	decl   -0x18(%ebp)
  10826e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  108272:	7f e4                	jg     108258 <vprintfmt+0x244>
            }
            break;
  108274:	e9 6c 01 00 00       	jmp    1083e5 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  108279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10827c:	89 44 24 04          	mov    %eax,0x4(%esp)
  108280:	8d 45 14             	lea    0x14(%ebp),%eax
  108283:	89 04 24             	mov    %eax,(%esp)
  108286:	e8 0b fd ff ff       	call   107f96 <getint>
  10828b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10828e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  108291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  108297:	85 d2                	test   %edx,%edx
  108299:	79 26                	jns    1082c1 <vprintfmt+0x2ad>
                putch('-', putdat);
  10829b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10829e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1082a2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1082a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1082ac:	ff d0                	call   *%eax
                num = -(long long)num;
  1082ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1082b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1082b4:	f7 d8                	neg    %eax
  1082b6:	83 d2 00             	adc    $0x0,%edx
  1082b9:	f7 da                	neg    %edx
  1082bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1082be:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1082c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1082c8:	e9 a8 00 00 00       	jmp    108375 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1082cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1082d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1082d4:	8d 45 14             	lea    0x14(%ebp),%eax
  1082d7:	89 04 24             	mov    %eax,(%esp)
  1082da:	e8 64 fc ff ff       	call   107f43 <getuint>
  1082df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1082e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1082e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1082ec:	e9 84 00 00 00       	jmp    108375 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1082f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1082f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1082f8:	8d 45 14             	lea    0x14(%ebp),%eax
  1082fb:	89 04 24             	mov    %eax,(%esp)
  1082fe:	e8 40 fc ff ff       	call   107f43 <getuint>
  108303:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108306:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  108309:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  108310:	eb 63                	jmp    108375 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  108312:	8b 45 0c             	mov    0xc(%ebp),%eax
  108315:	89 44 24 04          	mov    %eax,0x4(%esp)
  108319:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  108320:	8b 45 08             	mov    0x8(%ebp),%eax
  108323:	ff d0                	call   *%eax
            putch('x', putdat);
  108325:	8b 45 0c             	mov    0xc(%ebp),%eax
  108328:	89 44 24 04          	mov    %eax,0x4(%esp)
  10832c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  108333:	8b 45 08             	mov    0x8(%ebp),%eax
  108336:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  108338:	8b 45 14             	mov    0x14(%ebp),%eax
  10833b:	8d 50 04             	lea    0x4(%eax),%edx
  10833e:	89 55 14             	mov    %edx,0x14(%ebp)
  108341:	8b 00                	mov    (%eax),%eax
  108343:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10834d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  108354:	eb 1f                	jmp    108375 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  108356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  108359:	89 44 24 04          	mov    %eax,0x4(%esp)
  10835d:	8d 45 14             	lea    0x14(%ebp),%eax
  108360:	89 04 24             	mov    %eax,(%esp)
  108363:	e8 db fb ff ff       	call   107f43 <getuint>
  108368:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10836b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10836e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  108375:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  108379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10837c:	89 54 24 18          	mov    %edx,0x18(%esp)
  108380:	8b 55 e8             	mov    -0x18(%ebp),%edx
  108383:	89 54 24 14          	mov    %edx,0x14(%esp)
  108387:	89 44 24 10          	mov    %eax,0x10(%esp)
  10838b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10838e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  108391:	89 44 24 08          	mov    %eax,0x8(%esp)
  108395:	89 54 24 0c          	mov    %edx,0xc(%esp)
  108399:	8b 45 0c             	mov    0xc(%ebp),%eax
  10839c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1083a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1083a3:	89 04 24             	mov    %eax,(%esp)
  1083a6:	e8 94 fa ff ff       	call   107e3f <printnum>
            break;
  1083ab:	eb 38                	jmp    1083e5 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1083ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1083b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1083b4:	89 1c 24             	mov    %ebx,(%esp)
  1083b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1083ba:	ff d0                	call   *%eax
            break;
  1083bc:	eb 27                	jmp    1083e5 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1083be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1083c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1083c5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1083cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1083cf:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1083d1:	ff 4d 10             	decl   0x10(%ebp)
  1083d4:	eb 03                	jmp    1083d9 <vprintfmt+0x3c5>
  1083d6:	ff 4d 10             	decl   0x10(%ebp)
  1083d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1083dc:	48                   	dec    %eax
  1083dd:	0f b6 00             	movzbl (%eax),%eax
  1083e0:	3c 25                	cmp    $0x25,%al
  1083e2:	75 f2                	jne    1083d6 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  1083e4:	90                   	nop
    while (1) {
  1083e5:	e9 36 fc ff ff       	jmp    108020 <vprintfmt+0xc>
                return;
  1083ea:	90                   	nop
        }
    }
}
  1083eb:	83 c4 40             	add    $0x40,%esp
  1083ee:	5b                   	pop    %ebx
  1083ef:	5e                   	pop    %esi
  1083f0:	5d                   	pop    %ebp
  1083f1:	c3                   	ret    

001083f2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1083f2:	f3 0f 1e fb          	endbr32 
  1083f6:	55                   	push   %ebp
  1083f7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1083f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1083fc:	8b 40 08             	mov    0x8(%eax),%eax
  1083ff:	8d 50 01             	lea    0x1(%eax),%edx
  108402:	8b 45 0c             	mov    0xc(%ebp),%eax
  108405:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  108408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10840b:	8b 10                	mov    (%eax),%edx
  10840d:	8b 45 0c             	mov    0xc(%ebp),%eax
  108410:	8b 40 04             	mov    0x4(%eax),%eax
  108413:	39 c2                	cmp    %eax,%edx
  108415:	73 12                	jae    108429 <sprintputch+0x37>
        *b->buf ++ = ch;
  108417:	8b 45 0c             	mov    0xc(%ebp),%eax
  10841a:	8b 00                	mov    (%eax),%eax
  10841c:	8d 48 01             	lea    0x1(%eax),%ecx
  10841f:	8b 55 0c             	mov    0xc(%ebp),%edx
  108422:	89 0a                	mov    %ecx,(%edx)
  108424:	8b 55 08             	mov    0x8(%ebp),%edx
  108427:	88 10                	mov    %dl,(%eax)
    }
}
  108429:	90                   	nop
  10842a:	5d                   	pop    %ebp
  10842b:	c3                   	ret    

0010842c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10842c:	f3 0f 1e fb          	endbr32 
  108430:	55                   	push   %ebp
  108431:	89 e5                	mov    %esp,%ebp
  108433:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  108436:	8d 45 14             	lea    0x14(%ebp),%eax
  108439:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10843c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10843f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  108443:	8b 45 10             	mov    0x10(%ebp),%eax
  108446:	89 44 24 08          	mov    %eax,0x8(%esp)
  10844a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10844d:	89 44 24 04          	mov    %eax,0x4(%esp)
  108451:	8b 45 08             	mov    0x8(%ebp),%eax
  108454:	89 04 24             	mov    %eax,(%esp)
  108457:	e8 08 00 00 00       	call   108464 <vsnprintf>
  10845c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10845f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  108462:	c9                   	leave  
  108463:	c3                   	ret    

00108464 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  108464:	f3 0f 1e fb          	endbr32 
  108468:	55                   	push   %ebp
  108469:	89 e5                	mov    %esp,%ebp
  10846b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10846e:	8b 45 08             	mov    0x8(%ebp),%eax
  108471:	89 45 ec             	mov    %eax,-0x14(%ebp)
  108474:	8b 45 0c             	mov    0xc(%ebp),%eax
  108477:	8d 50 ff             	lea    -0x1(%eax),%edx
  10847a:	8b 45 08             	mov    0x8(%ebp),%eax
  10847d:	01 d0                	add    %edx,%eax
  10847f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  108489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10848d:	74 0a                	je     108499 <vsnprintf+0x35>
  10848f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  108492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108495:	39 c2                	cmp    %eax,%edx
  108497:	76 07                	jbe    1084a0 <vsnprintf+0x3c>
        return -E_INVAL;
  108499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10849e:	eb 2a                	jmp    1084ca <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1084a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1084a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1084a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1084aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1084ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1084b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1084b5:	c7 04 24 f2 83 10 00 	movl   $0x1083f2,(%esp)
  1084bc:	e8 53 fb ff ff       	call   108014 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1084c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1084c4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1084c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1084ca:	c9                   	leave  
  1084cb:	c3                   	ret    
