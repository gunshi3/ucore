
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 10 12 00       	mov    $0x121000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 10 12 c0       	mov    %eax,0xc0121000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 60 aa 2a c0       	mov    $0xc02aaa60,%eax
c0100045:	2d 00 30 12 c0       	sub    $0xc0123000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 30 12 c0 	movl   $0xc0123000,(%esp)
c010005d:	e8 46 7c 00 00       	call   c0107ca8 <memset>

    cons_init();                // init the console
c0100062:	e8 42 16 00 00       	call   c01016a9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 e0 84 10 c0 	movl   $0xc01084e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 fc 84 10 c0 	movl   $0xc01084fc,(%esp)
c010007c:	e8 48 02 00 00       	call   c01002c9 <cprintf>

    print_kerninfo();
c0100081:	e8 06 09 00 00       	call   c010098c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 9a 00 00 00       	call   c0100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 c4 33 00 00       	call   c0103454 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 8f 17 00 00       	call   c0101824 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 34 19 00 00       	call   c01019ce <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 51 0d 00 00       	call   c0100df0 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 cc 18 00 00       	call   c0101970 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c01000a4:	e8 86 01 00 00       	call   c010022f <lab1_switch_test>

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x73>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	f3 0f 1e fb          	endbr32 
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000bc:	00 
c01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c4:	00 
c01000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000cc:	e8 09 0d 00 00       	call   c0100dda <mon_backtrace>
}
c01000d1:	90                   	nop
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d4:	f3 0f 1e fb          	endbr32 
c01000d8:	55                   	push   %ebp
c01000d9:	89 e5                	mov    %esp,%ebp
c01000db:	53                   	push   %ebx
c01000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f7:	89 04 24             	mov    %eax,(%esp)
c01000fa:	e8 ac ff ff ff       	call   c01000ab <grade_backtrace2>
}
c01000ff:	90                   	nop
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	f3 0f 1e fb          	endbr32 
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100110:	8b 45 10             	mov    0x10(%ebp),%eax
c0100113:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100117:	8b 45 08             	mov    0x8(%ebp),%eax
c010011a:	89 04 24             	mov    %eax,(%esp)
c010011d:	e8 b2 ff ff ff       	call   c01000d4 <grade_backtrace1>
}
c0100122:	90                   	nop
c0100123:	c9                   	leave  
c0100124:	c3                   	ret    

c0100125 <grade_backtrace>:

void
grade_backtrace(void) {
c0100125:	f3 0f 1e fb          	endbr32 
c0100129:	55                   	push   %ebp
c010012a:	89 e5                	mov    %esp,%ebp
c010012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010013b:	ff 
c010013c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100147:	e8 ba ff ff ff       	call   c0100106 <grade_backtrace0>
}
c010014c:	90                   	nop
c010014d:	c9                   	leave  
c010014e:	c3                   	ret    

c010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014f:	f3 0f 1e fb          	endbr32 
c0100153:	55                   	push   %ebp
c0100154:	89 e5                	mov    %esp,%ebp
c0100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	83 e0 03             	and    $0x3,%eax
c010016c:	89 c2                	mov    %eax,%edx
c010016e:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100173:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100177:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017b:	c7 04 24 01 85 10 c0 	movl   $0xc0108501,(%esp)
c0100182:	e8 42 01 00 00       	call   c01002c9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010018b:	89 c2                	mov    %eax,%edx
c010018d:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100196:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019a:	c7 04 24 0f 85 10 c0 	movl   $0xc010850f,(%esp)
c01001a1:	e8 23 01 00 00       	call   c01002c9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001aa:	89 c2                	mov    %eax,%edx
c01001ac:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 1d 85 10 c0 	movl   $0xc010851d,(%esp)
c01001c0:	e8 04 01 00 00       	call   c01002c9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c9:	89 c2                	mov    %eax,%edx
c01001cb:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d8:	c7 04 24 2b 85 10 c0 	movl   $0xc010852b,(%esp)
c01001df:	e8 e5 00 00 00       	call   c01002c9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e8:	89 c2                	mov    %eax,%edx
c01001ea:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f7:	c7 04 24 39 85 10 c0 	movl   $0xc0108539,(%esp)
c01001fe:	e8 c6 00 00 00       	call   c01002c9 <cprintf>
    round ++;
c0100203:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100208:	40                   	inc    %eax
c0100209:	a3 00 30 12 c0       	mov    %eax,0xc0123000
}
c010020e:	90                   	nop
c010020f:	c9                   	leave  
c0100210:	c3                   	ret    

c0100211 <lab1_switch_to_user>:

static void lab1_switch_to_user(void) {
c0100211:	f3 0f 1e fb          	endbr32 
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
c0100218:	16                   	push   %ss
c0100219:	54                   	push   %esp
c010021a:	cd 78                	int    $0x78
c010021c:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c010021e:	90                   	nop
c010021f:	5d                   	pop    %ebp
c0100220:	c3                   	ret    

c0100221 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100221:	f3 0f 1e fb          	endbr32 
c0100225:	55                   	push   %ebp
c0100226:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c0100228:	cd 79                	int    $0x79
c010022a:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        : 
        : "i"(T_SWITCH_TOK)
    );
}
c010022c:	90                   	nop
c010022d:	5d                   	pop    %ebp
c010022e:	c3                   	ret    

c010022f <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010022f:	f3 0f 1e fb          	endbr32 
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100239:	e8 11 ff ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010023e:	c7 04 24 48 85 10 c0 	movl   $0xc0108548,(%esp)
c0100245:	e8 7f 00 00 00       	call   c01002c9 <cprintf>
    lab1_switch_to_user();
c010024a:	e8 c2 ff ff ff       	call   c0100211 <lab1_switch_to_user>
    lab1_print_cur_status();
c010024f:	e8 fb fe ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100254:	c7 04 24 68 85 10 c0 	movl   $0xc0108568,(%esp)
c010025b:	e8 69 00 00 00       	call   c01002c9 <cprintf>
    lab1_switch_to_kernel();
c0100260:	e8 bc ff ff ff       	call   c0100221 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100265:	e8 e5 fe ff ff       	call   c010014f <lab1_print_cur_status>
}
c010026a:	90                   	nop
c010026b:	c9                   	leave  
c010026c:	c3                   	ret    

c010026d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010026d:	f3 0f 1e fb          	endbr32 
c0100271:	55                   	push   %ebp
c0100272:	89 e5                	mov    %esp,%ebp
c0100274:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100277:	8b 45 08             	mov    0x8(%ebp),%eax
c010027a:	89 04 24             	mov    %eax,(%esp)
c010027d:	e8 58 14 00 00       	call   c01016da <cons_putc>
    (*cnt) ++;
c0100282:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100285:	8b 00                	mov    (%eax),%eax
c0100287:	8d 50 01             	lea    0x1(%eax),%edx
c010028a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010028d:	89 10                	mov    %edx,(%eax)
}
c010028f:	90                   	nop
c0100290:	c9                   	leave  
c0100291:	c3                   	ret    

c0100292 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100292:	f3 0f 1e fb          	endbr32 
c0100296:	55                   	push   %ebp
c0100297:	89 e5                	mov    %esp,%ebp
c0100299:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010029c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c01002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ad:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b8:	c7 04 24 6d 02 10 c0 	movl   $0xc010026d,(%esp)
c01002bf:	e8 50 7d 00 00       	call   c0108014 <vprintfmt>
    return cnt;
c01002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c7:	c9                   	leave  
c01002c8:	c3                   	ret    

c01002c9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002c9:	f3 0f 1e fb          	endbr32 
c01002cd:	55                   	push   %ebp
c01002ce:	89 e5                	mov    %esp,%ebp
c01002d0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002d3:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01002e3:	89 04 24             	mov    %eax,(%esp)
c01002e6:	e8 a7 ff ff ff       	call   c0100292 <vcprintf>
c01002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002f1:	c9                   	leave  
c01002f2:	c3                   	ret    

c01002f3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002f3:	f3 0f 1e fb          	endbr32 
c01002f7:	55                   	push   %ebp
c01002f8:	89 e5                	mov    %esp,%ebp
c01002fa:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100300:	89 04 24             	mov    %eax,(%esp)
c0100303:	e8 d2 13 00 00       	call   c01016da <cons_putc>
}
c0100308:	90                   	nop
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010030b:	f3 0f 1e fb          	endbr32 
c010030f:	55                   	push   %ebp
c0100310:	89 e5                	mov    %esp,%ebp
c0100312:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100315:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010031c:	eb 13                	jmp    c0100331 <cputs+0x26>
        cputch(c, &cnt);
c010031e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100322:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100325:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100329:	89 04 24             	mov    %eax,(%esp)
c010032c:	e8 3c ff ff ff       	call   c010026d <cputch>
    while ((c = *str ++) != '\0') {
c0100331:	8b 45 08             	mov    0x8(%ebp),%eax
c0100334:	8d 50 01             	lea    0x1(%eax),%edx
c0100337:	89 55 08             	mov    %edx,0x8(%ebp)
c010033a:	0f b6 00             	movzbl (%eax),%eax
c010033d:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100340:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100344:	75 d8                	jne    c010031e <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100346:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100349:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100354:	e8 14 ff ff ff       	call   c010026d <cputch>
    return cnt;
c0100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010035c:	c9                   	leave  
c010035d:	c3                   	ret    

c010035e <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010035e:	f3 0f 1e fb          	endbr32 
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100368:	90                   	nop
c0100369:	e8 ad 13 00 00       	call   c010171b <cons_getc>
c010036e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100375:	74 f2                	je     c0100369 <getchar+0xb>
        /* do nothing */;
    return c;
c0100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037a:	c9                   	leave  
c010037b:	c3                   	ret    

c010037c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010037c:	f3 0f 1e fb          	endbr32 
c0100380:	55                   	push   %ebp
c0100381:	89 e5                	mov    %esp,%ebp
c0100383:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010038a:	74 13                	je     c010039f <readline+0x23>
        cprintf("%s", prompt);
c010038c:	8b 45 08             	mov    0x8(%ebp),%eax
c010038f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100393:	c7 04 24 87 85 10 c0 	movl   $0xc0108587,(%esp)
c010039a:	e8 2a ff ff ff       	call   c01002c9 <cprintf>
    }
    int i = 0, c;
c010039f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003a6:	e8 b3 ff ff ff       	call   c010035e <getchar>
c01003ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003b2:	79 07                	jns    c01003bb <readline+0x3f>
            return NULL;
c01003b4:	b8 00 00 00 00       	mov    $0x0,%eax
c01003b9:	eb 78                	jmp    c0100433 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003bb:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003bf:	7e 28                	jle    c01003e9 <readline+0x6d>
c01003c1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003c8:	7f 1f                	jg     c01003e9 <readline+0x6d>
            cputchar(c);
c01003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003cd:	89 04 24             	mov    %eax,(%esp)
c01003d0:	e8 1e ff ff ff       	call   c01002f3 <cputchar>
            buf[i ++] = c;
c01003d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d8:	8d 50 01             	lea    0x1(%eax),%edx
c01003db:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003de:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003e1:	88 90 20 30 12 c0    	mov    %dl,-0x3fedcfe0(%eax)
c01003e7:	eb 45                	jmp    c010042e <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003e9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003ed:	75 16                	jne    c0100405 <readline+0x89>
c01003ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f3:	7e 10                	jle    c0100405 <readline+0x89>
            cputchar(c);
c01003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003f8:	89 04 24             	mov    %eax,(%esp)
c01003fb:	e8 f3 fe ff ff       	call   c01002f3 <cputchar>
            i --;
c0100400:	ff 4d f4             	decl   -0xc(%ebp)
c0100403:	eb 29                	jmp    c010042e <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100405:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100409:	74 06                	je     c0100411 <readline+0x95>
c010040b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010040f:	75 95                	jne    c01003a6 <readline+0x2a>
            cputchar(c);
c0100411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100414:	89 04 24             	mov    %eax,(%esp)
c0100417:	e8 d7 fe ff ff       	call   c01002f3 <cputchar>
            buf[i] = '\0';
c010041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041f:	05 20 30 12 c0       	add    $0xc0123020,%eax
c0100424:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100427:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
c010042c:	eb 05                	jmp    c0100433 <readline+0xb7>
        c = getchar();
c010042e:	e9 73 ff ff ff       	jmp    c01003a6 <readline+0x2a>
        }
    }
}
c0100433:	c9                   	leave  
c0100434:	c3                   	ret    

c0100435 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100435:	f3 0f 1e fb          	endbr32 
c0100439:	55                   	push   %ebp
c010043a:	89 e5                	mov    %esp,%ebp
c010043c:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c010043f:	a1 20 34 12 c0       	mov    0xc0123420,%eax
c0100444:	85 c0                	test   %eax,%eax
c0100446:	75 5b                	jne    c01004a3 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100448:	c7 05 20 34 12 c0 01 	movl   $0x1,0xc0123420
c010044f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100452:	8d 45 14             	lea    0x14(%ebp),%eax
c0100455:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100458:	8b 45 0c             	mov    0xc(%ebp),%eax
c010045b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010045f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100466:	c7 04 24 8a 85 10 c0 	movl   $0xc010858a,(%esp)
c010046d:	e8 57 fe ff ff       	call   c01002c9 <cprintf>
    vcprintf(fmt, ap);
c0100472:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100475:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100479:	8b 45 10             	mov    0x10(%ebp),%eax
c010047c:	89 04 24             	mov    %eax,(%esp)
c010047f:	e8 0e fe ff ff       	call   c0100292 <vcprintf>
    cprintf("\n");
c0100484:	c7 04 24 a6 85 10 c0 	movl   $0xc01085a6,(%esp)
c010048b:	e8 39 fe ff ff       	call   c01002c9 <cprintf>
    
    cprintf("stack trackback:\n");
c0100490:	c7 04 24 a8 85 10 c0 	movl   $0xc01085a8,(%esp)
c0100497:	e8 2d fe ff ff       	call   c01002c9 <cprintf>
    print_stackframe();
c010049c:	e8 3d 06 00 00       	call   c0100ade <print_stackframe>
c01004a1:	eb 01                	jmp    c01004a4 <__panic+0x6f>
        goto panic_dead;
c01004a3:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004a4:	e8 d3 14 00 00       	call   c010197c <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004b0:	e8 4c 08 00 00       	call   c0100d01 <kmonitor>
c01004b5:	eb f2                	jmp    c01004a9 <__panic+0x74>

c01004b7 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004b7:	f3 0f 1e fb          	endbr32 
c01004bb:	55                   	push   %ebp
c01004bc:	89 e5                	mov    %esp,%ebp
c01004be:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01004d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d5:	c7 04 24 ba 85 10 c0 	movl   $0xc01085ba,(%esp)
c01004dc:	e8 e8 fd ff ff       	call   c01002c9 <cprintf>
    vcprintf(fmt, ap);
c01004e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01004eb:	89 04 24             	mov    %eax,(%esp)
c01004ee:	e8 9f fd ff ff       	call   c0100292 <vcprintf>
    cprintf("\n");
c01004f3:	c7 04 24 a6 85 10 c0 	movl   $0xc01085a6,(%esp)
c01004fa:	e8 ca fd ff ff       	call   c01002c9 <cprintf>
    va_end(ap);
}
c01004ff:	90                   	nop
c0100500:	c9                   	leave  
c0100501:	c3                   	ret    

c0100502 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100502:	f3 0f 1e fb          	endbr32 
c0100506:	55                   	push   %ebp
c0100507:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100509:	a1 20 34 12 c0       	mov    0xc0123420,%eax
}
c010050e:	5d                   	pop    %ebp
c010050f:	c3                   	ret    

c0100510 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100510:	f3 0f 1e fb          	endbr32 
c0100514:	55                   	push   %ebp
c0100515:	89 e5                	mov    %esp,%ebp
c0100517:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010051a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051d:	8b 00                	mov    (%eax),%eax
c010051f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100522:	8b 45 10             	mov    0x10(%ebp),%eax
c0100525:	8b 00                	mov    (%eax),%eax
c0100527:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010052a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100531:	e9 ca 00 00 00       	jmp    c0100600 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100536:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100539:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010053c:	01 d0                	add    %edx,%eax
c010053e:	89 c2                	mov    %eax,%edx
c0100540:	c1 ea 1f             	shr    $0x1f,%edx
c0100543:	01 d0                	add    %edx,%eax
c0100545:	d1 f8                	sar    %eax
c0100547:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010054d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100550:	eb 03                	jmp    c0100555 <stab_binsearch+0x45>
            m --;
c0100552:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100555:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100558:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010055b:	7c 1f                	jl     c010057c <stab_binsearch+0x6c>
c010055d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100560:	89 d0                	mov    %edx,%eax
c0100562:	01 c0                	add    %eax,%eax
c0100564:	01 d0                	add    %edx,%eax
c0100566:	c1 e0 02             	shl    $0x2,%eax
c0100569:	89 c2                	mov    %eax,%edx
c010056b:	8b 45 08             	mov    0x8(%ebp),%eax
c010056e:	01 d0                	add    %edx,%eax
c0100570:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100574:	0f b6 c0             	movzbl %al,%eax
c0100577:	39 45 14             	cmp    %eax,0x14(%ebp)
c010057a:	75 d6                	jne    c0100552 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c010057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100582:	7d 09                	jge    c010058d <stab_binsearch+0x7d>
            l = true_m + 1;
c0100584:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100587:	40                   	inc    %eax
c0100588:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010058b:	eb 73                	jmp    c0100600 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c010058d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100594:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100597:	89 d0                	mov    %edx,%eax
c0100599:	01 c0                	add    %eax,%eax
c010059b:	01 d0                	add    %edx,%eax
c010059d:	c1 e0 02             	shl    $0x2,%eax
c01005a0:	89 c2                	mov    %eax,%edx
c01005a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a5:	01 d0                	add    %edx,%eax
c01005a7:	8b 40 08             	mov    0x8(%eax),%eax
c01005aa:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005ad:	76 11                	jbe    c01005c0 <stab_binsearch+0xb0>
            *region_left = m;
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b5:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005ba:	40                   	inc    %eax
c01005bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005be:	eb 40                	jmp    c0100600 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c3:	89 d0                	mov    %edx,%eax
c01005c5:	01 c0                	add    %eax,%eax
c01005c7:	01 d0                	add    %edx,%eax
c01005c9:	c1 e0 02             	shl    $0x2,%eax
c01005cc:	89 c2                	mov    %eax,%edx
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	01 d0                	add    %edx,%eax
c01005d3:	8b 40 08             	mov    0x8(%eax),%eax
c01005d6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005d9:	73 14                	jae    c01005ef <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005de:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e4:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e9:	48                   	dec    %eax
c01005ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005ed:	eb 11                	jmp    c0100600 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005f5:	89 10                	mov    %edx,(%eax)
            l = m;
c01005f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005fd:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c0100600:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100603:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100606:	0f 8e 2a ff ff ff    	jle    c0100536 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c010060c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100610:	75 0f                	jne    c0100621 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c0100612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100615:	8b 00                	mov    (%eax),%eax
c0100617:	8d 50 ff             	lea    -0x1(%eax),%edx
c010061a:	8b 45 10             	mov    0x10(%ebp),%eax
c010061d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010061f:	eb 3e                	jmp    c010065f <stab_binsearch+0x14f>
        l = *region_right;
c0100621:	8b 45 10             	mov    0x10(%ebp),%eax
c0100624:	8b 00                	mov    (%eax),%eax
c0100626:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100629:	eb 03                	jmp    c010062e <stab_binsearch+0x11e>
c010062b:	ff 4d fc             	decl   -0x4(%ebp)
c010062e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100631:	8b 00                	mov    (%eax),%eax
c0100633:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100636:	7e 1f                	jle    c0100657 <stab_binsearch+0x147>
c0100638:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010063b:	89 d0                	mov    %edx,%eax
c010063d:	01 c0                	add    %eax,%eax
c010063f:	01 d0                	add    %edx,%eax
c0100641:	c1 e0 02             	shl    $0x2,%eax
c0100644:	89 c2                	mov    %eax,%edx
c0100646:	8b 45 08             	mov    0x8(%ebp),%eax
c0100649:	01 d0                	add    %edx,%eax
c010064b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010064f:	0f b6 c0             	movzbl %al,%eax
c0100652:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100655:	75 d4                	jne    c010062b <stab_binsearch+0x11b>
        *region_left = l;
c0100657:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010065d:	89 10                	mov    %edx,(%eax)
}
c010065f:	90                   	nop
c0100660:	c9                   	leave  
c0100661:	c3                   	ret    

c0100662 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100662:	f3 0f 1e fb          	endbr32 
c0100666:	55                   	push   %ebp
c0100667:	89 e5                	mov    %esp,%ebp
c0100669:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010066c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066f:	c7 00 d8 85 10 c0    	movl   $0xc01085d8,(%eax)
    info->eip_line = 0;
c0100675:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010067f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100682:	c7 40 08 d8 85 10 c0 	movl   $0xc01085d8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100689:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100696:	8b 55 08             	mov    0x8(%ebp),%edx
c0100699:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010069c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006a6:	c7 45 f4 bc 9d 10 c0 	movl   $0xc0109dbc,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006ad:	c7 45 f0 34 a3 11 c0 	movl   $0xc011a334,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006b4:	c7 45 ec 35 a3 11 c0 	movl   $0xc011a335,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006bb:	c7 45 e8 7b d7 11 c0 	movl   $0xc011d77b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006c8:	76 0b                	jbe    c01006d5 <debuginfo_eip+0x73>
c01006ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006cd:	48                   	dec    %eax
c01006ce:	0f b6 00             	movzbl (%eax),%eax
c01006d1:	84 c0                	test   %al,%al
c01006d3:	74 0a                	je     c01006df <debuginfo_eip+0x7d>
        return -1;
c01006d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006da:	e9 ab 02 00 00       	jmp    c010098a <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006e9:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006ec:	c1 f8 02             	sar    $0x2,%eax
c01006ef:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006f5:	48                   	dec    %eax
c01006f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100700:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100707:	00 
c0100708:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010070b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100719:	89 04 24             	mov    %eax,(%esp)
c010071c:	e8 ef fd ff ff       	call   c0100510 <stab_binsearch>
    if (lfile == 0)
c0100721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100724:	85 c0                	test   %eax,%eax
c0100726:	75 0a                	jne    c0100732 <debuginfo_eip+0xd0>
        return -1;
c0100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010072d:	e9 58 02 00 00       	jmp    c010098a <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100735:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100738:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010073e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100741:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100745:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010074c:	00 
c010074d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100750:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100754:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100757:	89 44 24 04          	mov    %eax,0x4(%esp)
c010075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075e:	89 04 24             	mov    %eax,(%esp)
c0100761:	e8 aa fd ff ff       	call   c0100510 <stab_binsearch>

    if (lfun <= rfun) {
c0100766:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100769:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010076c:	39 c2                	cmp    %eax,%edx
c010076e:	7f 78                	jg     c01007e8 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100770:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100773:	89 c2                	mov    %eax,%edx
c0100775:	89 d0                	mov    %edx,%eax
c0100777:	01 c0                	add    %eax,%eax
c0100779:	01 d0                	add    %edx,%eax
c010077b:	c1 e0 02             	shl    $0x2,%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100783:	01 d0                	add    %edx,%eax
c0100785:	8b 10                	mov    (%eax),%edx
c0100787:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010078a:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010078d:	39 c2                	cmp    %eax,%edx
c010078f:	73 22                	jae    c01007b3 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100791:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	89 d0                	mov    %edx,%eax
c0100798:	01 c0                	add    %eax,%eax
c010079a:	01 d0                	add    %edx,%eax
c010079c:	c1 e0 02             	shl    $0x2,%eax
c010079f:	89 c2                	mov    %eax,%edx
c01007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	8b 10                	mov    (%eax),%edx
c01007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ab:	01 c2                	add    %eax,%edx
c01007ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b6:	89 c2                	mov    %eax,%edx
c01007b8:	89 d0                	mov    %edx,%eax
c01007ba:	01 c0                	add    %eax,%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	c1 e0 02             	shl    $0x2,%eax
c01007c1:	89 c2                	mov    %eax,%edx
c01007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c6:	01 d0                	add    %edx,%eax
c01007c8:	8b 50 08             	mov    0x8(%eax),%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d4:	8b 40 10             	mov    0x10(%eax),%eax
c01007d7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007e6:	eb 15                	jmp    c01007fd <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ee:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c010080a:	00 
c010080b:	89 04 24             	mov    %eax,(%esp)
c010080e:	e8 09 73 00 00       	call   c0107b1c <strfind>
c0100813:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100816:	8b 52 08             	mov    0x8(%edx),%edx
c0100819:	29 d0                	sub    %edx,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100820:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100823:	8b 45 08             	mov    0x8(%ebp),%eax
c0100826:	89 44 24 10          	mov    %eax,0x10(%esp)
c010082a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100831:	00 
c0100832:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100835:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100839:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010083c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100843:	89 04 24             	mov    %eax,(%esp)
c0100846:	e8 c5 fc ff ff       	call   c0100510 <stab_binsearch>
    if (lline <= rline) {
c010084b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100851:	39 c2                	cmp    %eax,%edx
c0100853:	7f 23                	jg     c0100878 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100855:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100858:	89 c2                	mov    %eax,%edx
c010085a:	89 d0                	mov    %edx,%eax
c010085c:	01 c0                	add    %eax,%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	c1 e0 02             	shl    $0x2,%eax
c0100863:	89 c2                	mov    %eax,%edx
c0100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100868:	01 d0                	add    %edx,%eax
c010086a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010086e:	89 c2                	mov    %eax,%edx
c0100870:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100873:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100876:	eb 11                	jmp    c0100889 <debuginfo_eip+0x227>
        return -1;
c0100878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010087d:	e9 08 01 00 00       	jmp    c010098a <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100885:	48                   	dec    %eax
c0100886:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100889:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010088c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088f:	39 c2                	cmp    %eax,%edx
c0100891:	7c 56                	jl     c01008e9 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c0100893:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100896:	89 c2                	mov    %eax,%edx
c0100898:	89 d0                	mov    %edx,%eax
c010089a:	01 c0                	add    %eax,%eax
c010089c:	01 d0                	add    %edx,%eax
c010089e:	c1 e0 02             	shl    $0x2,%eax
c01008a1:	89 c2                	mov    %eax,%edx
c01008a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a6:	01 d0                	add    %edx,%eax
c01008a8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ac:	3c 84                	cmp    $0x84,%al
c01008ae:	74 39                	je     c01008e9 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b3:	89 c2                	mov    %eax,%edx
c01008b5:	89 d0                	mov    %edx,%eax
c01008b7:	01 c0                	add    %eax,%eax
c01008b9:	01 d0                	add    %edx,%eax
c01008bb:	c1 e0 02             	shl    $0x2,%eax
c01008be:	89 c2                	mov    %eax,%edx
c01008c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c3:	01 d0                	add    %edx,%eax
c01008c5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008c9:	3c 64                	cmp    $0x64,%al
c01008cb:	75 b5                	jne    c0100882 <debuginfo_eip+0x220>
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	8b 40 08             	mov    0x8(%eax),%eax
c01008e5:	85 c0                	test   %eax,%eax
c01008e7:	74 99                	je     c0100882 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008ef:	39 c2                	cmp    %eax,%edx
c01008f1:	7c 42                	jl     c0100935 <debuginfo_eip+0x2d3>
c01008f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f6:	89 c2                	mov    %eax,%edx
c01008f8:	89 d0                	mov    %edx,%eax
c01008fa:	01 c0                	add    %eax,%eax
c01008fc:	01 d0                	add    %edx,%eax
c01008fe:	c1 e0 02             	shl    $0x2,%eax
c0100901:	89 c2                	mov    %eax,%edx
c0100903:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100906:	01 d0                	add    %edx,%eax
c0100908:	8b 10                	mov    (%eax),%edx
c010090a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010090d:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100910:	39 c2                	cmp    %eax,%edx
c0100912:	73 21                	jae    c0100935 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100917:	89 c2                	mov    %eax,%edx
c0100919:	89 d0                	mov    %edx,%eax
c010091b:	01 c0                	add    %eax,%eax
c010091d:	01 d0                	add    %edx,%eax
c010091f:	c1 e0 02             	shl    $0x2,%eax
c0100922:	89 c2                	mov    %eax,%edx
c0100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100927:	01 d0                	add    %edx,%eax
c0100929:	8b 10                	mov    (%eax),%edx
c010092b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092e:	01 c2                	add    %eax,%edx
c0100930:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100933:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100935:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100938:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010093b:	39 c2                	cmp    %eax,%edx
c010093d:	7d 46                	jge    c0100985 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c010093f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100942:	40                   	inc    %eax
c0100943:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100946:	eb 16                	jmp    c010095e <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100948:	8b 45 0c             	mov    0xc(%ebp),%eax
c010094b:	8b 40 14             	mov    0x14(%eax),%eax
c010094e:	8d 50 01             	lea    0x1(%eax),%edx
c0100951:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100954:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100957:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010095a:	40                   	inc    %eax
c010095b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100961:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100964:	39 c2                	cmp    %eax,%edx
c0100966:	7d 1d                	jge    c0100985 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010096b:	89 c2                	mov    %eax,%edx
c010096d:	89 d0                	mov    %edx,%eax
c010096f:	01 c0                	add    %eax,%eax
c0100971:	01 d0                	add    %edx,%eax
c0100973:	c1 e0 02             	shl    $0x2,%eax
c0100976:	89 c2                	mov    %eax,%edx
c0100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097b:	01 d0                	add    %edx,%eax
c010097d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100981:	3c a0                	cmp    $0xa0,%al
c0100983:	74 c3                	je     c0100948 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100985:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010098a:	c9                   	leave  
c010098b:	c3                   	ret    

c010098c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010098c:	f3 0f 1e fb          	endbr32 
c0100990:	55                   	push   %ebp
c0100991:	89 e5                	mov    %esp,%ebp
c0100993:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100996:	c7 04 24 e2 85 10 c0 	movl   $0xc01085e2,(%esp)
c010099d:	e8 27 f9 ff ff       	call   c01002c9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c01009a2:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009a9:	c0 
c01009aa:	c7 04 24 fb 85 10 c0 	movl   $0xc01085fb,(%esp)
c01009b1:	e8 13 f9 ff ff       	call   c01002c9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009b6:	c7 44 24 04 cc 84 10 	movl   $0xc01084cc,0x4(%esp)
c01009bd:	c0 
c01009be:	c7 04 24 13 86 10 c0 	movl   $0xc0108613,(%esp)
c01009c5:	e8 ff f8 ff ff       	call   c01002c9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009ca:	c7 44 24 04 00 30 12 	movl   $0xc0123000,0x4(%esp)
c01009d1:	c0 
c01009d2:	c7 04 24 2b 86 10 c0 	movl   $0xc010862b,(%esp)
c01009d9:	e8 eb f8 ff ff       	call   c01002c9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009de:	c7 44 24 04 60 aa 2a 	movl   $0xc02aaa60,0x4(%esp)
c01009e5:	c0 
c01009e6:	c7 04 24 43 86 10 c0 	movl   $0xc0108643,(%esp)
c01009ed:	e8 d7 f8 ff ff       	call   c01002c9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009f2:	b8 60 aa 2a c0       	mov    $0xc02aaa60,%eax
c01009f7:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009fc:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100a01:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a07:	85 c0                	test   %eax,%eax
c0100a09:	0f 48 c2             	cmovs  %edx,%eax
c0100a0c:	c1 f8 0a             	sar    $0xa,%eax
c0100a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a13:	c7 04 24 5c 86 10 c0 	movl   $0xc010865c,(%esp)
c0100a1a:	e8 aa f8 ff ff       	call   c01002c9 <cprintf>
}
c0100a1f:	90                   	nop
c0100a20:	c9                   	leave  
c0100a21:	c3                   	ret    

c0100a22 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a22:	f3 0f 1e fb          	endbr32 
c0100a26:	55                   	push   %ebp
c0100a27:	89 e5                	mov    %esp,%ebp
c0100a29:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a2f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a39:	89 04 24             	mov    %eax,(%esp)
c0100a3c:	e8 21 fc ff ff       	call   c0100662 <debuginfo_eip>
c0100a41:	85 c0                	test   %eax,%eax
c0100a43:	74 15                	je     c0100a5a <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a4c:	c7 04 24 86 86 10 c0 	movl   $0xc0108686,(%esp)
c0100a53:	e8 71 f8 ff ff       	call   c01002c9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a58:	eb 6c                	jmp    c0100ac6 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a61:	eb 1b                	jmp    c0100a7e <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	01 d0                	add    %edx,%eax
c0100a6b:	0f b6 10             	movzbl (%eax),%edx
c0100a6e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a77:	01 c8                	add    %ecx,%eax
c0100a79:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a7b:	ff 45 f4             	incl   -0xc(%ebp)
c0100a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a84:	7c dd                	jl     c0100a63 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a86:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8f:	01 d0                	add    %edx,%eax
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a97:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a9a:	89 d1                	mov    %edx,%ecx
c0100a9c:	29 c1                	sub    %eax,%ecx
c0100a9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100aa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aa4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100aa8:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100ab2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aba:	c7 04 24 a2 86 10 c0 	movl   $0xc01086a2,(%esp)
c0100ac1:	e8 03 f8 ff ff       	call   c01002c9 <cprintf>
}
c0100ac6:	90                   	nop
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ac9:	f3 0f 1e fb          	endbr32 
c0100acd:	55                   	push   %ebp
c0100ace:	89 e5                	mov    %esp,%ebp
c0100ad0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ad3:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100adc:	c9                   	leave  
c0100add:	c3                   	ret    

c0100ade <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ade:	f3 0f 1e fb          	endbr32 
c0100ae2:	55                   	push   %ebp
c0100ae3:	89 e5                	mov    %esp,%ebp
c0100ae5:	53                   	push   %ebx
c0100ae6:	83 ec 34             	sub    $0x34,%esp
    首先通过函数读取ebp、eip寄存器值，分别表示指向栈底的地址、当前指令的地址；
    ss:[ebp + 8]为函数第一个参数地址，ss:[ebp + 12]为第二个参数地址；
    ss:[ebp]处为上一级函数的ebp地址，ss:[ebp+4]为返回地址；
    可通过指针索引的方式访问指针所指内容
    */
    uint32_t *ebp = 0;                  
c0100ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32_t esp = 0;                   
c0100af0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100af7:	89 e8                	mov    %ebp,%eax
c0100af9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c0100afc:	8b 45 ec             	mov    -0x14(%ebp),%eax

    ebp = (uint32_t *)read_ebp();           //函数读取ebp、eip寄存器值
c0100aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    esp = read_eip();                       //
c0100b02:	e8 c2 ff ff ff       	call   c0100ac9 <read_eip>
c0100b07:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp)                             //当栈底元素不为空的时候,迭代打印
c0100b0a:	eb 73                	jmp    c0100b7f <print_stackframe+0xa1>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
c0100b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100b12:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1a:	c7 04 24 b4 86 10 c0 	movl   $0xc01086b4,(%esp)
c0100b21:	e8 a3 f7 ff ff       	call   c01002c9 <cprintf>
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
c0100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b29:	83 c0 14             	add    $0x14,%eax
c0100b2c:	8b 18                	mov    (%eax),%ebx
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b31:	83 c0 10             	add    $0x10,%eax
c0100b34:	8b 08                	mov    (%eax),%ecx
c0100b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b39:	83 c0 0c             	add    $0xc,%eax
c0100b3c:	8b 10                	mov    (%eax),%edx
c0100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b41:	83 c0 08             	add    $0x8,%eax
c0100b44:	8b 00                	mov    (%eax),%eax
c0100b46:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100b4a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100b4e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b56:	c7 04 24 d0 86 10 c0 	movl   $0xc01086d0,(%esp)
c0100b5d:	e8 67 f7 ff ff       	call   c01002c9 <cprintf>

        print_debuginfo(esp - 1);
c0100b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b65:	48                   	dec    %eax
c0100b66:	89 04 24             	mov    %eax,(%esp)
c0100b69:	e8 b4 fe ff ff       	call   c0100a22 <print_debuginfo>

        esp = ebp[1];                       //迭代,将ebp[1]-----> esp, *[*ebp]指向下一个地址,将它赋值给ebp
c0100b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b71:	8b 40 04             	mov    0x4(%eax),%eax
c0100b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = (uint32_t *)*ebp;
c0100b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b7a:	8b 00                	mov    (%eax),%eax
c0100b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (ebp)                             //当栈底元素不为空的时候,迭代打印
c0100b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b83:	75 87                	jne    c0100b0c <print_stackframe+0x2e>
    }
}
c0100b85:	90                   	nop
c0100b86:	90                   	nop
c0100b87:	83 c4 34             	add    $0x34,%esp
c0100b8a:	5b                   	pop    %ebx
c0100b8b:	5d                   	pop    %ebp
c0100b8c:	c3                   	ret    

c0100b8d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b8d:	f3 0f 1e fb          	endbr32 
c0100b91:	55                   	push   %ebp
c0100b92:	89 e5                	mov    %esp,%ebp
c0100b94:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b9e:	eb 0c                	jmp    c0100bac <parse+0x1f>
            *buf ++ = '\0';
c0100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba3:	8d 50 01             	lea    0x1(%eax),%edx
c0100ba6:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba9:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0100baf:	0f b6 00             	movzbl (%eax),%eax
c0100bb2:	84 c0                	test   %al,%al
c0100bb4:	74 1d                	je     c0100bd3 <parse+0x46>
c0100bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb9:	0f b6 00             	movzbl (%eax),%eax
c0100bbc:	0f be c0             	movsbl %al,%eax
c0100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc3:	c7 04 24 70 87 10 c0 	movl   $0xc0108770,(%esp)
c0100bca:	e8 17 6f 00 00       	call   c0107ae6 <strchr>
c0100bcf:	85 c0                	test   %eax,%eax
c0100bd1:	75 cd                	jne    c0100ba0 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd6:	0f b6 00             	movzbl (%eax),%eax
c0100bd9:	84 c0                	test   %al,%al
c0100bdb:	74 65                	je     c0100c42 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bdd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100be1:	75 14                	jne    c0100bf7 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100be3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bea:	00 
c0100beb:	c7 04 24 75 87 10 c0 	movl   $0xc0108775,(%esp)
c0100bf2:	e8 d2 f6 ff ff       	call   c01002c9 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bfa:	8d 50 01             	lea    0x1(%eax),%edx
c0100bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c0a:	01 c2                	add    %eax,%edx
c0100c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c11:	eb 03                	jmp    c0100c16 <parse+0x89>
            buf ++;
c0100c13:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c19:	0f b6 00             	movzbl (%eax),%eax
c0100c1c:	84 c0                	test   %al,%al
c0100c1e:	74 8c                	je     c0100bac <parse+0x1f>
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	0f b6 00             	movzbl (%eax),%eax
c0100c26:	0f be c0             	movsbl %al,%eax
c0100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2d:	c7 04 24 70 87 10 c0 	movl   $0xc0108770,(%esp)
c0100c34:	e8 ad 6e 00 00       	call   c0107ae6 <strchr>
c0100c39:	85 c0                	test   %eax,%eax
c0100c3b:	74 d6                	je     c0100c13 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c3d:	e9 6a ff ff ff       	jmp    c0100bac <parse+0x1f>
            break;
c0100c42:	90                   	nop
        }
    }
    return argc;
c0100c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c46:	c9                   	leave  
c0100c47:	c3                   	ret    

c0100c48 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c48:	f3 0f 1e fb          	endbr32 
c0100c4c:	55                   	push   %ebp
c0100c4d:	89 e5                	mov    %esp,%ebp
c0100c4f:	53                   	push   %ebx
c0100c50:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c53:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c5d:	89 04 24             	mov    %eax,(%esp)
c0100c60:	e8 28 ff ff ff       	call   c0100b8d <parse>
c0100c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c6c:	75 0a                	jne    c0100c78 <runcmd+0x30>
        return 0;
c0100c6e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c73:	e9 83 00 00 00       	jmp    c0100cfb <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c7f:	eb 5a                	jmp    c0100cdb <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c81:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c87:	89 d0                	mov    %edx,%eax
c0100c89:	01 c0                	add    %eax,%eax
c0100c8b:	01 d0                	add    %edx,%eax
c0100c8d:	c1 e0 02             	shl    $0x2,%eax
c0100c90:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c95:	8b 00                	mov    (%eax),%eax
c0100c97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c9b:	89 04 24             	mov    %eax,(%esp)
c0100c9e:	e8 9f 6d 00 00       	call   c0107a42 <strcmp>
c0100ca3:	85 c0                	test   %eax,%eax
c0100ca5:	75 31                	jne    c0100cd8 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100caa:	89 d0                	mov    %edx,%eax
c0100cac:	01 c0                	add    %eax,%eax
c0100cae:	01 d0                	add    %edx,%eax
c0100cb0:	c1 e0 02             	shl    $0x2,%eax
c0100cb3:	05 08 00 12 c0       	add    $0xc0120008,%eax
c0100cb8:	8b 10                	mov    (%eax),%edx
c0100cba:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cbd:	83 c0 04             	add    $0x4,%eax
c0100cc0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cc3:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cd1:	89 1c 24             	mov    %ebx,(%esp)
c0100cd4:	ff d2                	call   *%edx
c0100cd6:	eb 23                	jmp    c0100cfb <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cd8:	ff 45 f4             	incl   -0xc(%ebp)
c0100cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cde:	83 f8 02             	cmp    $0x2,%eax
c0100ce1:	76 9e                	jbe    c0100c81 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100ce3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cea:	c7 04 24 93 87 10 c0 	movl   $0xc0108793,(%esp)
c0100cf1:	e8 d3 f5 ff ff       	call   c01002c9 <cprintf>
    return 0;
c0100cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cfb:	83 c4 64             	add    $0x64,%esp
c0100cfe:	5b                   	pop    %ebx
c0100cff:	5d                   	pop    %ebp
c0100d00:	c3                   	ret    

c0100d01 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d01:	f3 0f 1e fb          	endbr32 
c0100d05:	55                   	push   %ebp
c0100d06:	89 e5                	mov    %esp,%ebp
c0100d08:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d0b:	c7 04 24 ac 87 10 c0 	movl   $0xc01087ac,(%esp)
c0100d12:	e8 b2 f5 ff ff       	call   c01002c9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d17:	c7 04 24 d4 87 10 c0 	movl   $0xc01087d4,(%esp)
c0100d1e:	e8 a6 f5 ff ff       	call   c01002c9 <cprintf>

    if (tf != NULL) {
c0100d23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d27:	74 0b                	je     c0100d34 <kmonitor+0x33>
        print_trapframe(tf);
c0100d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d2c:	89 04 24             	mov    %eax,(%esp)
c0100d2f:	e8 5f 0e 00 00       	call   c0101b93 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d34:	c7 04 24 f9 87 10 c0 	movl   $0xc01087f9,(%esp)
c0100d3b:	e8 3c f6 ff ff       	call   c010037c <readline>
c0100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d47:	74 eb                	je     c0100d34 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d53:	89 04 24             	mov    %eax,(%esp)
c0100d56:	e8 ed fe ff ff       	call   c0100c48 <runcmd>
c0100d5b:	85 c0                	test   %eax,%eax
c0100d5d:	78 02                	js     c0100d61 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d5f:	eb d3                	jmp    c0100d34 <kmonitor+0x33>
                break;
c0100d61:	90                   	nop
            }
        }
    }
}
c0100d62:	90                   	nop
c0100d63:	c9                   	leave  
c0100d64:	c3                   	ret    

c0100d65 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d65:	f3 0f 1e fb          	endbr32 
c0100d69:	55                   	push   %ebp
c0100d6a:	89 e5                	mov    %esp,%ebp
c0100d6c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d76:	eb 3d                	jmp    c0100db5 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7b:	89 d0                	mov    %edx,%eax
c0100d7d:	01 c0                	add    %eax,%eax
c0100d7f:	01 d0                	add    %edx,%eax
c0100d81:	c1 e0 02             	shl    $0x2,%eax
c0100d84:	05 04 00 12 c0       	add    $0xc0120004,%eax
c0100d89:	8b 08                	mov    (%eax),%ecx
c0100d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d8e:	89 d0                	mov    %edx,%eax
c0100d90:	01 c0                	add    %eax,%eax
c0100d92:	01 d0                	add    %edx,%eax
c0100d94:	c1 e0 02             	shl    $0x2,%eax
c0100d97:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100d9c:	8b 00                	mov    (%eax),%eax
c0100d9e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100da2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100da6:	c7 04 24 fd 87 10 c0 	movl   $0xc01087fd,(%esp)
c0100dad:	e8 17 f5 ff ff       	call   c01002c9 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100db2:	ff 45 f4             	incl   -0xc(%ebp)
c0100db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100db8:	83 f8 02             	cmp    $0x2,%eax
c0100dbb:	76 bb                	jbe    c0100d78 <mon_help+0x13>
    }
    return 0;
c0100dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc2:	c9                   	leave  
c0100dc3:	c3                   	ret    

c0100dc4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dc4:	f3 0f 1e fb          	endbr32 
c0100dc8:	55                   	push   %ebp
c0100dc9:	89 e5                	mov    %esp,%ebp
c0100dcb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dce:	e8 b9 fb ff ff       	call   c010098c <print_kerninfo>
    return 0;
c0100dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd8:	c9                   	leave  
c0100dd9:	c3                   	ret    

c0100dda <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dda:	f3 0f 1e fb          	endbr32 
c0100dde:	55                   	push   %ebp
c0100ddf:	89 e5                	mov    %esp,%ebp
c0100de1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100de4:	e8 f5 fc ff ff       	call   c0100ade <print_stackframe>
    return 0;
c0100de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dee:	c9                   	leave  
c0100def:	c3                   	ret    

c0100df0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100df0:	f3 0f 1e fb          	endbr32 
c0100df4:	55                   	push   %ebp
c0100df5:	89 e5                	mov    %esp,%ebp
c0100df7:	83 ec 28             	sub    $0x28,%esp
c0100dfa:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e00:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e04:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e08:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e0c:	ee                   	out    %al,(%dx)
}
c0100e0d:	90                   	nop
c0100e0e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e14:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e18:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e1c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e20:	ee                   	out    %al,(%dx)
}
c0100e21:	90                   	nop
c0100e22:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e28:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e2c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e34:	ee                   	out    %al,(%dx)
}
c0100e35:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e36:	c7 05 a0 3f 12 c0 00 	movl   $0x0,0xc0123fa0
c0100e3d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e40:	c7 04 24 06 88 10 c0 	movl   $0xc0108806,(%esp)
c0100e47:	e8 7d f4 ff ff       	call   c01002c9 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e53:	e8 95 09 00 00       	call   c01017ed <pic_enable>
}
c0100e58:	90                   	nop
c0100e59:	c9                   	leave  
c0100e5a:	c3                   	ret    

c0100e5b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e5b:	55                   	push   %ebp
c0100e5c:	89 e5                	mov    %esp,%ebp
c0100e5e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e61:	9c                   	pushf  
c0100e62:	58                   	pop    %eax
c0100e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e69:	25 00 02 00 00       	and    $0x200,%eax
c0100e6e:	85 c0                	test   %eax,%eax
c0100e70:	74 0c                	je     c0100e7e <__intr_save+0x23>
        intr_disable();
c0100e72:	e8 05 0b 00 00       	call   c010197c <intr_disable>
        return 1;
c0100e77:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e7c:	eb 05                	jmp    c0100e83 <__intr_save+0x28>
    }
    return 0;
c0100e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e83:	c9                   	leave  
c0100e84:	c3                   	ret    

c0100e85 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e85:	55                   	push   %ebp
c0100e86:	89 e5                	mov    %esp,%ebp
c0100e88:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e8f:	74 05                	je     c0100e96 <__intr_restore+0x11>
        intr_enable();
c0100e91:	e8 da 0a 00 00       	call   c0101970 <intr_enable>
    }
}
c0100e96:	90                   	nop
c0100e97:	c9                   	leave  
c0100e98:	c3                   	ret    

c0100e99 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e99:	f3 0f 1e fb          	endbr32 
c0100e9d:	55                   	push   %ebp
c0100e9e:	89 e5                	mov    %esp,%ebp
c0100ea0:	83 ec 10             	sub    $0x10,%esp
c0100ea3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ea9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ead:	89 c2                	mov    %eax,%edx
c0100eaf:	ec                   	in     (%dx),%al
c0100eb0:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100eb3:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100eb9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ebd:	89 c2                	mov    %eax,%edx
c0100ebf:	ec                   	in     (%dx),%al
c0100ec0:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ec3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ec9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ecd:	89 c2                	mov    %eax,%edx
c0100ecf:	ec                   	in     (%dx),%al
c0100ed0:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ed3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ed9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100edd:	89 c2                	mov    %eax,%edx
c0100edf:	ec                   	in     (%dx),%al
c0100ee0:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ee3:	90                   	nop
c0100ee4:	c9                   	leave  
c0100ee5:	c3                   	ret    

c0100ee6 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ee6:	f3 0f 1e fb          	endbr32 
c0100eea:	55                   	push   %ebp
c0100eeb:	89 e5                	mov    %esp,%ebp
c0100eed:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ef0:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100efa:	0f b7 00             	movzwl (%eax),%eax
c0100efd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f04:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0c:	0f b7 00             	movzwl (%eax),%eax
c0100f0f:	0f b7 c0             	movzwl %ax,%eax
c0100f12:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f17:	74 12                	je     c0100f2b <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f19:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f20:	66 c7 05 46 34 12 c0 	movw   $0x3b4,0xc0123446
c0100f27:	b4 03 
c0100f29:	eb 13                	jmp    c0100f3e <cga_init+0x58>
    } else {
        *cp = was;
c0100f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f32:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f35:	66 c7 05 46 34 12 c0 	movw   $0x3d4,0xc0123446
c0100f3c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f3e:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f45:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f49:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f51:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f55:	ee                   	out    %al,(%dx)
}
c0100f56:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f57:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f5e:	40                   	inc    %eax
c0100f5f:	0f b7 c0             	movzwl %ax,%eax
c0100f62:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f66:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f6a:	89 c2                	mov    %eax,%edx
c0100f6c:	ec                   	in     (%dx),%al
c0100f6d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f70:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f74:	0f b6 c0             	movzbl %al,%eax
c0100f77:	c1 e0 08             	shl    $0x8,%eax
c0100f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f7d:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f84:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f88:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
}
c0100f95:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f96:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f9d:	40                   	inc    %eax
c0100f9e:	0f b7 c0             	movzwl %ax,%eax
c0100fa1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fa5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fa9:	89 c2                	mov    %eax,%edx
c0100fab:	ec                   	in     (%dx),%al
c0100fac:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100faf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fb3:	0f b6 c0             	movzbl %al,%eax
c0100fb6:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fbc:	a3 40 34 12 c0       	mov    %eax,0xc0123440
    crt_pos = pos;
c0100fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fc4:	0f b7 c0             	movzwl %ax,%eax
c0100fc7:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
}
c0100fcd:	90                   	nop
c0100fce:	c9                   	leave  
c0100fcf:	c3                   	ret    

c0100fd0 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fd0:	f3 0f 1e fb          	endbr32 
c0100fd4:	55                   	push   %ebp
c0100fd5:	89 e5                	mov    %esp,%ebp
c0100fd7:	83 ec 48             	sub    $0x48,%esp
c0100fda:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fe0:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fe8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fec:	ee                   	out    %al,(%dx)
}
c0100fed:	90                   	nop
c0100fee:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ff4:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100ffc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101000:	ee                   	out    %al,(%dx)
}
c0101001:	90                   	nop
c0101002:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101008:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010100c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101010:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101014:	ee                   	out    %al,(%dx)
}
c0101015:	90                   	nop
c0101016:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010101c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101020:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101024:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101028:	ee                   	out    %al,(%dx)
}
c0101029:	90                   	nop
c010102a:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101030:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101034:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101038:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010103c:	ee                   	out    %al,(%dx)
}
c010103d:	90                   	nop
c010103e:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101044:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101048:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010104c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101050:	ee                   	out    %al,(%dx)
}
c0101051:	90                   	nop
c0101052:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101058:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010105c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101060:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101064:	ee                   	out    %al,(%dx)
}
c0101065:	90                   	nop
c0101066:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010106c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101070:	89 c2                	mov    %eax,%edx
c0101072:	ec                   	in     (%dx),%al
c0101073:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101076:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010107a:	3c ff                	cmp    $0xff,%al
c010107c:	0f 95 c0             	setne  %al
c010107f:	0f b6 c0             	movzbl %al,%eax
c0101082:	a3 48 34 12 c0       	mov    %eax,0xc0123448
c0101087:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010108d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101091:	89 c2                	mov    %eax,%edx
c0101093:	ec                   	in     (%dx),%al
c0101094:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101097:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010109d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010a1:	89 c2                	mov    %eax,%edx
c01010a3:	ec                   	in     (%dx),%al
c01010a4:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010a7:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01010ac:	85 c0                	test   %eax,%eax
c01010ae:	74 0c                	je     c01010bc <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010b0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010b7:	e8 31 07 00 00       	call   c01017ed <pic_enable>
    }
}
c01010bc:	90                   	nop
c01010bd:	c9                   	leave  
c01010be:	c3                   	ret    

c01010bf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010bf:	f3 0f 1e fb          	endbr32 
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010d0:	eb 08                	jmp    c01010da <lpt_putc_sub+0x1b>
        delay();
c01010d2:	e8 c2 fd ff ff       	call   c0100e99 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d7:	ff 45 fc             	incl   -0x4(%ebp)
c01010da:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010e0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010e4:	89 c2                	mov    %eax,%edx
c01010e6:	ec                   	in     (%dx),%al
c01010e7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010ee:	84 c0                	test   %al,%al
c01010f0:	78 09                	js     c01010fb <lpt_putc_sub+0x3c>
c01010f2:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010f9:	7e d7                	jle    c01010d2 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c01010fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fe:	0f b6 c0             	movzbl %al,%eax
c0101101:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101107:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010110a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010110e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101112:	ee                   	out    %al,(%dx)
}
c0101113:	90                   	nop
c0101114:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010111a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010111e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101122:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101126:	ee                   	out    %al,(%dx)
}
c0101127:	90                   	nop
c0101128:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010112e:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101132:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101136:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010113a:	ee                   	out    %al,(%dx)
}
c010113b:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010113c:	90                   	nop
c010113d:	c9                   	leave  
c010113e:	c3                   	ret    

c010113f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010113f:	f3 0f 1e fb          	endbr32 
c0101143:	55                   	push   %ebp
c0101144:	89 e5                	mov    %esp,%ebp
c0101146:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101149:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010114d:	74 0d                	je     c010115c <lpt_putc+0x1d>
        lpt_putc_sub(c);
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	89 04 24             	mov    %eax,(%esp)
c0101155:	e8 65 ff ff ff       	call   c01010bf <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010115a:	eb 24                	jmp    c0101180 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c010115c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101163:	e8 57 ff ff ff       	call   c01010bf <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101168:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010116f:	e8 4b ff ff ff       	call   c01010bf <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101174:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010117b:	e8 3f ff ff ff       	call   c01010bf <lpt_putc_sub>
}
c0101180:	90                   	nop
c0101181:	c9                   	leave  
c0101182:	c3                   	ret    

c0101183 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101183:	f3 0f 1e fb          	endbr32 
c0101187:	55                   	push   %ebp
c0101188:	89 e5                	mov    %esp,%ebp
c010118a:	53                   	push   %ebx
c010118b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010118e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101191:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101196:	85 c0                	test   %eax,%eax
c0101198:	75 07                	jne    c01011a1 <cga_putc+0x1e>
        c |= 0x0700;
c010119a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a4:	0f b6 c0             	movzbl %al,%eax
c01011a7:	83 f8 0d             	cmp    $0xd,%eax
c01011aa:	74 72                	je     c010121e <cga_putc+0x9b>
c01011ac:	83 f8 0d             	cmp    $0xd,%eax
c01011af:	0f 8f a3 00 00 00    	jg     c0101258 <cga_putc+0xd5>
c01011b5:	83 f8 08             	cmp    $0x8,%eax
c01011b8:	74 0a                	je     c01011c4 <cga_putc+0x41>
c01011ba:	83 f8 0a             	cmp    $0xa,%eax
c01011bd:	74 4c                	je     c010120b <cga_putc+0x88>
c01011bf:	e9 94 00 00 00       	jmp    c0101258 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011c4:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011cb:	85 c0                	test   %eax,%eax
c01011cd:	0f 84 af 00 00 00    	je     c0101282 <cga_putc+0xff>
            crt_pos --;
c01011d3:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011da:	48                   	dec    %eax
c01011db:	0f b7 c0             	movzwl %ax,%eax
c01011de:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e7:	98                   	cwtl   
c01011e8:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ed:	98                   	cwtl   
c01011ee:	83 c8 20             	or     $0x20,%eax
c01011f1:	98                   	cwtl   
c01011f2:	8b 15 40 34 12 c0    	mov    0xc0123440,%edx
c01011f8:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c01011ff:	01 c9                	add    %ecx,%ecx
c0101201:	01 ca                	add    %ecx,%edx
c0101203:	0f b7 c0             	movzwl %ax,%eax
c0101206:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101209:	eb 77                	jmp    c0101282 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c010120b:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101212:	83 c0 50             	add    $0x50,%eax
c0101215:	0f b7 c0             	movzwl %ax,%eax
c0101218:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010121e:	0f b7 1d 44 34 12 c0 	movzwl 0xc0123444,%ebx
c0101225:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c010122c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101231:	89 c8                	mov    %ecx,%eax
c0101233:	f7 e2                	mul    %edx
c0101235:	c1 ea 06             	shr    $0x6,%edx
c0101238:	89 d0                	mov    %edx,%eax
c010123a:	c1 e0 02             	shl    $0x2,%eax
c010123d:	01 d0                	add    %edx,%eax
c010123f:	c1 e0 04             	shl    $0x4,%eax
c0101242:	29 c1                	sub    %eax,%ecx
c0101244:	89 c8                	mov    %ecx,%eax
c0101246:	0f b7 c0             	movzwl %ax,%eax
c0101249:	29 c3                	sub    %eax,%ebx
c010124b:	89 d8                	mov    %ebx,%eax
c010124d:	0f b7 c0             	movzwl %ax,%eax
c0101250:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
        break;
c0101256:	eb 2b                	jmp    c0101283 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101258:	8b 0d 40 34 12 c0    	mov    0xc0123440,%ecx
c010125e:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101265:	8d 50 01             	lea    0x1(%eax),%edx
c0101268:	0f b7 d2             	movzwl %dx,%edx
c010126b:	66 89 15 44 34 12 c0 	mov    %dx,0xc0123444
c0101272:	01 c0                	add    %eax,%eax
c0101274:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101277:	8b 45 08             	mov    0x8(%ebp),%eax
c010127a:	0f b7 c0             	movzwl %ax,%eax
c010127d:	66 89 02             	mov    %ax,(%edx)
        break;
c0101280:	eb 01                	jmp    c0101283 <cga_putc+0x100>
        break;
c0101282:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101283:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010128a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c010128f:	76 5d                	jbe    c01012ee <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101291:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101296:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010129c:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c01012a1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012a8:	00 
c01012a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012ad:	89 04 24             	mov    %eax,(%esp)
c01012b0:	e8 36 6a 00 00       	call   c0107ceb <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012b5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012bc:	eb 14                	jmp    c01012d2 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012be:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c01012c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012c6:	01 d2                	add    %edx,%edx
c01012c8:	01 d0                	add    %edx,%eax
c01012ca:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012cf:	ff 45 f4             	incl   -0xc(%ebp)
c01012d2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012d9:	7e e3                	jle    c01012be <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012db:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01012e2:	83 e8 50             	sub    $0x50,%eax
c01012e5:	0f b7 c0             	movzwl %ax,%eax
c01012e8:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012ee:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c01012f5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012f9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012fd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101301:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101305:	ee                   	out    %al,(%dx)
}
c0101306:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101307:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010130e:	c1 e8 08             	shr    $0x8,%eax
c0101311:	0f b7 c0             	movzwl %ax,%eax
c0101314:	0f b6 c0             	movzbl %al,%eax
c0101317:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c010131e:	42                   	inc    %edx
c010131f:	0f b7 d2             	movzwl %dx,%edx
c0101322:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101326:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101329:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010132d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101331:	ee                   	out    %al,(%dx)
}
c0101332:	90                   	nop
    outb(addr_6845, 15);
c0101333:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c010133a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010133e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101342:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101346:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010134a:	ee                   	out    %al,(%dx)
}
c010134b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010134c:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101353:	0f b6 c0             	movzbl %al,%eax
c0101356:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c010135d:	42                   	inc    %edx
c010135e:	0f b7 d2             	movzwl %dx,%edx
c0101361:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101365:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101368:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010136c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101370:	ee                   	out    %al,(%dx)
}
c0101371:	90                   	nop
}
c0101372:	90                   	nop
c0101373:	83 c4 34             	add    $0x34,%esp
c0101376:	5b                   	pop    %ebx
c0101377:	5d                   	pop    %ebp
c0101378:	c3                   	ret    

c0101379 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101379:	f3 0f 1e fb          	endbr32 
c010137d:	55                   	push   %ebp
c010137e:	89 e5                	mov    %esp,%ebp
c0101380:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010138a:	eb 08                	jmp    c0101394 <serial_putc_sub+0x1b>
        delay();
c010138c:	e8 08 fb ff ff       	call   c0100e99 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101391:	ff 45 fc             	incl   -0x4(%ebp)
c0101394:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010139a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010139e:	89 c2                	mov    %eax,%edx
c01013a0:	ec                   	in     (%dx),%al
c01013a1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013a4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	83 e0 20             	and    $0x20,%eax
c01013ae:	85 c0                	test   %eax,%eax
c01013b0:	75 09                	jne    c01013bb <serial_putc_sub+0x42>
c01013b2:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013b9:	7e d1                	jle    c010138c <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01013be:	0f b6 c0             	movzbl %al,%eax
c01013c1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013c7:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013ca:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013ce:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013d2:	ee                   	out    %al,(%dx)
}
c01013d3:	90                   	nop
}
c01013d4:	90                   	nop
c01013d5:	c9                   	leave  
c01013d6:	c3                   	ret    

c01013d7 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013d7:	f3 0f 1e fb          	endbr32 
c01013db:	55                   	push   %ebp
c01013dc:	89 e5                	mov    %esp,%ebp
c01013de:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013e1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013e5:	74 0d                	je     c01013f4 <serial_putc+0x1d>
        serial_putc_sub(c);
c01013e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ea:	89 04 24             	mov    %eax,(%esp)
c01013ed:	e8 87 ff ff ff       	call   c0101379 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013f2:	eb 24                	jmp    c0101418 <serial_putc+0x41>
        serial_putc_sub('\b');
c01013f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013fb:	e8 79 ff ff ff       	call   c0101379 <serial_putc_sub>
        serial_putc_sub(' ');
c0101400:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101407:	e8 6d ff ff ff       	call   c0101379 <serial_putc_sub>
        serial_putc_sub('\b');
c010140c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101413:	e8 61 ff ff ff       	call   c0101379 <serial_putc_sub>
}
c0101418:	90                   	nop
c0101419:	c9                   	leave  
c010141a:	c3                   	ret    

c010141b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010141b:	f3 0f 1e fb          	endbr32 
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101425:	eb 33                	jmp    c010145a <cons_intr+0x3f>
        if (c != 0) {
c0101427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010142b:	74 2d                	je     c010145a <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c010142d:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101432:	8d 50 01             	lea    0x1(%eax),%edx
c0101435:	89 15 64 36 12 c0    	mov    %edx,0xc0123664
c010143b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010143e:	88 90 60 34 12 c0    	mov    %dl,-0x3fedcba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101444:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101449:	3d 00 02 00 00       	cmp    $0x200,%eax
c010144e:	75 0a                	jne    c010145a <cons_intr+0x3f>
                cons.wpos = 0;
c0101450:	c7 05 64 36 12 c0 00 	movl   $0x0,0xc0123664
c0101457:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010145a:	8b 45 08             	mov    0x8(%ebp),%eax
c010145d:	ff d0                	call   *%eax
c010145f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101462:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101466:	75 bf                	jne    c0101427 <cons_intr+0xc>
            }
        }
    }
}
c0101468:	90                   	nop
c0101469:	90                   	nop
c010146a:	c9                   	leave  
c010146b:	c3                   	ret    

c010146c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010146c:	f3 0f 1e fb          	endbr32 
c0101470:	55                   	push   %ebp
c0101471:	89 e5                	mov    %esp,%ebp
c0101473:	83 ec 10             	sub    $0x10,%esp
c0101476:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010147c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101480:	89 c2                	mov    %eax,%edx
c0101482:	ec                   	in     (%dx),%al
c0101483:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101486:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010148a:	0f b6 c0             	movzbl %al,%eax
c010148d:	83 e0 01             	and    $0x1,%eax
c0101490:	85 c0                	test   %eax,%eax
c0101492:	75 07                	jne    c010149b <serial_proc_data+0x2f>
        return -1;
c0101494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101499:	eb 2a                	jmp    c01014c5 <serial_proc_data+0x59>
c010149b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014a1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014a5:	89 c2                	mov    %eax,%edx
c01014a7:	ec                   	in     (%dx),%al
c01014a8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014af:	0f b6 c0             	movzbl %al,%eax
c01014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014b5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014b9:	75 07                	jne    c01014c2 <serial_proc_data+0x56>
        c = '\b';
c01014bb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014c5:	c9                   	leave  
c01014c6:	c3                   	ret    

c01014c7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014c7:	f3 0f 1e fb          	endbr32 
c01014cb:	55                   	push   %ebp
c01014cc:	89 e5                	mov    %esp,%ebp
c01014ce:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014d1:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01014d6:	85 c0                	test   %eax,%eax
c01014d8:	74 0c                	je     c01014e6 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014da:	c7 04 24 6c 14 10 c0 	movl   $0xc010146c,(%esp)
c01014e1:	e8 35 ff ff ff       	call   c010141b <cons_intr>
    }
}
c01014e6:	90                   	nop
c01014e7:	c9                   	leave  
c01014e8:	c3                   	ret    

c01014e9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014e9:	f3 0f 1e fb          	endbr32 
c01014ed:	55                   	push   %ebp
c01014ee:	89 e5                	mov    %esp,%ebp
c01014f0:	83 ec 38             	sub    $0x38,%esp
c01014f3:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014fc:	89 c2                	mov    %eax,%edx
c01014fe:	ec                   	in     (%dx),%al
c01014ff:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101502:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101506:	0f b6 c0             	movzbl %al,%eax
c0101509:	83 e0 01             	and    $0x1,%eax
c010150c:	85 c0                	test   %eax,%eax
c010150e:	75 0a                	jne    c010151a <kbd_proc_data+0x31>
        return -1;
c0101510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101515:	e9 56 01 00 00       	jmp    c0101670 <kbd_proc_data+0x187>
c010151a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101520:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101523:	89 c2                	mov    %eax,%edx
c0101525:	ec                   	in     (%dx),%al
c0101526:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101529:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010152d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101530:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101534:	75 17                	jne    c010154d <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c0101536:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010153b:	83 c8 40             	or     $0x40,%eax
c010153e:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c0101543:	b8 00 00 00 00       	mov    $0x0,%eax
c0101548:	e9 23 01 00 00       	jmp    c0101670 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010154d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101551:	84 c0                	test   %al,%al
c0101553:	79 45                	jns    c010159a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101555:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010155a:	83 e0 40             	and    $0x40,%eax
c010155d:	85 c0                	test   %eax,%eax
c010155f:	75 08                	jne    c0101569 <kbd_proc_data+0x80>
c0101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101565:	24 7f                	and    $0x7f,%al
c0101567:	eb 04                	jmp    c010156d <kbd_proc_data+0x84>
c0101569:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101570:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101574:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c010157b:	0c 40                	or     $0x40,%al
c010157d:	0f b6 c0             	movzbl %al,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	89 c2                	mov    %eax,%edx
c0101584:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101589:	21 d0                	and    %edx,%eax
c010158b:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c0101590:	b8 00 00 00 00       	mov    $0x0,%eax
c0101595:	e9 d6 00 00 00       	jmp    c0101670 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010159a:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010159f:	83 e0 40             	and    $0x40,%eax
c01015a2:	85 c0                	test   %eax,%eax
c01015a4:	74 11                	je     c01015b7 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015a6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015aa:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015af:	83 e0 bf             	and    $0xffffffbf,%eax
c01015b2:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    }

    shift |= shiftcode[data];
c01015b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015bb:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c01015c2:	0f b6 d0             	movzbl %al,%edx
c01015c5:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015ca:	09 d0                	or     %edx,%eax
c01015cc:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    shift ^= togglecode[data];
c01015d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015d5:	0f b6 80 40 01 12 c0 	movzbl -0x3fedfec0(%eax),%eax
c01015dc:	0f b6 d0             	movzbl %al,%edx
c01015df:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015e4:	31 d0                	xor    %edx,%eax
c01015e6:	a3 68 36 12 c0       	mov    %eax,0xc0123668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015eb:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015f0:	83 e0 03             	and    $0x3,%eax
c01015f3:	8b 14 85 40 05 12 c0 	mov    -0x3fedfac0(,%eax,4),%edx
c01015fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015fe:	01 d0                	add    %edx,%eax
c0101600:	0f b6 00             	movzbl (%eax),%eax
c0101603:	0f b6 c0             	movzbl %al,%eax
c0101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101609:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010160e:	83 e0 08             	and    $0x8,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	74 22                	je     c0101637 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101615:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101619:	7e 0c                	jle    c0101627 <kbd_proc_data+0x13e>
c010161b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010161f:	7f 06                	jg     c0101627 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101621:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101625:	eb 10                	jmp    c0101637 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101627:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010162b:	7e 0a                	jle    c0101637 <kbd_proc_data+0x14e>
c010162d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101631:	7f 04                	jg     c0101637 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101633:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101637:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010163c:	f7 d0                	not    %eax
c010163e:	83 e0 06             	and    $0x6,%eax
c0101641:	85 c0                	test   %eax,%eax
c0101643:	75 28                	jne    c010166d <kbd_proc_data+0x184>
c0101645:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010164c:	75 1f                	jne    c010166d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010164e:	c7 04 24 21 88 10 c0 	movl   $0xc0108821,(%esp)
c0101655:	e8 6f ec ff ff       	call   c01002c9 <cprintf>
c010165a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101660:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101664:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101668:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010166b:	ee                   	out    %al,(%dx)
}
c010166c:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101670:	c9                   	leave  
c0101671:	c3                   	ret    

c0101672 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101672:	f3 0f 1e fb          	endbr32 
c0101676:	55                   	push   %ebp
c0101677:	89 e5                	mov    %esp,%ebp
c0101679:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010167c:	c7 04 24 e9 14 10 c0 	movl   $0xc01014e9,(%esp)
c0101683:	e8 93 fd ff ff       	call   c010141b <cons_intr>
}
c0101688:	90                   	nop
c0101689:	c9                   	leave  
c010168a:	c3                   	ret    

c010168b <kbd_init>:

static void
kbd_init(void) {
c010168b:	f3 0f 1e fb          	endbr32 
c010168f:	55                   	push   %ebp
c0101690:	89 e5                	mov    %esp,%ebp
c0101692:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101695:	e8 d8 ff ff ff       	call   c0101672 <kbd_intr>
    pic_enable(IRQ_KBD);
c010169a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016a1:	e8 47 01 00 00       	call   c01017ed <pic_enable>
}
c01016a6:	90                   	nop
c01016a7:	c9                   	leave  
c01016a8:	c3                   	ret    

c01016a9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016a9:	f3 0f 1e fb          	endbr32 
c01016ad:	55                   	push   %ebp
c01016ae:	89 e5                	mov    %esp,%ebp
c01016b0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016b3:	e8 2e f8 ff ff       	call   c0100ee6 <cga_init>
    serial_init();
c01016b8:	e8 13 f9 ff ff       	call   c0100fd0 <serial_init>
    kbd_init();
c01016bd:	e8 c9 ff ff ff       	call   c010168b <kbd_init>
    if (!serial_exists) {
c01016c2:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01016c7:	85 c0                	test   %eax,%eax
c01016c9:	75 0c                	jne    c01016d7 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016cb:	c7 04 24 2d 88 10 c0 	movl   $0xc010882d,(%esp)
c01016d2:	e8 f2 eb ff ff       	call   c01002c9 <cprintf>
    }
}
c01016d7:	90                   	nop
c01016d8:	c9                   	leave  
c01016d9:	c3                   	ret    

c01016da <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016da:	f3 0f 1e fb          	endbr32 
c01016de:	55                   	push   %ebp
c01016df:	89 e5                	mov    %esp,%ebp
c01016e1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e4:	e8 72 f7 ff ff       	call   c0100e5b <__intr_save>
c01016e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ef:	89 04 24             	mov    %eax,(%esp)
c01016f2:	e8 48 fa ff ff       	call   c010113f <lpt_putc>
        cga_putc(c);
c01016f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fa:	89 04 24             	mov    %eax,(%esp)
c01016fd:	e8 81 fa ff ff       	call   c0101183 <cga_putc>
        serial_putc(c);
c0101702:	8b 45 08             	mov    0x8(%ebp),%eax
c0101705:	89 04 24             	mov    %eax,(%esp)
c0101708:	e8 ca fc ff ff       	call   c01013d7 <serial_putc>
    }
    local_intr_restore(intr_flag);
c010170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101710:	89 04 24             	mov    %eax,(%esp)
c0101713:	e8 6d f7 ff ff       	call   c0100e85 <__intr_restore>
}
c0101718:	90                   	nop
c0101719:	c9                   	leave  
c010171a:	c3                   	ret    

c010171b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010171b:	f3 0f 1e fb          	endbr32 
c010171f:	55                   	push   %ebp
c0101720:	89 e5                	mov    %esp,%ebp
c0101722:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010172c:	e8 2a f7 ff ff       	call   c0100e5b <__intr_save>
c0101731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101734:	e8 8e fd ff ff       	call   c01014c7 <serial_intr>
        kbd_intr();
c0101739:	e8 34 ff ff ff       	call   c0101672 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010173e:	8b 15 60 36 12 c0    	mov    0xc0123660,%edx
c0101744:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101749:	39 c2                	cmp    %eax,%edx
c010174b:	74 31                	je     c010177e <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c010174d:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c0101752:	8d 50 01             	lea    0x1(%eax),%edx
c0101755:	89 15 60 36 12 c0    	mov    %edx,0xc0123660
c010175b:	0f b6 80 60 34 12 c0 	movzbl -0x3fedcba0(%eax),%eax
c0101762:	0f b6 c0             	movzbl %al,%eax
c0101765:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101768:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c010176d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101772:	75 0a                	jne    c010177e <cons_getc+0x63>
                cons.rpos = 0;
c0101774:	c7 05 60 36 12 c0 00 	movl   $0x0,0xc0123660
c010177b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101781:	89 04 24             	mov    %eax,(%esp)
c0101784:	e8 fc f6 ff ff       	call   c0100e85 <__intr_restore>
    return c;
c0101789:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010178c:	c9                   	leave  
c010178d:	c3                   	ret    

c010178e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010178e:	f3 0f 1e fb          	endbr32 
c0101792:	55                   	push   %ebp
c0101793:	89 e5                	mov    %esp,%ebp
c0101795:	83 ec 14             	sub    $0x14,%esp
c0101798:	8b 45 08             	mov    0x8(%ebp),%eax
c010179b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c010179f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017a2:	66 a3 50 05 12 c0    	mov    %ax,0xc0120550
    if (did_init) {
c01017a8:	a1 6c 36 12 c0       	mov    0xc012366c,%eax
c01017ad:	85 c0                	test   %eax,%eax
c01017af:	74 39                	je     c01017ea <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017b4:	0f b6 c0             	movzbl %al,%eax
c01017b7:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017bd:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017c4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017c8:	ee                   	out    %al,(%dx)
}
c01017c9:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017ce:	c1 e8 08             	shr    $0x8,%eax
c01017d1:	0f b7 c0             	movzwl %ax,%eax
c01017d4:	0f b6 c0             	movzbl %al,%eax
c01017d7:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017dd:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017e4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017e8:	ee                   	out    %al,(%dx)
}
c01017e9:	90                   	nop
    }
}
c01017ea:	90                   	nop
c01017eb:	c9                   	leave  
c01017ec:	c3                   	ret    

c01017ed <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017ed:	f3 0f 1e fb          	endbr32 
c01017f1:	55                   	push   %ebp
c01017f2:	89 e5                	mov    %esp,%ebp
c01017f4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01017fa:	ba 01 00 00 00       	mov    $0x1,%edx
c01017ff:	88 c1                	mov    %al,%cl
c0101801:	d3 e2                	shl    %cl,%edx
c0101803:	89 d0                	mov    %edx,%eax
c0101805:	98                   	cwtl   
c0101806:	f7 d0                	not    %eax
c0101808:	0f bf d0             	movswl %ax,%edx
c010180b:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101812:	98                   	cwtl   
c0101813:	21 d0                	and    %edx,%eax
c0101815:	98                   	cwtl   
c0101816:	0f b7 c0             	movzwl %ax,%eax
c0101819:	89 04 24             	mov    %eax,(%esp)
c010181c:	e8 6d ff ff ff       	call   c010178e <pic_setmask>
}
c0101821:	90                   	nop
c0101822:	c9                   	leave  
c0101823:	c3                   	ret    

c0101824 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101824:	f3 0f 1e fb          	endbr32 
c0101828:	55                   	push   %ebp
c0101829:	89 e5                	mov    %esp,%ebp
c010182b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010182e:	c7 05 6c 36 12 c0 01 	movl   $0x1,0xc012366c
c0101835:	00 00 00 
c0101838:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010183e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101842:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101846:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184a:	ee                   	out    %al,(%dx)
}
c010184b:	90                   	nop
c010184c:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101852:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101856:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010185a:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010185e:	ee                   	out    %al,(%dx)
}
c010185f:	90                   	nop
c0101860:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101866:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010186e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101872:	ee                   	out    %al,(%dx)
}
c0101873:	90                   	nop
c0101874:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010187a:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010187e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101882:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101886:	ee                   	out    %al,(%dx)
}
c0101887:	90                   	nop
c0101888:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010188e:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101892:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101896:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010189a:	ee                   	out    %al,(%dx)
}
c010189b:	90                   	nop
c010189c:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018a2:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018aa:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018ae:	ee                   	out    %al,(%dx)
}
c01018af:	90                   	nop
c01018b0:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018b6:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ba:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018be:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018c2:	ee                   	out    %al,(%dx)
}
c01018c3:	90                   	nop
c01018c4:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018ca:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ce:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018d2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018d6:	ee                   	out    %al,(%dx)
}
c01018d7:	90                   	nop
c01018d8:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018de:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018e2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018e6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018ea:	ee                   	out    %al,(%dx)
}
c01018eb:	90                   	nop
c01018ec:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018f2:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018fe:	ee                   	out    %al,(%dx)
}
c01018ff:	90                   	nop
c0101900:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101906:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010190a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010190e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101912:	ee                   	out    %al,(%dx)
}
c0101913:	90                   	nop
c0101914:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010191a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010191e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101922:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101926:	ee                   	out    %al,(%dx)
}
c0101927:	90                   	nop
c0101928:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010192e:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101932:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101936:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010193a:	ee                   	out    %al,(%dx)
}
c010193b:	90                   	nop
c010193c:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101942:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101946:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010194a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010194e:	ee                   	out    %al,(%dx)
}
c010194f:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101950:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101957:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010195c:	74 0f                	je     c010196d <pic_init+0x149>
        pic_setmask(irq_mask);
c010195e:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101965:	89 04 24             	mov    %eax,(%esp)
c0101968:	e8 21 fe ff ff       	call   c010178e <pic_setmask>
    }
}
c010196d:	90                   	nop
c010196e:	c9                   	leave  
c010196f:	c3                   	ret    

c0101970 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101970:	f3 0f 1e fb          	endbr32 
c0101974:	55                   	push   %ebp
c0101975:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101977:	fb                   	sti    
}
c0101978:	90                   	nop
    sti();
}
c0101979:	90                   	nop
c010197a:	5d                   	pop    %ebp
c010197b:	c3                   	ret    

c010197c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010197c:	f3 0f 1e fb          	endbr32 
c0101980:	55                   	push   %ebp
c0101981:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101983:	fa                   	cli    
}
c0101984:	90                   	nop
    cli();
}
c0101985:	90                   	nop
c0101986:	5d                   	pop    %ebp
c0101987:	c3                   	ret    

c0101988 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
c0101988:	f3 0f 1e fb          	endbr32 
c010198c:	55                   	push   %ebp
c010198d:	89 e5                	mov    %esp,%ebp
c010198f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101992:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101999:	00 
c010199a:	c7 04 24 60 88 10 c0 	movl   $0xc0108860,(%esp)
c01019a1:	e8 23 e9 ff ff       	call   c01002c9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01019a6:	c7 04 24 6a 88 10 c0 	movl   $0xc010886a,(%esp)
c01019ad:	e8 17 e9 ff ff       	call   c01002c9 <cprintf>
    panic("EOT: kernel seems ok.");
c01019b2:	c7 44 24 08 78 88 10 	movl   $0xc0108878,0x8(%esp)
c01019b9:	c0 
c01019ba:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01019c1:	00 
c01019c2:	c7 04 24 8e 88 10 c0 	movl   $0xc010888e,(%esp)
c01019c9:	e8 67 ea ff ff       	call   c0100435 <__panic>

c01019ce <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019ce:	f3 0f 1e fb          	endbr32 
c01019d2:	55                   	push   %ebp
c01019d3:	89 e5                	mov    %esp,%ebp
c01019d5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019df:	e9 c4 00 00 00       	jmp    c0101aa8 <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e7:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c01019ee:	0f b7 d0             	movzwl %ax,%edx
c01019f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f4:	66 89 14 c5 80 36 12 	mov    %dx,-0x3fedc980(,%eax,8)
c01019fb:	c0 
c01019fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ff:	66 c7 04 c5 82 36 12 	movw   $0x8,-0x3fedc97e(,%eax,8)
c0101a06:	c0 08 00 
c0101a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0c:	0f b6 14 c5 84 36 12 	movzbl -0x3fedc97c(,%eax,8),%edx
c0101a13:	c0 
c0101a14:	80 e2 e0             	and    $0xe0,%dl
c0101a17:	88 14 c5 84 36 12 c0 	mov    %dl,-0x3fedc97c(,%eax,8)
c0101a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a21:	0f b6 14 c5 84 36 12 	movzbl -0x3fedc97c(,%eax,8),%edx
c0101a28:	c0 
c0101a29:	80 e2 1f             	and    $0x1f,%dl
c0101a2c:	88 14 c5 84 36 12 c0 	mov    %dl,-0x3fedc97c(,%eax,8)
c0101a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a36:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a3d:	c0 
c0101a3e:	80 e2 f0             	and    $0xf0,%dl
c0101a41:	80 ca 0e             	or     $0xe,%dl
c0101a44:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a4e:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a55:	c0 
c0101a56:	80 e2 ef             	and    $0xef,%dl
c0101a59:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a63:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a6a:	c0 
c0101a6b:	80 e2 9f             	and    $0x9f,%dl
c0101a6e:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a78:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a7f:	c0 
c0101a80:	80 ca 80             	or     $0x80,%dl
c0101a83:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a8d:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c0101a94:	c1 e8 10             	shr    $0x10,%eax
c0101a97:	0f b7 d0             	movzwl %ax,%edx
c0101a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a9d:	66 89 14 c5 86 36 12 	mov    %dx,-0x3fedc97a(,%eax,8)
c0101aa4:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101aa5:	ff 45 fc             	incl   -0x4(%ebp)
c0101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aab:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101ab0:	0f 86 2e ff ff ff    	jbe    c01019e4 <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101ab6:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0101abb:	0f b7 c0             	movzwl %ax,%eax
c0101abe:	66 a3 48 3a 12 c0    	mov    %ax,0xc0123a48
c0101ac4:	66 c7 05 4a 3a 12 c0 	movw   $0x8,0xc0123a4a
c0101acb:	08 00 
c0101acd:	0f b6 05 4c 3a 12 c0 	movzbl 0xc0123a4c,%eax
c0101ad4:	24 e0                	and    $0xe0,%al
c0101ad6:	a2 4c 3a 12 c0       	mov    %al,0xc0123a4c
c0101adb:	0f b6 05 4c 3a 12 c0 	movzbl 0xc0123a4c,%eax
c0101ae2:	24 1f                	and    $0x1f,%al
c0101ae4:	a2 4c 3a 12 c0       	mov    %al,0xc0123a4c
c0101ae9:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101af0:	24 f0                	and    $0xf0,%al
c0101af2:	0c 0e                	or     $0xe,%al
c0101af4:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101af9:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b00:	24 ef                	and    $0xef,%al
c0101b02:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b07:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b0e:	0c 60                	or     $0x60,%al
c0101b10:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b15:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b1c:	0c 80                	or     $0x80,%al
c0101b1e:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b23:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0101b28:	c1 e8 10             	shr    $0x10,%eax
c0101b2b:	0f b7 c0             	movzwl %ax,%eax
c0101b2e:	66 a3 4e 3a 12 c0    	mov    %ax,0xc0123a4e
c0101b34:	c7 45 f8 60 05 12 c0 	movl   $0xc0120560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b3e:	0f 01 18             	lidtl  (%eax)
}
c0101b41:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
c0101b42:	90                   	nop
c0101b43:	c9                   	leave  
c0101b44:	c3                   	ret    

c0101b45 <trapname>:

static const char *
trapname(int trapno) {
c0101b45:	f3 0f 1e fb          	endbr32 
c0101b49:	55                   	push   %ebp
c0101b4a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4f:	83 f8 13             	cmp    $0x13,%eax
c0101b52:	77 0c                	ja     c0101b60 <trapname+0x1b>
        return excnames[trapno];
c0101b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b57:	8b 04 85 e0 8b 10 c0 	mov    -0x3fef7420(,%eax,4),%eax
c0101b5e:	eb 18                	jmp    c0101b78 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b60:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b64:	7e 0d                	jle    c0101b73 <trapname+0x2e>
c0101b66:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b6a:	7f 07                	jg     c0101b73 <trapname+0x2e>
        return "Hardware Interrupt";
c0101b6c:	b8 9f 88 10 c0       	mov    $0xc010889f,%eax
c0101b71:	eb 05                	jmp    c0101b78 <trapname+0x33>
    }
    return "(unknown trap)";
c0101b73:	b8 b2 88 10 c0       	mov    $0xc01088b2,%eax
}
c0101b78:	5d                   	pop    %ebp
c0101b79:	c3                   	ret    

c0101b7a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b7a:	f3 0f 1e fb          	endbr32 
c0101b7e:	55                   	push   %ebp
c0101b7f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b88:	83 f8 08             	cmp    $0x8,%eax
c0101b8b:	0f 94 c0             	sete   %al
c0101b8e:	0f b6 c0             	movzbl %al,%eax
}
c0101b91:	5d                   	pop    %ebp
c0101b92:	c3                   	ret    

c0101b93 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b93:	f3 0f 1e fb          	endbr32 
c0101b97:	55                   	push   %ebp
c0101b98:	89 e5                	mov    %esp,%ebp
c0101b9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba4:	c7 04 24 f3 88 10 c0 	movl   $0xc01088f3,(%esp)
c0101bab:	e8 19 e7 ff ff       	call   c01002c9 <cprintf>
    print_regs(&tf->tf_regs);
c0101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb3:	89 04 24             	mov    %eax,(%esp)
c0101bb6:	e8 8d 01 00 00       	call   c0101d48 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc6:	c7 04 24 04 89 10 c0 	movl   $0xc0108904,(%esp)
c0101bcd:	e8 f7 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdd:	c7 04 24 17 89 10 c0 	movl   $0xc0108917,(%esp)
c0101be4:	e8 e0 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf4:	c7 04 24 2a 89 10 c0 	movl   $0xc010892a,(%esp)
c0101bfb:	e8 c9 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0b:	c7 04 24 3d 89 10 c0 	movl   $0xc010893d,(%esp)
c0101c12:	e8 b2 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c1d:	89 04 24             	mov    %eax,(%esp)
c0101c20:	e8 20 ff ff ff       	call   c0101b45 <trapname>
c0101c25:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c28:	8b 52 30             	mov    0x30(%edx),%edx
c0101c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c33:	c7 04 24 50 89 10 c0 	movl   $0xc0108950,(%esp)
c0101c3a:	e8 8a e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c42:	8b 40 34             	mov    0x34(%eax),%eax
c0101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c49:	c7 04 24 62 89 10 c0 	movl   $0xc0108962,(%esp)
c0101c50:	e8 74 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c58:	8b 40 38             	mov    0x38(%eax),%eax
c0101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5f:	c7 04 24 71 89 10 c0 	movl   $0xc0108971,(%esp)
c0101c66:	e8 5e e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c76:	c7 04 24 80 89 10 c0 	movl   $0xc0108980,(%esp)
c0101c7d:	e8 47 e6 ff ff       	call   c01002c9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c85:	8b 40 40             	mov    0x40(%eax),%eax
c0101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8c:	c7 04 24 93 89 10 c0 	movl   $0xc0108993,(%esp)
c0101c93:	e8 31 e6 ff ff       	call   c01002c9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ca6:	eb 3d                	jmp    c0101ce5 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cab:	8b 50 40             	mov    0x40(%eax),%edx
c0101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb1:	21 d0                	and    %edx,%eax
c0101cb3:	85 c0                	test   %eax,%eax
c0101cb5:	74 28                	je     c0101cdf <print_trapframe+0x14c>
c0101cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cba:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c0101cc1:	85 c0                	test   %eax,%eax
c0101cc3:	74 1a                	je     c0101cdf <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cc8:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c0101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd3:	c7 04 24 a2 89 10 c0 	movl   $0xc01089a2,(%esp)
c0101cda:	e8 ea e5 ff ff       	call   c01002c9 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cdf:	ff 45 f4             	incl   -0xc(%ebp)
c0101ce2:	d1 65 f0             	shll   -0x10(%ebp)
c0101ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ce8:	83 f8 17             	cmp    $0x17,%eax
c0101ceb:	76 bb                	jbe    c0101ca8 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf0:	8b 40 40             	mov    0x40(%eax),%eax
c0101cf3:	c1 e8 0c             	shr    $0xc,%eax
c0101cf6:	83 e0 03             	and    $0x3,%eax
c0101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfd:	c7 04 24 a6 89 10 c0 	movl   $0xc01089a6,(%esp)
c0101d04:	e8 c0 e5 ff ff       	call   c01002c9 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0c:	89 04 24             	mov    %eax,(%esp)
c0101d0f:	e8 66 fe ff ff       	call   c0101b7a <trap_in_kernel>
c0101d14:	85 c0                	test   %eax,%eax
c0101d16:	75 2d                	jne    c0101d45 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1b:	8b 40 44             	mov    0x44(%eax),%eax
c0101d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d22:	c7 04 24 af 89 10 c0 	movl   $0xc01089af,(%esp)
c0101d29:	e8 9b e5 ff ff       	call   c01002c9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d31:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d39:	c7 04 24 be 89 10 c0 	movl   $0xc01089be,(%esp)
c0101d40:	e8 84 e5 ff ff       	call   c01002c9 <cprintf>
    }
}
c0101d45:	90                   	nop
c0101d46:	c9                   	leave  
c0101d47:	c3                   	ret    

c0101d48 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d48:	f3 0f 1e fb          	endbr32 
c0101d4c:	55                   	push   %ebp
c0101d4d:	89 e5                	mov    %esp,%ebp
c0101d4f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d55:	8b 00                	mov    (%eax),%eax
c0101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5b:	c7 04 24 d1 89 10 c0 	movl   $0xc01089d1,(%esp)
c0101d62:	e8 62 e5 ff ff       	call   c01002c9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6a:	8b 40 04             	mov    0x4(%eax),%eax
c0101d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d71:	c7 04 24 e0 89 10 c0 	movl   $0xc01089e0,(%esp)
c0101d78:	e8 4c e5 ff ff       	call   c01002c9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d80:	8b 40 08             	mov    0x8(%eax),%eax
c0101d83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d87:	c7 04 24 ef 89 10 c0 	movl   $0xc01089ef,(%esp)
c0101d8e:	e8 36 e5 ff ff       	call   c01002c9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d96:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d9d:	c7 04 24 fe 89 10 c0 	movl   $0xc01089fe,(%esp)
c0101da4:	e8 20 e5 ff ff       	call   c01002c9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101da9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dac:	8b 40 10             	mov    0x10(%eax),%eax
c0101daf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db3:	c7 04 24 0d 8a 10 c0 	movl   $0xc0108a0d,(%esp)
c0101dba:	e8 0a e5 ff ff       	call   c01002c9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc2:	8b 40 14             	mov    0x14(%eax),%eax
c0101dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc9:	c7 04 24 1c 8a 10 c0 	movl   $0xc0108a1c,(%esp)
c0101dd0:	e8 f4 e4 ff ff       	call   c01002c9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd8:	8b 40 18             	mov    0x18(%eax),%eax
c0101ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ddf:	c7 04 24 2b 8a 10 c0 	movl   $0xc0108a2b,(%esp)
c0101de6:	e8 de e4 ff ff       	call   c01002c9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dee:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101df1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df5:	c7 04 24 3a 8a 10 c0 	movl   $0xc0108a3a,(%esp)
c0101dfc:	e8 c8 e4 ff ff       	call   c01002c9 <cprintf>
}
c0101e01:	90                   	nop
c0101e02:	c9                   	leave  
c0101e03:	c3                   	ret    

c0101e04 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e04:	f3 0f 1e fb          	endbr32 
c0101e08:	55                   	push   %ebp
c0101e09:	89 e5                	mov    %esp,%ebp
c0101e0b:	57                   	push   %edi
c0101e0c:	56                   	push   %esi
c0101e0d:	53                   	push   %ebx
c0101e0e:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e14:	8b 40 30             	mov    0x30(%eax),%eax
c0101e17:	83 f8 79             	cmp    $0x79,%eax
c0101e1a:	0f 84 c6 01 00 00    	je     c0101fe6 <trap_dispatch+0x1e2>
c0101e20:	83 f8 79             	cmp    $0x79,%eax
c0101e23:	0f 87 3a 02 00 00    	ja     c0102063 <trap_dispatch+0x25f>
c0101e29:	83 f8 78             	cmp    $0x78,%eax
c0101e2c:	0f 84 d0 00 00 00    	je     c0101f02 <trap_dispatch+0xfe>
c0101e32:	83 f8 78             	cmp    $0x78,%eax
c0101e35:	0f 87 28 02 00 00    	ja     c0102063 <trap_dispatch+0x25f>
c0101e3b:	83 f8 2f             	cmp    $0x2f,%eax
c0101e3e:	0f 87 1f 02 00 00    	ja     c0102063 <trap_dispatch+0x25f>
c0101e44:	83 f8 2e             	cmp    $0x2e,%eax
c0101e47:	0f 83 4b 02 00 00    	jae    c0102098 <trap_dispatch+0x294>
c0101e4d:	83 f8 24             	cmp    $0x24,%eax
c0101e50:	74 5e                	je     c0101eb0 <trap_dispatch+0xac>
c0101e52:	83 f8 24             	cmp    $0x24,%eax
c0101e55:	0f 87 08 02 00 00    	ja     c0102063 <trap_dispatch+0x25f>
c0101e5b:	83 f8 20             	cmp    $0x20,%eax
c0101e5e:	74 0a                	je     c0101e6a <trap_dispatch+0x66>
c0101e60:	83 f8 21             	cmp    $0x21,%eax
c0101e63:	74 74                	je     c0101ed9 <trap_dispatch+0xd5>
c0101e65:	e9 f9 01 00 00       	jmp    c0102063 <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
c0101e6a:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0101e6f:	40                   	inc    %eax
c0101e70:	a3 a0 3f 12 c0       	mov    %eax,0xc0123fa0
        if (ticks % TICK_NUM == 0) {
c0101e75:	8b 0d a0 3f 12 c0    	mov    0xc0123fa0,%ecx
c0101e7b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e80:	89 c8                	mov    %ecx,%eax
c0101e82:	f7 e2                	mul    %edx
c0101e84:	c1 ea 05             	shr    $0x5,%edx
c0101e87:	89 d0                	mov    %edx,%eax
c0101e89:	c1 e0 02             	shl    $0x2,%eax
c0101e8c:	01 d0                	add    %edx,%eax
c0101e8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e95:	01 d0                	add    %edx,%eax
c0101e97:	c1 e0 02             	shl    $0x2,%eax
c0101e9a:	29 c1                	sub    %eax,%ecx
c0101e9c:	89 ca                	mov    %ecx,%edx
c0101e9e:	85 d2                	test   %edx,%edx
c0101ea0:	0f 85 f5 01 00 00    	jne    c010209b <trap_dispatch+0x297>
            print_ticks();
c0101ea6:	e8 dd fa ff ff       	call   c0101988 <print_ticks>
        }
        break;
c0101eab:	e9 eb 01 00 00       	jmp    c010209b <trap_dispatch+0x297>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101eb0:	e8 66 f8 ff ff       	call   c010171b <cons_getc>
c0101eb5:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101eb8:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ebc:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101ec0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ec8:	c7 04 24 49 8a 10 c0 	movl   $0xc0108a49,(%esp)
c0101ecf:	e8 f5 e3 ff ff       	call   c01002c9 <cprintf>
        break;
c0101ed4:	e9 c9 01 00 00       	jmp    c01020a2 <trap_dispatch+0x29e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ed9:	e8 3d f8 ff ff       	call   c010171b <cons_getc>
c0101ede:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ee1:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ee5:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101ee9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101eed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ef1:	c7 04 24 5b 8a 10 c0 	movl   $0xc0108a5b,(%esp)
c0101ef8:	e8 cc e3 ff ff       	call   c01002c9 <cprintf>
        break;
c0101efd:	e9 a0 01 00 00       	jmp    c01020a2 <trap_dispatch+0x29e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f05:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f09:	83 f8 1b             	cmp    $0x1b,%eax
c0101f0c:	0f 84 8c 01 00 00    	je     c010209e <trap_dispatch+0x29a>
            switchk2u = *tf;
c0101f12:	8b 55 08             	mov    0x8(%ebp),%edx
c0101f15:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c0101f1a:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101f1f:	89 c1                	mov    %eax,%ecx
c0101f21:	83 e1 01             	and    $0x1,%ecx
c0101f24:	85 c9                	test   %ecx,%ecx
c0101f26:	74 0c                	je     c0101f34 <trap_dispatch+0x130>
c0101f28:	0f b6 0a             	movzbl (%edx),%ecx
c0101f2b:	88 08                	mov    %cl,(%eax)
c0101f2d:	8d 40 01             	lea    0x1(%eax),%eax
c0101f30:	8d 52 01             	lea    0x1(%edx),%edx
c0101f33:	4b                   	dec    %ebx
c0101f34:	89 c1                	mov    %eax,%ecx
c0101f36:	83 e1 02             	and    $0x2,%ecx
c0101f39:	85 c9                	test   %ecx,%ecx
c0101f3b:	74 0f                	je     c0101f4c <trap_dispatch+0x148>
c0101f3d:	0f b7 0a             	movzwl (%edx),%ecx
c0101f40:	66 89 08             	mov    %cx,(%eax)
c0101f43:	8d 40 02             	lea    0x2(%eax),%eax
c0101f46:	8d 52 02             	lea    0x2(%edx),%edx
c0101f49:	83 eb 02             	sub    $0x2,%ebx
c0101f4c:	89 df                	mov    %ebx,%edi
c0101f4e:	83 e7 fc             	and    $0xfffffffc,%edi
c0101f51:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101f56:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101f59:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101f5c:	83 c1 04             	add    $0x4,%ecx
c0101f5f:	39 f9                	cmp    %edi,%ecx
c0101f61:	72 f3                	jb     c0101f56 <trap_dispatch+0x152>
c0101f63:	01 c8                	add    %ecx,%eax
c0101f65:	01 ca                	add    %ecx,%edx
c0101f67:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101f6c:	89 de                	mov    %ebx,%esi
c0101f6e:	83 e6 02             	and    $0x2,%esi
c0101f71:	85 f6                	test   %esi,%esi
c0101f73:	74 0b                	je     c0101f80 <trap_dispatch+0x17c>
c0101f75:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101f79:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101f7d:	83 c1 02             	add    $0x2,%ecx
c0101f80:	83 e3 01             	and    $0x1,%ebx
c0101f83:	85 db                	test   %ebx,%ebx
c0101f85:	74 07                	je     c0101f8e <trap_dispatch+0x18a>
c0101f87:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101f8b:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101f8e:	66 c7 05 fc 3f 12 c0 	movw   $0x1b,0xc0123ffc
c0101f95:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101f97:	66 c7 05 08 40 12 c0 	movw   $0x23,0xc0124008
c0101f9e:	23 00 
c0101fa0:	0f b7 05 08 40 12 c0 	movzwl 0xc0124008,%eax
c0101fa7:	66 a3 e8 3f 12 c0    	mov    %ax,0xc0123fe8
c0101fad:	0f b7 05 e8 3f 12 c0 	movzwl 0xc0123fe8,%eax
c0101fb4:	66 a3 ec 3f 12 c0    	mov    %ax,0xc0123fec
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101fba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbd:	83 c0 44             	add    $0x44,%eax
c0101fc0:	a3 04 40 12 c0       	mov    %eax,0xc0124004
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101fc5:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0101fca:	0d 00 30 00 00       	or     $0x3000,%eax
c0101fcf:	a3 00 40 12 c0       	mov    %eax,0xc0124000
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd7:	83 e8 04             	sub    $0x4,%eax
c0101fda:	ba c0 3f 12 c0       	mov    $0xc0123fc0,%edx
c0101fdf:	89 10                	mov    %edx,(%eax)
        }
        break;
c0101fe1:	e9 b8 00 00 00       	jmp    c010209e <trap_dispatch+0x29a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fe9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fed:	83 f8 08             	cmp    $0x8,%eax
c0101ff0:	0f 84 ab 00 00 00    	je     c01020a1 <trap_dispatch+0x29d>
            tf->tf_cs = KERNEL_CS;
c0101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff9:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101fff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102002:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0102008:	8b 45 08             	mov    0x8(%ebp),%eax
c010200b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010200f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102012:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0102016:	8b 45 08             	mov    0x8(%ebp),%eax
c0102019:	8b 40 40             	mov    0x40(%eax),%eax
c010201c:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0102021:	89 c2                	mov    %eax,%edx
c0102023:	8b 45 08             	mov    0x8(%ebp),%eax
c0102026:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0102029:	8b 45 08             	mov    0x8(%ebp),%eax
c010202c:	8b 40 44             	mov    0x44(%eax),%eax
c010202f:	83 e8 44             	sub    $0x44,%eax
c0102032:	a3 0c 40 12 c0       	mov    %eax,0xc012400c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0102037:	a1 0c 40 12 c0       	mov    0xc012400c,%eax
c010203c:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0102043:	00 
c0102044:	8b 55 08             	mov    0x8(%ebp),%edx
c0102047:	89 54 24 04          	mov    %edx,0x4(%esp)
c010204b:	89 04 24             	mov    %eax,(%esp)
c010204e:	e8 98 5c 00 00       	call   c0107ceb <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0102053:	8b 15 0c 40 12 c0    	mov    0xc012400c,%edx
c0102059:	8b 45 08             	mov    0x8(%ebp),%eax
c010205c:	83 e8 04             	sub    $0x4,%eax
c010205f:	89 10                	mov    %edx,(%eax)
        }
        break;
c0102061:	eb 3e                	jmp    c01020a1 <trap_dispatch+0x29d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102063:	8b 45 08             	mov    0x8(%ebp),%eax
c0102066:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010206a:	83 e0 03             	and    $0x3,%eax
c010206d:	85 c0                	test   %eax,%eax
c010206f:	75 31                	jne    c01020a2 <trap_dispatch+0x29e>
            print_trapframe(tf);
c0102071:	8b 45 08             	mov    0x8(%ebp),%eax
c0102074:	89 04 24             	mov    %eax,(%esp)
c0102077:	e8 17 fb ff ff       	call   c0101b93 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010207c:	c7 44 24 08 6a 8a 10 	movl   $0xc0108a6a,0x8(%esp)
c0102083:	c0 
c0102084:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010208b:	00 
c010208c:	c7 04 24 8e 88 10 c0 	movl   $0xc010888e,(%esp)
c0102093:	e8 9d e3 ff ff       	call   c0100435 <__panic>
        break;
c0102098:	90                   	nop
c0102099:	eb 07                	jmp    c01020a2 <trap_dispatch+0x29e>
        break;
c010209b:	90                   	nop
c010209c:	eb 04                	jmp    c01020a2 <trap_dispatch+0x29e>
        break;
c010209e:	90                   	nop
c010209f:	eb 01                	jmp    c01020a2 <trap_dispatch+0x29e>
        break;
c01020a1:	90                   	nop
        }
    }
}
c01020a2:	90                   	nop
c01020a3:	83 c4 2c             	add    $0x2c,%esp
c01020a6:	5b                   	pop    %ebx
c01020a7:	5e                   	pop    %esi
c01020a8:	5f                   	pop    %edi
c01020a9:	5d                   	pop    %ebp
c01020aa:	c3                   	ret    

c01020ab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01020ab:	f3 0f 1e fb          	endbr32 
c01020af:	55                   	push   %ebp
c01020b0:	89 e5                	mov    %esp,%ebp
c01020b2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01020b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b8:	89 04 24             	mov    %eax,(%esp)
c01020bb:	e8 44 fd ff ff       	call   c0101e04 <trap_dispatch>
}
c01020c0:	90                   	nop
c01020c1:	c9                   	leave  
c01020c2:	c3                   	ret    

c01020c3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $0
c01020c5:	6a 00                	push   $0x0
  jmp __alltraps
c01020c7:	e9 69 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020cc <vector1>:
.globl vector1
vector1:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $1
c01020ce:	6a 01                	push   $0x1
  jmp __alltraps
c01020d0:	e9 60 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020d5 <vector2>:
.globl vector2
vector2:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $2
c01020d7:	6a 02                	push   $0x2
  jmp __alltraps
c01020d9:	e9 57 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020de <vector3>:
.globl vector3
vector3:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $3
c01020e0:	6a 03                	push   $0x3
  jmp __alltraps
c01020e2:	e9 4e 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020e7 <vector4>:
.globl vector4
vector4:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $4
c01020e9:	6a 04                	push   $0x4
  jmp __alltraps
c01020eb:	e9 45 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020f0 <vector5>:
.globl vector5
vector5:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $5
c01020f2:	6a 05                	push   $0x5
  jmp __alltraps
c01020f4:	e9 3c 0a 00 00       	jmp    c0102b35 <__alltraps>

c01020f9 <vector6>:
.globl vector6
vector6:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $6
c01020fb:	6a 06                	push   $0x6
  jmp __alltraps
c01020fd:	e9 33 0a 00 00       	jmp    c0102b35 <__alltraps>

c0102102 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $7
c0102104:	6a 07                	push   $0x7
  jmp __alltraps
c0102106:	e9 2a 0a 00 00       	jmp    c0102b35 <__alltraps>

c010210b <vector8>:
.globl vector8
vector8:
  pushl $8
c010210b:	6a 08                	push   $0x8
  jmp __alltraps
c010210d:	e9 23 0a 00 00       	jmp    c0102b35 <__alltraps>

c0102112 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $9
c0102114:	6a 09                	push   $0x9
  jmp __alltraps
c0102116:	e9 1a 0a 00 00       	jmp    c0102b35 <__alltraps>

c010211b <vector10>:
.globl vector10
vector10:
  pushl $10
c010211b:	6a 0a                	push   $0xa
  jmp __alltraps
c010211d:	e9 13 0a 00 00       	jmp    c0102b35 <__alltraps>

c0102122 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102122:	6a 0b                	push   $0xb
  jmp __alltraps
c0102124:	e9 0c 0a 00 00       	jmp    c0102b35 <__alltraps>

c0102129 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102129:	6a 0c                	push   $0xc
  jmp __alltraps
c010212b:	e9 05 0a 00 00       	jmp    c0102b35 <__alltraps>

c0102130 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102130:	6a 0d                	push   $0xd
  jmp __alltraps
c0102132:	e9 fe 09 00 00       	jmp    c0102b35 <__alltraps>

c0102137 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102137:	6a 0e                	push   $0xe
  jmp __alltraps
c0102139:	e9 f7 09 00 00       	jmp    c0102b35 <__alltraps>

c010213e <vector15>:
.globl vector15
vector15:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $15
c0102140:	6a 0f                	push   $0xf
  jmp __alltraps
c0102142:	e9 ee 09 00 00       	jmp    c0102b35 <__alltraps>

c0102147 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $16
c0102149:	6a 10                	push   $0x10
  jmp __alltraps
c010214b:	e9 e5 09 00 00       	jmp    c0102b35 <__alltraps>

c0102150 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102150:	6a 11                	push   $0x11
  jmp __alltraps
c0102152:	e9 de 09 00 00       	jmp    c0102b35 <__alltraps>

c0102157 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102157:	6a 00                	push   $0x0
  pushl $18
c0102159:	6a 12                	push   $0x12
  jmp __alltraps
c010215b:	e9 d5 09 00 00       	jmp    c0102b35 <__alltraps>

c0102160 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102160:	6a 00                	push   $0x0
  pushl $19
c0102162:	6a 13                	push   $0x13
  jmp __alltraps
c0102164:	e9 cc 09 00 00       	jmp    c0102b35 <__alltraps>

c0102169 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102169:	6a 00                	push   $0x0
  pushl $20
c010216b:	6a 14                	push   $0x14
  jmp __alltraps
c010216d:	e9 c3 09 00 00       	jmp    c0102b35 <__alltraps>

c0102172 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102172:	6a 00                	push   $0x0
  pushl $21
c0102174:	6a 15                	push   $0x15
  jmp __alltraps
c0102176:	e9 ba 09 00 00       	jmp    c0102b35 <__alltraps>

c010217b <vector22>:
.globl vector22
vector22:
  pushl $0
c010217b:	6a 00                	push   $0x0
  pushl $22
c010217d:	6a 16                	push   $0x16
  jmp __alltraps
c010217f:	e9 b1 09 00 00       	jmp    c0102b35 <__alltraps>

c0102184 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102184:	6a 00                	push   $0x0
  pushl $23
c0102186:	6a 17                	push   $0x17
  jmp __alltraps
c0102188:	e9 a8 09 00 00       	jmp    c0102b35 <__alltraps>

c010218d <vector24>:
.globl vector24
vector24:
  pushl $0
c010218d:	6a 00                	push   $0x0
  pushl $24
c010218f:	6a 18                	push   $0x18
  jmp __alltraps
c0102191:	e9 9f 09 00 00       	jmp    c0102b35 <__alltraps>

c0102196 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102196:	6a 00                	push   $0x0
  pushl $25
c0102198:	6a 19                	push   $0x19
  jmp __alltraps
c010219a:	e9 96 09 00 00       	jmp    c0102b35 <__alltraps>

c010219f <vector26>:
.globl vector26
vector26:
  pushl $0
c010219f:	6a 00                	push   $0x0
  pushl $26
c01021a1:	6a 1a                	push   $0x1a
  jmp __alltraps
c01021a3:	e9 8d 09 00 00       	jmp    c0102b35 <__alltraps>

c01021a8 <vector27>:
.globl vector27
vector27:
  pushl $0
c01021a8:	6a 00                	push   $0x0
  pushl $27
c01021aa:	6a 1b                	push   $0x1b
  jmp __alltraps
c01021ac:	e9 84 09 00 00       	jmp    c0102b35 <__alltraps>

c01021b1 <vector28>:
.globl vector28
vector28:
  pushl $0
c01021b1:	6a 00                	push   $0x0
  pushl $28
c01021b3:	6a 1c                	push   $0x1c
  jmp __alltraps
c01021b5:	e9 7b 09 00 00       	jmp    c0102b35 <__alltraps>

c01021ba <vector29>:
.globl vector29
vector29:
  pushl $0
c01021ba:	6a 00                	push   $0x0
  pushl $29
c01021bc:	6a 1d                	push   $0x1d
  jmp __alltraps
c01021be:	e9 72 09 00 00       	jmp    c0102b35 <__alltraps>

c01021c3 <vector30>:
.globl vector30
vector30:
  pushl $0
c01021c3:	6a 00                	push   $0x0
  pushl $30
c01021c5:	6a 1e                	push   $0x1e
  jmp __alltraps
c01021c7:	e9 69 09 00 00       	jmp    c0102b35 <__alltraps>

c01021cc <vector31>:
.globl vector31
vector31:
  pushl $0
c01021cc:	6a 00                	push   $0x0
  pushl $31
c01021ce:	6a 1f                	push   $0x1f
  jmp __alltraps
c01021d0:	e9 60 09 00 00       	jmp    c0102b35 <__alltraps>

c01021d5 <vector32>:
.globl vector32
vector32:
  pushl $0
c01021d5:	6a 00                	push   $0x0
  pushl $32
c01021d7:	6a 20                	push   $0x20
  jmp __alltraps
c01021d9:	e9 57 09 00 00       	jmp    c0102b35 <__alltraps>

c01021de <vector33>:
.globl vector33
vector33:
  pushl $0
c01021de:	6a 00                	push   $0x0
  pushl $33
c01021e0:	6a 21                	push   $0x21
  jmp __alltraps
c01021e2:	e9 4e 09 00 00       	jmp    c0102b35 <__alltraps>

c01021e7 <vector34>:
.globl vector34
vector34:
  pushl $0
c01021e7:	6a 00                	push   $0x0
  pushl $34
c01021e9:	6a 22                	push   $0x22
  jmp __alltraps
c01021eb:	e9 45 09 00 00       	jmp    c0102b35 <__alltraps>

c01021f0 <vector35>:
.globl vector35
vector35:
  pushl $0
c01021f0:	6a 00                	push   $0x0
  pushl $35
c01021f2:	6a 23                	push   $0x23
  jmp __alltraps
c01021f4:	e9 3c 09 00 00       	jmp    c0102b35 <__alltraps>

c01021f9 <vector36>:
.globl vector36
vector36:
  pushl $0
c01021f9:	6a 00                	push   $0x0
  pushl $36
c01021fb:	6a 24                	push   $0x24
  jmp __alltraps
c01021fd:	e9 33 09 00 00       	jmp    c0102b35 <__alltraps>

c0102202 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102202:	6a 00                	push   $0x0
  pushl $37
c0102204:	6a 25                	push   $0x25
  jmp __alltraps
c0102206:	e9 2a 09 00 00       	jmp    c0102b35 <__alltraps>

c010220b <vector38>:
.globl vector38
vector38:
  pushl $0
c010220b:	6a 00                	push   $0x0
  pushl $38
c010220d:	6a 26                	push   $0x26
  jmp __alltraps
c010220f:	e9 21 09 00 00       	jmp    c0102b35 <__alltraps>

c0102214 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102214:	6a 00                	push   $0x0
  pushl $39
c0102216:	6a 27                	push   $0x27
  jmp __alltraps
c0102218:	e9 18 09 00 00       	jmp    c0102b35 <__alltraps>

c010221d <vector40>:
.globl vector40
vector40:
  pushl $0
c010221d:	6a 00                	push   $0x0
  pushl $40
c010221f:	6a 28                	push   $0x28
  jmp __alltraps
c0102221:	e9 0f 09 00 00       	jmp    c0102b35 <__alltraps>

c0102226 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102226:	6a 00                	push   $0x0
  pushl $41
c0102228:	6a 29                	push   $0x29
  jmp __alltraps
c010222a:	e9 06 09 00 00       	jmp    c0102b35 <__alltraps>

c010222f <vector42>:
.globl vector42
vector42:
  pushl $0
c010222f:	6a 00                	push   $0x0
  pushl $42
c0102231:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102233:	e9 fd 08 00 00       	jmp    c0102b35 <__alltraps>

c0102238 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102238:	6a 00                	push   $0x0
  pushl $43
c010223a:	6a 2b                	push   $0x2b
  jmp __alltraps
c010223c:	e9 f4 08 00 00       	jmp    c0102b35 <__alltraps>

c0102241 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102241:	6a 00                	push   $0x0
  pushl $44
c0102243:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102245:	e9 eb 08 00 00       	jmp    c0102b35 <__alltraps>

c010224a <vector45>:
.globl vector45
vector45:
  pushl $0
c010224a:	6a 00                	push   $0x0
  pushl $45
c010224c:	6a 2d                	push   $0x2d
  jmp __alltraps
c010224e:	e9 e2 08 00 00       	jmp    c0102b35 <__alltraps>

c0102253 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102253:	6a 00                	push   $0x0
  pushl $46
c0102255:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102257:	e9 d9 08 00 00       	jmp    c0102b35 <__alltraps>

c010225c <vector47>:
.globl vector47
vector47:
  pushl $0
c010225c:	6a 00                	push   $0x0
  pushl $47
c010225e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102260:	e9 d0 08 00 00       	jmp    c0102b35 <__alltraps>

c0102265 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102265:	6a 00                	push   $0x0
  pushl $48
c0102267:	6a 30                	push   $0x30
  jmp __alltraps
c0102269:	e9 c7 08 00 00       	jmp    c0102b35 <__alltraps>

c010226e <vector49>:
.globl vector49
vector49:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $49
c0102270:	6a 31                	push   $0x31
  jmp __alltraps
c0102272:	e9 be 08 00 00       	jmp    c0102b35 <__alltraps>

c0102277 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102277:	6a 00                	push   $0x0
  pushl $50
c0102279:	6a 32                	push   $0x32
  jmp __alltraps
c010227b:	e9 b5 08 00 00       	jmp    c0102b35 <__alltraps>

c0102280 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102280:	6a 00                	push   $0x0
  pushl $51
c0102282:	6a 33                	push   $0x33
  jmp __alltraps
c0102284:	e9 ac 08 00 00       	jmp    c0102b35 <__alltraps>

c0102289 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102289:	6a 00                	push   $0x0
  pushl $52
c010228b:	6a 34                	push   $0x34
  jmp __alltraps
c010228d:	e9 a3 08 00 00       	jmp    c0102b35 <__alltraps>

c0102292 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $53
c0102294:	6a 35                	push   $0x35
  jmp __alltraps
c0102296:	e9 9a 08 00 00       	jmp    c0102b35 <__alltraps>

c010229b <vector54>:
.globl vector54
vector54:
  pushl $0
c010229b:	6a 00                	push   $0x0
  pushl $54
c010229d:	6a 36                	push   $0x36
  jmp __alltraps
c010229f:	e9 91 08 00 00       	jmp    c0102b35 <__alltraps>

c01022a4 <vector55>:
.globl vector55
vector55:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $55
c01022a6:	6a 37                	push   $0x37
  jmp __alltraps
c01022a8:	e9 88 08 00 00       	jmp    c0102b35 <__alltraps>

c01022ad <vector56>:
.globl vector56
vector56:
  pushl $0
c01022ad:	6a 00                	push   $0x0
  pushl $56
c01022af:	6a 38                	push   $0x38
  jmp __alltraps
c01022b1:	e9 7f 08 00 00       	jmp    c0102b35 <__alltraps>

c01022b6 <vector57>:
.globl vector57
vector57:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $57
c01022b8:	6a 39                	push   $0x39
  jmp __alltraps
c01022ba:	e9 76 08 00 00       	jmp    c0102b35 <__alltraps>

c01022bf <vector58>:
.globl vector58
vector58:
  pushl $0
c01022bf:	6a 00                	push   $0x0
  pushl $58
c01022c1:	6a 3a                	push   $0x3a
  jmp __alltraps
c01022c3:	e9 6d 08 00 00       	jmp    c0102b35 <__alltraps>

c01022c8 <vector59>:
.globl vector59
vector59:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $59
c01022ca:	6a 3b                	push   $0x3b
  jmp __alltraps
c01022cc:	e9 64 08 00 00       	jmp    c0102b35 <__alltraps>

c01022d1 <vector60>:
.globl vector60
vector60:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $60
c01022d3:	6a 3c                	push   $0x3c
  jmp __alltraps
c01022d5:	e9 5b 08 00 00       	jmp    c0102b35 <__alltraps>

c01022da <vector61>:
.globl vector61
vector61:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $61
c01022dc:	6a 3d                	push   $0x3d
  jmp __alltraps
c01022de:	e9 52 08 00 00       	jmp    c0102b35 <__alltraps>

c01022e3 <vector62>:
.globl vector62
vector62:
  pushl $0
c01022e3:	6a 00                	push   $0x0
  pushl $62
c01022e5:	6a 3e                	push   $0x3e
  jmp __alltraps
c01022e7:	e9 49 08 00 00       	jmp    c0102b35 <__alltraps>

c01022ec <vector63>:
.globl vector63
vector63:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $63
c01022ee:	6a 3f                	push   $0x3f
  jmp __alltraps
c01022f0:	e9 40 08 00 00       	jmp    c0102b35 <__alltraps>

c01022f5 <vector64>:
.globl vector64
vector64:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $64
c01022f7:	6a 40                	push   $0x40
  jmp __alltraps
c01022f9:	e9 37 08 00 00       	jmp    c0102b35 <__alltraps>

c01022fe <vector65>:
.globl vector65
vector65:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $65
c0102300:	6a 41                	push   $0x41
  jmp __alltraps
c0102302:	e9 2e 08 00 00       	jmp    c0102b35 <__alltraps>

c0102307 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102307:	6a 00                	push   $0x0
  pushl $66
c0102309:	6a 42                	push   $0x42
  jmp __alltraps
c010230b:	e9 25 08 00 00       	jmp    c0102b35 <__alltraps>

c0102310 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $67
c0102312:	6a 43                	push   $0x43
  jmp __alltraps
c0102314:	e9 1c 08 00 00       	jmp    c0102b35 <__alltraps>

c0102319 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $68
c010231b:	6a 44                	push   $0x44
  jmp __alltraps
c010231d:	e9 13 08 00 00       	jmp    c0102b35 <__alltraps>

c0102322 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $69
c0102324:	6a 45                	push   $0x45
  jmp __alltraps
c0102326:	e9 0a 08 00 00       	jmp    c0102b35 <__alltraps>

c010232b <vector70>:
.globl vector70
vector70:
  pushl $0
c010232b:	6a 00                	push   $0x0
  pushl $70
c010232d:	6a 46                	push   $0x46
  jmp __alltraps
c010232f:	e9 01 08 00 00       	jmp    c0102b35 <__alltraps>

c0102334 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $71
c0102336:	6a 47                	push   $0x47
  jmp __alltraps
c0102338:	e9 f8 07 00 00       	jmp    c0102b35 <__alltraps>

c010233d <vector72>:
.globl vector72
vector72:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $72
c010233f:	6a 48                	push   $0x48
  jmp __alltraps
c0102341:	e9 ef 07 00 00       	jmp    c0102b35 <__alltraps>

c0102346 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $73
c0102348:	6a 49                	push   $0x49
  jmp __alltraps
c010234a:	e9 e6 07 00 00       	jmp    c0102b35 <__alltraps>

c010234f <vector74>:
.globl vector74
vector74:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $74
c0102351:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102353:	e9 dd 07 00 00       	jmp    c0102b35 <__alltraps>

c0102358 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $75
c010235a:	6a 4b                	push   $0x4b
  jmp __alltraps
c010235c:	e9 d4 07 00 00       	jmp    c0102b35 <__alltraps>

c0102361 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $76
c0102363:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102365:	e9 cb 07 00 00       	jmp    c0102b35 <__alltraps>

c010236a <vector77>:
.globl vector77
vector77:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $77
c010236c:	6a 4d                	push   $0x4d
  jmp __alltraps
c010236e:	e9 c2 07 00 00       	jmp    c0102b35 <__alltraps>

c0102373 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $78
c0102375:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102377:	e9 b9 07 00 00       	jmp    c0102b35 <__alltraps>

c010237c <vector79>:
.globl vector79
vector79:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $79
c010237e:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102380:	e9 b0 07 00 00       	jmp    c0102b35 <__alltraps>

c0102385 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $80
c0102387:	6a 50                	push   $0x50
  jmp __alltraps
c0102389:	e9 a7 07 00 00       	jmp    c0102b35 <__alltraps>

c010238e <vector81>:
.globl vector81
vector81:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $81
c0102390:	6a 51                	push   $0x51
  jmp __alltraps
c0102392:	e9 9e 07 00 00       	jmp    c0102b35 <__alltraps>

c0102397 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $82
c0102399:	6a 52                	push   $0x52
  jmp __alltraps
c010239b:	e9 95 07 00 00       	jmp    c0102b35 <__alltraps>

c01023a0 <vector83>:
.globl vector83
vector83:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $83
c01023a2:	6a 53                	push   $0x53
  jmp __alltraps
c01023a4:	e9 8c 07 00 00       	jmp    c0102b35 <__alltraps>

c01023a9 <vector84>:
.globl vector84
vector84:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $84
c01023ab:	6a 54                	push   $0x54
  jmp __alltraps
c01023ad:	e9 83 07 00 00       	jmp    c0102b35 <__alltraps>

c01023b2 <vector85>:
.globl vector85
vector85:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $85
c01023b4:	6a 55                	push   $0x55
  jmp __alltraps
c01023b6:	e9 7a 07 00 00       	jmp    c0102b35 <__alltraps>

c01023bb <vector86>:
.globl vector86
vector86:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $86
c01023bd:	6a 56                	push   $0x56
  jmp __alltraps
c01023bf:	e9 71 07 00 00       	jmp    c0102b35 <__alltraps>

c01023c4 <vector87>:
.globl vector87
vector87:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $87
c01023c6:	6a 57                	push   $0x57
  jmp __alltraps
c01023c8:	e9 68 07 00 00       	jmp    c0102b35 <__alltraps>

c01023cd <vector88>:
.globl vector88
vector88:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $88
c01023cf:	6a 58                	push   $0x58
  jmp __alltraps
c01023d1:	e9 5f 07 00 00       	jmp    c0102b35 <__alltraps>

c01023d6 <vector89>:
.globl vector89
vector89:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $89
c01023d8:	6a 59                	push   $0x59
  jmp __alltraps
c01023da:	e9 56 07 00 00       	jmp    c0102b35 <__alltraps>

c01023df <vector90>:
.globl vector90
vector90:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $90
c01023e1:	6a 5a                	push   $0x5a
  jmp __alltraps
c01023e3:	e9 4d 07 00 00       	jmp    c0102b35 <__alltraps>

c01023e8 <vector91>:
.globl vector91
vector91:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $91
c01023ea:	6a 5b                	push   $0x5b
  jmp __alltraps
c01023ec:	e9 44 07 00 00       	jmp    c0102b35 <__alltraps>

c01023f1 <vector92>:
.globl vector92
vector92:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $92
c01023f3:	6a 5c                	push   $0x5c
  jmp __alltraps
c01023f5:	e9 3b 07 00 00       	jmp    c0102b35 <__alltraps>

c01023fa <vector93>:
.globl vector93
vector93:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $93
c01023fc:	6a 5d                	push   $0x5d
  jmp __alltraps
c01023fe:	e9 32 07 00 00       	jmp    c0102b35 <__alltraps>

c0102403 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $94
c0102405:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102407:	e9 29 07 00 00       	jmp    c0102b35 <__alltraps>

c010240c <vector95>:
.globl vector95
vector95:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $95
c010240e:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102410:	e9 20 07 00 00       	jmp    c0102b35 <__alltraps>

c0102415 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $96
c0102417:	6a 60                	push   $0x60
  jmp __alltraps
c0102419:	e9 17 07 00 00       	jmp    c0102b35 <__alltraps>

c010241e <vector97>:
.globl vector97
vector97:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $97
c0102420:	6a 61                	push   $0x61
  jmp __alltraps
c0102422:	e9 0e 07 00 00       	jmp    c0102b35 <__alltraps>

c0102427 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $98
c0102429:	6a 62                	push   $0x62
  jmp __alltraps
c010242b:	e9 05 07 00 00       	jmp    c0102b35 <__alltraps>

c0102430 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $99
c0102432:	6a 63                	push   $0x63
  jmp __alltraps
c0102434:	e9 fc 06 00 00       	jmp    c0102b35 <__alltraps>

c0102439 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $100
c010243b:	6a 64                	push   $0x64
  jmp __alltraps
c010243d:	e9 f3 06 00 00       	jmp    c0102b35 <__alltraps>

c0102442 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $101
c0102444:	6a 65                	push   $0x65
  jmp __alltraps
c0102446:	e9 ea 06 00 00       	jmp    c0102b35 <__alltraps>

c010244b <vector102>:
.globl vector102
vector102:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $102
c010244d:	6a 66                	push   $0x66
  jmp __alltraps
c010244f:	e9 e1 06 00 00       	jmp    c0102b35 <__alltraps>

c0102454 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $103
c0102456:	6a 67                	push   $0x67
  jmp __alltraps
c0102458:	e9 d8 06 00 00       	jmp    c0102b35 <__alltraps>

c010245d <vector104>:
.globl vector104
vector104:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $104
c010245f:	6a 68                	push   $0x68
  jmp __alltraps
c0102461:	e9 cf 06 00 00       	jmp    c0102b35 <__alltraps>

c0102466 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $105
c0102468:	6a 69                	push   $0x69
  jmp __alltraps
c010246a:	e9 c6 06 00 00       	jmp    c0102b35 <__alltraps>

c010246f <vector106>:
.globl vector106
vector106:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $106
c0102471:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102473:	e9 bd 06 00 00       	jmp    c0102b35 <__alltraps>

c0102478 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $107
c010247a:	6a 6b                	push   $0x6b
  jmp __alltraps
c010247c:	e9 b4 06 00 00       	jmp    c0102b35 <__alltraps>

c0102481 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $108
c0102483:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102485:	e9 ab 06 00 00       	jmp    c0102b35 <__alltraps>

c010248a <vector109>:
.globl vector109
vector109:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $109
c010248c:	6a 6d                	push   $0x6d
  jmp __alltraps
c010248e:	e9 a2 06 00 00       	jmp    c0102b35 <__alltraps>

c0102493 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $110
c0102495:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102497:	e9 99 06 00 00       	jmp    c0102b35 <__alltraps>

c010249c <vector111>:
.globl vector111
vector111:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $111
c010249e:	6a 6f                	push   $0x6f
  jmp __alltraps
c01024a0:	e9 90 06 00 00       	jmp    c0102b35 <__alltraps>

c01024a5 <vector112>:
.globl vector112
vector112:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $112
c01024a7:	6a 70                	push   $0x70
  jmp __alltraps
c01024a9:	e9 87 06 00 00       	jmp    c0102b35 <__alltraps>

c01024ae <vector113>:
.globl vector113
vector113:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $113
c01024b0:	6a 71                	push   $0x71
  jmp __alltraps
c01024b2:	e9 7e 06 00 00       	jmp    c0102b35 <__alltraps>

c01024b7 <vector114>:
.globl vector114
vector114:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $114
c01024b9:	6a 72                	push   $0x72
  jmp __alltraps
c01024bb:	e9 75 06 00 00       	jmp    c0102b35 <__alltraps>

c01024c0 <vector115>:
.globl vector115
vector115:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $115
c01024c2:	6a 73                	push   $0x73
  jmp __alltraps
c01024c4:	e9 6c 06 00 00       	jmp    c0102b35 <__alltraps>

c01024c9 <vector116>:
.globl vector116
vector116:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $116
c01024cb:	6a 74                	push   $0x74
  jmp __alltraps
c01024cd:	e9 63 06 00 00       	jmp    c0102b35 <__alltraps>

c01024d2 <vector117>:
.globl vector117
vector117:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $117
c01024d4:	6a 75                	push   $0x75
  jmp __alltraps
c01024d6:	e9 5a 06 00 00       	jmp    c0102b35 <__alltraps>

c01024db <vector118>:
.globl vector118
vector118:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $118
c01024dd:	6a 76                	push   $0x76
  jmp __alltraps
c01024df:	e9 51 06 00 00       	jmp    c0102b35 <__alltraps>

c01024e4 <vector119>:
.globl vector119
vector119:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $119
c01024e6:	6a 77                	push   $0x77
  jmp __alltraps
c01024e8:	e9 48 06 00 00       	jmp    c0102b35 <__alltraps>

c01024ed <vector120>:
.globl vector120
vector120:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $120
c01024ef:	6a 78                	push   $0x78
  jmp __alltraps
c01024f1:	e9 3f 06 00 00       	jmp    c0102b35 <__alltraps>

c01024f6 <vector121>:
.globl vector121
vector121:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $121
c01024f8:	6a 79                	push   $0x79
  jmp __alltraps
c01024fa:	e9 36 06 00 00       	jmp    c0102b35 <__alltraps>

c01024ff <vector122>:
.globl vector122
vector122:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $122
c0102501:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102503:	e9 2d 06 00 00       	jmp    c0102b35 <__alltraps>

c0102508 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $123
c010250a:	6a 7b                	push   $0x7b
  jmp __alltraps
c010250c:	e9 24 06 00 00       	jmp    c0102b35 <__alltraps>

c0102511 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $124
c0102513:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102515:	e9 1b 06 00 00       	jmp    c0102b35 <__alltraps>

c010251a <vector125>:
.globl vector125
vector125:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $125
c010251c:	6a 7d                	push   $0x7d
  jmp __alltraps
c010251e:	e9 12 06 00 00       	jmp    c0102b35 <__alltraps>

c0102523 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $126
c0102525:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102527:	e9 09 06 00 00       	jmp    c0102b35 <__alltraps>

c010252c <vector127>:
.globl vector127
vector127:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $127
c010252e:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102530:	e9 00 06 00 00       	jmp    c0102b35 <__alltraps>

c0102535 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $128
c0102537:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010253c:	e9 f4 05 00 00       	jmp    c0102b35 <__alltraps>

c0102541 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102541:	6a 00                	push   $0x0
  pushl $129
c0102543:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102548:	e9 e8 05 00 00       	jmp    c0102b35 <__alltraps>

c010254d <vector130>:
.globl vector130
vector130:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $130
c010254f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102554:	e9 dc 05 00 00       	jmp    c0102b35 <__alltraps>

c0102559 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $131
c010255b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102560:	e9 d0 05 00 00       	jmp    c0102b35 <__alltraps>

c0102565 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102565:	6a 00                	push   $0x0
  pushl $132
c0102567:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010256c:	e9 c4 05 00 00       	jmp    c0102b35 <__alltraps>

c0102571 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $133
c0102573:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102578:	e9 b8 05 00 00       	jmp    c0102b35 <__alltraps>

c010257d <vector134>:
.globl vector134
vector134:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $134
c010257f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102584:	e9 ac 05 00 00       	jmp    c0102b35 <__alltraps>

c0102589 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102589:	6a 00                	push   $0x0
  pushl $135
c010258b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102590:	e9 a0 05 00 00       	jmp    c0102b35 <__alltraps>

c0102595 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $136
c0102597:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010259c:	e9 94 05 00 00       	jmp    c0102b35 <__alltraps>

c01025a1 <vector137>:
.globl vector137
vector137:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $137
c01025a3:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01025a8:	e9 88 05 00 00       	jmp    c0102b35 <__alltraps>

c01025ad <vector138>:
.globl vector138
vector138:
  pushl $0
c01025ad:	6a 00                	push   $0x0
  pushl $138
c01025af:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01025b4:	e9 7c 05 00 00       	jmp    c0102b35 <__alltraps>

c01025b9 <vector139>:
.globl vector139
vector139:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $139
c01025bb:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01025c0:	e9 70 05 00 00       	jmp    c0102b35 <__alltraps>

c01025c5 <vector140>:
.globl vector140
vector140:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $140
c01025c7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01025cc:	e9 64 05 00 00       	jmp    c0102b35 <__alltraps>

c01025d1 <vector141>:
.globl vector141
vector141:
  pushl $0
c01025d1:	6a 00                	push   $0x0
  pushl $141
c01025d3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01025d8:	e9 58 05 00 00       	jmp    c0102b35 <__alltraps>

c01025dd <vector142>:
.globl vector142
vector142:
  pushl $0
c01025dd:	6a 00                	push   $0x0
  pushl $142
c01025df:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01025e4:	e9 4c 05 00 00       	jmp    c0102b35 <__alltraps>

c01025e9 <vector143>:
.globl vector143
vector143:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $143
c01025eb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01025f0:	e9 40 05 00 00       	jmp    c0102b35 <__alltraps>

c01025f5 <vector144>:
.globl vector144
vector144:
  pushl $0
c01025f5:	6a 00                	push   $0x0
  pushl $144
c01025f7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01025fc:	e9 34 05 00 00       	jmp    c0102b35 <__alltraps>

c0102601 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102601:	6a 00                	push   $0x0
  pushl $145
c0102603:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102608:	e9 28 05 00 00       	jmp    c0102b35 <__alltraps>

c010260d <vector146>:
.globl vector146
vector146:
  pushl $0
c010260d:	6a 00                	push   $0x0
  pushl $146
c010260f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102614:	e9 1c 05 00 00       	jmp    c0102b35 <__alltraps>

c0102619 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102619:	6a 00                	push   $0x0
  pushl $147
c010261b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102620:	e9 10 05 00 00       	jmp    c0102b35 <__alltraps>

c0102625 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102625:	6a 00                	push   $0x0
  pushl $148
c0102627:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010262c:	e9 04 05 00 00       	jmp    c0102b35 <__alltraps>

c0102631 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102631:	6a 00                	push   $0x0
  pushl $149
c0102633:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102638:	e9 f8 04 00 00       	jmp    c0102b35 <__alltraps>

c010263d <vector150>:
.globl vector150
vector150:
  pushl $0
c010263d:	6a 00                	push   $0x0
  pushl $150
c010263f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102644:	e9 ec 04 00 00       	jmp    c0102b35 <__alltraps>

c0102649 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102649:	6a 00                	push   $0x0
  pushl $151
c010264b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102650:	e9 e0 04 00 00       	jmp    c0102b35 <__alltraps>

c0102655 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102655:	6a 00                	push   $0x0
  pushl $152
c0102657:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010265c:	e9 d4 04 00 00       	jmp    c0102b35 <__alltraps>

c0102661 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102661:	6a 00                	push   $0x0
  pushl $153
c0102663:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102668:	e9 c8 04 00 00       	jmp    c0102b35 <__alltraps>

c010266d <vector154>:
.globl vector154
vector154:
  pushl $0
c010266d:	6a 00                	push   $0x0
  pushl $154
c010266f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102674:	e9 bc 04 00 00       	jmp    c0102b35 <__alltraps>

c0102679 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102679:	6a 00                	push   $0x0
  pushl $155
c010267b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102680:	e9 b0 04 00 00       	jmp    c0102b35 <__alltraps>

c0102685 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102685:	6a 00                	push   $0x0
  pushl $156
c0102687:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010268c:	e9 a4 04 00 00       	jmp    c0102b35 <__alltraps>

c0102691 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102691:	6a 00                	push   $0x0
  pushl $157
c0102693:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102698:	e9 98 04 00 00       	jmp    c0102b35 <__alltraps>

c010269d <vector158>:
.globl vector158
vector158:
  pushl $0
c010269d:	6a 00                	push   $0x0
  pushl $158
c010269f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01026a4:	e9 8c 04 00 00       	jmp    c0102b35 <__alltraps>

c01026a9 <vector159>:
.globl vector159
vector159:
  pushl $0
c01026a9:	6a 00                	push   $0x0
  pushl $159
c01026ab:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01026b0:	e9 80 04 00 00       	jmp    c0102b35 <__alltraps>

c01026b5 <vector160>:
.globl vector160
vector160:
  pushl $0
c01026b5:	6a 00                	push   $0x0
  pushl $160
c01026b7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01026bc:	e9 74 04 00 00       	jmp    c0102b35 <__alltraps>

c01026c1 <vector161>:
.globl vector161
vector161:
  pushl $0
c01026c1:	6a 00                	push   $0x0
  pushl $161
c01026c3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01026c8:	e9 68 04 00 00       	jmp    c0102b35 <__alltraps>

c01026cd <vector162>:
.globl vector162
vector162:
  pushl $0
c01026cd:	6a 00                	push   $0x0
  pushl $162
c01026cf:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01026d4:	e9 5c 04 00 00       	jmp    c0102b35 <__alltraps>

c01026d9 <vector163>:
.globl vector163
vector163:
  pushl $0
c01026d9:	6a 00                	push   $0x0
  pushl $163
c01026db:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01026e0:	e9 50 04 00 00       	jmp    c0102b35 <__alltraps>

c01026e5 <vector164>:
.globl vector164
vector164:
  pushl $0
c01026e5:	6a 00                	push   $0x0
  pushl $164
c01026e7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01026ec:	e9 44 04 00 00       	jmp    c0102b35 <__alltraps>

c01026f1 <vector165>:
.globl vector165
vector165:
  pushl $0
c01026f1:	6a 00                	push   $0x0
  pushl $165
c01026f3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01026f8:	e9 38 04 00 00       	jmp    c0102b35 <__alltraps>

c01026fd <vector166>:
.globl vector166
vector166:
  pushl $0
c01026fd:	6a 00                	push   $0x0
  pushl $166
c01026ff:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102704:	e9 2c 04 00 00       	jmp    c0102b35 <__alltraps>

c0102709 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102709:	6a 00                	push   $0x0
  pushl $167
c010270b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102710:	e9 20 04 00 00       	jmp    c0102b35 <__alltraps>

c0102715 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102715:	6a 00                	push   $0x0
  pushl $168
c0102717:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010271c:	e9 14 04 00 00       	jmp    c0102b35 <__alltraps>

c0102721 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102721:	6a 00                	push   $0x0
  pushl $169
c0102723:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102728:	e9 08 04 00 00       	jmp    c0102b35 <__alltraps>

c010272d <vector170>:
.globl vector170
vector170:
  pushl $0
c010272d:	6a 00                	push   $0x0
  pushl $170
c010272f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102734:	e9 fc 03 00 00       	jmp    c0102b35 <__alltraps>

c0102739 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102739:	6a 00                	push   $0x0
  pushl $171
c010273b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102740:	e9 f0 03 00 00       	jmp    c0102b35 <__alltraps>

c0102745 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102745:	6a 00                	push   $0x0
  pushl $172
c0102747:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010274c:	e9 e4 03 00 00       	jmp    c0102b35 <__alltraps>

c0102751 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $173
c0102753:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102758:	e9 d8 03 00 00       	jmp    c0102b35 <__alltraps>

c010275d <vector174>:
.globl vector174
vector174:
  pushl $0
c010275d:	6a 00                	push   $0x0
  pushl $174
c010275f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102764:	e9 cc 03 00 00       	jmp    c0102b35 <__alltraps>

c0102769 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102769:	6a 00                	push   $0x0
  pushl $175
c010276b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102770:	e9 c0 03 00 00       	jmp    c0102b35 <__alltraps>

c0102775 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $176
c0102777:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010277c:	e9 b4 03 00 00       	jmp    c0102b35 <__alltraps>

c0102781 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102781:	6a 00                	push   $0x0
  pushl $177
c0102783:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102788:	e9 a8 03 00 00       	jmp    c0102b35 <__alltraps>

c010278d <vector178>:
.globl vector178
vector178:
  pushl $0
c010278d:	6a 00                	push   $0x0
  pushl $178
c010278f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102794:	e9 9c 03 00 00       	jmp    c0102b35 <__alltraps>

c0102799 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102799:	6a 00                	push   $0x0
  pushl $179
c010279b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01027a0:	e9 90 03 00 00       	jmp    c0102b35 <__alltraps>

c01027a5 <vector180>:
.globl vector180
vector180:
  pushl $0
c01027a5:	6a 00                	push   $0x0
  pushl $180
c01027a7:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01027ac:	e9 84 03 00 00       	jmp    c0102b35 <__alltraps>

c01027b1 <vector181>:
.globl vector181
vector181:
  pushl $0
c01027b1:	6a 00                	push   $0x0
  pushl $181
c01027b3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01027b8:	e9 78 03 00 00       	jmp    c0102b35 <__alltraps>

c01027bd <vector182>:
.globl vector182
vector182:
  pushl $0
c01027bd:	6a 00                	push   $0x0
  pushl $182
c01027bf:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01027c4:	e9 6c 03 00 00       	jmp    c0102b35 <__alltraps>

c01027c9 <vector183>:
.globl vector183
vector183:
  pushl $0
c01027c9:	6a 00                	push   $0x0
  pushl $183
c01027cb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01027d0:	e9 60 03 00 00       	jmp    c0102b35 <__alltraps>

c01027d5 <vector184>:
.globl vector184
vector184:
  pushl $0
c01027d5:	6a 00                	push   $0x0
  pushl $184
c01027d7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01027dc:	e9 54 03 00 00       	jmp    c0102b35 <__alltraps>

c01027e1 <vector185>:
.globl vector185
vector185:
  pushl $0
c01027e1:	6a 00                	push   $0x0
  pushl $185
c01027e3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01027e8:	e9 48 03 00 00       	jmp    c0102b35 <__alltraps>

c01027ed <vector186>:
.globl vector186
vector186:
  pushl $0
c01027ed:	6a 00                	push   $0x0
  pushl $186
c01027ef:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01027f4:	e9 3c 03 00 00       	jmp    c0102b35 <__alltraps>

c01027f9 <vector187>:
.globl vector187
vector187:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $187
c01027fb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102800:	e9 30 03 00 00       	jmp    c0102b35 <__alltraps>

c0102805 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102805:	6a 00                	push   $0x0
  pushl $188
c0102807:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010280c:	e9 24 03 00 00       	jmp    c0102b35 <__alltraps>

c0102811 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102811:	6a 00                	push   $0x0
  pushl $189
c0102813:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102818:	e9 18 03 00 00       	jmp    c0102b35 <__alltraps>

c010281d <vector190>:
.globl vector190
vector190:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $190
c010281f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102824:	e9 0c 03 00 00       	jmp    c0102b35 <__alltraps>

c0102829 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102829:	6a 00                	push   $0x0
  pushl $191
c010282b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102830:	e9 00 03 00 00       	jmp    c0102b35 <__alltraps>

c0102835 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102835:	6a 00                	push   $0x0
  pushl $192
c0102837:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010283c:	e9 f4 02 00 00       	jmp    c0102b35 <__alltraps>

c0102841 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $193
c0102843:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102848:	e9 e8 02 00 00       	jmp    c0102b35 <__alltraps>

c010284d <vector194>:
.globl vector194
vector194:
  pushl $0
c010284d:	6a 00                	push   $0x0
  pushl $194
c010284f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102854:	e9 dc 02 00 00       	jmp    c0102b35 <__alltraps>

c0102859 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102859:	6a 00                	push   $0x0
  pushl $195
c010285b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102860:	e9 d0 02 00 00       	jmp    c0102b35 <__alltraps>

c0102865 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $196
c0102867:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010286c:	e9 c4 02 00 00       	jmp    c0102b35 <__alltraps>

c0102871 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102871:	6a 00                	push   $0x0
  pushl $197
c0102873:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102878:	e9 b8 02 00 00       	jmp    c0102b35 <__alltraps>

c010287d <vector198>:
.globl vector198
vector198:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $198
c010287f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102884:	e9 ac 02 00 00       	jmp    c0102b35 <__alltraps>

c0102889 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $199
c010288b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102890:	e9 a0 02 00 00       	jmp    c0102b35 <__alltraps>

c0102895 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102895:	6a 00                	push   $0x0
  pushl $200
c0102897:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010289c:	e9 94 02 00 00       	jmp    c0102b35 <__alltraps>

c01028a1 <vector201>:
.globl vector201
vector201:
  pushl $0
c01028a1:	6a 00                	push   $0x0
  pushl $201
c01028a3:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01028a8:	e9 88 02 00 00       	jmp    c0102b35 <__alltraps>

c01028ad <vector202>:
.globl vector202
vector202:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $202
c01028af:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01028b4:	e9 7c 02 00 00       	jmp    c0102b35 <__alltraps>

c01028b9 <vector203>:
.globl vector203
vector203:
  pushl $0
c01028b9:	6a 00                	push   $0x0
  pushl $203
c01028bb:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01028c0:	e9 70 02 00 00       	jmp    c0102b35 <__alltraps>

c01028c5 <vector204>:
.globl vector204
vector204:
  pushl $0
c01028c5:	6a 00                	push   $0x0
  pushl $204
c01028c7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01028cc:	e9 64 02 00 00       	jmp    c0102b35 <__alltraps>

c01028d1 <vector205>:
.globl vector205
vector205:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $205
c01028d3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01028d8:	e9 58 02 00 00       	jmp    c0102b35 <__alltraps>

c01028dd <vector206>:
.globl vector206
vector206:
  pushl $0
c01028dd:	6a 00                	push   $0x0
  pushl $206
c01028df:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01028e4:	e9 4c 02 00 00       	jmp    c0102b35 <__alltraps>

c01028e9 <vector207>:
.globl vector207
vector207:
  pushl $0
c01028e9:	6a 00                	push   $0x0
  pushl $207
c01028eb:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01028f0:	e9 40 02 00 00       	jmp    c0102b35 <__alltraps>

c01028f5 <vector208>:
.globl vector208
vector208:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $208
c01028f7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01028fc:	e9 34 02 00 00       	jmp    c0102b35 <__alltraps>

c0102901 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102901:	6a 00                	push   $0x0
  pushl $209
c0102903:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102908:	e9 28 02 00 00       	jmp    c0102b35 <__alltraps>

c010290d <vector210>:
.globl vector210
vector210:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $210
c010290f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102914:	e9 1c 02 00 00       	jmp    c0102b35 <__alltraps>

c0102919 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $211
c010291b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102920:	e9 10 02 00 00       	jmp    c0102b35 <__alltraps>

c0102925 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102925:	6a 00                	push   $0x0
  pushl $212
c0102927:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010292c:	e9 04 02 00 00       	jmp    c0102b35 <__alltraps>

c0102931 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $213
c0102933:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102938:	e9 f8 01 00 00       	jmp    c0102b35 <__alltraps>

c010293d <vector214>:
.globl vector214
vector214:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $214
c010293f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102944:	e9 ec 01 00 00       	jmp    c0102b35 <__alltraps>

c0102949 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102949:	6a 00                	push   $0x0
  pushl $215
c010294b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102950:	e9 e0 01 00 00       	jmp    c0102b35 <__alltraps>

c0102955 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $216
c0102957:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010295c:	e9 d4 01 00 00       	jmp    c0102b35 <__alltraps>

c0102961 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $217
c0102963:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102968:	e9 c8 01 00 00       	jmp    c0102b35 <__alltraps>

c010296d <vector218>:
.globl vector218
vector218:
  pushl $0
c010296d:	6a 00                	push   $0x0
  pushl $218
c010296f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102974:	e9 bc 01 00 00       	jmp    c0102b35 <__alltraps>

c0102979 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $219
c010297b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102980:	e9 b0 01 00 00       	jmp    c0102b35 <__alltraps>

c0102985 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $220
c0102987:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010298c:	e9 a4 01 00 00       	jmp    c0102b35 <__alltraps>

c0102991 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102991:	6a 00                	push   $0x0
  pushl $221
c0102993:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102998:	e9 98 01 00 00       	jmp    c0102b35 <__alltraps>

c010299d <vector222>:
.globl vector222
vector222:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $222
c010299f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01029a4:	e9 8c 01 00 00       	jmp    c0102b35 <__alltraps>

c01029a9 <vector223>:
.globl vector223
vector223:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $223
c01029ab:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01029b0:	e9 80 01 00 00       	jmp    c0102b35 <__alltraps>

c01029b5 <vector224>:
.globl vector224
vector224:
  pushl $0
c01029b5:	6a 00                	push   $0x0
  pushl $224
c01029b7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01029bc:	e9 74 01 00 00       	jmp    c0102b35 <__alltraps>

c01029c1 <vector225>:
.globl vector225
vector225:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $225
c01029c3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01029c8:	e9 68 01 00 00       	jmp    c0102b35 <__alltraps>

c01029cd <vector226>:
.globl vector226
vector226:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $226
c01029cf:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01029d4:	e9 5c 01 00 00       	jmp    c0102b35 <__alltraps>

c01029d9 <vector227>:
.globl vector227
vector227:
  pushl $0
c01029d9:	6a 00                	push   $0x0
  pushl $227
c01029db:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01029e0:	e9 50 01 00 00       	jmp    c0102b35 <__alltraps>

c01029e5 <vector228>:
.globl vector228
vector228:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $228
c01029e7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01029ec:	e9 44 01 00 00       	jmp    c0102b35 <__alltraps>

c01029f1 <vector229>:
.globl vector229
vector229:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $229
c01029f3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01029f8:	e9 38 01 00 00       	jmp    c0102b35 <__alltraps>

c01029fd <vector230>:
.globl vector230
vector230:
  pushl $0
c01029fd:	6a 00                	push   $0x0
  pushl $230
c01029ff:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102a04:	e9 2c 01 00 00       	jmp    c0102b35 <__alltraps>

c0102a09 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $231
c0102a0b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102a10:	e9 20 01 00 00       	jmp    c0102b35 <__alltraps>

c0102a15 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $232
c0102a17:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102a1c:	e9 14 01 00 00       	jmp    c0102b35 <__alltraps>

c0102a21 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102a21:	6a 00                	push   $0x0
  pushl $233
c0102a23:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102a28:	e9 08 01 00 00       	jmp    c0102b35 <__alltraps>

c0102a2d <vector234>:
.globl vector234
vector234:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $234
c0102a2f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102a34:	e9 fc 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a39 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $235
c0102a3b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102a40:	e9 f0 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a45 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102a45:	6a 00                	push   $0x0
  pushl $236
c0102a47:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102a4c:	e9 e4 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a51 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $237
c0102a53:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102a58:	e9 d8 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a5d <vector238>:
.globl vector238
vector238:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $238
c0102a5f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102a64:	e9 cc 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a69 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102a69:	6a 00                	push   $0x0
  pushl $239
c0102a6b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102a70:	e9 c0 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a75 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $240
c0102a77:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102a7c:	e9 b4 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a81 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $241
c0102a83:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102a88:	e9 a8 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a8d <vector242>:
.globl vector242
vector242:
  pushl $0
c0102a8d:	6a 00                	push   $0x0
  pushl $242
c0102a8f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102a94:	e9 9c 00 00 00       	jmp    c0102b35 <__alltraps>

c0102a99 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $243
c0102a9b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102aa0:	e9 90 00 00 00       	jmp    c0102b35 <__alltraps>

c0102aa5 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $244
c0102aa7:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102aac:	e9 84 00 00 00       	jmp    c0102b35 <__alltraps>

c0102ab1 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102ab1:	6a 00                	push   $0x0
  pushl $245
c0102ab3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102ab8:	e9 78 00 00 00       	jmp    c0102b35 <__alltraps>

c0102abd <vector246>:
.globl vector246
vector246:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $246
c0102abf:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102ac4:	e9 6c 00 00 00       	jmp    c0102b35 <__alltraps>

c0102ac9 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $247
c0102acb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102ad0:	e9 60 00 00 00       	jmp    c0102b35 <__alltraps>

c0102ad5 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102ad5:	6a 00                	push   $0x0
  pushl $248
c0102ad7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102adc:	e9 54 00 00 00       	jmp    c0102b35 <__alltraps>

c0102ae1 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $249
c0102ae3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102ae8:	e9 48 00 00 00       	jmp    c0102b35 <__alltraps>

c0102aed <vector250>:
.globl vector250
vector250:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $250
c0102aef:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102af4:	e9 3c 00 00 00       	jmp    c0102b35 <__alltraps>

c0102af9 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102af9:	6a 00                	push   $0x0
  pushl $251
c0102afb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102b00:	e9 30 00 00 00       	jmp    c0102b35 <__alltraps>

c0102b05 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $252
c0102b07:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102b0c:	e9 24 00 00 00       	jmp    c0102b35 <__alltraps>

c0102b11 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $253
c0102b13:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102b18:	e9 18 00 00 00       	jmp    c0102b35 <__alltraps>

c0102b1d <vector254>:
.globl vector254
vector254:
  pushl $0
c0102b1d:	6a 00                	push   $0x0
  pushl $254
c0102b1f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102b24:	e9 0c 00 00 00       	jmp    c0102b35 <__alltraps>

c0102b29 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $255
c0102b2b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102b30:	e9 00 00 00 00       	jmp    c0102b35 <__alltraps>

c0102b35 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102b35:	1e                   	push   %ds
    pushl %es
c0102b36:	06                   	push   %es
    pushl %fs
c0102b37:	0f a0                	push   %fs
    pushl %gs
c0102b39:	0f a8                	push   %gs
    pushal
c0102b3b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102b3c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102b41:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102b43:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102b45:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102b46:	e8 60 f5 ff ff       	call   c01020ab <trap>

    # pop the pushed stack pointer
    popl %esp
c0102b4b:	5c                   	pop    %esp

c0102b4c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102b4c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102b4d:	0f a9                	pop    %gs
    popl %fs
c0102b4f:	0f a1                	pop    %fs
    popl %es
c0102b51:	07                   	pop    %es
    popl %ds
c0102b52:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102b53:	83 c4 08             	add    $0x8,%esp
    iret
c0102b56:	cf                   	iret   

c0102b57 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102b57:	55                   	push   %ebp
c0102b58:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102b5a:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c0102b5f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b62:	29 c2                	sub    %eax,%edx
c0102b64:	89 d0                	mov    %edx,%eax
c0102b66:	c1 f8 02             	sar    $0x2,%eax
c0102b69:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102b6f:	5d                   	pop    %ebp
c0102b70:	c3                   	ret    

c0102b71 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102b71:	55                   	push   %ebp
c0102b72:	89 e5                	mov    %esp,%ebp
c0102b74:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b7a:	89 04 24             	mov    %eax,(%esp)
c0102b7d:	e8 d5 ff ff ff       	call   c0102b57 <page2ppn>
c0102b82:	c1 e0 0c             	shl    $0xc,%eax
}
c0102b85:	c9                   	leave  
c0102b86:	c3                   	ret    

c0102b87 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102b87:	55                   	push   %ebp
c0102b88:	89 e5                	mov    %esp,%ebp
c0102b8a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b90:	c1 e8 0c             	shr    $0xc,%eax
c0102b93:	89 c2                	mov    %eax,%edx
c0102b95:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0102b9a:	39 c2                	cmp    %eax,%edx
c0102b9c:	72 1c                	jb     c0102bba <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102b9e:	c7 44 24 08 30 8c 10 	movl   $0xc0108c30,0x8(%esp)
c0102ba5:	c0 
c0102ba6:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0102bad:	00 
c0102bae:	c7 04 24 4f 8c 10 c0 	movl   $0xc0108c4f,(%esp)
c0102bb5:	e8 7b d8 ff ff       	call   c0100435 <__panic>
    }
    return &pages[PPN(pa)];
c0102bba:	8b 0d 18 40 12 c0    	mov    0xc0124018,%ecx
c0102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc3:	c1 e8 0c             	shr    $0xc,%eax
c0102bc6:	89 c2                	mov    %eax,%edx
c0102bc8:	89 d0                	mov    %edx,%eax
c0102bca:	c1 e0 02             	shl    $0x2,%eax
c0102bcd:	01 d0                	add    %edx,%eax
c0102bcf:	c1 e0 02             	shl    $0x2,%eax
c0102bd2:	01 c8                	add    %ecx,%eax
}
c0102bd4:	c9                   	leave  
c0102bd5:	c3                   	ret    

c0102bd6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102bd6:	55                   	push   %ebp
c0102bd7:	89 e5                	mov    %esp,%ebp
c0102bd9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdf:	89 04 24             	mov    %eax,(%esp)
c0102be2:	e8 8a ff ff ff       	call   c0102b71 <page2pa>
c0102be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bed:	c1 e8 0c             	shr    $0xc,%eax
c0102bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102bf3:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0102bf8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102bfb:	72 23                	jb     c0102c20 <page2kva+0x4a>
c0102bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c00:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102c04:	c7 44 24 08 60 8c 10 	movl   $0xc0108c60,0x8(%esp)
c0102c0b:	c0 
c0102c0c:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0102c13:	00 
c0102c14:	c7 04 24 4f 8c 10 c0 	movl   $0xc0108c4f,(%esp)
c0102c1b:	e8 15 d8 ff ff       	call   c0100435 <__panic>
c0102c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c23:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102c28:	c9                   	leave  
c0102c29:	c3                   	ret    

c0102c2a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102c2a:	55                   	push   %ebp
c0102c2b:	89 e5                	mov    %esp,%ebp
c0102c2d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c33:	83 e0 01             	and    $0x1,%eax
c0102c36:	85 c0                	test   %eax,%eax
c0102c38:	75 1c                	jne    c0102c56 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102c3a:	c7 44 24 08 84 8c 10 	movl   $0xc0108c84,0x8(%esp)
c0102c41:	c0 
c0102c42:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102c49:	00 
c0102c4a:	c7 04 24 4f 8c 10 c0 	movl   $0xc0108c4f,(%esp)
c0102c51:	e8 df d7 ff ff       	call   c0100435 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102c5e:	89 04 24             	mov    %eax,(%esp)
c0102c61:	e8 21 ff ff ff       	call   c0102b87 <pa2page>
}
c0102c66:	c9                   	leave  
c0102c67:	c3                   	ret    

c0102c68 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102c68:	55                   	push   %ebp
c0102c69:	89 e5                	mov    %esp,%ebp
c0102c6b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102c76:	89 04 24             	mov    %eax,(%esp)
c0102c79:	e8 09 ff ff ff       	call   c0102b87 <pa2page>
}
c0102c7e:	c9                   	leave  
c0102c7f:	c3                   	ret    

c0102c80 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102c80:	55                   	push   %ebp
c0102c81:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c86:	8b 00                	mov    (%eax),%eax
}
c0102c88:	5d                   	pop    %ebp
c0102c89:	c3                   	ret    

c0102c8a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102c8a:	55                   	push   %ebp
c0102c8b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c90:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c93:	89 10                	mov    %edx,(%eax)
}
c0102c95:	90                   	nop
c0102c96:	5d                   	pop    %ebp
c0102c97:	c3                   	ret    

c0102c98 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102c98:	55                   	push   %ebp
c0102c99:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9e:	8b 00                	mov    (%eax),%eax
c0102ca0:	8d 50 01             	lea    0x1(%eax),%edx
c0102ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cab:	8b 00                	mov    (%eax),%eax
}
c0102cad:	5d                   	pop    %ebp
c0102cae:	c3                   	ret    

c0102caf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102caf:	55                   	push   %ebp
c0102cb0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb5:	8b 00                	mov    (%eax),%eax
c0102cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cbd:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc2:	8b 00                	mov    (%eax),%eax
}
c0102cc4:	5d                   	pop    %ebp
c0102cc5:	c3                   	ret    

c0102cc6 <__intr_save>:
__intr_save(void) {
c0102cc6:	55                   	push   %ebp
c0102cc7:	89 e5                	mov    %esp,%ebp
c0102cc9:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102ccc:	9c                   	pushf  
c0102ccd:	58                   	pop    %eax
c0102cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102cd4:	25 00 02 00 00       	and    $0x200,%eax
c0102cd9:	85 c0                	test   %eax,%eax
c0102cdb:	74 0c                	je     c0102ce9 <__intr_save+0x23>
        intr_disable();
c0102cdd:	e8 9a ec ff ff       	call   c010197c <intr_disable>
        return 1;
c0102ce2:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ce7:	eb 05                	jmp    c0102cee <__intr_save+0x28>
    return 0;
c0102ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102cee:	c9                   	leave  
c0102cef:	c3                   	ret    

c0102cf0 <__intr_restore>:
__intr_restore(bool flag) {
c0102cf0:	55                   	push   %ebp
c0102cf1:	89 e5                	mov    %esp,%ebp
c0102cf3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102cf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102cfa:	74 05                	je     c0102d01 <__intr_restore+0x11>
        intr_enable();
c0102cfc:	e8 6f ec ff ff       	call   c0101970 <intr_enable>
}
c0102d01:	90                   	nop
c0102d02:	c9                   	leave  
c0102d03:	c3                   	ret    

c0102d04 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102d04:	55                   	push   %ebp
c0102d05:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102d0d:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d12:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102d14:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d19:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102d1b:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d20:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102d22:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d27:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102d29:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d2e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102d30:	ea 37 2d 10 c0 08 00 	ljmp   $0x8,$0xc0102d37
}
c0102d37:	90                   	nop
c0102d38:	5d                   	pop    %ebp
c0102d39:	c3                   	ret    

c0102d3a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102d3a:	f3 0f 1e fb          	endbr32 
c0102d3e:	55                   	push   %ebp
c0102d3f:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d44:	a3 a4 3e 12 c0       	mov    %eax,0xc0123ea4
}
c0102d49:	90                   	nop
c0102d4a:	5d                   	pop    %ebp
c0102d4b:	c3                   	ret    

c0102d4c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102d4c:	f3 0f 1e fb          	endbr32 
c0102d50:	55                   	push   %ebp
c0102d51:	89 e5                	mov    %esp,%ebp
c0102d53:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102d56:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0102d5b:	89 04 24             	mov    %eax,(%esp)
c0102d5e:	e8 d7 ff ff ff       	call   c0102d3a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102d63:	66 c7 05 a8 3e 12 c0 	movw   $0x10,0xc0123ea8
c0102d6a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102d6c:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c0102d73:	68 00 
c0102d75:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102d7a:	0f b7 c0             	movzwl %ax,%eax
c0102d7d:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c0102d83:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102d88:	c1 e8 10             	shr    $0x10,%eax
c0102d8b:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0102d90:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102d97:	24 f0                	and    $0xf0,%al
c0102d99:	0c 09                	or     $0x9,%al
c0102d9b:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102da0:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102da7:	24 ef                	and    $0xef,%al
c0102da9:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102dae:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102db5:	24 9f                	and    $0x9f,%al
c0102db7:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102dbc:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102dc3:	0c 80                	or     $0x80,%al
c0102dc5:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102dca:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102dd1:	24 f0                	and    $0xf0,%al
c0102dd3:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102dd8:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102ddf:	24 ef                	and    $0xef,%al
c0102de1:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102de6:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102ded:	24 df                	and    $0xdf,%al
c0102def:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102df4:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102dfb:	0c 40                	or     $0x40,%al
c0102dfd:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e02:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e09:	24 7f                	and    $0x7f,%al
c0102e0b:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e10:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102e15:	c1 e8 18             	shr    $0x18,%eax
c0102e18:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102e1d:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c0102e24:	e8 db fe ff ff       	call   c0102d04 <lgdt>
c0102e29:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102e2f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102e33:	0f 00 d8             	ltr    %ax
}
c0102e36:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102e37:	90                   	nop
c0102e38:	c9                   	leave  
c0102e39:	c3                   	ret    

c0102e3a <init_pmm_manager>:
/*-------------------------------------------------------------------------------------------*/
//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102e3a:	f3 0f 1e fb          	endbr32 
c0102e3e:	55                   	push   %ebp
c0102e3f:	89 e5                	mov    %esp,%ebp
c0102e41:	83 ec 18             	sub    $0x18,%esp
    // pmm_manager = &default_pmm_manager;
    pmm_manager = &buddy_pmm_manager;
c0102e44:	c7 05 10 40 12 c0 a4 	movl   $0xc0109ba4,0xc0124010
c0102e4b:	9b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102e4e:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102e53:	8b 00                	mov    (%eax),%eax
c0102e55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e59:	c7 04 24 b0 8c 10 c0 	movl   $0xc0108cb0,(%esp)
c0102e60:	e8 64 d4 ff ff       	call   c01002c9 <cprintf>
    pmm_manager->init();
c0102e65:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102e6a:	8b 40 04             	mov    0x4(%eax),%eax
c0102e6d:	ff d0                	call   *%eax
}
c0102e6f:	90                   	nop
c0102e70:	c9                   	leave  
c0102e71:	c3                   	ret    

c0102e72 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102e72:	f3 0f 1e fb          	endbr32 
c0102e76:	55                   	push   %ebp
c0102e77:	89 e5                	mov    %esp,%ebp
c0102e79:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102e7c:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102e81:	8b 40 08             	mov    0x8(%eax),%eax
c0102e84:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e87:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102e8b:	8b 55 08             	mov    0x8(%ebp),%edx
c0102e8e:	89 14 24             	mov    %edx,(%esp)
c0102e91:	ff d0                	call   *%eax
}
c0102e93:	90                   	nop
c0102e94:	c9                   	leave  
c0102e95:	c3                   	ret    

c0102e96 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102e96:	f3 0f 1e fb          	endbr32 
c0102e9a:	55                   	push   %ebp
c0102e9b:	89 e5                	mov    %esp,%ebp
c0102e9d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ea7:	e8 1a fe ff ff       	call   c0102cc6 <__intr_save>
c0102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102eaf:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102eb4:	8b 40 0c             	mov    0xc(%eax),%eax
c0102eb7:	8b 55 08             	mov    0x8(%ebp),%edx
c0102eba:	89 14 24             	mov    %edx,(%esp)
c0102ebd:	ff d0                	call   *%eax
c0102ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec5:	89 04 24             	mov    %eax,(%esp)
c0102ec8:	e8 23 fe ff ff       	call   c0102cf0 <__intr_restore>
    return page;
c0102ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102ed0:	c9                   	leave  
c0102ed1:	c3                   	ret    

c0102ed2 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102ed2:	f3 0f 1e fb          	endbr32 
c0102ed6:	55                   	push   %ebp
c0102ed7:	89 e5                	mov    %esp,%ebp
c0102ed9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102edc:	e8 e5 fd ff ff       	call   c0102cc6 <__intr_save>
c0102ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102ee4:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102ee9:	8b 40 10             	mov    0x10(%eax),%eax
c0102eec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102eef:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102ef3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ef6:	89 14 24             	mov    %edx,(%esp)
c0102ef9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efe:	89 04 24             	mov    %eax,(%esp)
c0102f01:	e8 ea fd ff ff       	call   c0102cf0 <__intr_restore>
}
c0102f06:	90                   	nop
c0102f07:	c9                   	leave  
c0102f08:	c3                   	ret    

c0102f09 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102f09:	f3 0f 1e fb          	endbr32 
c0102f0d:	55                   	push   %ebp
c0102f0e:	89 e5                	mov    %esp,%ebp
c0102f10:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f13:	e8 ae fd ff ff       	call   c0102cc6 <__intr_save>
c0102f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102f1b:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0102f20:	8b 40 14             	mov    0x14(%eax),%eax
c0102f23:	ff d0                	call   *%eax
c0102f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2b:	89 04 24             	mov    %eax,(%esp)
c0102f2e:	e8 bd fd ff ff       	call   c0102cf0 <__intr_restore>
    return ret;
c0102f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102f36:	c9                   	leave  
c0102f37:	c3                   	ret    

c0102f38 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102f38:	f3 0f 1e fb          	endbr32 
c0102f3c:	55                   	push   %ebp
c0102f3d:	89 e5                	mov    %esp,%ebp
c0102f3f:	57                   	push   %edi
c0102f40:	56                   	push   %esi
c0102f41:	53                   	push   %ebx
c0102f42:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102f48:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102f4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102f56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102f5d:	c7 04 24 c7 8c 10 c0 	movl   $0xc0108cc7,(%esp)
c0102f64:	e8 60 d3 ff ff       	call   c01002c9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f69:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f70:	e9 1a 01 00 00       	jmp    c010308f <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f75:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f78:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f7b:	89 d0                	mov    %edx,%eax
c0102f7d:	c1 e0 02             	shl    $0x2,%eax
c0102f80:	01 d0                	add    %edx,%eax
c0102f82:	c1 e0 02             	shl    $0x2,%eax
c0102f85:	01 c8                	add    %ecx,%eax
c0102f87:	8b 50 08             	mov    0x8(%eax),%edx
c0102f8a:	8b 40 04             	mov    0x4(%eax),%eax
c0102f8d:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102f90:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102f93:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f96:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f99:	89 d0                	mov    %edx,%eax
c0102f9b:	c1 e0 02             	shl    $0x2,%eax
c0102f9e:	01 d0                	add    %edx,%eax
c0102fa0:	c1 e0 02             	shl    $0x2,%eax
c0102fa3:	01 c8                	add    %ecx,%eax
c0102fa5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fa8:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fab:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fae:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102fb1:	01 c8                	add    %ecx,%eax
c0102fb3:	11 da                	adc    %ebx,%edx
c0102fb5:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102fb8:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102fbb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fc1:	89 d0                	mov    %edx,%eax
c0102fc3:	c1 e0 02             	shl    $0x2,%eax
c0102fc6:	01 d0                	add    %edx,%eax
c0102fc8:	c1 e0 02             	shl    $0x2,%eax
c0102fcb:	01 c8                	add    %ecx,%eax
c0102fcd:	83 c0 14             	add    $0x14,%eax
c0102fd0:	8b 00                	mov    (%eax),%eax
c0102fd2:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102fd5:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fd8:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102fdb:	83 c0 ff             	add    $0xffffffff,%eax
c0102fde:	83 d2 ff             	adc    $0xffffffff,%edx
c0102fe1:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102fe7:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ff3:	89 d0                	mov    %edx,%eax
c0102ff5:	c1 e0 02             	shl    $0x2,%eax
c0102ff8:	01 d0                	add    %edx,%eax
c0102ffa:	c1 e0 02             	shl    $0x2,%eax
c0102ffd:	01 c8                	add    %ecx,%eax
c0102fff:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103002:	8b 58 10             	mov    0x10(%eax),%ebx
c0103005:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103008:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c010300c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103012:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0103018:	89 44 24 14          	mov    %eax,0x14(%esp)
c010301c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0103020:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103023:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103026:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010302a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010302e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103032:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103036:	c7 04 24 d4 8c 10 c0 	movl   $0xc0108cd4,(%esp)
c010303d:	e8 87 d2 ff ff       	call   c01002c9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103042:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103045:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103048:	89 d0                	mov    %edx,%eax
c010304a:	c1 e0 02             	shl    $0x2,%eax
c010304d:	01 d0                	add    %edx,%eax
c010304f:	c1 e0 02             	shl    $0x2,%eax
c0103052:	01 c8                	add    %ecx,%eax
c0103054:	83 c0 14             	add    $0x14,%eax
c0103057:	8b 00                	mov    (%eax),%eax
c0103059:	83 f8 01             	cmp    $0x1,%eax
c010305c:	75 2e                	jne    c010308c <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c010305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103064:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103067:	89 d0                	mov    %edx,%eax
c0103069:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c010306c:	73 1e                	jae    c010308c <page_init+0x154>
c010306e:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103073:	b8 00 00 00 00       	mov    $0x0,%eax
c0103078:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c010307b:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c010307e:	72 0c                	jb     c010308c <page_init+0x154>
                maxpa = end;
c0103080:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103083:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103086:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103089:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c010308c:	ff 45 dc             	incl   -0x24(%ebp)
c010308f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103092:	8b 00                	mov    (%eax),%eax
c0103094:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103097:	0f 8c d8 fe ff ff    	jl     c0102f75 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010309d:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01030a2:	b8 00 00 00 00       	mov    $0x0,%eax
c01030a7:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c01030aa:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c01030ad:	73 0e                	jae    c01030bd <page_init+0x185>
        maxpa = KMEMSIZE;
c01030af:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01030b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01030bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01030c3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030c7:	c1 ea 0c             	shr    $0xc,%edx
c01030ca:	a3 80 3e 12 c0       	mov    %eax,0xc0123e80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01030cf:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01030d6:	b8 60 aa 2a c0       	mov    $0xc02aaa60,%eax
c01030db:	8d 50 ff             	lea    -0x1(%eax),%edx
c01030de:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01030e1:	01 d0                	add    %edx,%eax
c01030e3:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01030e6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01030e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01030ee:	f7 75 c0             	divl   -0x40(%ebp)
c01030f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01030f4:	29 d0                	sub    %edx,%eax
c01030f6:	a3 18 40 12 c0       	mov    %eax,0xc0124018

    for (i = 0; i < npage; i ++) {
c01030fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103102:	eb 2f                	jmp    c0103133 <page_init+0x1fb>
        SetPageReserved(pages + i);
c0103104:	8b 0d 18 40 12 c0    	mov    0xc0124018,%ecx
c010310a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010310d:	89 d0                	mov    %edx,%eax
c010310f:	c1 e0 02             	shl    $0x2,%eax
c0103112:	01 d0                	add    %edx,%eax
c0103114:	c1 e0 02             	shl    $0x2,%eax
c0103117:	01 c8                	add    %ecx,%eax
c0103119:	83 c0 04             	add    $0x4,%eax
c010311c:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103123:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103126:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103129:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010312c:	0f ab 10             	bts    %edx,(%eax)
}
c010312f:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103130:	ff 45 dc             	incl   -0x24(%ebp)
c0103133:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103136:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c010313b:	39 c2                	cmp    %eax,%edx
c010313d:	72 c5                	jb     c0103104 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010313f:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0103145:	89 d0                	mov    %edx,%eax
c0103147:	c1 e0 02             	shl    $0x2,%eax
c010314a:	01 d0                	add    %edx,%eax
c010314c:	c1 e0 02             	shl    $0x2,%eax
c010314f:	89 c2                	mov    %eax,%edx
c0103151:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c0103156:	01 d0                	add    %edx,%eax
c0103158:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010315b:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103162:	77 23                	ja     c0103187 <page_init+0x24f>
c0103164:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103167:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010316b:	c7 44 24 08 04 8d 10 	movl   $0xc0108d04,0x8(%esp)
c0103172:	c0 
c0103173:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010317a:	00 
c010317b:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103182:	e8 ae d2 ff ff       	call   c0100435 <__panic>
c0103187:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010318a:	05 00 00 00 40       	add    $0x40000000,%eax
c010318f:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103192:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103199:	e9 4b 01 00 00       	jmp    c01032e9 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010319e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031a4:	89 d0                	mov    %edx,%eax
c01031a6:	c1 e0 02             	shl    $0x2,%eax
c01031a9:	01 d0                	add    %edx,%eax
c01031ab:	c1 e0 02             	shl    $0x2,%eax
c01031ae:	01 c8                	add    %ecx,%eax
c01031b0:	8b 50 08             	mov    0x8(%eax),%edx
c01031b3:	8b 40 04             	mov    0x4(%eax),%eax
c01031b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01031b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01031bc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031c2:	89 d0                	mov    %edx,%eax
c01031c4:	c1 e0 02             	shl    $0x2,%eax
c01031c7:	01 d0                	add    %edx,%eax
c01031c9:	c1 e0 02             	shl    $0x2,%eax
c01031cc:	01 c8                	add    %ecx,%eax
c01031ce:	8b 48 0c             	mov    0xc(%eax),%ecx
c01031d1:	8b 58 10             	mov    0x10(%eax),%ebx
c01031d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031da:	01 c8                	add    %ecx,%eax
c01031dc:	11 da                	adc    %ebx,%edx
c01031de:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01031e1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01031e4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031ea:	89 d0                	mov    %edx,%eax
c01031ec:	c1 e0 02             	shl    $0x2,%eax
c01031ef:	01 d0                	add    %edx,%eax
c01031f1:	c1 e0 02             	shl    $0x2,%eax
c01031f4:	01 c8                	add    %ecx,%eax
c01031f6:	83 c0 14             	add    $0x14,%eax
c01031f9:	8b 00                	mov    (%eax),%eax
c01031fb:	83 f8 01             	cmp    $0x1,%eax
c01031fe:	0f 85 e2 00 00 00    	jne    c01032e6 <page_init+0x3ae>
            if (begin < freemem) {
c0103204:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103207:	ba 00 00 00 00       	mov    $0x0,%edx
c010320c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010320f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103212:	19 d1                	sbb    %edx,%ecx
c0103214:	73 0d                	jae    c0103223 <page_init+0x2eb>
                begin = freemem;
c0103216:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103219:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010321c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103223:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103228:	b8 00 00 00 00       	mov    $0x0,%eax
c010322d:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103230:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103233:	73 0e                	jae    c0103243 <page_init+0x30b>
                end = KMEMSIZE;
c0103235:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010323c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103243:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103246:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103249:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010324c:	89 d0                	mov    %edx,%eax
c010324e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103251:	0f 83 8f 00 00 00    	jae    c01032e6 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c0103257:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010325e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103261:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103264:	01 d0                	add    %edx,%eax
c0103266:	48                   	dec    %eax
c0103267:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010326a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010326d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103272:	f7 75 b0             	divl   -0x50(%ebp)
c0103275:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103278:	29 d0                	sub    %edx,%eax
c010327a:	ba 00 00 00 00       	mov    $0x0,%edx
c010327f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103282:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103285:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103288:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010328b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010328e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103293:	89 c3                	mov    %eax,%ebx
c0103295:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010329b:	89 de                	mov    %ebx,%esi
c010329d:	89 d0                	mov    %edx,%eax
c010329f:	83 e0 00             	and    $0x0,%eax
c01032a2:	89 c7                	mov    %eax,%edi
c01032a4:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01032a7:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01032aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032b0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01032b3:	89 d0                	mov    %edx,%eax
c01032b5:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01032b8:	73 2c                	jae    c01032e6 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01032ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01032bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01032c0:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01032c3:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01032c6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01032ca:	c1 ea 0c             	shr    $0xc,%edx
c01032cd:	89 c3                	mov    %eax,%ebx
c01032cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032d2:	89 04 24             	mov    %eax,(%esp)
c01032d5:	e8 ad f8 ff ff       	call   c0102b87 <pa2page>
c01032da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01032de:	89 04 24             	mov    %eax,(%esp)
c01032e1:	e8 8c fb ff ff       	call   c0102e72 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01032e6:	ff 45 dc             	incl   -0x24(%ebp)
c01032e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032ec:	8b 00                	mov    (%eax),%eax
c01032ee:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032f1:	0f 8c a7 fe ff ff    	jl     c010319e <page_init+0x266>
                }
            }
        }
    }
}
c01032f7:	90                   	nop
c01032f8:	90                   	nop
c01032f9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01032ff:	5b                   	pop    %ebx
c0103300:	5e                   	pop    %esi
c0103301:	5f                   	pop    %edi
c0103302:	5d                   	pop    %ebp
c0103303:	c3                   	ret    

c0103304 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103304:	f3 0f 1e fb          	endbr32 
c0103308:	55                   	push   %ebp
c0103309:	89 e5                	mov    %esp,%ebp
c010330b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010330e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103311:	33 45 14             	xor    0x14(%ebp),%eax
c0103314:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103319:	85 c0                	test   %eax,%eax
c010331b:	74 24                	je     c0103341 <boot_map_segment+0x3d>
c010331d:	c7 44 24 0c 36 8d 10 	movl   $0xc0108d36,0xc(%esp)
c0103324:	c0 
c0103325:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c010332c:	c0 
c010332d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103334:	00 
c0103335:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c010333c:	e8 f4 d0 ff ff       	call   c0100435 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103341:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010334b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103350:	89 c2                	mov    %eax,%edx
c0103352:	8b 45 10             	mov    0x10(%ebp),%eax
c0103355:	01 c2                	add    %eax,%edx
c0103357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010335a:	01 d0                	add    %edx,%eax
c010335c:	48                   	dec    %eax
c010335d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103360:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103363:	ba 00 00 00 00       	mov    $0x0,%edx
c0103368:	f7 75 f0             	divl   -0x10(%ebp)
c010336b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010336e:	29 d0                	sub    %edx,%eax
c0103370:	c1 e8 0c             	shr    $0xc,%eax
c0103373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103376:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103379:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103384:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103387:	8b 45 14             	mov    0x14(%ebp),%eax
c010338a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010338d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103390:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103395:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103398:	eb 68                	jmp    c0103402 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010339a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01033a1:	00 
c01033a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033ac:	89 04 24             	mov    %eax,(%esp)
c01033af:	e8 8a 01 00 00       	call   c010353e <get_pte>
c01033b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01033b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01033bb:	75 24                	jne    c01033e1 <boot_map_segment+0xdd>
c01033bd:	c7 44 24 0c 62 8d 10 	movl   $0xc0108d62,0xc(%esp)
c01033c4:	c0 
c01033c5:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01033cc:	c0 
c01033cd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01033d4:	00 
c01033d5:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01033dc:	e8 54 d0 ff ff       	call   c0100435 <__panic>
        *ptep = pa | PTE_P | perm;
c01033e1:	8b 45 14             	mov    0x14(%ebp),%eax
c01033e4:	0b 45 18             	or     0x18(%ebp),%eax
c01033e7:	83 c8 01             	or     $0x1,%eax
c01033ea:	89 c2                	mov    %eax,%edx
c01033ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033ef:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01033f1:	ff 4d f4             	decl   -0xc(%ebp)
c01033f4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01033fb:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103406:	75 92                	jne    c010339a <boot_map_segment+0x96>
    }
}
c0103408:	90                   	nop
c0103409:	90                   	nop
c010340a:	c9                   	leave  
c010340b:	c3                   	ret    

c010340c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010340c:	f3 0f 1e fb          	endbr32 
c0103410:	55                   	push   %ebp
c0103411:	89 e5                	mov    %esp,%ebp
c0103413:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103416:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010341d:	e8 74 fa ff ff       	call   c0102e96 <alloc_pages>
c0103422:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103429:	75 1c                	jne    c0103447 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c010342b:	c7 44 24 08 6f 8d 10 	movl   $0xc0108d6f,0x8(%esp)
c0103432:	c0 
c0103433:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010343a:	00 
c010343b:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103442:	e8 ee cf ff ff       	call   c0100435 <__panic>
    }
    return page2kva(p);
c0103447:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010344a:	89 04 24             	mov    %eax,(%esp)
c010344d:	e8 84 f7 ff ff       	call   c0102bd6 <page2kva>
}
c0103452:	c9                   	leave  
c0103453:	c3                   	ret    

c0103454 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103454:	f3 0f 1e fb          	endbr32 
c0103458:	55                   	push   %ebp
c0103459:	89 e5                	mov    %esp,%ebp
c010345b:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010345e:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103463:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103466:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010346d:	77 23                	ja     c0103492 <pmm_init+0x3e>
c010346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103472:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103476:	c7 44 24 08 04 8d 10 	movl   $0xc0108d04,0x8(%esp)
c010347d:	c0 
c010347e:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103485:	00 
c0103486:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c010348d:	e8 a3 cf ff ff       	call   c0100435 <__panic>
c0103492:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103495:	05 00 00 00 40       	add    $0x40000000,%eax
c010349a:	a3 14 40 12 c0       	mov    %eax,0xc0124014
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010349f:	e8 96 f9 ff ff       	call   c0102e3a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01034a4:	e8 8f fa ff ff       	call   c0102f38 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01034a9:	e8 f3 03 00 00       	call   c01038a1 <check_alloc_page>

    check_pgdir();
c01034ae:	e8 11 04 00 00       	call   c01038c4 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01034b3:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01034b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034bb:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01034c2:	77 23                	ja     c01034e7 <pmm_init+0x93>
c01034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034cb:	c7 44 24 08 04 8d 10 	movl   $0xc0108d04,0x8(%esp)
c01034d2:	c0 
c01034d3:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01034da:	00 
c01034db:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01034e2:	e8 4e cf ff ff       	call   c0100435 <__panic>
c01034e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034ea:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01034f0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01034f5:	05 ac 0f 00 00       	add    $0xfac,%eax
c01034fa:	83 ca 03             	or     $0x3,%edx
c01034fd:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01034ff:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103504:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010350b:	00 
c010350c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103513:	00 
c0103514:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010351b:	38 
c010351c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103523:	c0 
c0103524:	89 04 24             	mov    %eax,(%esp)
c0103527:	e8 d8 fd ff ff       	call   c0103304 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010352c:	e8 1b f8 ff ff       	call   c0102d4c <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103531:	e8 2e 0a 00 00       	call   c0103f64 <check_boot_pgdir>

    print_pgdir();
c0103536:	e8 b3 0e 00 00       	call   c01043ee <print_pgdir>

}
c010353b:	90                   	nop
c010353c:	c9                   	leave  
c010353d:	c3                   	ret    

c010353e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010353e:	f3 0f 1e fb          	endbr32 
c0103542:	55                   	push   %ebp
c0103543:	89 e5                	mov    %esp,%ebp
c0103545:	83 ec 38             	sub    $0x38,%esp
        }
        return NULL;          // (8) return page table entry
    #endif

    //代码实现部分8steps
    pde_t *pdep = &pgdir[PDX(la)];                      //取出1级表项,两个过程: 1. 线性虚拟地址la >> 页目录索引 PDX(la) ((((uintptr_t)(la)) >> PDXSHIFT) & 0x3FF)
c0103548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010354b:	c1 e8 16             	shr    $0x16,%eax
c010354e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103555:	8b 45 08             	mov    0x8(%ebp),%eax
c0103558:	01 d0                	add    %edx,%eax
c010355a:	89 45 f4             	mov    %eax,-0xc(%ebp)
                                                        //2.用页目录索引PDX查找页目录pgdir
    if (!(*pdep & PTE_P)) {                             //检查项是否不存在 PTE_P 页目录或页表的 Present 位
c010355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103560:	8b 00                	mov    (%eax),%eax
c0103562:	83 e0 01             	and    $0x1,%eax
c0103565:	85 c0                	test   %eax,%eax
c0103567:	0f 85 af 00 00 00    	jne    c010361c <get_pte+0xde>
        struct Page *page;                              //不存在则构建
        if (!create || (page = alloc_page()) == NULL) { //构建失败
c010356d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103571:	74 15                	je     c0103588 <get_pte+0x4a>
c0103573:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010357a:	e8 17 f9 ff ff       	call   c0102e96 <alloc_pages>
c010357f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103586:	75 0a                	jne    c0103592 <get_pte+0x54>
            return NULL;
c0103588:	b8 00 00 00 00       	mov    $0x0,%eax
c010358d:	e9 e7 00 00 00       	jmp    c0103679 <get_pte+0x13b>
        }
        set_page_ref(page, 1);                          //设置引用计数, 被映射了多少次                             
c0103592:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103599:	00 
c010359a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010359d:	89 04 24             	mov    %eax,(%esp)
c01035a0:	e8 e5 f6 ff ff       	call   c0102c8a <set_page_ref>
        uintptr_t pa = page2pa(page);                   //取物理地址, page2ppn(page) << PGSHIFT;
c01035a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035a8:	89 04 24             	mov    %eax,(%esp)
c01035ab:	e8 c1 f5 ff ff       	call   c0102b71 <page2pa>
c01035b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                   //clear清零页面
c01035b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01035b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035bc:	c1 e8 0c             	shr    $0xc,%eax
c01035bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01035c2:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01035c7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01035ca:	72 23                	jb     c01035ef <get_pte+0xb1>
c01035cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01035d3:	c7 44 24 08 60 8c 10 	movl   $0xc0108c60,0x8(%esp)
c01035da:	c0 
c01035db:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
c01035e2:	00 
c01035e3:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01035ea:	e8 46 ce ff ff       	call   c0100435 <__panic>
c01035ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035f2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01035f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01035fe:	00 
c01035ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103606:	00 
c0103607:	89 04 24             	mov    %eax,(%esp)
c010360a:	e8 99 46 00 00       	call   c0107ca8 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;             //设置页面目录条目的权限,
c010360f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103612:	83 c8 07             	or     $0x7,%eax
c0103615:	89 c2                	mov    %eax,%edx
c0103617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361a:	89 10                	mov    %edx,(%eax)
                                                        // PTE_U: 位3，表示用户态的软件可以读取对应地址的物理内存页内容
                                                        // PTE_W: 位2，表示物理内存页内容可写
                                                        // PTE_P: 位1，表示物理内存页存在
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; //返回虚拟地址, KADDR: pa >> va, PTX: la >> 页目录索引
c010361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361f:	8b 00                	mov    (%eax),%eax
c0103621:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103626:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103629:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010362c:	c1 e8 0c             	shr    $0xc,%eax
c010362f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103632:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0103637:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010363a:	72 23                	jb     c010365f <get_pte+0x121>
c010363c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010363f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103643:	c7 44 24 08 60 8c 10 	movl   $0xc0108c60,0x8(%esp)
c010364a:	c0 
c010364b:	c7 44 24 04 7d 01 00 	movl   $0x17d,0x4(%esp)
c0103652:	00 
c0103653:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c010365a:	e8 d6 cd ff ff       	call   c0100435 <__panic>
c010365f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103662:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103667:	89 c2                	mov    %eax,%edx
c0103669:	8b 45 0c             	mov    0xc(%ebp),%eax
c010366c:	c1 e8 0c             	shr    $0xc,%eax
c010366f:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103674:	c1 e0 02             	shl    $0x2,%eax
c0103677:	01 d0                	add    %edx,%eax
}
c0103679:	c9                   	leave  
c010367a:	c3                   	ret    

c010367b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010367b:	f3 0f 1e fb          	endbr32 
c010367f:	55                   	push   %ebp
c0103680:	89 e5                	mov    %esp,%ebp
c0103682:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103685:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010368c:	00 
c010368d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103690:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103694:	8b 45 08             	mov    0x8(%ebp),%eax
c0103697:	89 04 24             	mov    %eax,(%esp)
c010369a:	e8 9f fe ff ff       	call   c010353e <get_pte>
c010369f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01036a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01036a6:	74 08                	je     c01036b0 <get_page+0x35>
        *ptep_store = ptep;
c01036a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01036ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036ae:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01036b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036b4:	74 1b                	je     c01036d1 <get_page+0x56>
c01036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b9:	8b 00                	mov    (%eax),%eax
c01036bb:	83 e0 01             	and    $0x1,%eax
c01036be:	85 c0                	test   %eax,%eax
c01036c0:	74 0f                	je     c01036d1 <get_page+0x56>
        return pte2page(*ptep);
c01036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c5:	8b 00                	mov    (%eax),%eax
c01036c7:	89 04 24             	mov    %eax,(%esp)
c01036ca:	e8 5b f5 ff ff       	call   c0102c2a <pte2page>
c01036cf:	eb 05                	jmp    c01036d6 <get_page+0x5b>
    }
    return NULL;
c01036d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01036d6:	c9                   	leave  
c01036d7:	c3                   	ret    

c01036d8 <page_remove_pte>:
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 

//释放某虚地址所在的页并取消对应二级页表项的映射
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01036d8:	55                   	push   %ebp
c01036d9:	89 e5                	mov    %esp,%ebp
c01036db:	83 ec 28             	sub    $0x28,%esp
                                    //(6) flush tlb
        }
    #endif

    //具体实现
    if (*ptep & PTE_P) {                        //检查当前页表项是否存在
c01036de:	8b 45 10             	mov    0x10(%ebp),%eax
c01036e1:	8b 00                	mov    (%eax),%eax
c01036e3:	83 e0 01             	and    $0x1,%eax
c01036e6:	85 c0                	test   %eax,%eax
c01036e8:	74 4d                	je     c0103737 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);    //找到pte对应的页面
c01036ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01036ed:	8b 00                	mov    (%eax),%eax
c01036ef:	89 04 24             	mov    %eax,(%esp)
c01036f2:	e8 33 f5 ff ff       	call   c0102c2a <pte2page>
c01036f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {          //如果当前页面只被引用了0次
c01036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036fd:	89 04 24             	mov    %eax,(%esp)
c0103700:	e8 aa f5 ff ff       	call   c0102caf <page_ref_dec>
c0103705:	85 c0                	test   %eax,%eax
c0103707:	75 13                	jne    c010371c <page_remove_pte+0x44>
            free_page(page);                    //那么直接释放该页     
c0103709:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103710:	00 
c0103711:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103714:	89 04 24             	mov    %eax,(%esp)
c0103717:	e8 b6 f7 ff ff       	call   c0102ed2 <free_pages>
        }
        *ptep = 0;                              
c010371c:	8b 45 10             	mov    0x10(%ebp),%eax
c010371f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);              //刷新TLB, 使TLB条目无效
c0103725:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103728:	89 44 24 04          	mov    %eax,0x4(%esp)
c010372c:	8b 45 08             	mov    0x8(%ebp),%eax
c010372f:	89 04 24             	mov    %eax,(%esp)
c0103732:	e8 09 01 00 00       	call   c0103840 <tlb_invalidate>
    }
}
c0103737:	90                   	nop
c0103738:	c9                   	leave  
c0103739:	c3                   	ret    

c010373a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010373a:	f3 0f 1e fb          	endbr32 
c010373e:	55                   	push   %ebp
c010373f:	89 e5                	mov    %esp,%ebp
c0103741:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103744:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010374b:	00 
c010374c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010374f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103753:	8b 45 08             	mov    0x8(%ebp),%eax
c0103756:	89 04 24             	mov    %eax,(%esp)
c0103759:	e8 e0 fd ff ff       	call   c010353e <get_pte>
c010375e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103765:	74 19                	je     c0103780 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c0103767:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010376e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103771:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103775:	8b 45 08             	mov    0x8(%ebp),%eax
c0103778:	89 04 24             	mov    %eax,(%esp)
c010377b:	e8 58 ff ff ff       	call   c01036d8 <page_remove_pte>
    }
}
c0103780:	90                   	nop
c0103781:	c9                   	leave  
c0103782:	c3                   	ret    

c0103783 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103783:	f3 0f 1e fb          	endbr32 
c0103787:	55                   	push   %ebp
c0103788:	89 e5                	mov    %esp,%ebp
c010378a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010378d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103794:	00 
c0103795:	8b 45 10             	mov    0x10(%ebp),%eax
c0103798:	89 44 24 04          	mov    %eax,0x4(%esp)
c010379c:	8b 45 08             	mov    0x8(%ebp),%eax
c010379f:	89 04 24             	mov    %eax,(%esp)
c01037a2:	e8 97 fd ff ff       	call   c010353e <get_pte>
c01037a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01037aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037ae:	75 0a                	jne    c01037ba <page_insert+0x37>
        return -E_NO_MEM;
c01037b0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01037b5:	e9 84 00 00 00       	jmp    c010383e <page_insert+0xbb>
    }
    page_ref_inc(page);
c01037ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037bd:	89 04 24             	mov    %eax,(%esp)
c01037c0:	e8 d3 f4 ff ff       	call   c0102c98 <page_ref_inc>
    if (*ptep & PTE_P) {
c01037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c8:	8b 00                	mov    (%eax),%eax
c01037ca:	83 e0 01             	and    $0x1,%eax
c01037cd:	85 c0                	test   %eax,%eax
c01037cf:	74 3e                	je     c010380f <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c01037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d4:	8b 00                	mov    (%eax),%eax
c01037d6:	89 04 24             	mov    %eax,(%esp)
c01037d9:	e8 4c f4 ff ff       	call   c0102c2a <pte2page>
c01037de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01037e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01037e7:	75 0d                	jne    c01037f6 <page_insert+0x73>
            page_ref_dec(page);
c01037e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037ec:	89 04 24             	mov    %eax,(%esp)
c01037ef:	e8 bb f4 ff ff       	call   c0102caf <page_ref_dec>
c01037f4:	eb 19                	jmp    c010380f <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01037fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0103800:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103804:	8b 45 08             	mov    0x8(%ebp),%eax
c0103807:	89 04 24             	mov    %eax,(%esp)
c010380a:	e8 c9 fe ff ff       	call   c01036d8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010380f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103812:	89 04 24             	mov    %eax,(%esp)
c0103815:	e8 57 f3 ff ff       	call   c0102b71 <page2pa>
c010381a:	0b 45 14             	or     0x14(%ebp),%eax
c010381d:	83 c8 01             	or     $0x1,%eax
c0103820:	89 c2                	mov    %eax,%edx
c0103822:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103825:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103827:	8b 45 10             	mov    0x10(%ebp),%eax
c010382a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010382e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103831:	89 04 24             	mov    %eax,(%esp)
c0103834:	e8 07 00 00 00       	call   c0103840 <tlb_invalidate>
    return 0;
c0103839:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010383e:	c9                   	leave  
c010383f:	c3                   	ret    

c0103840 <tlb_invalidate>:
// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//使一个TLB条目无效，但仅当页表存在
//编辑的是处理器当前正在使用的
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103840:	f3 0f 1e fb          	endbr32 
c0103844:	55                   	push   %ebp
c0103845:	89 e5                	mov    %esp,%ebp
c0103847:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010384a:	0f 20 d8             	mov    %cr3,%eax
c010384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103850:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103853:	8b 45 08             	mov    0x8(%ebp),%eax
c0103856:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103859:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103860:	77 23                	ja     c0103885 <tlb_invalidate+0x45>
c0103862:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103865:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103869:	c7 44 24 08 04 8d 10 	movl   $0xc0108d04,0x8(%esp)
c0103870:	c0 
c0103871:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103878:	00 
c0103879:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103880:	e8 b0 cb ff ff       	call   c0100435 <__panic>
c0103885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103888:	05 00 00 00 40       	add    $0x40000000,%eax
c010388d:	39 d0                	cmp    %edx,%eax
c010388f:	75 0d                	jne    c010389e <tlb_invalidate+0x5e>
        invlpg((void *)la);
c0103891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103894:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103897:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010389a:	0f 01 38             	invlpg (%eax)
}
c010389d:	90                   	nop
    }
}
c010389e:	90                   	nop
c010389f:	c9                   	leave  
c01038a0:	c3                   	ret    

c01038a1 <check_alloc_page>:

static void
check_alloc_page(void) {
c01038a1:	f3 0f 1e fb          	endbr32 
c01038a5:	55                   	push   %ebp
c01038a6:	89 e5                	mov    %esp,%ebp
c01038a8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01038ab:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c01038b0:	8b 40 18             	mov    0x18(%eax),%eax
c01038b3:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01038b5:	c7 04 24 88 8d 10 c0 	movl   $0xc0108d88,(%esp)
c01038bc:	e8 08 ca ff ff       	call   c01002c9 <cprintf>
}
c01038c1:	90                   	nop
c01038c2:	c9                   	leave  
c01038c3:	c3                   	ret    

c01038c4 <check_pgdir>:

static void
check_pgdir(void) {
c01038c4:	f3 0f 1e fb          	endbr32 
c01038c8:	55                   	push   %ebp
c01038c9:	89 e5                	mov    %esp,%ebp
c01038cb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01038ce:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01038d3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01038d8:	76 24                	jbe    c01038fe <check_pgdir+0x3a>
c01038da:	c7 44 24 0c a7 8d 10 	movl   $0xc0108da7,0xc(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01038f1:	00 
c01038f2:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01038f9:	e8 37 cb ff ff       	call   c0100435 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01038fe:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103903:	85 c0                	test   %eax,%eax
c0103905:	74 0e                	je     c0103915 <check_pgdir+0x51>
c0103907:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010390c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103911:	85 c0                	test   %eax,%eax
c0103913:	74 24                	je     c0103939 <check_pgdir+0x75>
c0103915:	c7 44 24 0c c4 8d 10 	movl   $0xc0108dc4,0xc(%esp)
c010391c:	c0 
c010391d:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103924:	c0 
c0103925:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c010392c:	00 
c010392d:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103934:	e8 fc ca ff ff       	call   c0100435 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103939:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010393e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103945:	00 
c0103946:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010394d:	00 
c010394e:	89 04 24             	mov    %eax,(%esp)
c0103951:	e8 25 fd ff ff       	call   c010367b <get_page>
c0103956:	85 c0                	test   %eax,%eax
c0103958:	74 24                	je     c010397e <check_pgdir+0xba>
c010395a:	c7 44 24 0c fc 8d 10 	movl   $0xc0108dfc,0xc(%esp)
c0103961:	c0 
c0103962:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103969:	c0 
c010396a:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103971:	00 
c0103972:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103979:	e8 b7 ca ff ff       	call   c0100435 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010397e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103985:	e8 0c f5 ff ff       	call   c0102e96 <alloc_pages>
c010398a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010398d:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103992:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103999:	00 
c010399a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039a1:	00 
c01039a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039a9:	89 04 24             	mov    %eax,(%esp)
c01039ac:	e8 d2 fd ff ff       	call   c0103783 <page_insert>
c01039b1:	85 c0                	test   %eax,%eax
c01039b3:	74 24                	je     c01039d9 <check_pgdir+0x115>
c01039b5:	c7 44 24 0c 24 8e 10 	movl   $0xc0108e24,0xc(%esp)
c01039bc:	c0 
c01039bd:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01039c4:	c0 
c01039c5:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01039cc:	00 
c01039cd:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01039d4:	e8 5c ca ff ff       	call   c0100435 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01039d9:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01039de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039e5:	00 
c01039e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039ed:	00 
c01039ee:	89 04 24             	mov    %eax,(%esp)
c01039f1:	e8 48 fb ff ff       	call   c010353e <get_pte>
c01039f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039fd:	75 24                	jne    c0103a23 <check_pgdir+0x15f>
c01039ff:	c7 44 24 0c 50 8e 10 	movl   $0xc0108e50,0xc(%esp)
c0103a06:	c0 
c0103a07:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103a0e:	c0 
c0103a0f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103a16:	00 
c0103a17:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103a1e:	e8 12 ca ff ff       	call   c0100435 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a26:	8b 00                	mov    (%eax),%eax
c0103a28:	89 04 24             	mov    %eax,(%esp)
c0103a2b:	e8 fa f1 ff ff       	call   c0102c2a <pte2page>
c0103a30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a33:	74 24                	je     c0103a59 <check_pgdir+0x195>
c0103a35:	c7 44 24 0c 7d 8e 10 	movl   $0xc0108e7d,0xc(%esp)
c0103a3c:	c0 
c0103a3d:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103a44:	c0 
c0103a45:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103a4c:	00 
c0103a4d:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103a54:	e8 dc c9 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p1) == 1);
c0103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5c:	89 04 24             	mov    %eax,(%esp)
c0103a5f:	e8 1c f2 ff ff       	call   c0102c80 <page_ref>
c0103a64:	83 f8 01             	cmp    $0x1,%eax
c0103a67:	74 24                	je     c0103a8d <check_pgdir+0x1c9>
c0103a69:	c7 44 24 0c 93 8e 10 	movl   $0xc0108e93,0xc(%esp)
c0103a70:	c0 
c0103a71:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103a78:	c0 
c0103a79:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103a80:	00 
c0103a81:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103a88:	e8 a8 c9 ff ff       	call   c0100435 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103a8d:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103a92:	8b 00                	mov    (%eax),%eax
c0103a94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a9f:	c1 e8 0c             	shr    $0xc,%eax
c0103aa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103aa5:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0103aaa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103aad:	72 23                	jb     c0103ad2 <check_pgdir+0x20e>
c0103aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ab2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ab6:	c7 44 24 08 60 8c 10 	movl   $0xc0108c60,0x8(%esp)
c0103abd:	c0 
c0103abe:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103ac5:	00 
c0103ac6:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103acd:	e8 63 c9 ff ff       	call   c0100435 <__panic>
c0103ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ad5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103ada:	83 c0 04             	add    $0x4,%eax
c0103add:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103ae0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103ae5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103aec:	00 
c0103aed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103af4:	00 
c0103af5:	89 04 24             	mov    %eax,(%esp)
c0103af8:	e8 41 fa ff ff       	call   c010353e <get_pte>
c0103afd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b00:	74 24                	je     c0103b26 <check_pgdir+0x262>
c0103b02:	c7 44 24 0c a8 8e 10 	movl   $0xc0108ea8,0xc(%esp)
c0103b09:	c0 
c0103b0a:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103b11:	c0 
c0103b12:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103b19:	00 
c0103b1a:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103b21:	e8 0f c9 ff ff       	call   c0100435 <__panic>

    p2 = alloc_page();
c0103b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b2d:	e8 64 f3 ff ff       	call   c0102e96 <alloc_pages>
c0103b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103b35:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103b3a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103b41:	00 
c0103b42:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b49:	00 
c0103b4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b51:	89 04 24             	mov    %eax,(%esp)
c0103b54:	e8 2a fc ff ff       	call   c0103783 <page_insert>
c0103b59:	85 c0                	test   %eax,%eax
c0103b5b:	74 24                	je     c0103b81 <check_pgdir+0x2bd>
c0103b5d:	c7 44 24 0c d0 8e 10 	movl   $0xc0108ed0,0xc(%esp)
c0103b64:	c0 
c0103b65:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103b6c:	c0 
c0103b6d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103b74:	00 
c0103b75:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103b7c:	e8 b4 c8 ff ff       	call   c0100435 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103b81:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103b86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b8d:	00 
c0103b8e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b95:	00 
c0103b96:	89 04 24             	mov    %eax,(%esp)
c0103b99:	e8 a0 f9 ff ff       	call   c010353e <get_pte>
c0103b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ba5:	75 24                	jne    c0103bcb <check_pgdir+0x307>
c0103ba7:	c7 44 24 0c 08 8f 10 	movl   $0xc0108f08,0xc(%esp)
c0103bae:	c0 
c0103baf:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103bb6:	c0 
c0103bb7:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103bbe:	00 
c0103bbf:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103bc6:	e8 6a c8 ff ff       	call   c0100435 <__panic>
    assert(*ptep & PTE_U);
c0103bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bce:	8b 00                	mov    (%eax),%eax
c0103bd0:	83 e0 04             	and    $0x4,%eax
c0103bd3:	85 c0                	test   %eax,%eax
c0103bd5:	75 24                	jne    c0103bfb <check_pgdir+0x337>
c0103bd7:	c7 44 24 0c 38 8f 10 	movl   $0xc0108f38,0xc(%esp)
c0103bde:	c0 
c0103bdf:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103be6:	c0 
c0103be7:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103bee:	00 
c0103bef:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103bf6:	e8 3a c8 ff ff       	call   c0100435 <__panic>
    assert(*ptep & PTE_W);
c0103bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bfe:	8b 00                	mov    (%eax),%eax
c0103c00:	83 e0 02             	and    $0x2,%eax
c0103c03:	85 c0                	test   %eax,%eax
c0103c05:	75 24                	jne    c0103c2b <check_pgdir+0x367>
c0103c07:	c7 44 24 0c 46 8f 10 	movl   $0xc0108f46,0xc(%esp)
c0103c0e:	c0 
c0103c0f:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103c16:	c0 
c0103c17:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103c1e:	00 
c0103c1f:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103c26:	e8 0a c8 ff ff       	call   c0100435 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103c2b:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103c30:	8b 00                	mov    (%eax),%eax
c0103c32:	83 e0 04             	and    $0x4,%eax
c0103c35:	85 c0                	test   %eax,%eax
c0103c37:	75 24                	jne    c0103c5d <check_pgdir+0x399>
c0103c39:	c7 44 24 0c 54 8f 10 	movl   $0xc0108f54,0xc(%esp)
c0103c40:	c0 
c0103c41:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103c48:	c0 
c0103c49:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103c50:	00 
c0103c51:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103c58:	e8 d8 c7 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p2) == 1);
c0103c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c60:	89 04 24             	mov    %eax,(%esp)
c0103c63:	e8 18 f0 ff ff       	call   c0102c80 <page_ref>
c0103c68:	83 f8 01             	cmp    $0x1,%eax
c0103c6b:	74 24                	je     c0103c91 <check_pgdir+0x3cd>
c0103c6d:	c7 44 24 0c 6a 8f 10 	movl   $0xc0108f6a,0xc(%esp)
c0103c74:	c0 
c0103c75:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103c7c:	c0 
c0103c7d:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103c84:	00 
c0103c85:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103c8c:	e8 a4 c7 ff ff       	call   c0100435 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103c91:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103c96:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103c9d:	00 
c0103c9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103ca5:	00 
c0103ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ca9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cad:	89 04 24             	mov    %eax,(%esp)
c0103cb0:	e8 ce fa ff ff       	call   c0103783 <page_insert>
c0103cb5:	85 c0                	test   %eax,%eax
c0103cb7:	74 24                	je     c0103cdd <check_pgdir+0x419>
c0103cb9:	c7 44 24 0c 7c 8f 10 	movl   $0xc0108f7c,0xc(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103cc8:	c0 
c0103cc9:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103cd0:	00 
c0103cd1:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103cd8:	e8 58 c7 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p1) == 2);
c0103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce0:	89 04 24             	mov    %eax,(%esp)
c0103ce3:	e8 98 ef ff ff       	call   c0102c80 <page_ref>
c0103ce8:	83 f8 02             	cmp    $0x2,%eax
c0103ceb:	74 24                	je     c0103d11 <check_pgdir+0x44d>
c0103ced:	c7 44 24 0c a8 8f 10 	movl   $0xc0108fa8,0xc(%esp)
c0103cf4:	c0 
c0103cf5:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103cfc:	c0 
c0103cfd:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103d04:	00 
c0103d05:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103d0c:	e8 24 c7 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p2) == 0);
c0103d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d14:	89 04 24             	mov    %eax,(%esp)
c0103d17:	e8 64 ef ff ff       	call   c0102c80 <page_ref>
c0103d1c:	85 c0                	test   %eax,%eax
c0103d1e:	74 24                	je     c0103d44 <check_pgdir+0x480>
c0103d20:	c7 44 24 0c ba 8f 10 	movl   $0xc0108fba,0xc(%esp)
c0103d27:	c0 
c0103d28:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103d2f:	c0 
c0103d30:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0103d37:	00 
c0103d38:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103d3f:	e8 f1 c6 ff ff       	call   c0100435 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103d44:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103d49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d50:	00 
c0103d51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d58:	00 
c0103d59:	89 04 24             	mov    %eax,(%esp)
c0103d5c:	e8 dd f7 ff ff       	call   c010353e <get_pte>
c0103d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d68:	75 24                	jne    c0103d8e <check_pgdir+0x4ca>
c0103d6a:	c7 44 24 0c 08 8f 10 	movl   $0xc0108f08,0xc(%esp)
c0103d71:	c0 
c0103d72:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103d79:	c0 
c0103d7a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103d81:	00 
c0103d82:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103d89:	e8 a7 c6 ff ff       	call   c0100435 <__panic>
    assert(pte2page(*ptep) == p1);
c0103d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d91:	8b 00                	mov    (%eax),%eax
c0103d93:	89 04 24             	mov    %eax,(%esp)
c0103d96:	e8 8f ee ff ff       	call   c0102c2a <pte2page>
c0103d9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103d9e:	74 24                	je     c0103dc4 <check_pgdir+0x500>
c0103da0:	c7 44 24 0c 7d 8e 10 	movl   $0xc0108e7d,0xc(%esp)
c0103da7:	c0 
c0103da8:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103daf:	c0 
c0103db0:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103db7:	00 
c0103db8:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103dbf:	e8 71 c6 ff ff       	call   c0100435 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dc7:	8b 00                	mov    (%eax),%eax
c0103dc9:	83 e0 04             	and    $0x4,%eax
c0103dcc:	85 c0                	test   %eax,%eax
c0103dce:	74 24                	je     c0103df4 <check_pgdir+0x530>
c0103dd0:	c7 44 24 0c cc 8f 10 	movl   $0xc0108fcc,0xc(%esp)
c0103dd7:	c0 
c0103dd8:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103ddf:	c0 
c0103de0:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103de7:	00 
c0103de8:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103def:	e8 41 c6 ff ff       	call   c0100435 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103df4:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103df9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103e00:	00 
c0103e01:	89 04 24             	mov    %eax,(%esp)
c0103e04:	e8 31 f9 ff ff       	call   c010373a <page_remove>
    assert(page_ref(p1) == 1);
c0103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e0c:	89 04 24             	mov    %eax,(%esp)
c0103e0f:	e8 6c ee ff ff       	call   c0102c80 <page_ref>
c0103e14:	83 f8 01             	cmp    $0x1,%eax
c0103e17:	74 24                	je     c0103e3d <check_pgdir+0x579>
c0103e19:	c7 44 24 0c 93 8e 10 	movl   $0xc0108e93,0xc(%esp)
c0103e20:	c0 
c0103e21:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103e28:	c0 
c0103e29:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0103e30:	00 
c0103e31:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103e38:	e8 f8 c5 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p2) == 0);
c0103e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e40:	89 04 24             	mov    %eax,(%esp)
c0103e43:	e8 38 ee ff ff       	call   c0102c80 <page_ref>
c0103e48:	85 c0                	test   %eax,%eax
c0103e4a:	74 24                	je     c0103e70 <check_pgdir+0x5ac>
c0103e4c:	c7 44 24 0c ba 8f 10 	movl   $0xc0108fba,0xc(%esp)
c0103e53:	c0 
c0103e54:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103e5b:	c0 
c0103e5c:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0103e63:	00 
c0103e64:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103e6b:	e8 c5 c5 ff ff       	call   c0100435 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103e70:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103e75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103e7c:	00 
c0103e7d:	89 04 24             	mov    %eax,(%esp)
c0103e80:	e8 b5 f8 ff ff       	call   c010373a <page_remove>
    assert(page_ref(p1) == 0);
c0103e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e88:	89 04 24             	mov    %eax,(%esp)
c0103e8b:	e8 f0 ed ff ff       	call   c0102c80 <page_ref>
c0103e90:	85 c0                	test   %eax,%eax
c0103e92:	74 24                	je     c0103eb8 <check_pgdir+0x5f4>
c0103e94:	c7 44 24 0c e1 8f 10 	movl   $0xc0108fe1,0xc(%esp)
c0103e9b:	c0 
c0103e9c:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103ea3:	c0 
c0103ea4:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0103eab:	00 
c0103eac:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103eb3:	e8 7d c5 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p2) == 0);
c0103eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ebb:	89 04 24             	mov    %eax,(%esp)
c0103ebe:	e8 bd ed ff ff       	call   c0102c80 <page_ref>
c0103ec3:	85 c0                	test   %eax,%eax
c0103ec5:	74 24                	je     c0103eeb <check_pgdir+0x627>
c0103ec7:	c7 44 24 0c ba 8f 10 	movl   $0xc0108fba,0xc(%esp)
c0103ece:	c0 
c0103ecf:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103ed6:	c0 
c0103ed7:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103ede:	00 
c0103edf:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103ee6:	e8 4a c5 ff ff       	call   c0100435 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103eeb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103ef0:	8b 00                	mov    (%eax),%eax
c0103ef2:	89 04 24             	mov    %eax,(%esp)
c0103ef5:	e8 6e ed ff ff       	call   c0102c68 <pde2page>
c0103efa:	89 04 24             	mov    %eax,(%esp)
c0103efd:	e8 7e ed ff ff       	call   c0102c80 <page_ref>
c0103f02:	83 f8 01             	cmp    $0x1,%eax
c0103f05:	74 24                	je     c0103f2b <check_pgdir+0x667>
c0103f07:	c7 44 24 0c f4 8f 10 	movl   $0xc0108ff4,0xc(%esp)
c0103f0e:	c0 
c0103f0f:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103f16:	c0 
c0103f17:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0103f1e:	00 
c0103f1f:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103f26:	e8 0a c5 ff ff       	call   c0100435 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103f2b:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103f30:	8b 00                	mov    (%eax),%eax
c0103f32:	89 04 24             	mov    %eax,(%esp)
c0103f35:	e8 2e ed ff ff       	call   c0102c68 <pde2page>
c0103f3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f41:	00 
c0103f42:	89 04 24             	mov    %eax,(%esp)
c0103f45:	e8 88 ef ff ff       	call   c0102ed2 <free_pages>
    boot_pgdir[0] = 0;
c0103f4a:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103f55:	c7 04 24 1b 90 10 c0 	movl   $0xc010901b,(%esp)
c0103f5c:	e8 68 c3 ff ff       	call   c01002c9 <cprintf>
}
c0103f61:	90                   	nop
c0103f62:	c9                   	leave  
c0103f63:	c3                   	ret    

c0103f64 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103f64:	f3 0f 1e fb          	endbr32 
c0103f68:	55                   	push   %ebp
c0103f69:	89 e5                	mov    %esp,%ebp
c0103f6b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103f6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103f75:	e9 ca 00 00 00       	jmp    c0104044 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f83:	c1 e8 0c             	shr    $0xc,%eax
c0103f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f89:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0103f8e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103f91:	72 23                	jb     c0103fb6 <check_boot_pgdir+0x52>
c0103f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f9a:	c7 44 24 08 60 8c 10 	movl   $0xc0108c60,0x8(%esp)
c0103fa1:	c0 
c0103fa2:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0103fa9:	00 
c0103faa:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0103fb1:	e8 7f c4 ff ff       	call   c0100435 <__panic>
c0103fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fb9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103fbe:	89 c2                	mov    %eax,%edx
c0103fc0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103fc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103fcc:	00 
c0103fcd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fd1:	89 04 24             	mov    %eax,(%esp)
c0103fd4:	e8 65 f5 ff ff       	call   c010353e <get_pte>
c0103fd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103fdc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103fe0:	75 24                	jne    c0104006 <check_boot_pgdir+0xa2>
c0103fe2:	c7 44 24 0c 38 90 10 	movl   $0xc0109038,0xc(%esp)
c0103fe9:	c0 
c0103fea:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0103ff1:	c0 
c0103ff2:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0103ff9:	00 
c0103ffa:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104001:	e8 2f c4 ff ff       	call   c0100435 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104006:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104009:	8b 00                	mov    (%eax),%eax
c010400b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104010:	89 c2                	mov    %eax,%edx
c0104012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104015:	39 c2                	cmp    %eax,%edx
c0104017:	74 24                	je     c010403d <check_boot_pgdir+0xd9>
c0104019:	c7 44 24 0c 75 90 10 	movl   $0xc0109075,0xc(%esp)
c0104020:	c0 
c0104021:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0104028:	c0 
c0104029:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104030:	00 
c0104031:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104038:	e8 f8 c3 ff ff       	call   c0100435 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c010403d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104044:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104047:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c010404c:	39 c2                	cmp    %eax,%edx
c010404e:	0f 82 26 ff ff ff    	jb     c0103f7a <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104054:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104059:	05 ac 0f 00 00       	add    $0xfac,%eax
c010405e:	8b 00                	mov    (%eax),%eax
c0104060:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104065:	89 c2                	mov    %eax,%edx
c0104067:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010406c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010406f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104076:	77 23                	ja     c010409b <check_boot_pgdir+0x137>
c0104078:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010407b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010407f:	c7 44 24 08 04 8d 10 	movl   $0xc0108d04,0x8(%esp)
c0104086:	c0 
c0104087:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c010408e:	00 
c010408f:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104096:	e8 9a c3 ff ff       	call   c0100435 <__panic>
c010409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010409e:	05 00 00 00 40       	add    $0x40000000,%eax
c01040a3:	39 d0                	cmp    %edx,%eax
c01040a5:	74 24                	je     c01040cb <check_boot_pgdir+0x167>
c01040a7:	c7 44 24 0c 8c 90 10 	movl   $0xc010908c,0xc(%esp)
c01040ae:	c0 
c01040af:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01040b6:	c0 
c01040b7:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01040be:	00 
c01040bf:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01040c6:	e8 6a c3 ff ff       	call   c0100435 <__panic>

    assert(boot_pgdir[0] == 0);
c01040cb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01040d0:	8b 00                	mov    (%eax),%eax
c01040d2:	85 c0                	test   %eax,%eax
c01040d4:	74 24                	je     c01040fa <check_boot_pgdir+0x196>
c01040d6:	c7 44 24 0c c0 90 10 	movl   $0xc01090c0,0xc(%esp)
c01040dd:	c0 
c01040de:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c01040ed:	00 
c01040ee:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01040f5:	e8 3b c3 ff ff       	call   c0100435 <__panic>

    struct Page *p;
    p = alloc_page();
c01040fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104101:	e8 90 ed ff ff       	call   c0102e96 <alloc_pages>
c0104106:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104109:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010410e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104115:	00 
c0104116:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010411d:	00 
c010411e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104121:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104125:	89 04 24             	mov    %eax,(%esp)
c0104128:	e8 56 f6 ff ff       	call   c0103783 <page_insert>
c010412d:	85 c0                	test   %eax,%eax
c010412f:	74 24                	je     c0104155 <check_boot_pgdir+0x1f1>
c0104131:	c7 44 24 0c d4 90 10 	movl   $0xc01090d4,0xc(%esp)
c0104138:	c0 
c0104139:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0104140:	c0 
c0104141:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104148:	00 
c0104149:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104150:	e8 e0 c2 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p) == 1);
c0104155:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104158:	89 04 24             	mov    %eax,(%esp)
c010415b:	e8 20 eb ff ff       	call   c0102c80 <page_ref>
c0104160:	83 f8 01             	cmp    $0x1,%eax
c0104163:	74 24                	je     c0104189 <check_boot_pgdir+0x225>
c0104165:	c7 44 24 0c 02 91 10 	movl   $0xc0109102,0xc(%esp)
c010416c:	c0 
c010416d:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0104174:	c0 
c0104175:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010417c:	00 
c010417d:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104184:	e8 ac c2 ff ff       	call   c0100435 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104189:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010418e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104195:	00 
c0104196:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010419d:	00 
c010419e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041a5:	89 04 24             	mov    %eax,(%esp)
c01041a8:	e8 d6 f5 ff ff       	call   c0103783 <page_insert>
c01041ad:	85 c0                	test   %eax,%eax
c01041af:	74 24                	je     c01041d5 <check_boot_pgdir+0x271>
c01041b1:	c7 44 24 0c 14 91 10 	movl   $0xc0109114,0xc(%esp)
c01041b8:	c0 
c01041b9:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01041c0:	c0 
c01041c1:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01041c8:	00 
c01041c9:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01041d0:	e8 60 c2 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p) == 2);
c01041d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041d8:	89 04 24             	mov    %eax,(%esp)
c01041db:	e8 a0 ea ff ff       	call   c0102c80 <page_ref>
c01041e0:	83 f8 02             	cmp    $0x2,%eax
c01041e3:	74 24                	je     c0104209 <check_boot_pgdir+0x2a5>
c01041e5:	c7 44 24 0c 4b 91 10 	movl   $0xc010914b,0xc(%esp)
c01041ec:	c0 
c01041ed:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c01041f4:	c0 
c01041f5:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c01041fc:	00 
c01041fd:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c0104204:	e8 2c c2 ff ff       	call   c0100435 <__panic>

    const char *str = "ucore: Hello world!!";
c0104209:	c7 45 e8 5c 91 10 c0 	movl   $0xc010915c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104210:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104213:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104217:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010421e:	e8 a1 37 00 00       	call   c01079c4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104223:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010422a:	00 
c010422b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104232:	e8 0b 38 00 00       	call   c0107a42 <strcmp>
c0104237:	85 c0                	test   %eax,%eax
c0104239:	74 24                	je     c010425f <check_boot_pgdir+0x2fb>
c010423b:	c7 44 24 0c 74 91 10 	movl   $0xc0109174,0xc(%esp)
c0104242:	c0 
c0104243:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c010424a:	c0 
c010424b:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104252:	00 
c0104253:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c010425a:	e8 d6 c1 ff ff       	call   c0100435 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010425f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104262:	89 04 24             	mov    %eax,(%esp)
c0104265:	e8 6c e9 ff ff       	call   c0102bd6 <page2kva>
c010426a:	05 00 01 00 00       	add    $0x100,%eax
c010426f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104272:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104279:	e8 e8 36 00 00       	call   c0107966 <strlen>
c010427e:	85 c0                	test   %eax,%eax
c0104280:	74 24                	je     c01042a6 <check_boot_pgdir+0x342>
c0104282:	c7 44 24 0c ac 91 10 	movl   $0xc01091ac,0xc(%esp)
c0104289:	c0 
c010428a:	c7 44 24 08 4d 8d 10 	movl   $0xc0108d4d,0x8(%esp)
c0104291:	c0 
c0104292:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0104299:	00 
c010429a:	c7 04 24 28 8d 10 c0 	movl   $0xc0108d28,(%esp)
c01042a1:	e8 8f c1 ff ff       	call   c0100435 <__panic>

    free_page(p);
c01042a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042ad:	00 
c01042ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042b1:	89 04 24             	mov    %eax,(%esp)
c01042b4:	e8 19 ec ff ff       	call   c0102ed2 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01042b9:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01042be:	8b 00                	mov    (%eax),%eax
c01042c0:	89 04 24             	mov    %eax,(%esp)
c01042c3:	e8 a0 e9 ff ff       	call   c0102c68 <pde2page>
c01042c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042cf:	00 
c01042d0:	89 04 24             	mov    %eax,(%esp)
c01042d3:	e8 fa eb ff ff       	call   c0102ed2 <free_pages>
    boot_pgdir[0] = 0;
c01042d8:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01042dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01042e3:	c7 04 24 d0 91 10 c0 	movl   $0xc01091d0,(%esp)
c01042ea:	e8 da bf ff ff       	call   c01002c9 <cprintf>
}
c01042ef:	90                   	nop
c01042f0:	c9                   	leave  
c01042f1:	c3                   	ret    

c01042f2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01042f2:	f3 0f 1e fb          	endbr32 
c01042f6:	55                   	push   %ebp
c01042f7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01042f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01042fc:	83 e0 04             	and    $0x4,%eax
c01042ff:	85 c0                	test   %eax,%eax
c0104301:	74 04                	je     c0104307 <perm2str+0x15>
c0104303:	b0 75                	mov    $0x75,%al
c0104305:	eb 02                	jmp    c0104309 <perm2str+0x17>
c0104307:	b0 2d                	mov    $0x2d,%al
c0104309:	a2 08 3f 12 c0       	mov    %al,0xc0123f08
    str[1] = 'r';
c010430e:	c6 05 09 3f 12 c0 72 	movb   $0x72,0xc0123f09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104315:	8b 45 08             	mov    0x8(%ebp),%eax
c0104318:	83 e0 02             	and    $0x2,%eax
c010431b:	85 c0                	test   %eax,%eax
c010431d:	74 04                	je     c0104323 <perm2str+0x31>
c010431f:	b0 77                	mov    $0x77,%al
c0104321:	eb 02                	jmp    c0104325 <perm2str+0x33>
c0104323:	b0 2d                	mov    $0x2d,%al
c0104325:	a2 0a 3f 12 c0       	mov    %al,0xc0123f0a
    str[3] = '\0';
c010432a:	c6 05 0b 3f 12 c0 00 	movb   $0x0,0xc0123f0b
    return str;
c0104331:	b8 08 3f 12 c0       	mov    $0xc0123f08,%eax
}
c0104336:	5d                   	pop    %ebp
c0104337:	c3                   	ret    

c0104338 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104338:	f3 0f 1e fb          	endbr32 
c010433c:	55                   	push   %ebp
c010433d:	89 e5                	mov    %esp,%ebp
c010433f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104342:	8b 45 10             	mov    0x10(%ebp),%eax
c0104345:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104348:	72 0d                	jb     c0104357 <get_pgtable_items+0x1f>
        return 0;
c010434a:	b8 00 00 00 00       	mov    $0x0,%eax
c010434f:	e9 98 00 00 00       	jmp    c01043ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104354:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104357:	8b 45 10             	mov    0x10(%ebp),%eax
c010435a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010435d:	73 18                	jae    c0104377 <get_pgtable_items+0x3f>
c010435f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104362:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104369:	8b 45 14             	mov    0x14(%ebp),%eax
c010436c:	01 d0                	add    %edx,%eax
c010436e:	8b 00                	mov    (%eax),%eax
c0104370:	83 e0 01             	and    $0x1,%eax
c0104373:	85 c0                	test   %eax,%eax
c0104375:	74 dd                	je     c0104354 <get_pgtable_items+0x1c>
    }
    if (start < right) {
c0104377:	8b 45 10             	mov    0x10(%ebp),%eax
c010437a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010437d:	73 68                	jae    c01043e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010437f:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104383:	74 08                	je     c010438d <get_pgtable_items+0x55>
            *left_store = start;
c0104385:	8b 45 18             	mov    0x18(%ebp),%eax
c0104388:	8b 55 10             	mov    0x10(%ebp),%edx
c010438b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010438d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104390:	8d 50 01             	lea    0x1(%eax),%edx
c0104393:	89 55 10             	mov    %edx,0x10(%ebp)
c0104396:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010439d:	8b 45 14             	mov    0x14(%ebp),%eax
c01043a0:	01 d0                	add    %edx,%eax
c01043a2:	8b 00                	mov    (%eax),%eax
c01043a4:	83 e0 07             	and    $0x7,%eax
c01043a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01043aa:	eb 03                	jmp    c01043af <get_pgtable_items+0x77>
            start ++;
c01043ac:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01043af:	8b 45 10             	mov    0x10(%ebp),%eax
c01043b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043b5:	73 1d                	jae    c01043d4 <get_pgtable_items+0x9c>
c01043b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01043ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01043c4:	01 d0                	add    %edx,%eax
c01043c6:	8b 00                	mov    (%eax),%eax
c01043c8:	83 e0 07             	and    $0x7,%eax
c01043cb:	89 c2                	mov    %eax,%edx
c01043cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043d0:	39 c2                	cmp    %eax,%edx
c01043d2:	74 d8                	je     c01043ac <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c01043d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01043d8:	74 08                	je     c01043e2 <get_pgtable_items+0xaa>
            *right_store = start;
c01043da:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01043dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01043e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01043e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043e5:	eb 05                	jmp    c01043ec <get_pgtable_items+0xb4>
    }
    return 0;
c01043e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01043ec:	c9                   	leave  
c01043ed:	c3                   	ret    

c01043ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01043ee:	f3 0f 1e fb          	endbr32 
c01043f2:	55                   	push   %ebp
c01043f3:	89 e5                	mov    %esp,%ebp
c01043f5:	57                   	push   %edi
c01043f6:	56                   	push   %esi
c01043f7:	53                   	push   %ebx
c01043f8:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01043fb:	c7 04 24 f0 91 10 c0 	movl   $0xc01091f0,(%esp)
c0104402:	e8 c2 be ff ff       	call   c01002c9 <cprintf>
    size_t left, right = 0, perm;
c0104407:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010440e:	e9 fa 00 00 00       	jmp    c010450d <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104416:	89 04 24             	mov    %eax,(%esp)
c0104419:	e8 d4 fe ff ff       	call   c01042f2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010441e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104421:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104424:	29 d1                	sub    %edx,%ecx
c0104426:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104428:	89 d6                	mov    %edx,%esi
c010442a:	c1 e6 16             	shl    $0x16,%esi
c010442d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104430:	89 d3                	mov    %edx,%ebx
c0104432:	c1 e3 16             	shl    $0x16,%ebx
c0104435:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104438:	89 d1                	mov    %edx,%ecx
c010443a:	c1 e1 16             	shl    $0x16,%ecx
c010443d:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104440:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104443:	29 d7                	sub    %edx,%edi
c0104445:	89 fa                	mov    %edi,%edx
c0104447:	89 44 24 14          	mov    %eax,0x14(%esp)
c010444b:	89 74 24 10          	mov    %esi,0x10(%esp)
c010444f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104457:	89 54 24 04          	mov    %edx,0x4(%esp)
c010445b:	c7 04 24 21 92 10 c0 	movl   $0xc0109221,(%esp)
c0104462:	e8 62 be ff ff       	call   c01002c9 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104467:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010446a:	c1 e0 0a             	shl    $0xa,%eax
c010446d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104470:	eb 54                	jmp    c01044c6 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104475:	89 04 24             	mov    %eax,(%esp)
c0104478:	e8 75 fe ff ff       	call   c01042f2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010447d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104480:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104483:	29 d1                	sub    %edx,%ecx
c0104485:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104487:	89 d6                	mov    %edx,%esi
c0104489:	c1 e6 0c             	shl    $0xc,%esi
c010448c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010448f:	89 d3                	mov    %edx,%ebx
c0104491:	c1 e3 0c             	shl    $0xc,%ebx
c0104494:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104497:	89 d1                	mov    %edx,%ecx
c0104499:	c1 e1 0c             	shl    $0xc,%ecx
c010449c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010449f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044a2:	29 d7                	sub    %edx,%edi
c01044a4:	89 fa                	mov    %edi,%edx
c01044a6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01044aa:	89 74 24 10          	mov    %esi,0x10(%esp)
c01044ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01044b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01044b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044ba:	c7 04 24 40 92 10 c0 	movl   $0xc0109240,(%esp)
c01044c1:	e8 03 be ff ff       	call   c01002c9 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01044c6:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01044cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01044ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044d1:	89 d3                	mov    %edx,%ebx
c01044d3:	c1 e3 0a             	shl    $0xa,%ebx
c01044d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044d9:	89 d1                	mov    %edx,%ecx
c01044db:	c1 e1 0a             	shl    $0xa,%ecx
c01044de:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01044e1:	89 54 24 14          	mov    %edx,0x14(%esp)
c01044e5:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01044e8:	89 54 24 10          	mov    %edx,0x10(%esp)
c01044ec:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01044f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01044f8:	89 0c 24             	mov    %ecx,(%esp)
c01044fb:	e8 38 fe ff ff       	call   c0104338 <get_pgtable_items>
c0104500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104503:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104507:	0f 85 65 ff ff ff    	jne    c0104472 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010450d:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104512:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104515:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104518:	89 54 24 14          	mov    %edx,0x14(%esp)
c010451c:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010451f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104523:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104527:	89 44 24 08          	mov    %eax,0x8(%esp)
c010452b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104532:	00 
c0104533:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010453a:	e8 f9 fd ff ff       	call   c0104338 <get_pgtable_items>
c010453f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104546:	0f 85 c7 fe ff ff    	jne    c0104413 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010454c:	c7 04 24 64 92 10 c0 	movl   $0xc0109264,(%esp)
c0104553:	e8 71 bd ff ff       	call   c01002c9 <cprintf>
}
c0104558:	90                   	nop
c0104559:	83 c4 4c             	add    $0x4c,%esp
c010455c:	5b                   	pop    %ebx
c010455d:	5e                   	pop    %esi
c010455e:	5f                   	pop    %edi
c010455f:	5d                   	pop    %ebp
c0104560:	c3                   	ret    

c0104561 <page2ppn>:
page2ppn(struct Page *page) {
c0104561:	55                   	push   %ebp
c0104562:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104564:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c0104569:	8b 55 08             	mov    0x8(%ebp),%edx
c010456c:	29 c2                	sub    %eax,%edx
c010456e:	89 d0                	mov    %edx,%eax
c0104570:	c1 f8 02             	sar    $0x2,%eax
c0104573:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104579:	5d                   	pop    %ebp
c010457a:	c3                   	ret    

c010457b <page2pa>:
page2pa(struct Page *page) {
c010457b:	55                   	push   %ebp
c010457c:	89 e5                	mov    %esp,%ebp
c010457e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104581:	8b 45 08             	mov    0x8(%ebp),%eax
c0104584:	89 04 24             	mov    %eax,(%esp)
c0104587:	e8 d5 ff ff ff       	call   c0104561 <page2ppn>
c010458c:	c1 e0 0c             	shl    $0xc,%eax
}
c010458f:	c9                   	leave  
c0104590:	c3                   	ret    

c0104591 <page2kva>:
page2kva(struct Page *page) {
c0104591:	55                   	push   %ebp
c0104592:	89 e5                	mov    %esp,%ebp
c0104594:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104597:	8b 45 08             	mov    0x8(%ebp),%eax
c010459a:	89 04 24             	mov    %eax,(%esp)
c010459d:	e8 d9 ff ff ff       	call   c010457b <page2pa>
c01045a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a8:	c1 e8 0c             	shr    $0xc,%eax
c01045ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045ae:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01045b3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01045b6:	72 23                	jb     c01045db <page2kva+0x4a>
c01045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045bf:	c7 44 24 08 98 92 10 	movl   $0xc0109298,0x8(%esp)
c01045c6:	c0 
c01045c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01045ce:	00 
c01045cf:	c7 04 24 bb 92 10 c0 	movl   $0xc01092bb,(%esp)
c01045d6:	e8 5a be ff ff       	call   c0100435 <__panic>
c01045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045de:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01045e3:	c9                   	leave  
c01045e4:	c3                   	ret    

c01045e5 <kmem_cache_grow>:
static struct kmem_cache_t *sized_caches[SIZED_CACHE_NUM];
static char *cache_cache_name = "cache";
static char *sized_cache_name = "sized";

// kmem_cache_grow - add a free slab
static void * kmem_cache_grow(struct kmem_cache_t *cachep) {
c01045e5:	f3 0f 1e fb          	endbr32 
c01045e9:	55                   	push   %ebp
c01045ea:	89 e5                	mov    %esp,%ebp
c01045ec:	83 ec 58             	sub    $0x58,%esp
    struct Page *page = alloc_page();
c01045ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045f6:	e8 9b e8 ff ff       	call   c0102e96 <alloc_pages>
c01045fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    void *kva = page2kva(page);
c01045fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104601:	89 04 24             	mov    %eax,(%esp)
c0104604:	e8 88 ff ff ff       	call   c0104591 <page2kva>
c0104609:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // Init slub meta data
    struct slab_t *slab = (struct slab_t *) page;
c010460c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010460f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    slab->cachep = cachep;
c0104612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104615:	8b 55 08             	mov    0x8(%ebp),%edx
c0104618:	89 50 04             	mov    %edx,0x4(%eax)
    slab->inuse = slab->free = 0;
c010461b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010461e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
c0104624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104627:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
c010462b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010462e:	66 89 50 08          	mov    %dx,0x8(%eax)
    list_add(&(cachep->slabs_free), &(slab->slab_link));
c0104632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104635:	83 c0 0c             	add    $0xc,%eax
c0104638:	8b 55 08             	mov    0x8(%ebp),%edx
c010463b:	83 c2 10             	add    $0x10,%edx
c010463e:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104641:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104644:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104647:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010464a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010464d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104650:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104653:	8b 40 04             	mov    0x4(%eax),%eax
c0104656:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104659:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010465c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010465f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104662:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104665:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104668:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010466b:	89 10                	mov    %edx,(%eax)
c010466d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104670:	8b 10                	mov    (%eax),%edx
c0104672:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104675:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104678:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010467b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010467e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104681:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104684:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104687:	89 10                	mov    %edx,(%eax)
}
c0104689:	90                   	nop
}
c010468a:	90                   	nop
}
c010468b:	90                   	nop
    // Init bufctl
    int16_t *bufctl = kva;
c010468c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010468f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (int i = 1; i < cachep->num; i++)
c0104692:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0104699:	eb 1a                	jmp    c01046b5 <kmem_cache_grow+0xd0>
        bufctl[i-1] = i;
c010469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469e:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
c01046a3:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01046a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046a9:	01 c2                	add    %eax,%edx
c01046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ae:	98                   	cwtl   
c01046af:	66 89 02             	mov    %ax,(%edx)
    for (int i = 1; i < cachep->num; i++)
c01046b2:	ff 45 f4             	incl   -0xc(%ebp)
c01046b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b8:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c01046bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046bf:	7c da                	jl     c010469b <kmem_cache_grow+0xb6>
    bufctl[cachep->num-1] = -1;
c01046c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c4:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c01046c8:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
c01046cd:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01046d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046d3:	01 d0                	add    %edx,%eax
c01046d5:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
    // Init cache 
    void *buf = bufctl + cachep->num;
c01046da:	8b 45 08             	mov    0x8(%ebp),%eax
c01046dd:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c01046e1:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01046e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046e7:	01 d0                	add    %edx,%eax
c01046e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cachep->ctor) 
c01046ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ef:	8b 40 1c             	mov    0x1c(%eax),%eax
c01046f2:	85 c0                	test   %eax,%eax
c01046f4:	74 51                	je     c0104747 <kmem_cache_grow+0x162>
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
c01046f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046fc:	eb 2a                	jmp    c0104728 <kmem_cache_grow+0x143>
            cachep->ctor(p, cachep, cachep->objsize);
c01046fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104701:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104704:	8b 55 08             	mov    0x8(%ebp),%edx
c0104707:	0f b7 52 18          	movzwl 0x18(%edx),%edx
c010470b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010470f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104712:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104716:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104719:	89 14 24             	mov    %edx,(%esp)
c010471c:	ff d0                	call   *%eax
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
c010471e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104721:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c0104725:	01 45 f0             	add    %eax,-0x10(%ebp)
c0104728:	8b 45 08             	mov    0x8(%ebp),%eax
c010472b:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c010472f:	89 c2                	mov    %eax,%edx
c0104731:	8b 45 08             	mov    0x8(%ebp),%eax
c0104734:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c0104738:	0f af c2             	imul   %edx,%eax
c010473b:	89 c2                	mov    %eax,%edx
c010473d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104740:	01 d0                	add    %edx,%eax
c0104742:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104745:	72 b7                	jb     c01046fe <kmem_cache_grow+0x119>
    return slab;
c0104747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
c010474a:	c9                   	leave  
c010474b:	c3                   	ret    

c010474c <kmem_slab_destroy>:

// kmem_slab_destroy - destroy a slab
static void kmem_slab_destroy(struct kmem_cache_t *cachep, struct slab_t *slab) {
c010474c:	f3 0f 1e fb          	endbr32 
c0104750:	55                   	push   %ebp
c0104751:	89 e5                	mov    %esp,%ebp
c0104753:	83 ec 38             	sub    $0x38,%esp
    // Destruct cache
    struct Page *page = (struct Page *) slab;
c0104756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104759:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int16_t *bufctl = page2kva(page);
c010475c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475f:	89 04 24             	mov    %eax,(%esp)
c0104762:	e8 2a fe ff ff       	call   c0104591 <page2kva>
c0104767:	89 45 ec             	mov    %eax,-0x14(%ebp)
    void *buf = bufctl + cachep->num;
c010476a:	8b 45 08             	mov    0x8(%ebp),%eax
c010476d:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c0104771:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104774:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104777:	01 d0                	add    %edx,%eax
c0104779:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (cachep->dtor)
c010477c:	8b 45 08             	mov    0x8(%ebp),%eax
c010477f:	8b 40 20             	mov    0x20(%eax),%eax
c0104782:	85 c0                	test   %eax,%eax
c0104784:	74 51                	je     c01047d7 <kmem_slab_destroy+0x8b>
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
c0104786:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104789:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010478c:	eb 2a                	jmp    c01047b8 <kmem_slab_destroy+0x6c>
            cachep->dtor(p, cachep, cachep->objsize);
c010478e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104791:	8b 40 20             	mov    0x20(%eax),%eax
c0104794:	8b 55 08             	mov    0x8(%ebp),%edx
c0104797:	0f b7 52 18          	movzwl 0x18(%edx),%edx
c010479b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010479f:	8b 55 08             	mov    0x8(%ebp),%edx
c01047a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047a9:	89 14 24             	mov    %edx,(%esp)
c01047ac:	ff d0                	call   *%eax
        for (void *p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
c01047ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01047b1:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c01047b5:	01 45 f4             	add    %eax,-0xc(%ebp)
c01047b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047bb:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c01047bf:	89 c2                	mov    %eax,%edx
c01047c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c4:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c01047c8:	0f af c2             	imul   %edx,%eax
c01047cb:	89 c2                	mov    %eax,%edx
c01047cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047d0:	01 d0                	add    %edx,%eax
c01047d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01047d5:	72 b7                	jb     c010478e <kmem_slab_destroy+0x42>
    // Return slub page 
    page->property = page->flags = 0;
c01047d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c01047e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047e4:	8b 50 04             	mov    0x4(%eax),%edx
c01047e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ea:	89 50 08             	mov    %edx,0x8(%eax)
    list_del(&(page->page_link));
c01047ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f0:	83 c0 0c             	add    $0xc,%eax
c01047f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01047f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047f9:	8b 40 04             	mov    0x4(%eax),%eax
c01047fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047ff:	8b 12                	mov    (%edx),%edx
c0104801:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104804:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104807:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010480a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010480d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104810:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104813:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104816:	89 10                	mov    %edx,(%eax)
}
c0104818:	90                   	nop
}
c0104819:	90                   	nop
    free_page(page);
c010481a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104821:	00 
c0104822:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104825:	89 04 24             	mov    %eax,(%esp)
c0104828:	e8 a5 e6 ff ff       	call   c0102ed2 <free_pages>
}
c010482d:	90                   	nop
c010482e:	c9                   	leave  
c010482f:	c3                   	ret    

c0104830 <kmem_sized_index>:

static int kmem_sized_index(size_t size) {
c0104830:	f3 0f 1e fb          	endbr32 
c0104834:	55                   	push   %ebp
c0104835:	89 e5                	mov    %esp,%ebp
c0104837:	83 ec 20             	sub    $0x20,%esp
    // Round up 
    size_t rsize = ROUNDUP(size, 2);
c010483a:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
c0104841:	8b 55 08             	mov    0x8(%ebp),%edx
c0104844:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104847:	01 d0                	add    %edx,%eax
c0104849:	48                   	dec    %eax
c010484a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010484d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104850:	ba 00 00 00 00       	mov    $0x0,%edx
c0104855:	f7 75 f0             	divl   -0x10(%ebp)
c0104858:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010485b:	29 d0                	sub    %edx,%eax
c010485d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (rsize < SIZED_CACHE_MIN)
c0104860:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
c0104864:	77 07                	ja     c010486d <kmem_sized_index+0x3d>
        rsize = SIZED_CACHE_MIN;
c0104866:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%ebp)
    // Find index
    int index = 0;
c010486d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for (int t = rsize / 32; t; t /= 2)
c0104874:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104877:	c1 e8 05             	shr    $0x5,%eax
c010487a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010487d:	eb 12                	jmp    c0104891 <kmem_sized_index+0x61>
        index ++;
c010487f:	ff 45 f8             	incl   -0x8(%ebp)
    for (int t = rsize / 32; t; t /= 2)
c0104882:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104885:	89 c2                	mov    %eax,%edx
c0104887:	c1 ea 1f             	shr    $0x1f,%edx
c010488a:	01 d0                	add    %edx,%eax
c010488c:	d1 f8                	sar    %eax
c010488e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104895:	75 e8                	jne    c010487f <kmem_sized_index+0x4f>
    return index;
c0104897:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010489a:	c9                   	leave  
c010489b:	c3                   	ret    

c010489c <test_ctor>:

struct test_object {
    char test_member[TEST_OBJECT_LENTH];
};

static void test_ctor(void* objp, struct kmem_cache_t * cachep, size_t size) {
c010489c:	f3 0f 1e fb          	endbr32 
c01048a0:	55                   	push   %ebp
c01048a1:	89 e5                	mov    %esp,%ebp
c01048a3:	83 ec 10             	sub    $0x10,%esp
    char *p = objp;
c01048a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (int i = 0; i < size; i++)
c01048ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01048b3:	eb 0e                	jmp    c01048c3 <test_ctor+0x27>
        p[i] = TEST_OBJECT_CTVAL;
c01048b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01048b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048bb:	01 d0                	add    %edx,%eax
c01048bd:	c6 00 22             	movb   $0x22,(%eax)
    for (int i = 0; i < size; i++)
c01048c0:	ff 45 fc             	incl   -0x4(%ebp)
c01048c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01048c6:	39 45 10             	cmp    %eax,0x10(%ebp)
c01048c9:	77 ea                	ja     c01048b5 <test_ctor+0x19>
}
c01048cb:	90                   	nop
c01048cc:	90                   	nop
c01048cd:	c9                   	leave  
c01048ce:	c3                   	ret    

c01048cf <test_dtor>:

static void test_dtor(void* objp, struct kmem_cache_t * cachep, size_t size) {
c01048cf:	f3 0f 1e fb          	endbr32 
c01048d3:	55                   	push   %ebp
c01048d4:	89 e5                	mov    %esp,%ebp
c01048d6:	83 ec 10             	sub    $0x10,%esp
    char *p = objp;
c01048d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01048dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (int i = 0; i < size; i++)
c01048df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01048e6:	eb 0e                	jmp    c01048f6 <test_dtor+0x27>
        p[i] = TEST_OBJECT_DTVAL;
c01048e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01048eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048ee:	01 d0                	add    %edx,%eax
c01048f0:	c6 00 11             	movb   $0x11,(%eax)
    for (int i = 0; i < size; i++)
c01048f3:	ff 45 fc             	incl   -0x4(%ebp)
c01048f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01048f9:	39 45 10             	cmp    %eax,0x10(%ebp)
c01048fc:	77 ea                	ja     c01048e8 <test_dtor+0x19>
}
c01048fe:	90                   	nop
c01048ff:	90                   	nop
c0104900:	c9                   	leave  
c0104901:	c3                   	ret    

c0104902 <list_length>:

static size_t list_length(list_entry_t *listelm) {
c0104902:	f3 0f 1e fb          	endbr32 
c0104906:	55                   	push   %ebp
c0104907:	89 e5                	mov    %esp,%ebp
c0104909:	83 ec 10             	sub    $0x10,%esp
    size_t len = 0;
c010490c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    list_entry_t *le = listelm;
c0104913:	8b 45 08             	mov    0x8(%ebp),%eax
c0104916:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while ((le = list_next(le)) != listelm)
c0104919:	eb 03                	jmp    c010491e <list_length+0x1c>
        len ++;
c010491b:	ff 45 fc             	incl   -0x4(%ebp)
c010491e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104921:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return listelm->next;
c0104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104927:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != listelm)
c010492a:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010492d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104930:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104933:	75 e6                	jne    c010491b <list_length+0x19>
    return len;
c0104935:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104938:	c9                   	leave  
c0104939:	c3                   	ret    

c010493a <check_kmem>:

static void check_kmem() {
c010493a:	f3 0f 1e fb          	endbr32 
c010493e:	55                   	push   %ebp
c010493f:	89 e5                	mov    %esp,%ebp
c0104941:	53                   	push   %ebx
c0104942:	83 ec 54             	sub    $0x54,%esp

    assert(sizeof(struct Page) == sizeof(struct slab_t));

    size_t fp = nr_free_pages();
c0104945:	e8 bf e5 ff ff       	call   c0102f09 <nr_free_pages>
c010494a:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // Create a cache 
    struct kmem_cache_t *cp0 = kmem_cache_create(test_object_name, sizeof(struct test_object), test_ctor, test_dtor);
c010494d:	a1 40 0a 12 c0       	mov    0xc0120a40,%eax
c0104952:	c7 44 24 0c cf 48 10 	movl   $0xc01048cf,0xc(%esp)
c0104959:	c0 
c010495a:	c7 44 24 08 9c 48 10 	movl   $0xc010489c,0x8(%esp)
c0104961:	c0 
c0104962:	c7 44 24 04 fe 07 00 	movl   $0x7fe,0x4(%esp)
c0104969:	00 
c010496a:	89 04 24             	mov    %eax,(%esp)
c010496d:	e8 c6 06 00 00       	call   c0105038 <kmem_cache_create>
c0104972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(cp0 != NULL);
c0104975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104979:	75 24                	jne    c010499f <check_kmem+0x65>
c010497b:	c7 44 24 0c da 92 10 	movl   $0xc01092da,0xc(%esp)
c0104982:	c0 
c0104983:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c010498a:	c0 
c010498b:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0104992:	00 
c0104993:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c010499a:	e8 96 ba ff ff       	call   c0100435 <__panic>
    assert(kmem_cache_size(cp0) == sizeof(struct test_object));
c010499f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049a2:	89 04 24             	mov    %eax,(%esp)
c01049a5:	e8 c0 0c 00 00       	call   c010566a <kmem_cache_size>
c01049aa:	3d fe 07 00 00       	cmp    $0x7fe,%eax
c01049af:	74 24                	je     c01049d5 <check_kmem+0x9b>
c01049b1:	c7 44 24 0c 0c 93 10 	movl   $0xc010930c,0xc(%esp)
c01049b8:	c0 
c01049b9:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c01049c0:	c0 
c01049c1:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c01049c8:	00 
c01049c9:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c01049d0:	e8 60 ba ff ff       	call   c0100435 <__panic>
    assert(strcmp(kmem_cache_name(cp0), test_object_name) == 0);
c01049d5:	8b 1d 40 0a 12 c0    	mov    0xc0120a40,%ebx
c01049db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049de:	89 04 24             	mov    %eax,(%esp)
c01049e1:	e8 94 0c 00 00       	call   c010567a <kmem_cache_name>
c01049e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01049ea:	89 04 24             	mov    %eax,(%esp)
c01049ed:	e8 50 30 00 00       	call   c0107a42 <strcmp>
c01049f2:	85 c0                	test   %eax,%eax
c01049f4:	74 24                	je     c0104a1a <check_kmem+0xe0>
c01049f6:	c7 44 24 0c 40 93 10 	movl   $0xc0109340,0xc(%esp)
c01049fd:	c0 
c01049fe:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104a05:	c0 
c0104a06:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0104a0d:	00 
c0104a0e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104a15:	e8 1b ba ff ff       	call   c0100435 <__panic>
    // Allocate six objects
    struct test_object *p0, *p1, *p2, *p3, *p4, *p5;
    char *p;
    assert((p0 = kmem_cache_alloc(cp0)) != NULL);
c0104a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a1d:	89 04 24             	mov    %eax,(%esp)
c0104a20:	e8 70 08 00 00       	call   c0105295 <kmem_cache_alloc>
c0104a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104a2c:	75 24                	jne    c0104a52 <check_kmem+0x118>
c0104a2e:	c7 44 24 0c 74 93 10 	movl   $0xc0109374,0xc(%esp)
c0104a35:	c0 
c0104a36:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104a3d:	c0 
c0104a3e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0104a45:	00 
c0104a46:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104a4d:	e8 e3 b9 ff ff       	call   c0100435 <__panic>
    assert((p1 = kmem_cache_alloc(cp0)) != NULL);
c0104a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a55:	89 04 24             	mov    %eax,(%esp)
c0104a58:	e8 38 08 00 00       	call   c0105295 <kmem_cache_alloc>
c0104a5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104a60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104a64:	75 24                	jne    c0104a8a <check_kmem+0x150>
c0104a66:	c7 44 24 0c 9c 93 10 	movl   $0xc010939c,0xc(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104a75:	c0 
c0104a76:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104a7d:	00 
c0104a7e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104a85:	e8 ab b9 ff ff       	call   c0100435 <__panic>
    assert((p2 = kmem_cache_alloc(cp0)) != NULL);
c0104a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a8d:	89 04 24             	mov    %eax,(%esp)
c0104a90:	e8 00 08 00 00       	call   c0105295 <kmem_cache_alloc>
c0104a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104a98:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104a9c:	75 24                	jne    c0104ac2 <check_kmem+0x188>
c0104a9e:	c7 44 24 0c c4 93 10 	movl   $0xc01093c4,0xc(%esp)
c0104aa5:	c0 
c0104aa6:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104aad:	c0 
c0104aae:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0104ab5:	00 
c0104ab6:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104abd:	e8 73 b9 ff ff       	call   c0100435 <__panic>
    assert((p3 = kmem_cache_alloc(cp0)) != NULL);
c0104ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ac5:	89 04 24             	mov    %eax,(%esp)
c0104ac8:	e8 c8 07 00 00       	call   c0105295 <kmem_cache_alloc>
c0104acd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104ad0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104ad4:	75 24                	jne    c0104afa <check_kmem+0x1c0>
c0104ad6:	c7 44 24 0c ec 93 10 	movl   $0xc01093ec,0xc(%esp)
c0104add:	c0 
c0104ade:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104ae5:	c0 
c0104ae6:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0104aed:	00 
c0104aee:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104af5:	e8 3b b9 ff ff       	call   c0100435 <__panic>
    assert((p4 = kmem_cache_alloc(cp0)) != NULL);
c0104afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104afd:	89 04 24             	mov    %eax,(%esp)
c0104b00:	e8 90 07 00 00       	call   c0105295 <kmem_cache_alloc>
c0104b05:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b08:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104b0c:	75 24                	jne    c0104b32 <check_kmem+0x1f8>
c0104b0e:	c7 44 24 0c 14 94 10 	movl   $0xc0109414,0xc(%esp)
c0104b15:	c0 
c0104b16:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104b1d:	c0 
c0104b1e:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0104b25:	00 
c0104b26:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104b2d:	e8 03 b9 ff ff       	call   c0100435 <__panic>
    p = (char *) p4;
c0104b32:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b35:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104b38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104b3f:	eb 36                	jmp    c0104b77 <check_kmem+0x23d>
        assert(p[i] == TEST_OBJECT_CTVAL);
c0104b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b44:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104b47:	01 d0                	add    %edx,%eax
c0104b49:	0f b6 00             	movzbl (%eax),%eax
c0104b4c:	3c 22                	cmp    $0x22,%al
c0104b4e:	74 24                	je     c0104b74 <check_kmem+0x23a>
c0104b50:	c7 44 24 0c 39 94 10 	movl   $0xc0109439,0xc(%esp)
c0104b57:	c0 
c0104b58:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104b5f:	c0 
c0104b60:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0104b67:	00 
c0104b68:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104b6f:	e8 c1 b8 ff ff       	call   c0100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104b74:	ff 45 f4             	incl   -0xc(%ebp)
c0104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7a:	3d fd 07 00 00       	cmp    $0x7fd,%eax
c0104b7f:	76 c0                	jbe    c0104b41 <check_kmem+0x207>
    assert((p5 = kmem_cache_zalloc(cp0)) != NULL);
c0104b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b84:	89 04 24             	mov    %eax,(%esp)
c0104b87:	e8 fb 08 00 00       	call   c0105487 <kmem_cache_zalloc>
c0104b8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b8f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104b93:	75 24                	jne    c0104bb9 <check_kmem+0x27f>
c0104b95:	c7 44 24 0c 54 94 10 	movl   $0xc0109454,0xc(%esp)
c0104b9c:	c0 
c0104b9d:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104ba4:	c0 
c0104ba5:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0104bac:	00 
c0104bad:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104bb4:	e8 7c b8 ff ff       	call   c0100435 <__panic>
    p = (char *) p5;
c0104bb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104bbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104bc6:	eb 36                	jmp    c0104bfe <check_kmem+0x2c4>
        assert(p[i] == 0);
c0104bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104bce:	01 d0                	add    %edx,%eax
c0104bd0:	0f b6 00             	movzbl (%eax),%eax
c0104bd3:	84 c0                	test   %al,%al
c0104bd5:	74 24                	je     c0104bfb <check_kmem+0x2c1>
c0104bd7:	c7 44 24 0c 7a 94 10 	movl   $0xc010947a,0xc(%esp)
c0104bde:	c0 
c0104bdf:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104be6:	c0 
c0104be7:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c0104bee:	00 
c0104bef:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104bf6:	e8 3a b8 ff ff       	call   c0100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104bfb:	ff 45 f0             	incl   -0x10(%ebp)
c0104bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c01:	3d fd 07 00 00       	cmp    $0x7fd,%eax
c0104c06:	76 c0                	jbe    c0104bc8 <check_kmem+0x28e>
    assert(nr_free_pages()+3 == fp);
c0104c08:	e8 fc e2 ff ff       	call   c0102f09 <nr_free_pages>
c0104c0d:	83 c0 03             	add    $0x3,%eax
c0104c10:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104c13:	74 24                	je     c0104c39 <check_kmem+0x2ff>
c0104c15:	c7 44 24 0c 84 94 10 	movl   $0xc0109484,0xc(%esp)
c0104c1c:	c0 
c0104c1d:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104c24:	c0 
c0104c25:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
c0104c2c:	00 
c0104c2d:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104c34:	e8 fc b7 ff ff       	call   c0100435 <__panic>
    assert(list_empty(&(cp0->slabs_free)));
c0104c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c3c:	83 c0 10             	add    $0x10,%eax
c0104c3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return list->next == list;
c0104c42:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c45:	8b 40 04             	mov    0x4(%eax),%eax
c0104c48:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
c0104c4b:	0f 94 c0             	sete   %al
c0104c4e:	0f b6 c0             	movzbl %al,%eax
c0104c51:	85 c0                	test   %eax,%eax
c0104c53:	75 24                	jne    c0104c79 <check_kmem+0x33f>
c0104c55:	c7 44 24 0c 9c 94 10 	movl   $0xc010949c,0xc(%esp)
c0104c5c:	c0 
c0104c5d:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104c64:	c0 
c0104c65:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
c0104c6c:	00 
c0104c6d:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104c74:	e8 bc b7 ff ff       	call   c0100435 <__panic>
    assert(list_empty(&(cp0->slabs_partial)));
c0104c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c7c:	83 c0 08             	add    $0x8,%eax
c0104c7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104c82:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c85:	8b 40 04             	mov    0x4(%eax),%eax
c0104c88:	39 45 c0             	cmp    %eax,-0x40(%ebp)
c0104c8b:	0f 94 c0             	sete   %al
c0104c8e:	0f b6 c0             	movzbl %al,%eax
c0104c91:	85 c0                	test   %eax,%eax
c0104c93:	75 24                	jne    c0104cb9 <check_kmem+0x37f>
c0104c95:	c7 44 24 0c bc 94 10 	movl   $0xc01094bc,0xc(%esp)
c0104c9c:	c0 
c0104c9d:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104ca4:	c0 
c0104ca5:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
c0104cac:	00 
c0104cad:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104cb4:	e8 7c b7 ff ff       	call   c0100435 <__panic>
    assert(list_length(&(cp0->slabs_full)) == 3);
c0104cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cbc:	89 04 24             	mov    %eax,(%esp)
c0104cbf:	e8 3e fc ff ff       	call   c0104902 <list_length>
c0104cc4:	83 f8 03             	cmp    $0x3,%eax
c0104cc7:	74 24                	je     c0104ced <check_kmem+0x3b3>
c0104cc9:	c7 44 24 0c e0 94 10 	movl   $0xc01094e0,0xc(%esp)
c0104cd0:	c0 
c0104cd1:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104cd8:	c0 
c0104cd9:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
c0104ce0:	00 
c0104ce1:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104ce8:	e8 48 b7 ff ff       	call   c0100435 <__panic>
    // Free three objects 
    kmem_cache_free(cp0, p3);
c0104ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cf7:	89 04 24             	mov    %eax,(%esp)
c0104cfa:	e8 c3 07 00 00       	call   c01054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p4);
c0104cff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d09:	89 04 24             	mov    %eax,(%esp)
c0104d0c:	e8 b1 07 00 00       	call   c01054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p5);
c0104d11:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104d14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d1b:	89 04 24             	mov    %eax,(%esp)
c0104d1e:	e8 9f 07 00 00       	call   c01054c2 <kmem_cache_free>
    assert(list_length(&(cp0->slabs_free)) == 1);
c0104d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d26:	83 c0 10             	add    $0x10,%eax
c0104d29:	89 04 24             	mov    %eax,(%esp)
c0104d2c:	e8 d1 fb ff ff       	call   c0104902 <list_length>
c0104d31:	83 f8 01             	cmp    $0x1,%eax
c0104d34:	74 24                	je     c0104d5a <check_kmem+0x420>
c0104d36:	c7 44 24 0c 08 95 10 	movl   $0xc0109508,0xc(%esp)
c0104d3d:	c0 
c0104d3e:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104d45:	c0 
c0104d46:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c0104d4d:	00 
c0104d4e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104d55:	e8 db b6 ff ff       	call   c0100435 <__panic>
    assert(list_length(&(cp0->slabs_partial)) == 1);
c0104d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d5d:	83 c0 08             	add    $0x8,%eax
c0104d60:	89 04 24             	mov    %eax,(%esp)
c0104d63:	e8 9a fb ff ff       	call   c0104902 <list_length>
c0104d68:	83 f8 01             	cmp    $0x1,%eax
c0104d6b:	74 24                	je     c0104d91 <check_kmem+0x457>
c0104d6d:	c7 44 24 0c 30 95 10 	movl   $0xc0109530,0xc(%esp)
c0104d74:	c0 
c0104d75:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104d7c:	c0 
c0104d7d:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0104d84:	00 
c0104d85:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104d8c:	e8 a4 b6 ff ff       	call   c0100435 <__panic>
    assert(list_length(&(cp0->slabs_full)) == 1);
c0104d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d94:	89 04 24             	mov    %eax,(%esp)
c0104d97:	e8 66 fb ff ff       	call   c0104902 <list_length>
c0104d9c:	83 f8 01             	cmp    $0x1,%eax
c0104d9f:	74 24                	je     c0104dc5 <check_kmem+0x48b>
c0104da1:	c7 44 24 0c 58 95 10 	movl   $0xc0109558,0xc(%esp)
c0104da8:	c0 
c0104da9:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104db0:	c0 
c0104db1:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
c0104db8:	00 
c0104db9:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104dc0:	e8 70 b6 ff ff       	call   c0100435 <__panic>
    // Shrink cache 
    assert(kmem_cache_shrink(cp0) == 1);
c0104dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc8:	89 04 24             	mov    %eax,(%esp)
c0104dcb:	e8 b9 08 00 00       	call   c0105689 <kmem_cache_shrink>
c0104dd0:	83 f8 01             	cmp    $0x1,%eax
c0104dd3:	74 24                	je     c0104df9 <check_kmem+0x4bf>
c0104dd5:	c7 44 24 0c 7d 95 10 	movl   $0xc010957d,0xc(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104de4:	c0 
c0104de5:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c0104dec:	00 
c0104ded:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104df4:	e8 3c b6 ff ff       	call   c0100435 <__panic>
    assert(nr_free_pages()+2 == fp);
c0104df9:	e8 0b e1 ff ff       	call   c0102f09 <nr_free_pages>
c0104dfe:	83 c0 02             	add    $0x2,%eax
c0104e01:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104e04:	74 24                	je     c0104e2a <check_kmem+0x4f0>
c0104e06:	c7 44 24 0c 99 95 10 	movl   $0xc0109599,0xc(%esp)
c0104e0d:	c0 
c0104e0e:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104e15:	c0 
c0104e16:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0104e1d:	00 
c0104e1e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104e25:	e8 0b b6 ff ff       	call   c0100435 <__panic>
    assert(list_empty(&(cp0->slabs_free)));
c0104e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e2d:	83 c0 10             	add    $0x10,%eax
c0104e30:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104e33:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104e36:	8b 40 04             	mov    0x4(%eax),%eax
c0104e39:	39 45 bc             	cmp    %eax,-0x44(%ebp)
c0104e3c:	0f 94 c0             	sete   %al
c0104e3f:	0f b6 c0             	movzbl %al,%eax
c0104e42:	85 c0                	test   %eax,%eax
c0104e44:	75 24                	jne    c0104e6a <check_kmem+0x530>
c0104e46:	c7 44 24 0c 9c 94 10 	movl   $0xc010949c,0xc(%esp)
c0104e4d:	c0 
c0104e4e:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104e55:	c0 
c0104e56:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0104e5d:	00 
c0104e5e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104e65:	e8 cb b5 ff ff       	call   c0100435 <__panic>
    p = (char *) p4;
c0104e6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104e70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104e77:	eb 36                	jmp    c0104eaf <check_kmem+0x575>
        assert(p[i] == TEST_OBJECT_DTVAL);
c0104e79:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e7f:	01 d0                	add    %edx,%eax
c0104e81:	0f b6 00             	movzbl (%eax),%eax
c0104e84:	3c 11                	cmp    $0x11,%al
c0104e86:	74 24                	je     c0104eac <check_kmem+0x572>
c0104e88:	c7 44 24 0c b1 95 10 	movl   $0xc01095b1,0xc(%esp)
c0104e8f:	c0 
c0104e90:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104e97:	c0 
c0104e98:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0104e9f:	00 
c0104ea0:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104ea7:	e8 89 b5 ff ff       	call   c0100435 <__panic>
    for (int i = 0; i < sizeof(struct test_object); i++)
c0104eac:	ff 45 ec             	incl   -0x14(%ebp)
c0104eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eb2:	3d fd 07 00 00       	cmp    $0x7fd,%eax
c0104eb7:	76 c0                	jbe    c0104e79 <check_kmem+0x53f>
    // Reap cache 
    kmem_cache_free(cp0, p0);
c0104eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ec3:	89 04 24             	mov    %eax,(%esp)
c0104ec6:	e8 f7 05 00 00       	call   c01054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p1);
c0104ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ece:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ed5:	89 04 24             	mov    %eax,(%esp)
c0104ed8:	e8 e5 05 00 00       	call   c01054c2 <kmem_cache_free>
    kmem_cache_free(cp0, p2);
c0104edd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ee7:	89 04 24             	mov    %eax,(%esp)
c0104eea:	e8 d3 05 00 00       	call   c01054c2 <kmem_cache_free>
    assert(kmem_cache_reap() == 2);
c0104eef:	e8 f7 07 00 00       	call   c01056eb <kmem_cache_reap>
c0104ef4:	83 f8 02             	cmp    $0x2,%eax
c0104ef7:	74 24                	je     c0104f1d <check_kmem+0x5e3>
c0104ef9:	c7 44 24 0c cb 95 10 	movl   $0xc01095cb,0xc(%esp)
c0104f00:	c0 
c0104f01:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0104f10:	00 
c0104f11:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104f18:	e8 18 b5 ff ff       	call   c0100435 <__panic>
    assert(nr_free_pages() == fp);
c0104f1d:	e8 e7 df ff ff       	call   c0102f09 <nr_free_pages>
c0104f22:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104f25:	74 24                	je     c0104f4b <check_kmem+0x611>
c0104f27:	c7 44 24 0c e2 95 10 	movl   $0xc01095e2,0xc(%esp)
c0104f2e:	c0 
c0104f2f:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104f36:	c0 
c0104f37:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0104f3e:	00 
c0104f3f:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104f46:	e8 ea b4 ff ff       	call   c0100435 <__panic>
    // Destory a cache 
    kmem_cache_destroy(cp0);
c0104f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f4e:	89 04 24             	mov    %eax,(%esp)
c0104f51:	e8 3e 02 00 00       	call   c0105194 <kmem_cache_destroy>

    // Sized alloc 
    assert((p0 = kmalloc(2048)) != NULL);
c0104f56:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
c0104f5d:	e8 d1 07 00 00       	call   c0105733 <kmalloc>
c0104f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104f69:	75 24                	jne    c0104f8f <check_kmem+0x655>
c0104f6b:	c7 44 24 0c f8 95 10 	movl   $0xc01095f8,0xc(%esp)
c0104f72:	c0 
c0104f73:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104f7a:	c0 
c0104f7b:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0104f82:	00 
c0104f83:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104f8a:	e8 a6 b4 ff ff       	call   c0100435 <__panic>
    assert(nr_free_pages()+1 == fp);
c0104f8f:	e8 75 df ff ff       	call   c0102f09 <nr_free_pages>
c0104f94:	40                   	inc    %eax
c0104f95:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104f98:	74 24                	je     c0104fbe <check_kmem+0x684>
c0104f9a:	c7 44 24 0c 15 96 10 	movl   $0xc0109615,0xc(%esp)
c0104fa1:	c0 
c0104fa2:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104fa9:	c0 
c0104faa:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0104fb1:	00 
c0104fb2:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104fb9:	e8 77 b4 ff ff       	call   c0100435 <__panic>
    kfree(p0);
c0104fbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fc1:	89 04 24             	mov    %eax,(%esp)
c0104fc4:	e8 bd 07 00 00       	call   c0105786 <kfree>
    assert(kmem_cache_reap() == 1);
c0104fc9:	e8 1d 07 00 00       	call   c01056eb <kmem_cache_reap>
c0104fce:	83 f8 01             	cmp    $0x1,%eax
c0104fd1:	74 24                	je     c0104ff7 <check_kmem+0x6bd>
c0104fd3:	c7 44 24 0c 2d 96 10 	movl   $0xc010962d,0xc(%esp)
c0104fda:	c0 
c0104fdb:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0104fe2:	c0 
c0104fe3:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0104fea:	00 
c0104feb:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0104ff2:	e8 3e b4 ff ff       	call   c0100435 <__panic>
    assert(nr_free_pages() == fp);
c0104ff7:	e8 0d df ff ff       	call   c0102f09 <nr_free_pages>
c0104ffc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104fff:	74 24                	je     c0105025 <check_kmem+0x6eb>
c0105001:	c7 44 24 0c e2 95 10 	movl   $0xc01095e2,0xc(%esp)
c0105008:	c0 
c0105009:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0105010:	c0 
c0105011:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0105018:	00 
c0105019:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0105020:	e8 10 b4 ff ff       	call   c0100435 <__panic>

    cprintf("check_kmem() succeeded!\n");
c0105025:	c7 04 24 44 96 10 c0 	movl   $0xc0109644,(%esp)
c010502c:	e8 98 b2 ff ff       	call   c01002c9 <cprintf>

}
c0105031:	90                   	nop
c0105032:	83 c4 54             	add    $0x54,%esp
c0105035:	5b                   	pop    %ebx
c0105036:	5d                   	pop    %ebp
c0105037:	c3                   	ret    

c0105038 <kmem_cache_create>:
// ! End of test code

// kmem_cache_create - create a kmem_cache
struct kmem_cache_t * kmem_cache_create(const char *name, size_t size,
                       void (*ctor)(void*, struct kmem_cache_t *, size_t),
                       void (*dtor)(void*, struct kmem_cache_t *, size_t)) {
c0105038:	f3 0f 1e fb          	endbr32 
c010503c:	55                   	push   %ebp
c010503d:	89 e5                	mov    %esp,%ebp
c010503f:	83 ec 48             	sub    $0x48,%esp
    assert(size <= (PGSIZE - 2));
c0105042:	81 7d 0c fe 0f 00 00 	cmpl   $0xffe,0xc(%ebp)
c0105049:	76 24                	jbe    c010506f <kmem_cache_create+0x37>
c010504b:	c7 44 24 0c 5d 96 10 	movl   $0xc010965d,0xc(%esp)
c0105052:	c0 
c0105053:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c010505a:	c0 
c010505b:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0105062:	00 
c0105063:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c010506a:	e8 c6 b3 ff ff       	call   c0100435 <__panic>
    struct kmem_cache_t *cachep = kmem_cache_alloc(&(cache_cache));
c010506f:	c7 04 24 40 3f 12 c0 	movl   $0xc0123f40,(%esp)
c0105076:	e8 1a 02 00 00       	call   c0105295 <kmem_cache_alloc>
c010507b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (cachep != NULL) {
c010507e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105082:	0f 84 07 01 00 00    	je     c010518f <kmem_cache_create+0x157>
        cachep->objsize = size;
c0105088:	8b 45 0c             	mov    0xc(%ebp),%eax
c010508b:	0f b7 d0             	movzwl %ax,%edx
c010508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105091:	66 89 50 18          	mov    %dx,0x18(%eax)
        cachep->num = PGSIZE / (sizeof(int16_t) + size);
c0105095:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105098:	8d 48 02             	lea    0x2(%eax),%ecx
c010509b:	b8 00 10 00 00       	mov    $0x1000,%eax
c01050a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01050a5:	f7 f1                	div    %ecx
c01050a7:	0f b7 d0             	movzwl %ax,%edx
c01050aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050ad:	66 89 50 1a          	mov    %dx,0x1a(%eax)
        cachep->ctor = ctor;
c01050b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b4:	8b 55 10             	mov    0x10(%ebp),%edx
c01050b7:	89 50 1c             	mov    %edx,0x1c(%eax)
        cachep->dtor = dtor;
c01050ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050bd:	8b 55 14             	mov    0x14(%ebp),%edx
c01050c0:	89 50 20             	mov    %edx,0x20(%eax)
        memcpy(cachep->name, name, CACHE_NAMELEN);
c01050c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c6:	8d 50 24             	lea    0x24(%eax),%edx
c01050c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01050d0:	00 
c01050d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01050d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050d8:	89 14 24             	mov    %edx,(%esp)
c01050db:	e8 b2 2c 00 00       	call   c0107d92 <memcpy>
        list_init(&(cachep->slabs_full));
c01050e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    elm->prev = elm->next = elm;
c01050e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01050e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01050ec:	89 50 04             	mov    %edx,0x4(%eax)
c01050ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01050f2:	8b 50 04             	mov    0x4(%eax),%edx
c01050f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01050f8:	89 10                	mov    %edx,(%eax)
}
c01050fa:	90                   	nop
        list_init(&(cachep->slabs_partial));
c01050fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050fe:	83 c0 08             	add    $0x8,%eax
c0105101:	89 45 d0             	mov    %eax,-0x30(%ebp)
    elm->prev = elm->next = elm;
c0105104:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105107:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010510a:	89 50 04             	mov    %edx,0x4(%eax)
c010510d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105110:	8b 50 04             	mov    0x4(%eax),%edx
c0105113:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105116:	89 10                	mov    %edx,(%eax)
}
c0105118:	90                   	nop
        list_init(&(cachep->slabs_free));
c0105119:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010511c:	83 c0 10             	add    $0x10,%eax
c010511f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    elm->prev = elm->next = elm;
c0105122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105125:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105128:	89 50 04             	mov    %edx,0x4(%eax)
c010512b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010512e:	8b 50 04             	mov    0x4(%eax),%edx
c0105131:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105134:	89 10                	mov    %edx,(%eax)
}
c0105136:	90                   	nop
        list_add(&(cache_chain), &(cachep->cache_link));
c0105137:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010513a:	83 c0 34             	add    $0x34,%eax
c010513d:	c7 45 f0 20 3f 12 c0 	movl   $0xc0123f20,-0x10(%ebp)
c0105144:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105147:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010514a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010514d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105153:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105156:	8b 40 04             	mov    0x4(%eax),%eax
c0105159:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010515c:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010515f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105162:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105165:	89 45 d8             	mov    %eax,-0x28(%ebp)
    prev->next = next->prev = elm;
c0105168:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010516b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010516e:	89 10                	mov    %edx,(%eax)
c0105170:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105173:	8b 10                	mov    (%eax),%edx
c0105175:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105178:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010517b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010517e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105181:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105187:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010518a:	89 10                	mov    %edx,(%eax)
}
c010518c:	90                   	nop
}
c010518d:	90                   	nop
}
c010518e:	90                   	nop
    }
    return cachep;
c010518f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105192:	c9                   	leave  
c0105193:	c3                   	ret    

c0105194 <kmem_cache_destroy>:

// kmem_cache_destroy - destroy a kmem_cache
void kmem_cache_destroy(struct kmem_cache_t *cachep) {
c0105194:	f3 0f 1e fb          	endbr32 
c0105198:	55                   	push   %ebp
c0105199:	89 e5                	mov    %esp,%ebp
c010519b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head, *le;
    // Destory full slabs
    head = &(cachep->slabs_full);
c010519e:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c01051aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051ad:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
c01051b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
c01051b3:	eb 2a                	jmp    c01051df <kmem_cache_destroy+0x4b>
        list_entry_t *temp = le;
c01051b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051be:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01051c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051c4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01051c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
c01051ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051cd:	83 e8 0c             	sub    $0xc,%eax
c01051d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d7:	89 04 24             	mov    %eax,(%esp)
c01051da:	e8 6d f5 ff ff       	call   c010474c <kmem_slab_destroy>
    while (le != head) {
c01051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01051e5:	75 ce                	jne    c01051b5 <kmem_cache_destroy+0x21>
    }
    // Destory partial slabs 
    head = &(cachep->slabs_partial);
c01051e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ea:	83 c0 08             	add    $0x8,%eax
c01051ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01051f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01051f9:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
c01051fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
c01051ff:	eb 2a                	jmp    c010522b <kmem_cache_destroy+0x97>
        list_entry_t *temp = le;
c0105201:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105204:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105207:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010520a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010520d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105210:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105213:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
c0105216:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105219:	83 e8 0c             	sub    $0xc,%eax
c010521c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105220:	8b 45 08             	mov    0x8(%ebp),%eax
c0105223:	89 04 24             	mov    %eax,(%esp)
c0105226:	e8 21 f5 ff ff       	call   c010474c <kmem_slab_destroy>
    while (le != head) {
c010522b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010522e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105231:	75 ce                	jne    c0105201 <kmem_cache_destroy+0x6d>
    }
    // Destory free slabs 
    head = &(cachep->slabs_free);
c0105233:	8b 45 08             	mov    0x8(%ebp),%eax
c0105236:	83 c0 10             	add    $0x10,%eax
c0105239:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010523c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010523f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105245:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(head);
c0105248:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le != head) {
c010524b:	eb 2a                	jmp    c0105277 <kmem_cache_destroy+0xe3>
        list_entry_t *temp = le;
c010524d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105250:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105253:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105256:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0105259:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010525c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010525f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
c0105262:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105265:	83 e8 0c             	sub    $0xc,%eax
c0105268:	89 44 24 04          	mov    %eax,0x4(%esp)
c010526c:	8b 45 08             	mov    0x8(%ebp),%eax
c010526f:	89 04 24             	mov    %eax,(%esp)
c0105272:	e8 d5 f4 ff ff       	call   c010474c <kmem_slab_destroy>
    while (le != head) {
c0105277:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010527a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010527d:	75 ce                	jne    c010524d <kmem_cache_destroy+0xb9>
    }
    // Free kmem_cache 
    kmem_cache_free(&(cache_cache), cachep);
c010527f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105282:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105286:	c7 04 24 40 3f 12 c0 	movl   $0xc0123f40,(%esp)
c010528d:	e8 30 02 00 00       	call   c01054c2 <kmem_cache_free>
}   
c0105292:	90                   	nop
c0105293:	c9                   	leave  
c0105294:	c3                   	ret    

c0105295 <kmem_cache_alloc>:

// kmem_cache_alloc - allocate an object
void * kmem_cache_alloc(struct kmem_cache_t *cachep) {
c0105295:	f3 0f 1e fb          	endbr32 
c0105299:	55                   	push   %ebp
c010529a:	89 e5                	mov    %esp,%ebp
c010529c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    list_entry_t *le = NULL;
c01052a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    // Find in partial list 
    if (!list_empty(&(cachep->slabs_partial)))
c01052a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ac:	83 c0 08             	add    $0x8,%eax
c01052af:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return list->next == list;
c01052b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052b5:	8b 40 04             	mov    0x4(%eax),%eax
c01052b8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01052bb:	0f 94 c0             	sete   %al
c01052be:	0f b6 c0             	movzbl %al,%eax
c01052c1:	85 c0                	test   %eax,%eax
c01052c3:	75 14                	jne    c01052d9 <kmem_cache_alloc+0x44>
        le = list_next(&(cachep->slabs_partial));
c01052c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c8:	83 c0 08             	add    $0x8,%eax
c01052cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return listelm->next;
c01052ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01052d1:	8b 40 04             	mov    0x4(%eax),%eax
c01052d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052d7:	eb 47                	jmp    c0105320 <kmem_cache_alloc+0x8b>
    // Find in empty list 
    else {
        if (list_empty(&(cachep->slabs_free)) && kmem_cache_grow(cachep) == NULL)
c01052d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052dc:	83 c0 10             	add    $0x10,%eax
c01052df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return list->next == list;
c01052e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052e5:	8b 40 04             	mov    0x4(%eax),%eax
c01052e8:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
c01052eb:	0f 94 c0             	sete   %al
c01052ee:	0f b6 c0             	movzbl %al,%eax
c01052f1:	85 c0                	test   %eax,%eax
c01052f3:	74 19                	je     c010530e <kmem_cache_alloc+0x79>
c01052f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f8:	89 04 24             	mov    %eax,(%esp)
c01052fb:	e8 e5 f2 ff ff       	call   c01045e5 <kmem_cache_grow>
c0105300:	85 c0                	test   %eax,%eax
c0105302:	75 0a                	jne    c010530e <kmem_cache_alloc+0x79>
            return NULL;
c0105304:	b8 00 00 00 00       	mov    $0x0,%eax
c0105309:	e9 77 01 00 00       	jmp    c0105485 <kmem_cache_alloc+0x1f0>
        le = list_next(&(cachep->slabs_free));
c010530e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105311:	83 c0 10             	add    $0x10,%eax
c0105314:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
c0105317:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010531a:	8b 40 04             	mov    0x4(%eax),%eax
c010531d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105323:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105326:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105329:	8b 40 04             	mov    0x4(%eax),%eax
c010532c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010532f:	8b 12                	mov    (%edx),%edx
c0105331:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105334:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next;
c0105337:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010533a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010533d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105340:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105343:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105346:	89 10                	mov    %edx,(%eax)
}
c0105348:	90                   	nop
}
c0105349:	90                   	nop
    }
    // Alloc 
    list_del(le);
    struct slab_t *slab = le2slab(le, page_link);
c010534a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010534d:	83 e8 0c             	sub    $0xc,%eax
c0105350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *kva = slab2kva(slab);
c0105353:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105356:	89 04 24             	mov    %eax,(%esp)
c0105359:	e8 33 f2 ff ff       	call   c0104591 <page2kva>
c010535e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int16_t *bufctl = kva;
c0105361:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105364:	89 45 e8             	mov    %eax,-0x18(%ebp)
    void *buf = bufctl + cachep->num;
c0105367:	8b 45 08             	mov    0x8(%ebp),%eax
c010536a:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c010536e:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0105371:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105374:	01 d0                	add    %edx,%eax
c0105376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    void *objp = buf + slab->free * cachep->objsize;
c0105379:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010537c:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
c0105380:	89 c2                	mov    %eax,%edx
c0105382:	8b 45 08             	mov    0x8(%ebp),%eax
c0105385:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c0105389:	0f af c2             	imul   %edx,%eax
c010538c:	89 c2                	mov    %eax,%edx
c010538e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105391:	01 d0                	add    %edx,%eax
c0105393:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Update slab
    slab->inuse ++;
c0105396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105399:	0f b7 40 08          	movzwl 0x8(%eax),%eax
c010539d:	40                   	inc    %eax
c010539e:	0f b7 d0             	movzwl %ax,%edx
c01053a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053a4:	66 89 50 08          	mov    %dx,0x8(%eax)
    slab->free = bufctl[slab->free];
c01053a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053ab:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
c01053af:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01053b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053b5:	01 d0                	add    %edx,%eax
c01053b7:	0f bf 00             	movswl (%eax),%eax
c01053ba:	0f b7 d0             	movzwl %ax,%edx
c01053bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c0:	66 89 50 0a          	mov    %dx,0xa(%eax)
    if (slab->inuse == cachep->num)
c01053c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c7:	0f b7 50 08          	movzwl 0x8(%eax),%edx
c01053cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ce:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c01053d2:	39 c2                	cmp    %eax,%edx
c01053d4:	75 55                	jne    c010542b <kmem_cache_alloc+0x196>
        list_add(&(cachep->slabs_full), le);
c01053d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01053dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053df:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01053e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01053e5:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01053e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01053eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01053ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01053f1:	8b 40 04             	mov    0x4(%eax),%eax
c01053f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01053f7:	89 55 b0             	mov    %edx,-0x50(%ebp)
c01053fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01053fd:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0105400:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next->prev = elm;
c0105403:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105406:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105409:	89 10                	mov    %edx,(%eax)
c010540b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010540e:	8b 10                	mov    (%eax),%edx
c0105410:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105413:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105416:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105419:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010541c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010541f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105422:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105425:	89 10                	mov    %edx,(%eax)
}
c0105427:	90                   	nop
}
c0105428:	90                   	nop
}
c0105429:	eb 57                	jmp    c0105482 <kmem_cache_alloc+0x1ed>
    else 
        list_add(&(cachep->slabs_partial), le);
c010542b:	8b 45 08             	mov    0x8(%ebp),%eax
c010542e:	83 c0 08             	add    $0x8,%eax
c0105431:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105437:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010543a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010543d:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0105440:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105443:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105446:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105449:	8b 40 04             	mov    0x4(%eax),%eax
c010544c:	8b 55 98             	mov    -0x68(%ebp),%edx
c010544f:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0105452:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105455:	89 55 90             	mov    %edx,-0x70(%ebp)
c0105458:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c010545b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010545e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105461:	89 10                	mov    %edx,(%eax)
c0105463:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105466:	8b 10                	mov    (%eax),%edx
c0105468:	8b 45 90             	mov    -0x70(%ebp),%eax
c010546b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010546e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105471:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105474:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105477:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010547a:	8b 55 90             	mov    -0x70(%ebp),%edx
c010547d:	89 10                	mov    %edx,(%eax)
}
c010547f:	90                   	nop
}
c0105480:	90                   	nop
}
c0105481:	90                   	nop
    return objp;
c0105482:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c0105485:	c9                   	leave  
c0105486:	c3                   	ret    

c0105487 <kmem_cache_zalloc>:

// kmem_cache_zalloc - allocate an object and fill it with zero
void * kmem_cache_zalloc(struct kmem_cache_t *cachep) {
c0105487:	f3 0f 1e fb          	endbr32 
c010548b:	55                   	push   %ebp
c010548c:	89 e5                	mov    %esp,%ebp
c010548e:	83 ec 28             	sub    $0x28,%esp
    void *objp = kmem_cache_alloc(cachep);
c0105491:	8b 45 08             	mov    0x8(%ebp),%eax
c0105494:	89 04 24             	mov    %eax,(%esp)
c0105497:	e8 f9 fd ff ff       	call   c0105295 <kmem_cache_alloc>
c010549c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memset(objp, 0, cachep->objsize);
c010549f:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a2:	0f b7 40 18          	movzwl 0x18(%eax),%eax
c01054a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01054b1:	00 
c01054b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054b5:	89 04 24             	mov    %eax,(%esp)
c01054b8:	e8 eb 27 00 00       	call   c0107ca8 <memset>
    return objp;
c01054bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01054c0:	c9                   	leave  
c01054c1:	c3                   	ret    

c01054c2 <kmem_cache_free>:

// kmem_cache_free - free an object
void kmem_cache_free(struct kmem_cache_t *cachep, void *objp) {
c01054c2:	f3 0f 1e fb          	endbr32 
c01054c6:	55                   	push   %ebp
c01054c7:	89 e5                	mov    %esp,%ebp
c01054c9:	83 ec 78             	sub    $0x78,%esp
    // Get slab of object 
    void *base = page2kva(pages);
c01054cc:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c01054d1:	89 04 24             	mov    %eax,(%esp)
c01054d4:	e8 b8 f0 ff ff       	call   c0104591 <page2kva>
c01054d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *kva = ROUNDDOWN(objp, PGSIZE);
c01054dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct slab_t *slab = (struct slab_t *) &pages[(kva-base)/PGSIZE];
c01054ed:	8b 0d 18 40 12 c0    	mov    0xc0124018,%ecx
c01054f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054f6:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01054f9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
c01054ff:	85 c0                	test   %eax,%eax
c0105501:	0f 48 c2             	cmovs  %edx,%eax
c0105504:	c1 f8 0c             	sar    $0xc,%eax
c0105507:	89 c2                	mov    %eax,%edx
c0105509:	89 d0                	mov    %edx,%eax
c010550b:	c1 e0 02             	shl    $0x2,%eax
c010550e:	01 d0                	add    %edx,%eax
c0105510:	c1 e0 02             	shl    $0x2,%eax
c0105513:	01 c8                	add    %ecx,%eax
c0105515:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // Get offset in slab
    int16_t *bufctl = kva;
c0105518:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010551b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    void *buf = bufctl + cachep->num;
c010551e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105521:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
c0105525:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0105528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010552b:	01 d0                	add    %edx,%eax
c010552d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    int offset = (objp - buf) / cachep->objsize;
c0105530:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105533:	2b 45 e0             	sub    -0x20(%ebp),%eax
c0105536:	8b 55 08             	mov    0x8(%ebp),%edx
c0105539:	0f b7 52 18          	movzwl 0x18(%edx),%edx
c010553d:	89 d1                	mov    %edx,%ecx
c010553f:	99                   	cltd   
c0105540:	f7 f9                	idiv   %ecx
c0105542:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Update slab 
    list_del(&(slab->slab_link));
c0105545:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105548:	83 c0 0c             	add    $0xc,%eax
c010554b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_del(listelm->prev, listelm->next);
c010554e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105551:	8b 40 04             	mov    0x4(%eax),%eax
c0105554:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105557:	8b 12                	mov    (%edx),%edx
c0105559:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010555c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next;
c010555f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105562:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105565:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105568:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010556b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010556e:	89 10                	mov    %edx,(%eax)
}
c0105570:	90                   	nop
}
c0105571:	90                   	nop
    bufctl[offset] = slab->free;
c0105572:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105575:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
c0105579:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010557c:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
c010557f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105582:	01 ca                	add    %ecx,%edx
c0105584:	98                   	cwtl   
c0105585:	66 89 02             	mov    %ax,(%edx)
    slab->inuse --;
c0105588:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010558b:	0f b7 40 08          	movzwl 0x8(%eax),%eax
c010558f:	48                   	dec    %eax
c0105590:	0f b7 d0             	movzwl %ax,%edx
c0105593:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105596:	66 89 50 08          	mov    %dx,0x8(%eax)
    slab->free = offset;
c010559a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010559d:	0f b7 d0             	movzwl %ax,%edx
c01055a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055a3:	66 89 50 0a          	mov    %dx,0xa(%eax)
    if (slab->inuse == 0)
c01055a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055aa:	0f b7 40 08          	movzwl 0x8(%eax),%eax
c01055ae:	85 c0                	test   %eax,%eax
c01055b0:	75 5b                	jne    c010560d <kmem_cache_free+0x14b>
        list_add(&(cachep->slabs_free), &(slab->slab_link));
c01055b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055b5:	83 c0 0c             	add    $0xc,%eax
c01055b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055bb:	83 c2 10             	add    $0x10,%edx
c01055be:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01055c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01055c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01055c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01055ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01055cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_add(elm, listelm, listelm->next);
c01055d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055d3:	8b 40 04             	mov    0x4(%eax),%eax
c01055d6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01055d9:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01055dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01055df:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01055e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next->prev = elm;
c01055e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01055e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01055eb:	89 10                	mov    %edx,(%eax)
c01055ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01055f0:	8b 10                	mov    (%eax),%edx
c01055f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01055f5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01055f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01055fb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01055fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105601:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105604:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105607:	89 10                	mov    %edx,(%eax)
}
c0105609:	90                   	nop
}
c010560a:	90                   	nop
}
c010560b:	eb 5a                	jmp    c0105667 <kmem_cache_free+0x1a5>
    else 
        list_add(&(cachep->slabs_partial), &(slab->slab_link));
c010560d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105610:	83 c0 0c             	add    $0xc,%eax
c0105613:	8b 55 08             	mov    0x8(%ebp),%edx
c0105616:	83 c2 08             	add    $0x8,%edx
c0105619:	89 55 b0             	mov    %edx,-0x50(%ebp)
c010561c:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010561f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105622:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105625:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105628:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_add(elm, listelm, listelm->next);
c010562b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010562e:	8b 40 04             	mov    0x4(%eax),%eax
c0105631:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105634:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0105637:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010563a:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010563d:	89 45 98             	mov    %eax,-0x68(%ebp)
    prev->next = next->prev = elm;
c0105640:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105643:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105646:	89 10                	mov    %edx,(%eax)
c0105648:	8b 45 98             	mov    -0x68(%ebp),%eax
c010564b:	8b 10                	mov    (%eax),%edx
c010564d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105650:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105653:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105656:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105659:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010565c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010565f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105662:	89 10                	mov    %edx,(%eax)
}
c0105664:	90                   	nop
}
c0105665:	90                   	nop
}
c0105666:	90                   	nop
}
c0105667:	90                   	nop
c0105668:	c9                   	leave  
c0105669:	c3                   	ret    

c010566a <kmem_cache_size>:

// kmem_cache_size - get object size
size_t kmem_cache_size(struct kmem_cache_t *cachep) {
c010566a:	f3 0f 1e fb          	endbr32 
c010566e:	55                   	push   %ebp
c010566f:	89 e5                	mov    %esp,%ebp
    return cachep->objsize;
c0105671:	8b 45 08             	mov    0x8(%ebp),%eax
c0105674:	0f b7 40 18          	movzwl 0x18(%eax),%eax
}
c0105678:	5d                   	pop    %ebp
c0105679:	c3                   	ret    

c010567a <kmem_cache_name>:

// kmem_cache_name - get cache name
const char * kmem_cache_name(struct kmem_cache_t *cachep) {
c010567a:	f3 0f 1e fb          	endbr32 
c010567e:	55                   	push   %ebp
c010567f:	89 e5                	mov    %esp,%ebp
    return cachep->name;
c0105681:	8b 45 08             	mov    0x8(%ebp),%eax
c0105684:	83 c0 24             	add    $0x24,%eax
}
c0105687:	5d                   	pop    %ebp
c0105688:	c3                   	ret    

c0105689 <kmem_cache_shrink>:

// kmem_cache_shrink - destroy all slabs in free list 
int kmem_cache_shrink(struct kmem_cache_t *cachep) {
c0105689:	f3 0f 1e fb          	endbr32 
c010568d:	55                   	push   %ebp
c010568e:	89 e5                	mov    %esp,%ebp
c0105690:	83 ec 38             	sub    $0x38,%esp
    int count = 0;
c0105693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = list_next(&(cachep->slabs_free));
c010569a:	8b 45 08             	mov    0x8(%ebp),%eax
c010569d:	83 c0 10             	add    $0x10,%eax
c01056a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return listelm->next;
c01056a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056a6:	8b 40 04             	mov    0x4(%eax),%eax
c01056a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &(cachep->slabs_free)) {
c01056ac:	eb 2d                	jmp    c01056db <kmem_cache_shrink+0x52>
        list_entry_t *temp = le;
c01056ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056bd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01056c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        kmem_slab_destroy(cachep, le2slab(temp, page_link));
c01056c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056c6:	83 e8 0c             	sub    $0xc,%eax
c01056c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d0:	89 04 24             	mov    %eax,(%esp)
c01056d3:	e8 74 f0 ff ff       	call   c010474c <kmem_slab_destroy>
        count ++;
c01056d8:	ff 45 f4             	incl   -0xc(%ebp)
    while (le != &(cachep->slabs_free)) {
c01056db:	8b 45 08             	mov    0x8(%ebp),%eax
c01056de:	83 c0 10             	add    $0x10,%eax
c01056e1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01056e4:	75 c8                	jne    c01056ae <kmem_cache_shrink+0x25>
    }
    return count;
c01056e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01056e9:	c9                   	leave  
c01056ea:	c3                   	ret    

c01056eb <kmem_cache_reap>:

// kmem_cache_reap - reap all free slabs 
int kmem_cache_reap() {
c01056eb:	f3 0f 1e fb          	endbr32 
c01056ef:	55                   	push   %ebp
c01056f0:	89 e5                	mov    %esp,%ebp
c01056f2:	83 ec 28             	sub    $0x28,%esp
    int count = 0;
c01056f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &(cache_chain);
c01056fc:	c7 45 f0 20 3f 12 c0 	movl   $0xc0123f20,-0x10(%ebp)
    while ((le = list_next(le)) != &(cache_chain))
c0105703:	eb 11                	jmp    c0105716 <kmem_cache_reap+0x2b>
        count += kmem_cache_shrink(to_struct(le, struct kmem_cache_t, cache_link));
c0105705:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105708:	83 e8 34             	sub    $0x34,%eax
c010570b:	89 04 24             	mov    %eax,(%esp)
c010570e:	e8 76 ff ff ff       	call   c0105689 <kmem_cache_shrink>
c0105713:	01 45 f4             	add    %eax,-0xc(%ebp)
c0105716:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105719:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010571c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010571f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &(cache_chain))
c0105722:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105725:	81 7d f0 20 3f 12 c0 	cmpl   $0xc0123f20,-0x10(%ebp)
c010572c:	75 d7                	jne    c0105705 <kmem_cache_reap+0x1a>
    return count;
c010572e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105731:	c9                   	leave  
c0105732:	c3                   	ret    

c0105733 <kmalloc>:

void * kmalloc(size_t size) {
c0105733:	f3 0f 1e fb          	endbr32 
c0105737:	55                   	push   %ebp
c0105738:	89 e5                	mov    %esp,%ebp
c010573a:	83 ec 18             	sub    $0x18,%esp
    assert(size <= SIZED_CACHE_MAX);
c010573d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
c0105744:	76 24                	jbe    c010576a <kmalloc+0x37>
c0105746:	c7 44 24 0c 72 96 10 	movl   $0xc0109672,0xc(%esp)
c010574d:	c0 
c010574e:	c7 44 24 08 e6 92 10 	movl   $0xc01092e6,0x8(%esp)
c0105755:	c0 
c0105756:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c010575d:	00 
c010575e:	c7 04 24 fb 92 10 c0 	movl   $0xc01092fb,(%esp)
c0105765:	e8 cb ac ff ff       	call   c0100435 <__panic>
    return kmem_cache_alloc(sized_caches[kmem_sized_index(size)]);
c010576a:	8b 45 08             	mov    0x8(%ebp),%eax
c010576d:	89 04 24             	mov    %eax,(%esp)
c0105770:	e8 bb f0 ff ff       	call   c0104830 <kmem_sized_index>
c0105775:	8b 04 85 80 3f 12 c0 	mov    -0x3fedc080(,%eax,4),%eax
c010577c:	89 04 24             	mov    %eax,(%esp)
c010577f:	e8 11 fb ff ff       	call   c0105295 <kmem_cache_alloc>
}
c0105784:	c9                   	leave  
c0105785:	c3                   	ret    

c0105786 <kfree>:

void kfree(void *objp) {
c0105786:	f3 0f 1e fb          	endbr32 
c010578a:	55                   	push   %ebp
c010578b:	89 e5                	mov    %esp,%ebp
c010578d:	83 ec 28             	sub    $0x28,%esp
    void *base = slab2kva(pages);
c0105790:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c0105795:	89 04 24             	mov    %eax,(%esp)
c0105798:	e8 f4 ed ff ff       	call   c0104591 <page2kva>
c010579d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *kva = ROUNDDOWN(objp, PGSIZE);
c01057a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01057ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct slab_t *slab = (struct slab_t *) &pages[(kva-base)/PGSIZE];
c01057b1:	8b 0d 18 40 12 c0    	mov    0xc0124018,%ecx
c01057b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057ba:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01057bd:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
c01057c3:	85 c0                	test   %eax,%eax
c01057c5:	0f 48 c2             	cmovs  %edx,%eax
c01057c8:	c1 f8 0c             	sar    $0xc,%eax
c01057cb:	89 c2                	mov    %eax,%edx
c01057cd:	89 d0                	mov    %edx,%eax
c01057cf:	c1 e0 02             	shl    $0x2,%eax
c01057d2:	01 d0                	add    %edx,%eax
c01057d4:	c1 e0 02             	shl    $0x2,%eax
c01057d7:	01 c8                	add    %ecx,%eax
c01057d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    kmem_cache_free(slab->cachep, objp);
c01057dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057df:	8b 40 04             	mov    0x4(%eax),%eax
c01057e2:	8b 55 08             	mov    0x8(%ebp),%edx
c01057e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057e9:	89 04 24             	mov    %eax,(%esp)
c01057ec:	e8 d1 fc ff ff       	call   c01054c2 <kmem_cache_free>
}
c01057f1:	90                   	nop
c01057f2:	c9                   	leave  
c01057f3:	c3                   	ret    

c01057f4 <kmem_int>:

void kmem_int() {
c01057f4:	f3 0f 1e fb          	endbr32 
c01057f8:	55                   	push   %ebp
c01057f9:	89 e5                	mov    %esp,%ebp
c01057fb:	83 ec 58             	sub    $0x58,%esp

    // Init cache for kmem_cache
    cache_cache.objsize = sizeof(struct kmem_cache_t);
c01057fe:	66 c7 05 58 3f 12 c0 	movw   $0x3c,0xc0123f58
c0105805:	3c 00 
    cache_cache.num = PGSIZE / (sizeof(int16_t) + sizeof(struct kmem_cache_t));
c0105807:	66 c7 05 5a 3f 12 c0 	movw   $0x42,0xc0123f5a
c010580e:	42 00 
    cache_cache.ctor = NULL;
c0105810:	c7 05 5c 3f 12 c0 00 	movl   $0x0,0xc0123f5c
c0105817:	00 00 00 
    cache_cache.dtor = NULL;
c010581a:	c7 05 60 3f 12 c0 00 	movl   $0x0,0xc0123f60
c0105821:	00 00 00 
    memcpy(cache_cache.name, cache_cache_name, CACHE_NAMELEN);
c0105824:	a1 38 0a 12 c0       	mov    0xc0120a38,%eax
c0105829:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0105830:	00 
c0105831:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105835:	c7 04 24 64 3f 12 c0 	movl   $0xc0123f64,(%esp)
c010583c:	e8 51 25 00 00       	call   c0107d92 <memcpy>
c0105841:	c7 45 c4 40 3f 12 c0 	movl   $0xc0123f40,-0x3c(%ebp)
    elm->prev = elm->next = elm;
c0105848:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010584b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010584e:	89 50 04             	mov    %edx,0x4(%eax)
c0105851:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105854:	8b 50 04             	mov    0x4(%eax),%edx
c0105857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010585a:	89 10                	mov    %edx,(%eax)
}
c010585c:	90                   	nop
c010585d:	c7 45 c8 48 3f 12 c0 	movl   $0xc0123f48,-0x38(%ebp)
    elm->prev = elm->next = elm;
c0105864:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105867:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010586a:	89 50 04             	mov    %edx,0x4(%eax)
c010586d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105870:	8b 50 04             	mov    0x4(%eax),%edx
c0105873:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105876:	89 10                	mov    %edx,(%eax)
}
c0105878:	90                   	nop
c0105879:	c7 45 cc 50 3f 12 c0 	movl   $0xc0123f50,-0x34(%ebp)
    elm->prev = elm->next = elm;
c0105880:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105883:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105886:	89 50 04             	mov    %edx,0x4(%eax)
c0105889:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010588c:	8b 50 04             	mov    0x4(%eax),%edx
c010588f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105892:	89 10                	mov    %edx,(%eax)
}
c0105894:	90                   	nop
c0105895:	c7 45 d0 20 3f 12 c0 	movl   $0xc0123f20,-0x30(%ebp)
    elm->prev = elm->next = elm;
c010589c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010589f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01058a2:	89 50 04             	mov    %edx,0x4(%eax)
c01058a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058a8:	8b 50 04             	mov    0x4(%eax),%edx
c01058ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058ae:	89 10                	mov    %edx,(%eax)
}
c01058b0:	90                   	nop
c01058b1:	c7 45 ec 20 3f 12 c0 	movl   $0xc0123f20,-0x14(%ebp)
c01058b8:	c7 45 e8 74 3f 12 c0 	movl   $0xc0123f74,-0x18(%ebp)
c01058bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c01058cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058ce:	8b 40 04             	mov    0x4(%eax),%eax
c01058d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01058d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01058d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058da:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01058dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c01058e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01058e6:	89 10                	mov    %edx,(%eax)
c01058e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058eb:	8b 10                	mov    (%eax),%edx
c01058ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01058fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105902:	89 10                	mov    %edx,(%eax)
}
c0105904:	90                   	nop
}
c0105905:	90                   	nop
}
c0105906:	90                   	nop
    list_init(&(cache_cache.slabs_free));
    list_init(&(cache_chain));
    list_add(&(cache_chain), &(cache_cache.cache_link));

    // Init sized cache 
    for (int i = 0, size = 16; i < SIZED_CACHE_NUM; i++, size *= 2)
c0105907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010590e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
c0105915:	eb 34                	jmp    c010594b <kmem_int+0x157>
        sized_caches[i] = kmem_cache_create(sized_cache_name, size, NULL, NULL); 
c0105917:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010591a:	a1 3c 0a 12 c0       	mov    0xc0120a3c,%eax
c010591f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105926:	00 
c0105927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010592e:	00 
c010592f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105933:	89 04 24             	mov    %eax,(%esp)
c0105936:	e8 fd f6 ff ff       	call   c0105038 <kmem_cache_create>
c010593b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010593e:	89 04 95 80 3f 12 c0 	mov    %eax,-0x3fedc080(,%edx,4)
    for (int i = 0, size = 16; i < SIZED_CACHE_NUM; i++, size *= 2)
c0105945:	ff 45 f4             	incl   -0xc(%ebp)
c0105948:	d1 65 f0             	shll   -0x10(%ebp)
c010594b:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
c010594f:	7e c6                	jle    c0105917 <kmem_int+0x123>

    check_kmem();
c0105951:	e8 e4 ef ff ff       	call   c010493a <check_kmem>
c0105956:	90                   	nop
c0105957:	c9                   	leave  
c0105958:	c3                   	ret    

c0105959 <page2ppn>:
page2ppn(struct Page *page) {
c0105959:	55                   	push   %ebp
c010595a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010595c:	a1 18 40 12 c0       	mov    0xc0124018,%eax
c0105961:	8b 55 08             	mov    0x8(%ebp),%edx
c0105964:	29 c2                	sub    %eax,%edx
c0105966:	89 d0                	mov    %edx,%eax
c0105968:	c1 f8 02             	sar    $0x2,%eax
c010596b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0105971:	5d                   	pop    %ebp
c0105972:	c3                   	ret    

c0105973 <page2pa>:
page2pa(struct Page *page) {
c0105973:	55                   	push   %ebp
c0105974:	89 e5                	mov    %esp,%ebp
c0105976:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105979:	8b 45 08             	mov    0x8(%ebp),%eax
c010597c:	89 04 24             	mov    %eax,(%esp)
c010597f:	e8 d5 ff ff ff       	call   c0105959 <page2ppn>
c0105984:	c1 e0 0c             	shl    $0xc,%eax
}
c0105987:	c9                   	leave  
c0105988:	c3                   	ret    

c0105989 <page_ref>:
page_ref(struct Page *page) {
c0105989:	55                   	push   %ebp
c010598a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010598c:	8b 45 08             	mov    0x8(%ebp),%eax
c010598f:	8b 00                	mov    (%eax),%eax
}
c0105991:	5d                   	pop    %ebp
c0105992:	c3                   	ret    

c0105993 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0105993:	55                   	push   %ebp
c0105994:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105996:	8b 45 08             	mov    0x8(%ebp),%eax
c0105999:	8b 55 0c             	mov    0xc(%ebp),%edx
c010599c:	89 10                	mov    %edx,(%eax)
}
c010599e:	90                   	nop
c010599f:	5d                   	pop    %ebp
c01059a0:	c3                   	ret    

c01059a1 <default_init>:
#define free_list (free_area.free_list)             //双向链表指针
#define nr_free (free_area.nr_free)                 //记录当前空闲页的个数的无符号整型变量nr_free

//对free_area_t的双向链表和空闲块的数目进行初始化
static void
default_init(void) {
c01059a1:	f3 0f 1e fb          	endbr32 
c01059a5:	55                   	push   %ebp
c01059a6:	89 e5                	mov    %esp,%ebp
c01059a8:	83 ec 10             	sub    $0x10,%esp
c01059ab:	c7 45 fc 1c 40 12 c0 	movl   $0xc012401c,-0x4(%ebp)
    elm->prev = elm->next = elm;
c01059b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01059b8:	89 50 04             	mov    %edx,0x4(%eax)
c01059bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059be:	8b 50 04             	mov    0x4(%eax),%edx
c01059c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059c4:	89 10                	mov    %edx,(%eax)
}
c01059c6:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01059c7:	c7 05 24 40 12 c0 00 	movl   $0x0,0xc0124024
c01059ce:	00 00 00 
}
c01059d1:	90                   	nop
c01059d2:	c9                   	leave  
c01059d3:	c3                   	ret    

c01059d4 <default_init_memmap>:
然后对每一块物理页进行设置：先判断是否为保留页，如果不是，则进行下一步。
将标志位清0，连续空页个数清0，然后将标志位设置为1，将引用此物理页的虚拟页的个数清0。
然后再加入空闲链表。最后计算空闲页的个数，修改物理基地址页的property的个数为n
*/
static void
default_init_memmap(struct Page *base, size_t n) {  //基地址和物理页数量
c01059d4:	f3 0f 1e fb          	endbr32 
c01059d8:	55                   	push   %ebp
c01059d9:	89 e5                	mov    %esp,%ebp
c01059db:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01059de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059e2:	75 24                	jne    c0105a08 <default_init_memmap+0x34>
c01059e4:	c7 44 24 0c 8c 96 10 	movl   $0xc010968c,0xc(%esp)
c01059eb:	c0 
c01059ec:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01059f3:	c0 
c01059f4:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
c01059fb:	00 
c01059fc:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105a03:	e8 2d aa ff ff       	call   c0100435 <__panic>
    struct Page *p = base;
c0105a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {                   //处理每一页
c0105a0e:	eb 7d                	jmp    c0105a8d <default_init_memmap+0xb9>
        assert(PageReserved(p));                    //是否为保留页
c0105a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a13:	83 c0 04             	add    $0x4,%eax
c0105a16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0105a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a26:	0f a3 10             	bt     %edx,(%eax)
c0105a29:	19 c0                	sbb    %eax,%eax
c0105a2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0105a2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a32:	0f 95 c0             	setne  %al
c0105a35:	0f b6 c0             	movzbl %al,%eax
c0105a38:	85 c0                	test   %eax,%eax
c0105a3a:	75 24                	jne    c0105a60 <default_init_memmap+0x8c>
c0105a3c:	c7 44 24 0c bd 96 10 	movl   $0xc01096bd,0xc(%esp)
c0105a43:	c0 
c0105a44:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0105a4b:	c0 
c0105a4c:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
c0105a53:	00 
c0105a54:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105a5b:	e8 d5 a9 ff ff       	call   c0100435 <__panic>
        p->flags = p->property = 0;                 //标志位清零, 空闲块数量
c0105a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a6d:	8b 50 08             	mov    0x8(%eax),%edx
c0105a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a73:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);                         //将引用此物理页的虚拟页的个数清0
c0105a76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a7d:	00 
c0105a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a81:	89 04 24             	mov    %eax,(%esp)
c0105a84:	e8 0a ff ff ff       	call   c0105993 <set_page_ref>
    for (; p != base + n; p ++) {                   //处理每一页
c0105a89:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0105a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a90:	89 d0                	mov    %edx,%eax
c0105a92:	c1 e0 02             	shl    $0x2,%eax
c0105a95:	01 d0                	add    %edx,%eax
c0105a97:	c1 e0 02             	shl    $0x2,%eax
c0105a9a:	89 c2                	mov    %eax,%edx
c0105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9f:	01 d0                	add    %edx,%eax
c0105aa1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105aa4:	0f 85 66 ff ff ff    	jne    c0105a10 <default_init_memmap+0x3c>
    }
    base->property = n;                             //开头页面的空闲块数量设置为n
c0105aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ab0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);      
c0105ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab6:	83 c0 04             	add    $0x4,%eax
c0105ab9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105ac0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105ac3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105ac6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105ac9:	0f ab 10             	bts    %edx,(%eax)
}
c0105acc:	90                   	nop
    nr_free += n;                                   //新增空闲页个数nr_free
c0105acd:	8b 15 24 40 12 c0    	mov    0xc0124024,%edx
c0105ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad6:	01 d0                	add    %edx,%eax
c0105ad8:	a3 24 40 12 c0       	mov    %eax,0xc0124024
    list_add_before(&free_list, &(base->page_link));//将新增的Page加在双向链表指针中
c0105add:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae0:	83 c0 0c             	add    $0xc,%eax
c0105ae3:	c7 45 e4 1c 40 12 c0 	movl   $0xc012401c,-0x1c(%ebp)
c0105aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105af0:	8b 00                	mov    (%eax),%eax
c0105af2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105af5:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105af8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105afe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0105b01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b04:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105b07:	89 10                	mov    %edx,(%eax)
c0105b09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b0c:	8b 10                	mov    (%eax),%edx
c0105b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b11:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105b14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105b1a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105b1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b20:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105b23:	89 10                	mov    %edx,(%eax)
}
c0105b25:	90                   	nop
}
c0105b26:	90                   	nop
}
c0105b27:	90                   	nop
c0105b28:	c9                   	leave  
c0105b29:	c3                   	ret    

c0105b2a <default_alloc_pages>:
如果当前空闲页的大小大于所需大小。则分割页块。具体操作就是，刚刚分配了n个页，如果分配完了，还有连续的空间，
则在最后分配的那个页的下一个页（未分配），更新它的连续空闲页值。如果正好合适，则不进行操作。
最后计算剩余空闲页个数并返回分配的页块地址。
*/
static struct Page *
default_alloc_pages(size_t n) {
c0105b2a:	f3 0f 1e fb          	endbr32 
c0105b2e:	55                   	push   %ebp
c0105b2f:	89 e5                	mov    %esp,%ebp
c0105b31:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);                                              
c0105b34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b38:	75 24                	jne    c0105b5e <default_alloc_pages+0x34>
c0105b3a:	c7 44 24 0c 8c 96 10 	movl   $0xc010968c,0xc(%esp)
c0105b41:	c0 
c0105b42:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0105b49:	c0 
c0105b4a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0105b51:	00 
c0105b52:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105b59:	e8 d7 a8 ff ff       	call   c0100435 <__panic>
    if (n > nr_free) {                                              //检查空闲页的大小是否大于所需的页块大小
c0105b5e:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c0105b63:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105b66:	76 0a                	jbe    c0105b72 <default_alloc_pages+0x48>
        return NULL;
c0105b68:	b8 00 00 00 00       	mov    $0x0,%eax
c0105b6d:	e9 43 01 00 00       	jmp    c0105cb5 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
c0105b72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105b79:	c7 45 f0 1c 40 12 c0 	movl   $0xc012401c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {                    //遍历链表找到合适的空闲页
c0105b80:	eb 1c                	jmp    c0105b9e <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c0105b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b85:	83 e8 0c             	sub    $0xc,%eax
c0105b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {                                     //第一个目标页
c0105b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b8e:	8b 40 08             	mov    0x8(%eax),%eax
c0105b91:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105b94:	77 08                	ja     c0105b9e <default_alloc_pages+0x74>
            page = p;
c0105b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105b9c:	eb 18                	jmp    c0105bb6 <default_alloc_pages+0x8c>
c0105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0105ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ba7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {                    //遍历链表找到合适的空闲页
c0105baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bad:	81 7d f0 1c 40 12 c0 	cmpl   $0xc012401c,-0x10(%ebp)
c0105bb4:	75 cc                	jne    c0105b82 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {                                             //如果页的空闲块数量大于n 执行分割
c0105bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105bba:	0f 84 f2 00 00 00    	je     c0105cb2 <default_alloc_pages+0x188>
        if (page->property > n) {
c0105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc3:	8b 40 08             	mov    0x8(%eax),%eax
c0105bc6:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105bc9:	0f 83 8f 00 00 00    	jae    c0105c5e <default_alloc_pages+0x134>
            struct Page *p = page + n;                              //指针后移n单位
c0105bcf:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bd2:	89 d0                	mov    %edx,%eax
c0105bd4:	c1 e0 02             	shl    $0x2,%eax
c0105bd7:	01 d0                	add    %edx,%eax
c0105bd9:	c1 e0 02             	shl    $0x2,%eax
c0105bdc:	89 c2                	mov    %eax,%edx
c0105bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105be1:	01 d0                	add    %edx,%eax
c0105be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;                       //数量减n
c0105be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105be9:	8b 40 08             	mov    0x8(%eax),%eax
c0105bec:	2b 45 08             	sub    0x8(%ebp),%eax
c0105bef:	89 c2                	mov    %eax,%edx
c0105bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105bf4:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                                     //调SetPageProperty设置当前页面预留
c0105bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105bfa:	83 c0 04             	add    $0x4,%eax
c0105bfd:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0105c04:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105c07:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105c0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105c0d:	0f ab 10             	bts    %edx,(%eax)
}
c0105c10:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));    //链接被分割之后剩下的空闲块地址
c0105c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c14:	83 c0 0c             	add    $0xc,%eax
c0105c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c1a:	83 c2 0c             	add    $0xc,%edx
c0105c1d:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0105c20:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c26:	8b 40 04             	mov    0x4(%eax),%eax
c0105c29:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105c2c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0105c2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105c32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105c35:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0105c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105c3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105c3e:	89 10                	mov    %edx,(%eax)
c0105c40:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105c43:	8b 10                	mov    (%eax),%edx
c0105c45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105c48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105c4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105c51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c5a:	89 10                	mov    %edx,(%eax)
}
c0105c5c:	90                   	nop
}
c0105c5d:	90                   	nop
        }
        list_del(&(page->page_link));                               //删除pageLink链接
c0105c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c61:	83 c0 0c             	add    $0xc,%eax
c0105c64:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c67:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105c6a:	8b 40 04             	mov    0x4(%eax),%eax
c0105c6d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105c70:	8b 12                	mov    (%edx),%edx
c0105c72:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0105c75:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c0105c78:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105c7b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105c7e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105c84:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105c87:	89 10                	mov    %edx,(%eax)
}
c0105c89:	90                   	nop
}
c0105c8a:	90                   	nop
        nr_free -= n;                                               //更新空闲页个数
c0105c8b:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c0105c90:	2b 45 08             	sub    0x8(%ebp),%eax
c0105c93:	a3 24 40 12 c0       	mov    %eax,0xc0124024
        ClearPageProperty(page);                                    //清空该页面的连续空闲页面数量值
c0105c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c9b:	83 c0 04             	add    $0x4,%eax
c0105c9e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105ca5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105ca8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105cab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105cae:	0f b3 10             	btr    %edx,(%eax)
}
c0105cb1:	90                   	nop
    }
    return page;
c0105cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105cb5:	c9                   	leave  
c0105cb6:	c3                   	ret    

c0105cb7 <default_free_pages>:
接着，声明一个页p，p遍历一遍整个物理空间，直到遍历到base所在位置停止，开始释放操作
找到了这个基地址之后，将空闲页重新加进来（之前在分配的时候删除），设置一系列标记位
检查合并, 如果插入基地址附近的高地址或低地址可以合并，那么需要更新相应的连续空闲页数量，向高合并和向低合并。
*/
static void
default_free_pages(struct Page *base, size_t n) {
c0105cb7:	f3 0f 1e fb          	endbr32 
c0105cbb:	55                   	push   %ebp
c0105cbc:	89 e5                	mov    %esp,%ebp
c0105cbe:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0); 
c0105cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105cc8:	75 24                	jne    c0105cee <default_free_pages+0x37>
c0105cca:	c7 44 24 0c 8c 96 10 	movl   $0xc010968c,0xc(%esp)
c0105cd1:	c0 
c0105cd2:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0105cd9:	c0 
c0105cda:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0105ce1:	00 
c0105ce2:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105ce9:	e8 47 a7 ff ff       	call   c0100435 <__panic>
    //assert(PageReserved(base));                         //检查基地址所在的页是否为预留                                  
    struct Page *p = base;
c0105cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {                       //遍历整个物理空间
c0105cf4:	e9 9d 00 00 00       	jmp    c0105d96 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));   //检查是否是预留或者head页,内核保留无法分配释放, 只有PageProperty有效才是!free状态
c0105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cfc:	83 c0 04             	add    $0x4,%eax
c0105cff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105d06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d0f:	0f a3 10             	bt     %edx,(%eax)
c0105d12:	19 c0                	sbb    %eax,%eax
c0105d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0105d17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105d1b:	0f 95 c0             	setne  %al
c0105d1e:	0f b6 c0             	movzbl %al,%eax
c0105d21:	85 c0                	test   %eax,%eax
c0105d23:	75 2c                	jne    c0105d51 <default_free_pages+0x9a>
c0105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d28:	83 c0 04             	add    $0x4,%eax
c0105d2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105d32:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d38:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d3b:	0f a3 10             	bt     %edx,(%eax)
c0105d3e:	19 c0                	sbb    %eax,%eax
c0105d40:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0105d43:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105d47:	0f 95 c0             	setne  %al
c0105d4a:	0f b6 c0             	movzbl %al,%eax
c0105d4d:	85 c0                	test   %eax,%eax
c0105d4f:	74 24                	je     c0105d75 <default_free_pages+0xbe>
c0105d51:	c7 44 24 0c d0 96 10 	movl   $0xc01096d0,0xc(%esp)
c0105d58:	c0 
c0105d59:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0105d60:	c0 
c0105d61:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0105d68:	00 
c0105d69:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105d70:	e8 c0 a6 ff ff       	call   c0100435 <__panic>
        p->flags = 0;                                   //设置flage标志
c0105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);                             //将引用此物理页的虚拟页的个数清0, 这里类似与初始化的设置
c0105d7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105d86:	00 
c0105d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8a:	89 04 24             	mov    %eax,(%esp)
c0105d8d:	e8 01 fc ff ff       	call   c0105993 <set_page_ref>
    for (; p != base + n; p ++) {                       //遍历整个物理空间
c0105d92:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0105d96:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d99:	89 d0                	mov    %edx,%eax
c0105d9b:	c1 e0 02             	shl    $0x2,%eax
c0105d9e:	01 d0                	add    %edx,%eax
c0105da0:	c1 e0 02             	shl    $0x2,%eax
c0105da3:	89 c2                	mov    %eax,%edx
c0105da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da8:	01 d0                	add    %edx,%eax
c0105daa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105dad:	0f 85 46 ff ff ff    	jne    c0105cf9 <default_free_pages+0x42>
    }
    base->property = n;                                 //设置空闲块数量
c0105db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105db9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);                              //调SetPageProperty设置当前页面预留仅仅head
c0105dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbf:	83 c0 04             	add    $0x4,%eax
c0105dc2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105dc9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105dcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105dcf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105dd2:	0f ab 10             	bts    %edx,(%eax)
}
c0105dd5:	90                   	nop
c0105dd6:	c7 45 d4 1c 40 12 c0 	movl   $0xc012401c,-0x2c(%ebp)
    return listelm->next;
c0105ddd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105de0:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);           //新建一个管理结构,为链表头的子节点
c0105de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          //遍历
c0105de6:	e9 0e 01 00 00       	jmp    c0105ef9 <default_free_pages+0x242>
        p = le2page(le, page_link);                     //新页le2page就是初始化为一个Page结构
c0105deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dee:	83 e8 0c             	sub    $0xc,%eax
c0105df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105df7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105dfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105dfd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);                             //取下一个节点
c0105e00:	89 45 f0             	mov    %eax,-0x10(%ebp)

        //向高地址合并
        if (base + base->property == p) {               //如果到达当前页的尾部地址,执行合并
c0105e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e06:	8b 50 08             	mov    0x8(%eax),%edx
c0105e09:	89 d0                	mov    %edx,%eax
c0105e0b:	c1 e0 02             	shl    $0x2,%eax
c0105e0e:	01 d0                	add    %edx,%eax
c0105e10:	c1 e0 02             	shl    $0x2,%eax
c0105e13:	89 c2                	mov    %eax,%edx
c0105e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e18:	01 d0                	add    %edx,%eax
c0105e1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105e1d:	75 5d                	jne    c0105e7c <default_free_pages+0x1c5>
            base->property += p->property;              //增加头页的property
c0105e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e22:	8b 50 08             	mov    0x8(%eax),%edx
c0105e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e28:	8b 40 08             	mov    0x8(%eax),%eax
c0105e2b:	01 c2                	add    %eax,%edx
c0105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e30:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);                       //清空该页面的连续空闲页面数量值
c0105e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e36:	83 c0 04             	add    $0x4,%eax
c0105e39:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0105e40:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105e43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105e46:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105e49:	0f b3 10             	btr    %edx,(%eax)
}
c0105e4c:	90                   	nop
            list_del(&(p->page_link));                  //删除旧的索引
c0105e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e50:	83 c0 0c             	add    $0xc,%eax
c0105e53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105e56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105e59:	8b 40 04             	mov    0x4(%eax),%eax
c0105e5c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105e5f:	8b 12                	mov    (%edx),%edx
c0105e61:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105e64:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0105e67:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105e6a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105e6d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105e70:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105e73:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105e76:	89 10                	mov    %edx,(%eax)
}
c0105e78:	90                   	nop
}
c0105e79:	90                   	nop
c0105e7a:	eb 7d                	jmp    c0105ef9 <default_free_pages+0x242>
        }
        //向低地址合并
        else if (p + p->property == base) {             //同上
c0105e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e7f:	8b 50 08             	mov    0x8(%eax),%edx
c0105e82:	89 d0                	mov    %edx,%eax
c0105e84:	c1 e0 02             	shl    $0x2,%eax
c0105e87:	01 d0                	add    %edx,%eax
c0105e89:	c1 e0 02             	shl    $0x2,%eax
c0105e8c:	89 c2                	mov    %eax,%edx
c0105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e91:	01 d0                	add    %edx,%eax
c0105e93:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105e96:	75 61                	jne    c0105ef9 <default_free_pages+0x242>
            p->property += base->property;              //增加头页的property
c0105e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e9b:	8b 50 08             	mov    0x8(%eax),%edx
c0105e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea1:	8b 40 08             	mov    0x8(%eax),%eax
c0105ea4:	01 c2                	add    %eax,%edx
c0105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ea9:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);                    //clear 
c0105eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eaf:	83 c0 04             	add    $0x4,%eax
c0105eb2:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0105eb9:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105ebc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105ebf:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105ec2:	0f b3 10             	btr    %edx,(%eax)
}
c0105ec5:	90                   	nop
            base = p;                                   //迭代交换base
c0105ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ec9:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));                  //删除旧的索引
c0105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ecf:	83 c0 0c             	add    $0xc,%eax
c0105ed2:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105ed5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105ed8:	8b 40 04             	mov    0x4(%eax),%eax
c0105edb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105ede:	8b 12                	mov    (%edx),%edx
c0105ee0:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0105ee3:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0105ee6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105ee9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105eec:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105eef:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105ef2:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105ef5:	89 10                	mov    %edx,(%eax)
}
c0105ef7:	90                   	nop
}
c0105ef8:	90                   	nop
    while (le != &free_list) {                          //遍历
c0105ef9:	81 7d f0 1c 40 12 c0 	cmpl   $0xc012401c,-0x10(%ebp)
c0105f00:	0f 85 e5 fe ff ff    	jne    c0105deb <default_free_pages+0x134>
        }
    }

    //检查合并结果是否发生了错误
    nr_free += n;                                       //新增空闲快数量
c0105f06:	8b 15 24 40 12 c0    	mov    0xc0124024,%edx
c0105f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f0f:	01 d0                	add    %edx,%eax
c0105f11:	a3 24 40 12 c0       	mov    %eax,0xc0124024
c0105f16:	c7 45 9c 1c 40 12 c0 	movl   $0xc012401c,-0x64(%ebp)
    return listelm->next;
c0105f1d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105f20:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);                         
c0105f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          
c0105f26:	eb 74                	jmp    c0105f9c <default_free_pages+0x2e5>
        p = le2page(le, page_link);
c0105f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f2b:	83 e8 0c             	sub    $0xc,%eax
c0105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {               //如果当前页的尾部地址小于等于p
c0105f31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f34:	8b 50 08             	mov    0x8(%eax),%edx
c0105f37:	89 d0                	mov    %edx,%eax
c0105f39:	c1 e0 02             	shl    $0x2,%eax
c0105f3c:	01 d0                	add    %edx,%eax
c0105f3e:	c1 e0 02             	shl    $0x2,%eax
c0105f41:	89 c2                	mov    %eax,%edx
c0105f43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f46:	01 d0                	add    %edx,%eax
c0105f48:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105f4b:	72 40                	jb     c0105f8d <default_free_pages+0x2d6>
            assert(base + base->property != p);         //检查是否不等于p
c0105f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f50:	8b 50 08             	mov    0x8(%eax),%edx
c0105f53:	89 d0                	mov    %edx,%eax
c0105f55:	c1 e0 02             	shl    $0x2,%eax
c0105f58:	01 d0                	add    %edx,%eax
c0105f5a:	c1 e0 02             	shl    $0x2,%eax
c0105f5d:	89 c2                	mov    %eax,%edx
c0105f5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f62:	01 d0                	add    %edx,%eax
c0105f64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105f67:	75 3e                	jne    c0105fa7 <default_free_pages+0x2f0>
c0105f69:	c7 44 24 0c f5 96 10 	movl   $0xc01096f5,0xc(%esp)
c0105f70:	c0 
c0105f71:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0105f78:	c0 
c0105f79:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0105f80:	00 
c0105f81:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0105f88:	e8 a8 a4 ff ff       	call   c0100435 <__panic>
c0105f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f90:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105f93:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105f96:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0105f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                          
c0105f9c:	81 7d f0 1c 40 12 c0 	cmpl   $0xc012401c,-0x10(%ebp)
c0105fa3:	75 83                	jne    c0105f28 <default_free_pages+0x271>
c0105fa5:	eb 01                	jmp    c0105fa8 <default_free_pages+0x2f1>
            break;
c0105fa7:	90                   	nop
    }
    list_add_before(le, &(base->page_link));            //将新增的Page加在双向链表指针中
c0105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fab:	8d 50 0c             	lea    0xc(%eax),%edx
c0105fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fb1:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105fb4:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105fb7:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105fba:	8b 00                	mov    (%eax),%eax
c0105fbc:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105fbf:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105fc2:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105fc5:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105fc8:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0105fcb:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105fce:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105fd1:	89 10                	mov    %edx,(%eax)
c0105fd3:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105fd6:	8b 10                	mov    (%eax),%edx
c0105fd8:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105fdb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105fde:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105fe1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105fe4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105fe7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105fea:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105fed:	89 10                	mov    %edx,(%eax)
}
c0105fef:	90                   	nop
}
c0105ff0:	90                   	nop
}
c0105ff1:	90                   	nop
c0105ff2:	c9                   	leave  
c0105ff3:	c3                   	ret    

c0105ff4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105ff4:	f3 0f 1e fb          	endbr32 
c0105ff8:	55                   	push   %ebp
c0105ff9:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105ffb:	a1 24 40 12 c0       	mov    0xc0124024,%eax
}
c0106000:	5d                   	pop    %ebp
c0106001:	c3                   	ret    

c0106002 <basic_check>:



static void
basic_check(void) {
c0106002:	f3 0f 1e fb          	endbr32 
c0106006:	55                   	push   %ebp
c0106007:	89 e5                	mov    %esp,%ebp
c0106009:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010600c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106013:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106016:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106019:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010601c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010601f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106026:	e8 6b ce ff ff       	call   c0102e96 <alloc_pages>
c010602b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010602e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106032:	75 24                	jne    c0106058 <basic_check+0x56>
c0106034:	c7 44 24 0c 10 97 10 	movl   $0xc0109710,0xc(%esp)
c010603b:	c0 
c010603c:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106043:	c0 
c0106044:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c010604b:	00 
c010604c:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106053:	e8 dd a3 ff ff       	call   c0100435 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106058:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010605f:	e8 32 ce ff ff       	call   c0102e96 <alloc_pages>
c0106064:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010606b:	75 24                	jne    c0106091 <basic_check+0x8f>
c010606d:	c7 44 24 0c 2c 97 10 	movl   $0xc010972c,0xc(%esp)
c0106074:	c0 
c0106075:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010607c:	c0 
c010607d:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106084:	00 
c0106085:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010608c:	e8 a4 a3 ff ff       	call   c0100435 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0106091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106098:	e8 f9 cd ff ff       	call   c0102e96 <alloc_pages>
c010609d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060a4:	75 24                	jne    c01060ca <basic_check+0xc8>
c01060a6:	c7 44 24 0c 48 97 10 	movl   $0xc0109748,0xc(%esp)
c01060ad:	c0 
c01060ae:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01060b5:	c0 
c01060b6:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c01060bd:	00 
c01060be:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01060c5:	e8 6b a3 ff ff       	call   c0100435 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01060ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01060d0:	74 10                	je     c01060e2 <basic_check+0xe0>
c01060d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060d8:	74 08                	je     c01060e2 <basic_check+0xe0>
c01060da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060e0:	75 24                	jne    c0106106 <basic_check+0x104>
c01060e2:	c7 44 24 0c 64 97 10 	movl   $0xc0109764,0xc(%esp)
c01060e9:	c0 
c01060ea:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01060f1:	c0 
c01060f2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c01060f9:	00 
c01060fa:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106101:	e8 2f a3 ff ff       	call   c0100435 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0106106:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106109:	89 04 24             	mov    %eax,(%esp)
c010610c:	e8 78 f8 ff ff       	call   c0105989 <page_ref>
c0106111:	85 c0                	test   %eax,%eax
c0106113:	75 1e                	jne    c0106133 <basic_check+0x131>
c0106115:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106118:	89 04 24             	mov    %eax,(%esp)
c010611b:	e8 69 f8 ff ff       	call   c0105989 <page_ref>
c0106120:	85 c0                	test   %eax,%eax
c0106122:	75 0f                	jne    c0106133 <basic_check+0x131>
c0106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106127:	89 04 24             	mov    %eax,(%esp)
c010612a:	e8 5a f8 ff ff       	call   c0105989 <page_ref>
c010612f:	85 c0                	test   %eax,%eax
c0106131:	74 24                	je     c0106157 <basic_check+0x155>
c0106133:	c7 44 24 0c 88 97 10 	movl   $0xc0109788,0xc(%esp)
c010613a:	c0 
c010613b:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106142:	c0 
c0106143:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c010614a:	00 
c010614b:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106152:	e8 de a2 ff ff       	call   c0100435 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0106157:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010615a:	89 04 24             	mov    %eax,(%esp)
c010615d:	e8 11 f8 ff ff       	call   c0105973 <page2pa>
c0106162:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0106168:	c1 e2 0c             	shl    $0xc,%edx
c010616b:	39 d0                	cmp    %edx,%eax
c010616d:	72 24                	jb     c0106193 <basic_check+0x191>
c010616f:	c7 44 24 0c c4 97 10 	movl   $0xc01097c4,0xc(%esp)
c0106176:	c0 
c0106177:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010617e:	c0 
c010617f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106186:	00 
c0106187:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010618e:	e8 a2 a2 ff ff       	call   c0100435 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0106193:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106196:	89 04 24             	mov    %eax,(%esp)
c0106199:	e8 d5 f7 ff ff       	call   c0105973 <page2pa>
c010619e:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c01061a4:	c1 e2 0c             	shl    $0xc,%edx
c01061a7:	39 d0                	cmp    %edx,%eax
c01061a9:	72 24                	jb     c01061cf <basic_check+0x1cd>
c01061ab:	c7 44 24 0c e1 97 10 	movl   $0xc01097e1,0xc(%esp)
c01061b2:	c0 
c01061b3:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01061ba:	c0 
c01061bb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c01061c2:	00 
c01061c3:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01061ca:	e8 66 a2 ff ff       	call   c0100435 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01061cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d2:	89 04 24             	mov    %eax,(%esp)
c01061d5:	e8 99 f7 ff ff       	call   c0105973 <page2pa>
c01061da:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c01061e0:	c1 e2 0c             	shl    $0xc,%edx
c01061e3:	39 d0                	cmp    %edx,%eax
c01061e5:	72 24                	jb     c010620b <basic_check+0x209>
c01061e7:	c7 44 24 0c fe 97 10 	movl   $0xc01097fe,0xc(%esp)
c01061ee:	c0 
c01061ef:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01061f6:	c0 
c01061f7:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01061fe:	00 
c01061ff:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106206:	e8 2a a2 ff ff       	call   c0100435 <__panic>

    list_entry_t free_list_store = free_list;
c010620b:	a1 1c 40 12 c0       	mov    0xc012401c,%eax
c0106210:	8b 15 20 40 12 c0    	mov    0xc0124020,%edx
c0106216:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106219:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010621c:	c7 45 dc 1c 40 12 c0 	movl   $0xc012401c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0106223:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106226:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106229:	89 50 04             	mov    %edx,0x4(%eax)
c010622c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010622f:	8b 50 04             	mov    0x4(%eax),%edx
c0106232:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106235:	89 10                	mov    %edx,(%eax)
}
c0106237:	90                   	nop
c0106238:	c7 45 e0 1c 40 12 c0 	movl   $0xc012401c,-0x20(%ebp)
    return list->next == list;
c010623f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106242:	8b 40 04             	mov    0x4(%eax),%eax
c0106245:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0106248:	0f 94 c0             	sete   %al
c010624b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010624e:	85 c0                	test   %eax,%eax
c0106250:	75 24                	jne    c0106276 <basic_check+0x274>
c0106252:	c7 44 24 0c 1b 98 10 	movl   $0xc010981b,0xc(%esp)
c0106259:	c0 
c010625a:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106261:	c0 
c0106262:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0106269:	00 
c010626a:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106271:	e8 bf a1 ff ff       	call   c0100435 <__panic>

    unsigned int nr_free_store = nr_free;
c0106276:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c010627b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010627e:	c7 05 24 40 12 c0 00 	movl   $0x0,0xc0124024
c0106285:	00 00 00 

    assert(alloc_page() == NULL);
c0106288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010628f:	e8 02 cc ff ff       	call   c0102e96 <alloc_pages>
c0106294:	85 c0                	test   %eax,%eax
c0106296:	74 24                	je     c01062bc <basic_check+0x2ba>
c0106298:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c010629f:	c0 
c01062a0:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01062a7:	c0 
c01062a8:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c01062af:	00 
c01062b0:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01062b7:	e8 79 a1 ff ff       	call   c0100435 <__panic>

    free_page(p0);
c01062bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062c3:	00 
c01062c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062c7:	89 04 24             	mov    %eax,(%esp)
c01062ca:	e8 03 cc ff ff       	call   c0102ed2 <free_pages>
    free_page(p1);
c01062cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062d6:	00 
c01062d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062da:	89 04 24             	mov    %eax,(%esp)
c01062dd:	e8 f0 cb ff ff       	call   c0102ed2 <free_pages>
    free_page(p2);
c01062e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062e9:	00 
c01062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062ed:	89 04 24             	mov    %eax,(%esp)
c01062f0:	e8 dd cb ff ff       	call   c0102ed2 <free_pages>
    assert(nr_free == 3);
c01062f5:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c01062fa:	83 f8 03             	cmp    $0x3,%eax
c01062fd:	74 24                	je     c0106323 <basic_check+0x321>
c01062ff:	c7 44 24 0c 47 98 10 	movl   $0xc0109847,0xc(%esp)
c0106306:	c0 
c0106307:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010630e:	c0 
c010630f:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0106316:	00 
c0106317:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010631e:	e8 12 a1 ff ff       	call   c0100435 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0106323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010632a:	e8 67 cb ff ff       	call   c0102e96 <alloc_pages>
c010632f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106332:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106336:	75 24                	jne    c010635c <basic_check+0x35a>
c0106338:	c7 44 24 0c 10 97 10 	movl   $0xc0109710,0xc(%esp)
c010633f:	c0 
c0106340:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106347:	c0 
c0106348:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c010634f:	00 
c0106350:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106357:	e8 d9 a0 ff ff       	call   c0100435 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010635c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106363:	e8 2e cb ff ff       	call   c0102e96 <alloc_pages>
c0106368:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010636b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010636f:	75 24                	jne    c0106395 <basic_check+0x393>
c0106371:	c7 44 24 0c 2c 97 10 	movl   $0xc010972c,0xc(%esp)
c0106378:	c0 
c0106379:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106380:	c0 
c0106381:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0106388:	00 
c0106389:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106390:	e8 a0 a0 ff ff       	call   c0100435 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0106395:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010639c:	e8 f5 ca ff ff       	call   c0102e96 <alloc_pages>
c01063a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01063a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063a8:	75 24                	jne    c01063ce <basic_check+0x3cc>
c01063aa:	c7 44 24 0c 48 97 10 	movl   $0xc0109748,0xc(%esp)
c01063b1:	c0 
c01063b2:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01063b9:	c0 
c01063ba:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01063c1:	00 
c01063c2:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01063c9:	e8 67 a0 ff ff       	call   c0100435 <__panic>

    assert(alloc_page() == NULL);
c01063ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063d5:	e8 bc ca ff ff       	call   c0102e96 <alloc_pages>
c01063da:	85 c0                	test   %eax,%eax
c01063dc:	74 24                	je     c0106402 <basic_check+0x400>
c01063de:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c01063e5:	c0 
c01063e6:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01063ed:	c0 
c01063ee:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01063f5:	00 
c01063f6:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01063fd:	e8 33 a0 ff ff       	call   c0100435 <__panic>

    free_page(p0);
c0106402:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106409:	00 
c010640a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010640d:	89 04 24             	mov    %eax,(%esp)
c0106410:	e8 bd ca ff ff       	call   c0102ed2 <free_pages>
c0106415:	c7 45 d8 1c 40 12 c0 	movl   $0xc012401c,-0x28(%ebp)
c010641c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010641f:	8b 40 04             	mov    0x4(%eax),%eax
c0106422:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0106425:	0f 94 c0             	sete   %al
c0106428:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010642b:	85 c0                	test   %eax,%eax
c010642d:	74 24                	je     c0106453 <basic_check+0x451>
c010642f:	c7 44 24 0c 54 98 10 	movl   $0xc0109854,0xc(%esp)
c0106436:	c0 
c0106437:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010643e:	c0 
c010643f:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0106446:	00 
c0106447:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010644e:	e8 e2 9f ff ff       	call   c0100435 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0106453:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010645a:	e8 37 ca ff ff       	call   c0102e96 <alloc_pages>
c010645f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106465:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106468:	74 24                	je     c010648e <basic_check+0x48c>
c010646a:	c7 44 24 0c 6c 98 10 	movl   $0xc010986c,0xc(%esp)
c0106471:	c0 
c0106472:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106479:	c0 
c010647a:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0106481:	00 
c0106482:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106489:	e8 a7 9f ff ff       	call   c0100435 <__panic>
    assert(alloc_page() == NULL);
c010648e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106495:	e8 fc c9 ff ff       	call   c0102e96 <alloc_pages>
c010649a:	85 c0                	test   %eax,%eax
c010649c:	74 24                	je     c01064c2 <basic_check+0x4c0>
c010649e:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c01064a5:	c0 
c01064a6:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01064ad:	c0 
c01064ae:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01064b5:	00 
c01064b6:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01064bd:	e8 73 9f ff ff       	call   c0100435 <__panic>

    assert(nr_free == 0);
c01064c2:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c01064c7:	85 c0                	test   %eax,%eax
c01064c9:	74 24                	je     c01064ef <basic_check+0x4ed>
c01064cb:	c7 44 24 0c 85 98 10 	movl   $0xc0109885,0xc(%esp)
c01064d2:	c0 
c01064d3:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01064da:	c0 
c01064db:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01064e2:	00 
c01064e3:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01064ea:	e8 46 9f ff ff       	call   c0100435 <__panic>
    free_list = free_list_store;
c01064ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01064f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01064f5:	a3 1c 40 12 c0       	mov    %eax,0xc012401c
c01064fa:	89 15 20 40 12 c0    	mov    %edx,0xc0124020
    nr_free = nr_free_store;
c0106500:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106503:	a3 24 40 12 c0       	mov    %eax,0xc0124024

    free_page(p);
c0106508:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010650f:	00 
c0106510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106513:	89 04 24             	mov    %eax,(%esp)
c0106516:	e8 b7 c9 ff ff       	call   c0102ed2 <free_pages>
    free_page(p1);
c010651b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106522:	00 
c0106523:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106526:	89 04 24             	mov    %eax,(%esp)
c0106529:	e8 a4 c9 ff ff       	call   c0102ed2 <free_pages>
    free_page(p2);
c010652e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106535:	00 
c0106536:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106539:	89 04 24             	mov    %eax,(%esp)
c010653c:	e8 91 c9 ff ff       	call   c0102ed2 <free_pages>
}
c0106541:	90                   	nop
c0106542:	c9                   	leave  
c0106543:	c3                   	ret    

c0106544 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0106544:	f3 0f 1e fb          	endbr32 
c0106548:	55                   	push   %ebp
c0106549:	89 e5                	mov    %esp,%ebp
c010654b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0106551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106558:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010655f:	c7 45 ec 1c 40 12 c0 	movl   $0xc012401c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106566:	eb 6a                	jmp    c01065d2 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c0106568:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010656b:	83 e8 0c             	sub    $0xc,%eax
c010656e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0106571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106574:	83 c0 04             	add    $0x4,%eax
c0106577:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010657e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106581:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106584:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106587:	0f a3 10             	bt     %edx,(%eax)
c010658a:	19 c0                	sbb    %eax,%eax
c010658c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010658f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0106593:	0f 95 c0             	setne  %al
c0106596:	0f b6 c0             	movzbl %al,%eax
c0106599:	85 c0                	test   %eax,%eax
c010659b:	75 24                	jne    c01065c1 <default_check+0x7d>
c010659d:	c7 44 24 0c 92 98 10 	movl   $0xc0109892,0xc(%esp)
c01065a4:	c0 
c01065a5:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01065ac:	c0 
c01065ad:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01065b4:	00 
c01065b5:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01065bc:	e8 74 9e ff ff       	call   c0100435 <__panic>
        count ++, total += p->property;
c01065c1:	ff 45 f4             	incl   -0xc(%ebp)
c01065c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01065c7:	8b 50 08             	mov    0x8(%eax),%edx
c01065ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065cd:	01 d0                	add    %edx,%eax
c01065cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01065d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01065db:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01065de:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01065e1:	81 7d ec 1c 40 12 c0 	cmpl   $0xc012401c,-0x14(%ebp)
c01065e8:	0f 85 7a ff ff ff    	jne    c0106568 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c01065ee:	e8 16 c9 ff ff       	call   c0102f09 <nr_free_pages>
c01065f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01065f6:	39 d0                	cmp    %edx,%eax
c01065f8:	74 24                	je     c010661e <default_check+0xda>
c01065fa:	c7 44 24 0c a2 98 10 	movl   $0xc01098a2,0xc(%esp)
c0106601:	c0 
c0106602:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106609:	c0 
c010660a:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0106611:	00 
c0106612:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106619:	e8 17 9e ff ff       	call   c0100435 <__panic>

    basic_check();
c010661e:	e8 df f9 ff ff       	call   c0106002 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0106623:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010662a:	e8 67 c8 ff ff       	call   c0102e96 <alloc_pages>
c010662f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0106632:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106636:	75 24                	jne    c010665c <default_check+0x118>
c0106638:	c7 44 24 0c bb 98 10 	movl   $0xc01098bb,0xc(%esp)
c010663f:	c0 
c0106640:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106647:	c0 
c0106648:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010664f:	00 
c0106650:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106657:	e8 d9 9d ff ff       	call   c0100435 <__panic>
    assert(!PageProperty(p0));
c010665c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010665f:	83 c0 04             	add    $0x4,%eax
c0106662:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0106669:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010666c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010666f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0106672:	0f a3 10             	bt     %edx,(%eax)
c0106675:	19 c0                	sbb    %eax,%eax
c0106677:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010667a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010667e:	0f 95 c0             	setne  %al
c0106681:	0f b6 c0             	movzbl %al,%eax
c0106684:	85 c0                	test   %eax,%eax
c0106686:	74 24                	je     c01066ac <default_check+0x168>
c0106688:	c7 44 24 0c c6 98 10 	movl   $0xc01098c6,0xc(%esp)
c010668f:	c0 
c0106690:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106697:	c0 
c0106698:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010669f:	00 
c01066a0:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01066a7:	e8 89 9d ff ff       	call   c0100435 <__panic>

    list_entry_t free_list_store = free_list;
c01066ac:	a1 1c 40 12 c0       	mov    0xc012401c,%eax
c01066b1:	8b 15 20 40 12 c0    	mov    0xc0124020,%edx
c01066b7:	89 45 80             	mov    %eax,-0x80(%ebp)
c01066ba:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01066bd:	c7 45 b0 1c 40 12 c0 	movl   $0xc012401c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01066c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01066c7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01066ca:	89 50 04             	mov    %edx,0x4(%eax)
c01066cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01066d0:	8b 50 04             	mov    0x4(%eax),%edx
c01066d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01066d6:	89 10                	mov    %edx,(%eax)
}
c01066d8:	90                   	nop
c01066d9:	c7 45 b4 1c 40 12 c0 	movl   $0xc012401c,-0x4c(%ebp)
    return list->next == list;
c01066e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01066e3:	8b 40 04             	mov    0x4(%eax),%eax
c01066e6:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01066e9:	0f 94 c0             	sete   %al
c01066ec:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01066ef:	85 c0                	test   %eax,%eax
c01066f1:	75 24                	jne    c0106717 <default_check+0x1d3>
c01066f3:	c7 44 24 0c 1b 98 10 	movl   $0xc010981b,0xc(%esp)
c01066fa:	c0 
c01066fb:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106702:	c0 
c0106703:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010670a:	00 
c010670b:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106712:	e8 1e 9d ff ff       	call   c0100435 <__panic>
    assert(alloc_page() == NULL);
c0106717:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010671e:	e8 73 c7 ff ff       	call   c0102e96 <alloc_pages>
c0106723:	85 c0                	test   %eax,%eax
c0106725:	74 24                	je     c010674b <default_check+0x207>
c0106727:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c010672e:	c0 
c010672f:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106736:	c0 
c0106737:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010673e:	00 
c010673f:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106746:	e8 ea 9c ff ff       	call   c0100435 <__panic>

    unsigned int nr_free_store = nr_free;
c010674b:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c0106750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0106753:	c7 05 24 40 12 c0 00 	movl   $0x0,0xc0124024
c010675a:	00 00 00 

    free_pages(p0 + 2, 3);
c010675d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106760:	83 c0 28             	add    $0x28,%eax
c0106763:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010676a:	00 
c010676b:	89 04 24             	mov    %eax,(%esp)
c010676e:	e8 5f c7 ff ff       	call   c0102ed2 <free_pages>
    assert(alloc_pages(4) == NULL);
c0106773:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010677a:	e8 17 c7 ff ff       	call   c0102e96 <alloc_pages>
c010677f:	85 c0                	test   %eax,%eax
c0106781:	74 24                	je     c01067a7 <default_check+0x263>
c0106783:	c7 44 24 0c d8 98 10 	movl   $0xc01098d8,0xc(%esp)
c010678a:	c0 
c010678b:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106792:	c0 
c0106793:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010679a:	00 
c010679b:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01067a2:	e8 8e 9c ff ff       	call   c0100435 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01067a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067aa:	83 c0 28             	add    $0x28,%eax
c01067ad:	83 c0 04             	add    $0x4,%eax
c01067b0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01067b7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067ba:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01067bd:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01067c0:	0f a3 10             	bt     %edx,(%eax)
c01067c3:	19 c0                	sbb    %eax,%eax
c01067c5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01067c8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01067cc:	0f 95 c0             	setne  %al
c01067cf:	0f b6 c0             	movzbl %al,%eax
c01067d2:	85 c0                	test   %eax,%eax
c01067d4:	74 0e                	je     c01067e4 <default_check+0x2a0>
c01067d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067d9:	83 c0 28             	add    $0x28,%eax
c01067dc:	8b 40 08             	mov    0x8(%eax),%eax
c01067df:	83 f8 03             	cmp    $0x3,%eax
c01067e2:	74 24                	je     c0106808 <default_check+0x2c4>
c01067e4:	c7 44 24 0c f0 98 10 	movl   $0xc01098f0,0xc(%esp)
c01067eb:	c0 
c01067ec:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01067f3:	c0 
c01067f4:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01067fb:	00 
c01067fc:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106803:	e8 2d 9c ff ff       	call   c0100435 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0106808:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010680f:	e8 82 c6 ff ff       	call   c0102e96 <alloc_pages>
c0106814:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010681b:	75 24                	jne    c0106841 <default_check+0x2fd>
c010681d:	c7 44 24 0c 1c 99 10 	movl   $0xc010991c,0xc(%esp)
c0106824:	c0 
c0106825:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010682c:	c0 
c010682d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0106834:	00 
c0106835:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010683c:	e8 f4 9b ff ff       	call   c0100435 <__panic>
    assert(alloc_page() == NULL);
c0106841:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106848:	e8 49 c6 ff ff       	call   c0102e96 <alloc_pages>
c010684d:	85 c0                	test   %eax,%eax
c010684f:	74 24                	je     c0106875 <default_check+0x331>
c0106851:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c0106858:	c0 
c0106859:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106860:	c0 
c0106861:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0106868:	00 
c0106869:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106870:	e8 c0 9b ff ff       	call   c0100435 <__panic>
    assert(p0 + 2 == p1);
c0106875:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106878:	83 c0 28             	add    $0x28,%eax
c010687b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010687e:	74 24                	je     c01068a4 <default_check+0x360>
c0106880:	c7 44 24 0c 3a 99 10 	movl   $0xc010993a,0xc(%esp)
c0106887:	c0 
c0106888:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c010688f:	c0 
c0106890:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0106897:	00 
c0106898:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c010689f:	e8 91 9b ff ff       	call   c0100435 <__panic>

    p2 = p0 + 1;
c01068a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068a7:	83 c0 14             	add    $0x14,%eax
c01068aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01068ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01068b4:	00 
c01068b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068b8:	89 04 24             	mov    %eax,(%esp)
c01068bb:	e8 12 c6 ff ff       	call   c0102ed2 <free_pages>
    free_pages(p1, 3);
c01068c0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01068c7:	00 
c01068c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068cb:	89 04 24             	mov    %eax,(%esp)
c01068ce:	e8 ff c5 ff ff       	call   c0102ed2 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01068d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068d6:	83 c0 04             	add    $0x4,%eax
c01068d9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01068e0:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01068e3:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01068e6:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01068e9:	0f a3 10             	bt     %edx,(%eax)
c01068ec:	19 c0                	sbb    %eax,%eax
c01068ee:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01068f1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01068f5:	0f 95 c0             	setne  %al
c01068f8:	0f b6 c0             	movzbl %al,%eax
c01068fb:	85 c0                	test   %eax,%eax
c01068fd:	74 0b                	je     c010690a <default_check+0x3c6>
c01068ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106902:	8b 40 08             	mov    0x8(%eax),%eax
c0106905:	83 f8 01             	cmp    $0x1,%eax
c0106908:	74 24                	je     c010692e <default_check+0x3ea>
c010690a:	c7 44 24 0c 48 99 10 	movl   $0xc0109948,0xc(%esp)
c0106911:	c0 
c0106912:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106919:	c0 
c010691a:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0106921:	00 
c0106922:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106929:	e8 07 9b ff ff       	call   c0100435 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010692e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106931:	83 c0 04             	add    $0x4,%eax
c0106934:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010693b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010693e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106941:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0106944:	0f a3 10             	bt     %edx,(%eax)
c0106947:	19 c0                	sbb    %eax,%eax
c0106949:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010694c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0106950:	0f 95 c0             	setne  %al
c0106953:	0f b6 c0             	movzbl %al,%eax
c0106956:	85 c0                	test   %eax,%eax
c0106958:	74 0b                	je     c0106965 <default_check+0x421>
c010695a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010695d:	8b 40 08             	mov    0x8(%eax),%eax
c0106960:	83 f8 03             	cmp    $0x3,%eax
c0106963:	74 24                	je     c0106989 <default_check+0x445>
c0106965:	c7 44 24 0c 70 99 10 	movl   $0xc0109970,0xc(%esp)
c010696c:	c0 
c010696d:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106974:	c0 
c0106975:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c010697c:	00 
c010697d:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106984:	e8 ac 9a ff ff       	call   c0100435 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106990:	e8 01 c5 ff ff       	call   c0102e96 <alloc_pages>
c0106995:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106998:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010699b:	83 e8 14             	sub    $0x14,%eax
c010699e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01069a1:	74 24                	je     c01069c7 <default_check+0x483>
c01069a3:	c7 44 24 0c 96 99 10 	movl   $0xc0109996,0xc(%esp)
c01069aa:	c0 
c01069ab:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c01069b2:	c0 
c01069b3:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01069ba:	00 
c01069bb:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c01069c2:	e8 6e 9a ff ff       	call   c0100435 <__panic>
    free_page(p0);
c01069c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069ce:	00 
c01069cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01069d2:	89 04 24             	mov    %eax,(%esp)
c01069d5:	e8 f8 c4 ff ff       	call   c0102ed2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01069da:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01069e1:	e8 b0 c4 ff ff       	call   c0102e96 <alloc_pages>
c01069e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01069e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069ec:	83 c0 14             	add    $0x14,%eax
c01069ef:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01069f2:	74 24                	je     c0106a18 <default_check+0x4d4>
c01069f4:	c7 44 24 0c b4 99 10 	movl   $0xc01099b4,0xc(%esp)
c01069fb:	c0 
c01069fc:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106a03:	c0 
c0106a04:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0106a0b:	00 
c0106a0c:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106a13:	e8 1d 9a ff ff       	call   c0100435 <__panic>

    free_pages(p0, 2);
c0106a18:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106a1f:	00 
c0106a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106a23:	89 04 24             	mov    %eax,(%esp)
c0106a26:	e8 a7 c4 ff ff       	call   c0102ed2 <free_pages>
    free_page(p2);
c0106a2b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a32:	00 
c0106a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a36:	89 04 24             	mov    %eax,(%esp)
c0106a39:	e8 94 c4 ff ff       	call   c0102ed2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0106a3e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106a45:	e8 4c c4 ff ff       	call   c0102e96 <alloc_pages>
c0106a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106a4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106a51:	75 24                	jne    c0106a77 <default_check+0x533>
c0106a53:	c7 44 24 0c d4 99 10 	movl   $0xc01099d4,0xc(%esp)
c0106a5a:	c0 
c0106a5b:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106a62:	c0 
c0106a63:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0106a6a:	00 
c0106a6b:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106a72:	e8 be 99 ff ff       	call   c0100435 <__panic>
    assert(alloc_page() == NULL);
c0106a77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a7e:	e8 13 c4 ff ff       	call   c0102e96 <alloc_pages>
c0106a83:	85 c0                	test   %eax,%eax
c0106a85:	74 24                	je     c0106aab <default_check+0x567>
c0106a87:	c7 44 24 0c 32 98 10 	movl   $0xc0109832,0xc(%esp)
c0106a8e:	c0 
c0106a8f:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106a96:	c0 
c0106a97:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0106a9e:	00 
c0106a9f:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106aa6:	e8 8a 99 ff ff       	call   c0100435 <__panic>

    assert(nr_free == 0);
c0106aab:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c0106ab0:	85 c0                	test   %eax,%eax
c0106ab2:	74 24                	je     c0106ad8 <default_check+0x594>
c0106ab4:	c7 44 24 0c 85 98 10 	movl   $0xc0109885,0xc(%esp)
c0106abb:	c0 
c0106abc:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106ac3:	c0 
c0106ac4:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0106acb:	00 
c0106acc:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106ad3:	e8 5d 99 ff ff       	call   c0100435 <__panic>
    nr_free = nr_free_store;
c0106ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106adb:	a3 24 40 12 c0       	mov    %eax,0xc0124024

    free_list = free_list_store;
c0106ae0:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106ae3:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106ae6:	a3 1c 40 12 c0       	mov    %eax,0xc012401c
c0106aeb:	89 15 20 40 12 c0    	mov    %edx,0xc0124020
    free_pages(p0, 5);
c0106af1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0106af8:	00 
c0106af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106afc:	89 04 24             	mov    %eax,(%esp)
c0106aff:	e8 ce c3 ff ff       	call   c0102ed2 <free_pages>

    le = &free_list;
c0106b04:	c7 45 ec 1c 40 12 c0 	movl   $0xc012401c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106b0b:	eb 1c                	jmp    c0106b29 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c0106b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b10:	83 e8 0c             	sub    $0xc,%eax
c0106b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0106b16:	ff 4d f4             	decl   -0xc(%ebp)
c0106b19:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106b1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106b1f:	8b 40 08             	mov    0x8(%eax),%eax
c0106b22:	29 c2                	sub    %eax,%edx
c0106b24:	89 d0                	mov    %edx,%eax
c0106b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b2c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0106b2f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0106b32:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0106b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106b38:	81 7d ec 1c 40 12 c0 	cmpl   $0xc012401c,-0x14(%ebp)
c0106b3f:	75 cc                	jne    c0106b0d <default_check+0x5c9>
    }
    assert(count == 0);
c0106b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106b45:	74 24                	je     c0106b6b <default_check+0x627>
c0106b47:	c7 44 24 0c f2 99 10 	movl   $0xc01099f2,0xc(%esp)
c0106b4e:	c0 
c0106b4f:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106b56:	c0 
c0106b57:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0106b5e:	00 
c0106b5f:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106b66:	e8 ca 98 ff ff       	call   c0100435 <__panic>
    assert(total == 0);
c0106b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106b6f:	74 24                	je     c0106b95 <default_check+0x651>
c0106b71:	c7 44 24 0c fd 99 10 	movl   $0xc01099fd,0xc(%esp)
c0106b78:	c0 
c0106b79:	c7 44 24 08 92 96 10 	movl   $0xc0109692,0x8(%esp)
c0106b80:	c0 
c0106b81:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0106b88:	00 
c0106b89:	c7 04 24 a7 96 10 c0 	movl   $0xc01096a7,(%esp)
c0106b90:	e8 a0 98 ff ff       	call   c0100435 <__panic>
}
c0106b95:	90                   	nop
c0106b96:	c9                   	leave  
c0106b97:	c3                   	ret    

c0106b98 <page_ref>:
page_ref(struct Page *page) {
c0106b98:	55                   	push   %ebp
c0106b99:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b9e:	8b 00                	mov    (%eax),%eax
}
c0106ba0:	5d                   	pop    %ebp
c0106ba1:	c3                   	ret    

c0106ba2 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0106ba2:	55                   	push   %ebp
c0106ba3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106bab:	89 10                	mov    %edx,(%eax)
}
c0106bad:	90                   	nop
c0106bae:	5d                   	pop    %ebp
c0106baf:	c3                   	ret    

c0106bb0 <fixsize>:
#define UINT32_MASK(a)          (UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(a,1),2),4),8),16))    
//大于a的一个最小的2^k
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))//小于a的最大的2^k

static unsigned fixsize(unsigned size) {
c0106bb0:	f3 0f 1e fb          	endbr32 
c0106bb4:	55                   	push   %ebp
c0106bb5:	89 e5                	mov    %esp,%ebp
  size |= size >> 1;
c0106bb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bba:	d1 e8                	shr    %eax
c0106bbc:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 2;
c0106bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bc2:	c1 e8 02             	shr    $0x2,%eax
c0106bc5:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 4;
c0106bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bcb:	c1 e8 04             	shr    $0x4,%eax
c0106bce:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 8;
c0106bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd4:	c1 e8 08             	shr    $0x8,%eax
c0106bd7:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 16;
c0106bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bdd:	c1 e8 10             	shr    $0x10,%eax
c0106be0:	09 45 08             	or     %eax,0x8(%ebp)
  return size+1;
c0106be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106be6:	40                   	inc    %eax
}
c0106be7:	5d                   	pop    %ebp
c0106be8:	c3                   	ret    

c0106be9 <buddy_init>:

struct allocRecord rec[80000];//存放偏移量的数组
int nr_block;//已分配的块数

static void buddy_init()
{
c0106be9:	f3 0f 1e fb          	endbr32 
c0106bed:	55                   	push   %ebp
c0106bee:	89 e5                	mov    %esp,%ebp
c0106bf0:	83 ec 10             	sub    $0x10,%esp
c0106bf3:	c7 45 fc 1c 40 12 c0 	movl   $0xc012401c,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0106bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c00:	89 50 04             	mov    %edx,0x4(%eax)
c0106c03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c06:	8b 50 04             	mov    0x4(%eax),%edx
c0106c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c0c:	89 10                	mov    %edx,(%eax)
}
c0106c0e:	90                   	nop
    list_init(&free_list);
    nr_free=0;
c0106c0f:	c7 05 24 40 12 c0 00 	movl   $0x0,0xc0124024
c0106c16:	00 00 00 
}
c0106c19:	90                   	nop
c0106c1a:	c9                   	leave  
c0106c1b:	c3                   	ret    

c0106c1c <buddy2_new>:

//初始化二叉树上的节点
void buddy2_new( int size ) {
c0106c1c:	f3 0f 1e fb          	endbr32 
c0106c20:	55                   	push   %ebp
c0106c21:	89 e5                	mov    %esp,%ebp
c0106c23:	83 ec 10             	sub    $0x10,%esp
  unsigned node_size;
  int i;
  nr_block=0;
c0106c26:	c7 05 40 40 12 c0 00 	movl   $0x0,0xc0124040
c0106c2d:	00 00 00 
  if (size < 1 || !IS_POWER_OF_2(size))
c0106c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106c34:	7e 54                	jle    c0106c8a <buddy2_new+0x6e>
c0106c36:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c39:	48                   	dec    %eax
c0106c3a:	23 45 08             	and    0x8(%ebp),%eax
c0106c3d:	85 c0                	test   %eax,%eax
c0106c3f:	75 49                	jne    c0106c8a <buddy2_new+0x6e>
    return;

  root[0].size = size;
c0106c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c44:	a3 60 40 12 c0       	mov    %eax,0xc0124060
  node_size = size * 2;
c0106c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c4c:	01 c0                	add    %eax,%eax
c0106c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  for (i = 0; i < 2 * size - 1; ++i) {
c0106c51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0106c58:	eb 23                	jmp    c0106c7d <buddy2_new+0x61>
    if (IS_POWER_OF_2(i+1))
c0106c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106c5d:	40                   	inc    %eax
c0106c5e:	23 45 f8             	and    -0x8(%ebp),%eax
c0106c61:	85 c0                	test   %eax,%eax
c0106c63:	75 08                	jne    c0106c6d <buddy2_new+0x51>
      node_size /= 2;
c0106c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c68:	d1 e8                	shr    %eax
c0106c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    root[i].longest = node_size;
c0106c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106c70:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c73:	89 14 c5 64 40 12 c0 	mov    %edx,-0x3fedbf9c(,%eax,8)
  for (i = 0; i < 2 * size - 1; ++i) {
c0106c7a:	ff 45 f8             	incl   -0x8(%ebp)
c0106c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c80:	01 c0                	add    %eax,%eax
c0106c82:	48                   	dec    %eax
c0106c83:	39 45 f8             	cmp    %eax,-0x8(%ebp)
c0106c86:	7c d2                	jl     c0106c5a <buddy2_new+0x3e>
  }
  return;
c0106c88:	eb 01                	jmp    c0106c8b <buddy2_new+0x6f>
    return;
c0106c8a:	90                   	nop
}
c0106c8b:	c9                   	leave  
c0106c8c:	c3                   	ret    

c0106c8d <buddy_init_memmap>:

//初始化内存映射关系
static void
buddy_init_memmap(struct Page *base, size_t n)
{
c0106c8d:	f3 0f 1e fb          	endbr32 
c0106c91:	55                   	push   %ebp
c0106c92:	89 e5                	mov    %esp,%ebp
c0106c94:	56                   	push   %esi
c0106c95:	53                   	push   %ebx
c0106c96:	83 ec 40             	sub    $0x40,%esp
    assert(n>0);
c0106c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106c9d:	75 24                	jne    c0106cc3 <buddy_init_memmap+0x36>
c0106c9f:	c7 44 24 0c 38 9a 10 	movl   $0xc0109a38,0xc(%esp)
c0106ca6:	c0 
c0106ca7:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0106cae:	c0 
c0106caf:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
c0106cb6:	00 
c0106cb7:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0106cbe:	e8 72 97 ff ff       	call   c0100435 <__panic>
    struct Page* p=base;
c0106cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;p!=base + n;p++)
c0106cc9:	e9 df 00 00 00       	jmp    c0106dad <buddy_init_memmap+0x120>
    {
        assert(PageReserved(p));
c0106cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cd1:	83 c0 04             	add    $0x4,%eax
c0106cd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ce1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ce4:	0f a3 10             	bt     %edx,(%eax)
c0106ce7:	19 c0                	sbb    %eax,%eax
c0106ce9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0106cec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106cf0:	0f 95 c0             	setne  %al
c0106cf3:	0f b6 c0             	movzbl %al,%eax
c0106cf6:	85 c0                	test   %eax,%eax
c0106cf8:	75 24                	jne    c0106d1e <buddy_init_memmap+0x91>
c0106cfa:	c7 44 24 0c 65 9a 10 	movl   $0xc0109a65,0xc(%esp)
c0106d01:	c0 
c0106d02:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0106d09:	c0 
c0106d0a:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0106d11:	00 
c0106d12:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0106d19:	e8 17 97 ff ff       	call   c0100435 <__panic>
        p->flags = 0;
c0106d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 1;
c0106d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d2b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
        set_page_ref(p, 0);   
c0106d32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106d39:	00 
c0106d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d3d:	89 04 24             	mov    %eax,(%esp)
c0106d40:	e8 5d fe ff ff       	call   c0106ba2 <set_page_ref>
        SetPageProperty(p);
c0106d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d48:	83 c0 04             	add    $0x4,%eax
c0106d4b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0106d52:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106d55:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106d58:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106d5b:	0f ab 10             	bts    %edx,(%eax)
}
c0106d5e:	90                   	nop
        list_add_before(&free_list,&(p->page_link));     
c0106d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d62:	83 c0 0c             	add    $0xc,%eax
c0106d65:	c7 45 e0 1c 40 12 c0 	movl   $0xc012401c,-0x20(%ebp)
c0106d6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0106d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d72:	8b 00                	mov    (%eax),%eax
c0106d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d77:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106d7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0106d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d80:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0106d83:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d86:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106d89:	89 10                	mov    %edx,(%eax)
c0106d8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d8e:	8b 10                	mov    (%eax),%edx
c0106d90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106d96:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d99:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106d9c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106d9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106da2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106da5:	89 10                	mov    %edx,(%eax)
}
c0106da7:	90                   	nop
}
c0106da8:	90                   	nop
    for(;p!=base + n;p++)
c0106da9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0106dad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106db0:	89 d0                	mov    %edx,%eax
c0106db2:	c1 e0 02             	shl    $0x2,%eax
c0106db5:	01 d0                	add    %edx,%eax
c0106db7:	c1 e0 02             	shl    $0x2,%eax
c0106dba:	89 c2                	mov    %eax,%edx
c0106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dbf:	01 d0                	add    %edx,%eax
c0106dc1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0106dc4:	0f 85 04 ff ff ff    	jne    c0106cce <buddy_init_memmap+0x41>
    }
    nr_free += n;
c0106dca:	8b 15 24 40 12 c0    	mov    0xc0124024,%edx
c0106dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dd3:	01 d0                	add    %edx,%eax
c0106dd5:	a3 24 40 12 c0       	mov    %eax,0xc0124024
    int allocpages=UINT32_ROUND_DOWN(n);
c0106dda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ddd:	d1 e8                	shr    %eax
c0106ddf:	0b 45 0c             	or     0xc(%ebp),%eax
c0106de2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106de5:	d1 ea                	shr    %edx
c0106de7:	0b 55 0c             	or     0xc(%ebp),%edx
c0106dea:	c1 ea 02             	shr    $0x2,%edx
c0106ded:	09 d0                	or     %edx,%eax
c0106def:	89 c1                	mov    %eax,%ecx
c0106df1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106df4:	d1 e8                	shr    %eax
c0106df6:	0b 45 0c             	or     0xc(%ebp),%eax
c0106df9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106dfc:	d1 ea                	shr    %edx
c0106dfe:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e01:	c1 ea 02             	shr    $0x2,%edx
c0106e04:	09 d0                	or     %edx,%eax
c0106e06:	c1 e8 04             	shr    $0x4,%eax
c0106e09:	09 c1                	or     %eax,%ecx
c0106e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e0e:	d1 e8                	shr    %eax
c0106e10:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e13:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e16:	d1 ea                	shr    %edx
c0106e18:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e1b:	c1 ea 02             	shr    $0x2,%edx
c0106e1e:	09 d0                	or     %edx,%eax
c0106e20:	89 c3                	mov    %eax,%ebx
c0106e22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e25:	d1 e8                	shr    %eax
c0106e27:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e2d:	d1 ea                	shr    %edx
c0106e2f:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e32:	c1 ea 02             	shr    $0x2,%edx
c0106e35:	09 d0                	or     %edx,%eax
c0106e37:	c1 e8 04             	shr    $0x4,%eax
c0106e3a:	09 d8                	or     %ebx,%eax
c0106e3c:	c1 e8 08             	shr    $0x8,%eax
c0106e3f:	09 c1                	or     %eax,%ecx
c0106e41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e44:	d1 e8                	shr    %eax
c0106e46:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e49:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e4c:	d1 ea                	shr    %edx
c0106e4e:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e51:	c1 ea 02             	shr    $0x2,%edx
c0106e54:	09 d0                	or     %edx,%eax
c0106e56:	89 c3                	mov    %eax,%ebx
c0106e58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e5b:	d1 e8                	shr    %eax
c0106e5d:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e60:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e63:	d1 ea                	shr    %edx
c0106e65:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e68:	c1 ea 02             	shr    $0x2,%edx
c0106e6b:	09 d0                	or     %edx,%eax
c0106e6d:	c1 e8 04             	shr    $0x4,%eax
c0106e70:	09 c3                	or     %eax,%ebx
c0106e72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e75:	d1 e8                	shr    %eax
c0106e77:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e7d:	d1 ea                	shr    %edx
c0106e7f:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e82:	c1 ea 02             	shr    $0x2,%edx
c0106e85:	09 d0                	or     %edx,%eax
c0106e87:	89 c6                	mov    %eax,%esi
c0106e89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e8c:	d1 e8                	shr    %eax
c0106e8e:	0b 45 0c             	or     0xc(%ebp),%eax
c0106e91:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e94:	d1 ea                	shr    %edx
c0106e96:	0b 55 0c             	or     0xc(%ebp),%edx
c0106e99:	c1 ea 02             	shr    $0x2,%edx
c0106e9c:	09 d0                	or     %edx,%eax
c0106e9e:	c1 e8 04             	shr    $0x4,%eax
c0106ea1:	09 f0                	or     %esi,%eax
c0106ea3:	c1 e8 08             	shr    $0x8,%eax
c0106ea6:	09 d8                	or     %ebx,%eax
c0106ea8:	c1 e8 10             	shr    $0x10,%eax
c0106eab:	09 c8                	or     %ecx,%eax
c0106ead:	d1 e8                	shr    %eax
c0106eaf:	23 45 0c             	and    0xc(%ebp),%eax
c0106eb2:	85 c0                	test   %eax,%eax
c0106eb4:	0f 84 dc 00 00 00    	je     c0106f96 <buddy_init_memmap+0x309>
c0106eba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ebd:	d1 e8                	shr    %eax
c0106ebf:	0b 45 0c             	or     0xc(%ebp),%eax
c0106ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106ec5:	d1 ea                	shr    %edx
c0106ec7:	0b 55 0c             	or     0xc(%ebp),%edx
c0106eca:	c1 ea 02             	shr    $0x2,%edx
c0106ecd:	09 d0                	or     %edx,%eax
c0106ecf:	89 c1                	mov    %eax,%ecx
c0106ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ed4:	d1 e8                	shr    %eax
c0106ed6:	0b 45 0c             	or     0xc(%ebp),%eax
c0106ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106edc:	d1 ea                	shr    %edx
c0106ede:	0b 55 0c             	or     0xc(%ebp),%edx
c0106ee1:	c1 ea 02             	shr    $0x2,%edx
c0106ee4:	09 d0                	or     %edx,%eax
c0106ee6:	c1 e8 04             	shr    $0x4,%eax
c0106ee9:	09 c1                	or     %eax,%ecx
c0106eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106eee:	d1 e8                	shr    %eax
c0106ef0:	0b 45 0c             	or     0xc(%ebp),%eax
c0106ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106ef6:	d1 ea                	shr    %edx
c0106ef8:	0b 55 0c             	or     0xc(%ebp),%edx
c0106efb:	c1 ea 02             	shr    $0x2,%edx
c0106efe:	09 d0                	or     %edx,%eax
c0106f00:	89 c3                	mov    %eax,%ebx
c0106f02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f05:	d1 e8                	shr    %eax
c0106f07:	0b 45 0c             	or     0xc(%ebp),%eax
c0106f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f0d:	d1 ea                	shr    %edx
c0106f0f:	0b 55 0c             	or     0xc(%ebp),%edx
c0106f12:	c1 ea 02             	shr    $0x2,%edx
c0106f15:	09 d0                	or     %edx,%eax
c0106f17:	c1 e8 04             	shr    $0x4,%eax
c0106f1a:	09 d8                	or     %ebx,%eax
c0106f1c:	c1 e8 08             	shr    $0x8,%eax
c0106f1f:	09 c1                	or     %eax,%ecx
c0106f21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f24:	d1 e8                	shr    %eax
c0106f26:	0b 45 0c             	or     0xc(%ebp),%eax
c0106f29:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f2c:	d1 ea                	shr    %edx
c0106f2e:	0b 55 0c             	or     0xc(%ebp),%edx
c0106f31:	c1 ea 02             	shr    $0x2,%edx
c0106f34:	09 d0                	or     %edx,%eax
c0106f36:	89 c3                	mov    %eax,%ebx
c0106f38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f3b:	d1 e8                	shr    %eax
c0106f3d:	0b 45 0c             	or     0xc(%ebp),%eax
c0106f40:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f43:	d1 ea                	shr    %edx
c0106f45:	0b 55 0c             	or     0xc(%ebp),%edx
c0106f48:	c1 ea 02             	shr    $0x2,%edx
c0106f4b:	09 d0                	or     %edx,%eax
c0106f4d:	c1 e8 04             	shr    $0x4,%eax
c0106f50:	09 c3                	or     %eax,%ebx
c0106f52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f55:	d1 e8                	shr    %eax
c0106f57:	0b 45 0c             	or     0xc(%ebp),%eax
c0106f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f5d:	d1 ea                	shr    %edx
c0106f5f:	0b 55 0c             	or     0xc(%ebp),%edx
c0106f62:	c1 ea 02             	shr    $0x2,%edx
c0106f65:	09 d0                	or     %edx,%eax
c0106f67:	89 c6                	mov    %eax,%esi
c0106f69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f6c:	d1 e8                	shr    %eax
c0106f6e:	0b 45 0c             	or     0xc(%ebp),%eax
c0106f71:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f74:	d1 ea                	shr    %edx
c0106f76:	0b 55 0c             	or     0xc(%ebp),%edx
c0106f79:	c1 ea 02             	shr    $0x2,%edx
c0106f7c:	09 d0                	or     %edx,%eax
c0106f7e:	c1 e8 04             	shr    $0x4,%eax
c0106f81:	09 f0                	or     %esi,%eax
c0106f83:	c1 e8 08             	shr    $0x8,%eax
c0106f86:	09 d8                	or     %ebx,%eax
c0106f88:	c1 e8 10             	shr    $0x10,%eax
c0106f8b:	09 c8                	or     %ecx,%eax
c0106f8d:	d1 e8                	shr    %eax
c0106f8f:	f7 d0                	not    %eax
c0106f91:	23 45 0c             	and    0xc(%ebp),%eax
c0106f94:	eb 03                	jmp    c0106f99 <buddy_init_memmap+0x30c>
c0106f96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy2_new(allocpages);
c0106f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f9f:	89 04 24             	mov    %eax,(%esp)
c0106fa2:	e8 75 fc ff ff       	call   c0106c1c <buddy2_new>
}
c0106fa7:	90                   	nop
c0106fa8:	83 c4 40             	add    $0x40,%esp
c0106fab:	5b                   	pop    %ebx
c0106fac:	5e                   	pop    %esi
c0106fad:	5d                   	pop    %ebp
c0106fae:	c3                   	ret    

c0106faf <buddy2_alloc>:
//内存分配
int buddy2_alloc(struct buddy2* self, int size) {
c0106faf:	f3 0f 1e fb          	endbr32 
c0106fb3:	55                   	push   %ebp
c0106fb4:	89 e5                	mov    %esp,%ebp
c0106fb6:	53                   	push   %ebx
c0106fb7:	83 ec 14             	sub    $0x14,%esp
  unsigned index = 0;//节点的标号
c0106fba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  unsigned node_size;
  unsigned offset = 0;
c0106fc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if (self==NULL)//无法分配
c0106fc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106fcc:	75 0a                	jne    c0106fd8 <buddy2_alloc+0x29>
    return -1;
c0106fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0106fd3:	e9 63 01 00 00       	jmp    c010713b <buddy2_alloc+0x18c>

  if (size <= 0)//分配不合理
c0106fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106fdc:	7f 09                	jg     c0106fe7 <buddy2_alloc+0x38>
    size = 1;
c0106fde:	c7 45 0c 01 00 00 00 	movl   $0x1,0xc(%ebp)
c0106fe5:	eb 19                	jmp    c0107000 <buddy2_alloc+0x51>
  else if (!IS_POWER_OF_2(size))//不为2的幂时，取比size更大的2的n次幂
c0106fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fea:	48                   	dec    %eax
c0106feb:	23 45 0c             	and    0xc(%ebp),%eax
c0106fee:	85 c0                	test   %eax,%eax
c0106ff0:	74 0e                	je     c0107000 <buddy2_alloc+0x51>
    size = fixsize(size);
c0106ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ff5:	89 04 24             	mov    %eax,(%esp)
c0106ff8:	e8 b3 fb ff ff       	call   c0106bb0 <fixsize>
c0106ffd:	89 45 0c             	mov    %eax,0xc(%ebp)

  if (self[index].longest < size)//可分配内存不足
c0107000:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107003:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010700a:	8b 45 08             	mov    0x8(%ebp),%eax
c010700d:	01 d0                	add    %edx,%eax
c010700f:	8b 50 04             	mov    0x4(%eax),%edx
c0107012:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107015:	39 c2                	cmp    %eax,%edx
c0107017:	73 0a                	jae    c0107023 <buddy2_alloc+0x74>
    return -1;
c0107019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010701e:	e9 18 01 00 00       	jmp    c010713b <buddy2_alloc+0x18c>

  for(node_size = self->size; node_size != size; node_size /= 2 ) {
c0107023:	8b 45 08             	mov    0x8(%ebp),%eax
c0107026:	8b 00                	mov    (%eax),%eax
c0107028:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010702b:	e9 85 00 00 00       	jmp    c01070b5 <buddy2_alloc+0x106>
    if (self[LEFT_LEAF(index)].longest >= size)
c0107030:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107033:	c1 e0 04             	shl    $0x4,%eax
c0107036:	8d 50 08             	lea    0x8(%eax),%edx
c0107039:	8b 45 08             	mov    0x8(%ebp),%eax
c010703c:	01 d0                	add    %edx,%eax
c010703e:	8b 50 04             	mov    0x4(%eax),%edx
c0107041:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107044:	39 c2                	cmp    %eax,%edx
c0107046:	72 5c                	jb     c01070a4 <buddy2_alloc+0xf5>
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
c0107048:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010704b:	40                   	inc    %eax
c010704c:	c1 e0 04             	shl    $0x4,%eax
c010704f:	89 c2                	mov    %eax,%edx
c0107051:	8b 45 08             	mov    0x8(%ebp),%eax
c0107054:	01 d0                	add    %edx,%eax
c0107056:	8b 50 04             	mov    0x4(%eax),%edx
c0107059:	8b 45 0c             	mov    0xc(%ebp),%eax
c010705c:	39 c2                	cmp    %eax,%edx
c010705e:	72 39                	jb     c0107099 <buddy2_alloc+0xea>
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
c0107060:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107063:	c1 e0 04             	shl    $0x4,%eax
c0107066:	8d 50 08             	lea    0x8(%eax),%edx
c0107069:	8b 45 08             	mov    0x8(%ebp),%eax
c010706c:	01 d0                	add    %edx,%eax
c010706e:	8b 50 04             	mov    0x4(%eax),%edx
c0107071:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107074:	40                   	inc    %eax
c0107075:	c1 e0 04             	shl    $0x4,%eax
c0107078:	89 c1                	mov    %eax,%ecx
c010707a:	8b 45 08             	mov    0x8(%ebp),%eax
c010707d:	01 c8                	add    %ecx,%eax
c010707f:	8b 40 04             	mov    0x4(%eax),%eax
c0107082:	39 c2                	cmp    %eax,%edx
c0107084:	77 08                	ja     c010708e <buddy2_alloc+0xdf>
c0107086:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107089:	01 c0                	add    %eax,%eax
c010708b:	40                   	inc    %eax
c010708c:	eb 06                	jmp    c0107094 <buddy2_alloc+0xe5>
c010708e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107091:	40                   	inc    %eax
c0107092:	01 c0                	add    %eax,%eax
c0107094:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0107097:	eb 14                	jmp    c01070ad <buddy2_alloc+0xfe>
         //找到两个相符合的节点中内存较小的结点
        }
       else
       {
         index=LEFT_LEAF(index);
c0107099:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010709c:	01 c0                	add    %eax,%eax
c010709e:	40                   	inc    %eax
c010709f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01070a2:	eb 09                	jmp    c01070ad <buddy2_alloc+0xfe>
       }  
    }
    else
      index = RIGHT_LEAF(index);
c01070a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01070a7:	40                   	inc    %eax
c01070a8:	01 c0                	add    %eax,%eax
c01070aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(node_size = self->size; node_size != size; node_size /= 2 ) {
c01070ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070b0:	d1 e8                	shr    %eax
c01070b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01070b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01070bb:	0f 85 6f ff ff ff    	jne    c0107030 <buddy2_alloc+0x81>
  }

  self[index].longest = 0;//标记节点为已使用
c01070c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01070c4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01070cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01070ce:	01 d0                	add    %edx,%eax
c01070d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  offset = (index + 1) * node_size - self->size;
c01070d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01070da:	40                   	inc    %eax
c01070db:	0f af 45 f4          	imul   -0xc(%ebp),%eax
c01070df:	89 c2                	mov    %eax,%edx
c01070e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01070e4:	8b 00                	mov    (%eax),%eax
c01070e6:	29 c2                	sub    %eax,%edx
c01070e8:	89 d0                	mov    %edx,%eax
c01070ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (index) {
c01070ed:	eb 43                	jmp    c0107132 <buddy2_alloc+0x183>
    index = PARENT(index);
c01070ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01070f2:	40                   	inc    %eax
c01070f3:	d1 e8                	shr    %eax
c01070f5:	48                   	dec    %eax
c01070f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
c01070f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01070fc:	40                   	inc    %eax
c01070fd:	c1 e0 04             	shl    $0x4,%eax
c0107100:	89 c2                	mov    %eax,%edx
c0107102:	8b 45 08             	mov    0x8(%ebp),%eax
c0107105:	01 d0                	add    %edx,%eax
c0107107:	8b 50 04             	mov    0x4(%eax),%edx
c010710a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010710d:	c1 e0 04             	shl    $0x4,%eax
c0107110:	8d 48 08             	lea    0x8(%eax),%ecx
c0107113:	8b 45 08             	mov    0x8(%ebp),%eax
c0107116:	01 c8                	add    %ecx,%eax
c0107118:	8b 40 04             	mov    0x4(%eax),%eax
    self[index].longest = 
c010711b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
c010711e:	8d 1c cd 00 00 00 00 	lea    0x0(,%ecx,8),%ebx
c0107125:	8b 4d 08             	mov    0x8(%ebp),%ecx
c0107128:	01 d9                	add    %ebx,%ecx
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
c010712a:	39 c2                	cmp    %eax,%edx
c010712c:	0f 43 c2             	cmovae %edx,%eax
    self[index].longest = 
c010712f:	89 41 04             	mov    %eax,0x4(%ecx)
  while (index) {
c0107132:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107136:	75 b7                	jne    c01070ef <buddy2_alloc+0x140>
  }
//向上刷新，修改先祖结点的数值
  return offset;
c0107138:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010713b:	83 c4 14             	add    $0x14,%esp
c010713e:	5b                   	pop    %ebx
c010713f:	5d                   	pop    %ebp
c0107140:	c3                   	ret    

c0107141 <buddy_alloc_pages>:

static struct Page*
buddy_alloc_pages(size_t n){
c0107141:	f3 0f 1e fb          	endbr32 
c0107145:	55                   	push   %ebp
c0107146:	89 e5                	mov    %esp,%ebp
c0107148:	53                   	push   %ebx
c0107149:	83 ec 44             	sub    $0x44,%esp
  assert(n>0);
c010714c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107150:	75 24                	jne    c0107176 <buddy_alloc_pages+0x35>
c0107152:	c7 44 24 0c 38 9a 10 	movl   $0xc0109a38,0xc(%esp)
c0107159:	c0 
c010715a:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107161:	c0 
c0107162:	c7 44 24 04 8d 00 00 	movl   $0x8d,0x4(%esp)
c0107169:	00 
c010716a:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0107171:	e8 bf 92 ff ff       	call   c0100435 <__panic>
  if(n>nr_free)
c0107176:	a1 24 40 12 c0       	mov    0xc0124024,%eax
c010717b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010717e:	76 0a                	jbe    c010718a <buddy_alloc_pages+0x49>
   return NULL;
c0107180:	b8 00 00 00 00       	mov    $0x0,%eax
c0107185:	e9 41 01 00 00       	jmp    c01072cb <buddy_alloc_pages+0x18a>
  struct Page* page=NULL;
c010718a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct Page* p;
  list_entry_t *le=&free_list,*len;
c0107191:	c7 45 f4 1c 40 12 c0 	movl   $0xc012401c,-0xc(%ebp)
  rec[nr_block].offset=buddy2_alloc(root,n);//记录偏移量
c0107198:	8b 45 08             	mov    0x8(%ebp),%eax
c010719b:	8b 1d 40 40 12 c0    	mov    0xc0124040,%ebx
c01071a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01071a5:	c7 04 24 60 40 12 c0 	movl   $0xc0124060,(%esp)
c01071ac:	e8 fe fd ff ff       	call   c0106faf <buddy2_alloc>
c01071b1:	89 c2                	mov    %eax,%edx
c01071b3:	89 d8                	mov    %ebx,%eax
c01071b5:	01 c0                	add    %eax,%eax
c01071b7:	01 d8                	add    %ebx,%eax
c01071b9:	c1 e0 02             	shl    $0x2,%eax
c01071bc:	05 64 04 1c c0       	add    $0xc01c0464,%eax
c01071c1:	89 10                	mov    %edx,(%eax)
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)
c01071c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01071ca:	eb 12                	jmp    c01071de <buddy_alloc_pages+0x9d>
c01071cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
c01071d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01071d5:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(le);
c01071d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<rec[nr_block].offset+1;i++)
c01071db:	ff 45 f0             	incl   -0x10(%ebp)
c01071de:	8b 15 40 40 12 c0    	mov    0xc0124040,%edx
c01071e4:	89 d0                	mov    %edx,%eax
c01071e6:	01 c0                	add    %eax,%eax
c01071e8:	01 d0                	add    %edx,%eax
c01071ea:	c1 e0 02             	shl    $0x2,%eax
c01071ed:	05 64 04 1c c0       	add    $0xc01c0464,%eax
c01071f2:	8b 00                	mov    (%eax),%eax
c01071f4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01071f7:	7e d3                	jle    c01071cc <buddy_alloc_pages+0x8b>
  page=le2page(le,page_link);
c01071f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071fc:	83 e8 0c             	sub    $0xc,%eax
c01071ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int allocpages;
  if(!IS_POWER_OF_2(n))
c0107202:	8b 45 08             	mov    0x8(%ebp),%eax
c0107205:	48                   	dec    %eax
c0107206:	23 45 08             	and    0x8(%ebp),%eax
c0107209:	85 c0                	test   %eax,%eax
c010720b:	74 10                	je     c010721d <buddy_alloc_pages+0xdc>
   allocpages=fixsize(n);
c010720d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107210:	89 04 24             	mov    %eax,(%esp)
c0107213:	e8 98 f9 ff ff       	call   c0106bb0 <fixsize>
c0107218:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010721b:	eb 06                	jmp    c0107223 <buddy_alloc_pages+0xe2>
  else
  {
     allocpages=n;
c010721d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107220:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  //根据需求n得到块大小
  rec[nr_block].base=page;//记录分配块首页
c0107223:	8b 15 40 40 12 c0    	mov    0xc0124040,%edx
c0107229:	89 d0                	mov    %edx,%eax
c010722b:	01 c0                	add    %eax,%eax
c010722d:	01 d0                	add    %edx,%eax
c010722f:	c1 e0 02             	shl    $0x2,%eax
c0107232:	8d 90 60 04 1c c0    	lea    -0x3fe3fba0(%eax),%edx
c0107238:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010723b:	89 02                	mov    %eax,(%edx)
  rec[nr_block].nr=allocpages;//记录分配的页数
c010723d:	8b 15 40 40 12 c0    	mov    0xc0124040,%edx
c0107243:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0107246:	89 d0                	mov    %edx,%eax
c0107248:	01 c0                	add    %eax,%eax
c010724a:	01 d0                	add    %edx,%eax
c010724c:	c1 e0 02             	shl    $0x2,%eax
c010724f:	05 68 04 1c c0       	add    $0xc01c0468,%eax
c0107254:	89 08                	mov    %ecx,(%eax)
  nr_block++;
c0107256:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c010725b:	40                   	inc    %eax
c010725c:	a3 40 40 12 c0       	mov    %eax,0xc0124040
  for(i=0;i<allocpages;i++)
c0107261:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0107268:	eb 3b                	jmp    c01072a5 <buddy_alloc_pages+0x164>
c010726a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010726d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107270:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107273:	8b 40 04             	mov    0x4(%eax),%eax
  {
    len=list_next(le);
c0107276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p=le2page(le,page_link);
c0107279:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010727c:	83 e8 0c             	sub    $0xc,%eax
c010727f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    ClearPageProperty(p);
c0107282:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107285:	83 c0 04             	add    $0x4,%eax
c0107288:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c010728f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107292:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107295:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107298:	0f b3 10             	btr    %edx,(%eax)
}
c010729b:	90                   	nop
    le=len;
c010729c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010729f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<allocpages;i++)
c01072a2:	ff 45 f0             	incl   -0x10(%ebp)
c01072a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072ab:	7c bd                	jl     c010726a <buddy_alloc_pages+0x129>
  }//修改每一页的状态
  nr_free-=allocpages;//减去已被分配的页数
c01072ad:	8b 15 24 40 12 c0    	mov    0xc0124024,%edx
c01072b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072b6:	29 c2                	sub    %eax,%edx
c01072b8:	89 d0                	mov    %edx,%eax
c01072ba:	a3 24 40 12 c0       	mov    %eax,0xc0124024
  page->property=n;
c01072bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01072c5:	89 50 08             	mov    %edx,0x8(%eax)
  return page;
c01072c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c01072cb:	83 c4 44             	add    $0x44,%esp
c01072ce:	5b                   	pop    %ebx
c01072cf:	5d                   	pop    %ebp
c01072d0:	c3                   	ret    

c01072d1 <buddy_free_pages>:

void buddy_free_pages(struct Page* base, size_t n) {
c01072d1:	f3 0f 1e fb          	endbr32 
c01072d5:	55                   	push   %ebp
c01072d6:	89 e5                	mov    %esp,%ebp
c01072d8:	83 ec 58             	sub    $0x58,%esp
  unsigned node_size, index = 0;
c01072db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
c01072e2:	c7 45 e0 60 40 12 c0 	movl   $0xc0124060,-0x20(%ebp)
c01072e9:	c7 45 c8 1c 40 12 c0 	movl   $0xc012401c,-0x38(%ebp)
c01072f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01072f3:	8b 40 04             	mov    0x4(%eax),%eax
  
  list_entry_t *le=list_next(&free_list);
c01072f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i=0;
c01072f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(i=0;i<nr_block;i++)//找到块
c0107300:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0107307:	eb 1b                	jmp    c0107324 <buddy_free_pages+0x53>
  {
    if(rec[i].base==base)
c0107309:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010730c:	89 d0                	mov    %edx,%eax
c010730e:	01 c0                	add    %eax,%eax
c0107310:	01 d0                	add    %edx,%eax
c0107312:	c1 e0 02             	shl    $0x2,%eax
c0107315:	05 60 04 1c c0       	add    $0xc01c0460,%eax
c010731a:	8b 00                	mov    (%eax),%eax
c010731c:	39 45 08             	cmp    %eax,0x8(%ebp)
c010731f:	74 0f                	je     c0107330 <buddy_free_pages+0x5f>
  for(i=0;i<nr_block;i++)//找到块
c0107321:	ff 45 e8             	incl   -0x18(%ebp)
c0107324:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0107329:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010732c:	7c db                	jl     c0107309 <buddy_free_pages+0x38>
c010732e:	eb 01                	jmp    c0107331 <buddy_free_pages+0x60>
     break;
c0107330:	90                   	nop
  }
  int offset=rec[i].offset;
c0107331:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107334:	89 d0                	mov    %edx,%eax
c0107336:	01 c0                	add    %eax,%eax
c0107338:	01 d0                	add    %edx,%eax
c010733a:	c1 e0 02             	shl    $0x2,%eax
c010733d:	05 64 04 1c c0       	add    $0xc01c0464,%eax
c0107342:	8b 00                	mov    (%eax),%eax
c0107344:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int pos=i;//暂存i
c0107347:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010734a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  i=0;
c010734d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  while(i<offset)
c0107354:	eb 12                	jmp    c0107368 <buddy_free_pages+0x97>
c0107356:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107359:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010735c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010735f:	8b 40 04             	mov    0x4(%eax),%eax
  {
    le=list_next(le);
c0107362:	89 45 ec             	mov    %eax,-0x14(%ebp)
    i++;
c0107365:	ff 45 e8             	incl   -0x18(%ebp)
  while(i<offset)
c0107368:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010736b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010736e:	7c e6                	jl     c0107356 <buddy_free_pages+0x85>
  }
  int allocpages;
  if(!IS_POWER_OF_2(n))
c0107370:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107373:	48                   	dec    %eax
c0107374:	23 45 0c             	and    0xc(%ebp),%eax
c0107377:	85 c0                	test   %eax,%eax
c0107379:	74 10                	je     c010738b <buddy_free_pages+0xba>
   allocpages=fixsize(n);
c010737b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010737e:	89 04 24             	mov    %eax,(%esp)
c0107381:	e8 2a f8 ff ff       	call   c0106bb0 <fixsize>
c0107386:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107389:	eb 06                	jmp    c0107391 <buddy_free_pages+0xc0>
  else
  {
     allocpages=n;
c010738b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010738e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  assert(self && offset >= 0 && offset < self->size);//是否合法
c0107391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107395:	74 12                	je     c01073a9 <buddy_free_pages+0xd8>
c0107397:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010739b:	78 0c                	js     c01073a9 <buddy_free_pages+0xd8>
c010739d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073a0:	8b 10                	mov    (%eax),%edx
c01073a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073a5:	39 c2                	cmp    %eax,%edx
c01073a7:	77 24                	ja     c01073cd <buddy_free_pages+0xfc>
c01073a9:	c7 44 24 0c 78 9a 10 	movl   $0xc0109a78,0xc(%esp)
c01073b0:	c0 
c01073b1:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c01073b8:	c0 
c01073b9:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01073c0:	00 
c01073c1:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01073c8:	e8 68 90 ff ff       	call   c0100435 <__panic>
  node_size = 1;
c01073cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  index = offset + self->size - 1;
c01073d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073d7:	8b 10                	mov    (%eax),%edx
c01073d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073dc:	01 d0                	add    %edx,%eax
c01073de:	48                   	dec    %eax
c01073df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  nr_free+=allocpages;//更新空闲页的数量
c01073e2:	8b 15 24 40 12 c0    	mov    0xc0124024,%edx
c01073e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073eb:	01 d0                	add    %edx,%eax
c01073ed:	a3 24 40 12 c0       	mov    %eax,0xc0124024
  struct Page* p;
  self[index].longest = allocpages;
c01073f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01073fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073ff:	01 c2                	add    %eax,%edx
c0107401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107404:	89 42 04             	mov    %eax,0x4(%edx)
  for(i=0;i<allocpages;i++)//回收已分配的页
c0107407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010740e:	eb 49                	jmp    c0107459 <buddy_free_pages+0x188>
  {
     p=le2page(le,page_link);
c0107410:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107413:	83 e8 0c             	sub    $0xc,%eax
c0107416:	89 45 cc             	mov    %eax,-0x34(%ebp)
     p->flags=0;
c0107419:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010741c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     p->property=1;
c0107423:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107426:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
     SetPageProperty(p);
c010742d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107430:	83 c0 04             	add    $0x4,%eax
c0107433:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c010743a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010743d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107440:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0107443:	0f ab 10             	bts    %edx,(%eax)
}
c0107446:	90                   	nop
c0107447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010744a:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010744d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0107450:	8b 40 04             	mov    0x4(%eax),%eax
     le=list_next(le);
c0107453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(i=0;i<allocpages;i++)//回收已分配的页
c0107456:	ff 45 e8             	incl   -0x18(%ebp)
c0107459:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010745c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c010745f:	7c af                	jl     c0107410 <buddy_free_pages+0x13f>
  }
  while (index) {//向上合并，修改先祖节点的记录值
c0107461:	eb 75                	jmp    c01074d8 <buddy_free_pages+0x207>
    index = PARENT(index);
c0107463:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107466:	40                   	inc    %eax
c0107467:	d1 e8                	shr    %eax
c0107469:	48                   	dec    %eax
c010746a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
c010746d:	d1 65 f4             	shll   -0xc(%ebp)

    left_longest = self[LEFT_LEAF(index)].longest;
c0107470:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107473:	c1 e0 04             	shl    $0x4,%eax
c0107476:	8d 50 08             	lea    0x8(%eax),%edx
c0107479:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010747c:	01 d0                	add    %edx,%eax
c010747e:	8b 40 04             	mov    0x4(%eax),%eax
c0107481:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    right_longest = self[RIGHT_LEAF(index)].longest;
c0107484:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107487:	40                   	inc    %eax
c0107488:	c1 e0 04             	shl    $0x4,%eax
c010748b:	89 c2                	mov    %eax,%edx
c010748d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107490:	01 d0                	add    %edx,%eax
c0107492:	8b 40 04             	mov    0x4(%eax),%eax
c0107495:	89 45 d0             	mov    %eax,-0x30(%ebp)
    
    if (left_longest + right_longest == node_size) 
c0107498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010749b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010749e:	01 d0                	add    %edx,%eax
c01074a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01074a3:	75 17                	jne    c01074bc <buddy_free_pages+0x1eb>
      self[index].longest = node_size;
c01074a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01074af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074b2:	01 c2                	add    %eax,%edx
c01074b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074b7:	89 42 04             	mov    %eax,0x4(%edx)
c01074ba:	eb 1c                	jmp    c01074d8 <buddy_free_pages+0x207>
    else
      self[index].longest = MAX(left_longest, right_longest);
c01074bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01074c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074c9:	01 c2                	add    %eax,%edx
c01074cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01074ce:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01074d1:	0f 43 45 d0          	cmovae -0x30(%ebp),%eax
c01074d5:	89 42 04             	mov    %eax,0x4(%edx)
  while (index) {//向上合并，修改先祖节点的记录值
c01074d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01074dc:	75 85                	jne    c0107463 <buddy_free_pages+0x192>
  }
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
c01074de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01074e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074e4:	eb 39                	jmp    c010751f <buddy_free_pages+0x24e>
  {
    rec[i]=rec[i+1];
c01074e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074e9:	8d 48 01             	lea    0x1(%eax),%ecx
c01074ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01074ef:	89 d0                	mov    %edx,%eax
c01074f1:	01 c0                	add    %eax,%eax
c01074f3:	01 d0                	add    %edx,%eax
c01074f5:	c1 e0 02             	shl    $0x2,%eax
c01074f8:	8d 90 60 04 1c c0    	lea    -0x3fe3fba0(%eax),%edx
c01074fe:	89 c8                	mov    %ecx,%eax
c0107500:	01 c0                	add    %eax,%eax
c0107502:	01 c8                	add    %ecx,%eax
c0107504:	c1 e0 02             	shl    $0x2,%eax
c0107507:	05 60 04 1c c0       	add    $0xc01c0460,%eax
c010750c:	8b 08                	mov    (%eax),%ecx
c010750e:	89 0a                	mov    %ecx,(%edx)
c0107510:	8b 48 04             	mov    0x4(%eax),%ecx
c0107513:	89 4a 04             	mov    %ecx,0x4(%edx)
c0107516:	8b 40 08             	mov    0x8(%eax),%eax
c0107519:	89 42 08             	mov    %eax,0x8(%edx)
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
c010751c:	ff 45 e8             	incl   -0x18(%ebp)
c010751f:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0107524:	48                   	dec    %eax
c0107525:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107528:	7c bc                	jl     c01074e6 <buddy_free_pages+0x215>
  }
  nr_block--;//更新分配块数的值
c010752a:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c010752f:	48                   	dec    %eax
c0107530:	a3 40 40 12 c0       	mov    %eax,0xc0124040
}
c0107535:	90                   	nop
c0107536:	c9                   	leave  
c0107537:	c3                   	ret    

c0107538 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c0107538:	f3 0f 1e fb          	endbr32 
c010753c:	55                   	push   %ebp
c010753d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010753f:	a1 24 40 12 c0       	mov    0xc0124024,%eax
}
c0107544:	5d                   	pop    %ebp
c0107545:	c3                   	ret    

c0107546 <buddy_check>:

//以下是一个测试函数
static void

buddy_check(void) {
c0107546:	f3 0f 1e fb          	endbr32 
c010754a:	55                   	push   %ebp
c010754b:	89 e5                	mov    %esp,%ebp
c010754d:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *A, *B,*C,*D;
    p0 = A = B = C = D =NULL;
c0107550:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107557:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010755a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010755d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107560:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107563:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107566:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107569:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010756c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
c010756f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107576:	e8 1b b9 ff ff       	call   c0102e96 <alloc_pages>
c010757b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010757e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107582:	75 24                	jne    c01075a8 <buddy_check+0x62>
c0107584:	c7 44 24 0c a3 9a 10 	movl   $0xc0109aa3,0xc(%esp)
c010758b:	c0 
c010758c:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107593:	c0 
c0107594:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010759b:	00 
c010759c:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01075a3:	e8 8d 8e ff ff       	call   c0100435 <__panic>
    assert((A = alloc_page()) != NULL);
c01075a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01075af:	e8 e2 b8 ff ff       	call   c0102e96 <alloc_pages>
c01075b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01075b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01075bb:	75 24                	jne    c01075e1 <buddy_check+0x9b>
c01075bd:	c7 44 24 0c bf 9a 10 	movl   $0xc0109abf,0xc(%esp)
c01075c4:	c0 
c01075c5:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c01075cc:	c0 
c01075cd:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01075d4:	00 
c01075d5:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01075dc:	e8 54 8e ff ff       	call   c0100435 <__panic>
    assert((B = alloc_page()) != NULL);
c01075e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01075e8:	e8 a9 b8 ff ff       	call   c0102e96 <alloc_pages>
c01075ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01075f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01075f4:	75 24                	jne    c010761a <buddy_check+0xd4>
c01075f6:	c7 44 24 0c da 9a 10 	movl   $0xc0109ada,0xc(%esp)
c01075fd:	c0 
c01075fe:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107605:	c0 
c0107606:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010760d:	00 
c010760e:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0107615:	e8 1b 8e ff ff       	call   c0100435 <__panic>

    assert(p0 != A && p0 != B && A != B);
c010761a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010761d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0107620:	74 10                	je     c0107632 <buddy_check+0xec>
c0107622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107625:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107628:	74 08                	je     c0107632 <buddy_check+0xec>
c010762a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010762d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107630:	75 24                	jne    c0107656 <buddy_check+0x110>
c0107632:	c7 44 24 0c f5 9a 10 	movl   $0xc0109af5,0xc(%esp)
c0107639:	c0 
c010763a:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107641:	c0 
c0107642:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107649:	00 
c010764a:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0107651:	e8 df 8d ff ff       	call   c0100435 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
c0107656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107659:	89 04 24             	mov    %eax,(%esp)
c010765c:	e8 37 f5 ff ff       	call   c0106b98 <page_ref>
c0107661:	85 c0                	test   %eax,%eax
c0107663:	75 1e                	jne    c0107683 <buddy_check+0x13d>
c0107665:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107668:	89 04 24             	mov    %eax,(%esp)
c010766b:	e8 28 f5 ff ff       	call   c0106b98 <page_ref>
c0107670:	85 c0                	test   %eax,%eax
c0107672:	75 0f                	jne    c0107683 <buddy_check+0x13d>
c0107674:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107677:	89 04 24             	mov    %eax,(%esp)
c010767a:	e8 19 f5 ff ff       	call   c0106b98 <page_ref>
c010767f:	85 c0                	test   %eax,%eax
c0107681:	74 24                	je     c01076a7 <buddy_check+0x161>
c0107683:	c7 44 24 0c 14 9b 10 	movl   $0xc0109b14,0xc(%esp)
c010768a:	c0 
c010768b:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107692:	c0 
c0107693:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010769a:	00 
c010769b:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01076a2:	e8 8e 8d ff ff       	call   c0100435 <__panic>
    free_page(p0);
c01076a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01076ae:	00 
c01076af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076b2:	89 04 24             	mov    %eax,(%esp)
c01076b5:	e8 18 b8 ff ff       	call   c0102ed2 <free_pages>
    free_page(A);
c01076ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01076c1:	00 
c01076c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076c5:	89 04 24             	mov    %eax,(%esp)
c01076c8:	e8 05 b8 ff ff       	call   c0102ed2 <free_pages>
    free_page(B);
c01076cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01076d4:	00 
c01076d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076d8:	89 04 24             	mov    %eax,(%esp)
c01076db:	e8 f2 b7 ff ff       	call   c0102ed2 <free_pages>
    
    A=alloc_pages(500);
c01076e0:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c01076e7:	e8 aa b7 ff ff       	call   c0102e96 <alloc_pages>
c01076ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(500);
c01076ef:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c01076f6:	e8 9b b7 ff ff       	call   c0102e96 <alloc_pages>
c01076fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("A %p\n",A);
c01076fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107701:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107705:	c7 04 24 4e 9b 10 c0 	movl   $0xc0109b4e,(%esp)
c010770c:	e8 b8 8b ff ff       	call   c01002c9 <cprintf>
    cprintf("B %p\n",B);
c0107711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107718:	c7 04 24 54 9b 10 c0 	movl   $0xc0109b54,(%esp)
c010771f:	e8 a5 8b ff ff       	call   c01002c9 <cprintf>
    free_pages(A,250);
c0107724:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010772b:	00 
c010772c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010772f:	89 04 24             	mov    %eax,(%esp)
c0107732:	e8 9b b7 ff ff       	call   c0102ed2 <free_pages>
    free_pages(B,500);
c0107737:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c010773e:	00 
c010773f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107742:	89 04 24             	mov    %eax,(%esp)
c0107745:	e8 88 b7 ff ff       	call   c0102ed2 <free_pages>
    free_pages(A+250,250);
c010774a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010774d:	05 88 13 00 00       	add    $0x1388,%eax
c0107752:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107759:	00 
c010775a:	89 04 24             	mov    %eax,(%esp)
c010775d:	e8 70 b7 ff ff       	call   c0102ed2 <free_pages>
    
    p0=alloc_pages(1024);
c0107762:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
c0107769:	e8 28 b7 ff ff       	call   c0102e96 <alloc_pages>
c010776e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("p0 %p\n",p0);
c0107771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107774:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107778:	c7 04 24 5a 9b 10 c0 	movl   $0xc0109b5a,(%esp)
c010777f:	e8 45 8b ff ff       	call   c01002c9 <cprintf>
    assert(p0 == A);
c0107784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107787:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010778a:	74 24                	je     c01077b0 <buddy_check+0x26a>
c010778c:	c7 44 24 0c 61 9b 10 	movl   $0xc0109b61,0xc(%esp)
c0107793:	c0 
c0107794:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c010779b:	c0 
c010779c:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01077a3:	00 
c01077a4:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01077ab:	e8 85 8c ff ff       	call   c0100435 <__panic>
    //以下是根据链接中的样例测试编写的
    A=alloc_pages(70);  
c01077b0:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
c01077b7:	e8 da b6 ff ff       	call   c0102e96 <alloc_pages>
c01077bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(35);
c01077bf:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
c01077c6:	e8 cb b6 ff ff       	call   c0102e96 <alloc_pages>
c01077cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(A+128==B);//检查是否相邻
c01077ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077d1:	05 00 0a 00 00       	add    $0xa00,%eax
c01077d6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01077d9:	74 24                	je     c01077ff <buddy_check+0x2b9>
c01077db:	c7 44 24 0c 69 9b 10 	movl   $0xc0109b69,0xc(%esp)
c01077e2:	c0 
c01077e3:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c01077ea:	c0 
c01077eb:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01077f2:	00 
c01077f3:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01077fa:	e8 36 8c ff ff       	call   c0100435 <__panic>
    cprintf("A %p\n",A);
c01077ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107802:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107806:	c7 04 24 4e 9b 10 c0 	movl   $0xc0109b4e,(%esp)
c010780d:	e8 b7 8a ff ff       	call   c01002c9 <cprintf>
    cprintf("B %p\n",B);
c0107812:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107815:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107819:	c7 04 24 54 9b 10 c0 	movl   $0xc0109b54,(%esp)
c0107820:	e8 a4 8a ff ff       	call   c01002c9 <cprintf>
    C=alloc_pages(80);
c0107825:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
c010782c:	e8 65 b6 ff ff       	call   c0102e96 <alloc_pages>
c0107831:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(A+256==C);//检查C有没有和A重叠
c0107834:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107837:	05 00 14 00 00       	add    $0x1400,%eax
c010783c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010783f:	74 24                	je     c0107865 <buddy_check+0x31f>
c0107841:	c7 44 24 0c 72 9b 10 	movl   $0xc0109b72,0xc(%esp)
c0107848:	c0 
c0107849:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c0107850:	c0 
c0107851:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0107858:	00 
c0107859:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c0107860:	e8 d0 8b ff ff       	call   c0100435 <__panic>
    cprintf("C %p\n",C);
c0107865:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107868:	89 44 24 04          	mov    %eax,0x4(%esp)
c010786c:	c7 04 24 7b 9b 10 c0 	movl   $0xc0109b7b,(%esp)
c0107873:	e8 51 8a ff ff       	call   c01002c9 <cprintf>
    free_pages(A,70);//释放A
c0107878:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010787f:	00 
c0107880:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107883:	89 04 24             	mov    %eax,(%esp)
c0107886:	e8 47 b6 ff ff       	call   c0102ed2 <free_pages>
    cprintf("B %p\n",B);
c010788b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010788e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107892:	c7 04 24 54 9b 10 c0 	movl   $0xc0109b54,(%esp)
c0107899:	e8 2b 8a ff ff       	call   c01002c9 <cprintf>
    D=alloc_pages(60);
c010789e:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
c01078a5:	e8 ec b5 ff ff       	call   c0102e96 <alloc_pages>
c01078aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n",D);
c01078ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078b4:	c7 04 24 81 9b 10 c0 	movl   $0xc0109b81,(%esp)
c01078bb:	e8 09 8a ff ff       	call   c01002c9 <cprintf>
    assert(B+64==D);//检查B，D是否相邻
c01078c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078c3:	05 00 05 00 00       	add    $0x500,%eax
c01078c8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01078cb:	74 24                	je     c01078f1 <buddy_check+0x3ab>
c01078cd:	c7 44 24 0c 87 9b 10 	movl   $0xc0109b87,0xc(%esp)
c01078d4:	c0 
c01078d5:	c7 44 24 08 3c 9a 10 	movl   $0xc0109a3c,0x8(%esp)
c01078dc:	c0 
c01078dd:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01078e4:	00 
c01078e5:	c7 04 24 51 9a 10 c0 	movl   $0xc0109a51,(%esp)
c01078ec:	e8 44 8b ff ff       	call   c0100435 <__panic>
    free_pages(B,35);
c01078f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
c01078f8:	00 
c01078f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078fc:	89 04 24             	mov    %eax,(%esp)
c01078ff:	e8 ce b5 ff ff       	call   c0102ed2 <free_pages>
    cprintf("D %p\n",D);
c0107904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010790b:	c7 04 24 81 9b 10 c0 	movl   $0xc0109b81,(%esp)
c0107912:	e8 b2 89 ff ff       	call   c01002c9 <cprintf>
    free_pages(D,60);
c0107917:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c010791e:	00 
c010791f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107922:	89 04 24             	mov    %eax,(%esp)
c0107925:	e8 a8 b5 ff ff       	call   c0102ed2 <free_pages>
    cprintf("C %p\n",C);
c010792a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010792d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107931:	c7 04 24 7b 9b 10 c0 	movl   $0xc0109b7b,(%esp)
c0107938:	e8 8c 89 ff ff       	call   c01002c9 <cprintf>
    free_pages(C,80);
c010793d:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
c0107944:	00 
c0107945:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107948:	89 04 24             	mov    %eax,(%esp)
c010794b:	e8 82 b5 ff ff       	call   c0102ed2 <free_pages>
    free_pages(p0,1000);//全部释放
c0107950:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
c0107957:	00 
c0107958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010795b:	89 04 24             	mov    %eax,(%esp)
c010795e:	e8 6f b5 ff ff       	call   c0102ed2 <free_pages>
}
c0107963:	90                   	nop
c0107964:	c9                   	leave  
c0107965:	c3                   	ret    

c0107966 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0107966:	f3 0f 1e fb          	endbr32 
c010796a:	55                   	push   %ebp
c010796b:	89 e5                	mov    %esp,%ebp
c010796d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0107970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0107977:	eb 03                	jmp    c010797c <strlen+0x16>
        cnt ++;
c0107979:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010797c:	8b 45 08             	mov    0x8(%ebp),%eax
c010797f:	8d 50 01             	lea    0x1(%eax),%edx
c0107982:	89 55 08             	mov    %edx,0x8(%ebp)
c0107985:	0f b6 00             	movzbl (%eax),%eax
c0107988:	84 c0                	test   %al,%al
c010798a:	75 ed                	jne    c0107979 <strlen+0x13>
    }
    return cnt;
c010798c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010798f:	c9                   	leave  
c0107990:	c3                   	ret    

c0107991 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0107991:	f3 0f 1e fb          	endbr32 
c0107995:	55                   	push   %ebp
c0107996:	89 e5                	mov    %esp,%ebp
c0107998:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010799b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01079a2:	eb 03                	jmp    c01079a7 <strnlen+0x16>
        cnt ++;
c01079a4:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01079a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079ad:	73 10                	jae    c01079bf <strnlen+0x2e>
c01079af:	8b 45 08             	mov    0x8(%ebp),%eax
c01079b2:	8d 50 01             	lea    0x1(%eax),%edx
c01079b5:	89 55 08             	mov    %edx,0x8(%ebp)
c01079b8:	0f b6 00             	movzbl (%eax),%eax
c01079bb:	84 c0                	test   %al,%al
c01079bd:	75 e5                	jne    c01079a4 <strnlen+0x13>
    }
    return cnt;
c01079bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01079c2:	c9                   	leave  
c01079c3:	c3                   	ret    

c01079c4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01079c4:	f3 0f 1e fb          	endbr32 
c01079c8:	55                   	push   %ebp
c01079c9:	89 e5                	mov    %esp,%ebp
c01079cb:	57                   	push   %edi
c01079cc:	56                   	push   %esi
c01079cd:	83 ec 20             	sub    $0x20,%esp
c01079d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01079d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01079d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01079dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01079df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079e2:	89 d1                	mov    %edx,%ecx
c01079e4:	89 c2                	mov    %eax,%edx
c01079e6:	89 ce                	mov    %ecx,%esi
c01079e8:	89 d7                	mov    %edx,%edi
c01079ea:	ac                   	lods   %ds:(%esi),%al
c01079eb:	aa                   	stos   %al,%es:(%edi)
c01079ec:	84 c0                	test   %al,%al
c01079ee:	75 fa                	jne    c01079ea <strcpy+0x26>
c01079f0:	89 fa                	mov    %edi,%edx
c01079f2:	89 f1                	mov    %esi,%ecx
c01079f4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01079f7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01079fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01079fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0107a00:	83 c4 20             	add    $0x20,%esp
c0107a03:	5e                   	pop    %esi
c0107a04:	5f                   	pop    %edi
c0107a05:	5d                   	pop    %ebp
c0107a06:	c3                   	ret    

c0107a07 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0107a07:	f3 0f 1e fb          	endbr32 
c0107a0b:	55                   	push   %ebp
c0107a0c:	89 e5                	mov    %esp,%ebp
c0107a0e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0107a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0107a17:	eb 1e                	jmp    c0107a37 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c0107a19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a1c:	0f b6 10             	movzbl (%eax),%edx
c0107a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107a22:	88 10                	mov    %dl,(%eax)
c0107a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107a27:	0f b6 00             	movzbl (%eax),%eax
c0107a2a:	84 c0                	test   %al,%al
c0107a2c:	74 03                	je     c0107a31 <strncpy+0x2a>
            src ++;
c0107a2e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0107a31:	ff 45 fc             	incl   -0x4(%ebp)
c0107a34:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0107a37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107a3b:	75 dc                	jne    c0107a19 <strncpy+0x12>
    }
    return dst;
c0107a3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107a40:	c9                   	leave  
c0107a41:	c3                   	ret    

c0107a42 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0107a42:	f3 0f 1e fb          	endbr32 
c0107a46:	55                   	push   %ebp
c0107a47:	89 e5                	mov    %esp,%ebp
c0107a49:	57                   	push   %edi
c0107a4a:	56                   	push   %esi
c0107a4b:	83 ec 20             	sub    $0x20,%esp
c0107a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0107a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a60:	89 d1                	mov    %edx,%ecx
c0107a62:	89 c2                	mov    %eax,%edx
c0107a64:	89 ce                	mov    %ecx,%esi
c0107a66:	89 d7                	mov    %edx,%edi
c0107a68:	ac                   	lods   %ds:(%esi),%al
c0107a69:	ae                   	scas   %es:(%edi),%al
c0107a6a:	75 08                	jne    c0107a74 <strcmp+0x32>
c0107a6c:	84 c0                	test   %al,%al
c0107a6e:	75 f8                	jne    c0107a68 <strcmp+0x26>
c0107a70:	31 c0                	xor    %eax,%eax
c0107a72:	eb 04                	jmp    c0107a78 <strcmp+0x36>
c0107a74:	19 c0                	sbb    %eax,%eax
c0107a76:	0c 01                	or     $0x1,%al
c0107a78:	89 fa                	mov    %edi,%edx
c0107a7a:	89 f1                	mov    %esi,%ecx
c0107a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107a7f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0107a82:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0107a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0107a88:	83 c4 20             	add    $0x20,%esp
c0107a8b:	5e                   	pop    %esi
c0107a8c:	5f                   	pop    %edi
c0107a8d:	5d                   	pop    %ebp
c0107a8e:	c3                   	ret    

c0107a8f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0107a8f:	f3 0f 1e fb          	endbr32 
c0107a93:	55                   	push   %ebp
c0107a94:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0107a96:	eb 09                	jmp    c0107aa1 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0107a98:	ff 4d 10             	decl   0x10(%ebp)
c0107a9b:	ff 45 08             	incl   0x8(%ebp)
c0107a9e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0107aa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107aa5:	74 1a                	je     c0107ac1 <strncmp+0x32>
c0107aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107aaa:	0f b6 00             	movzbl (%eax),%eax
c0107aad:	84 c0                	test   %al,%al
c0107aaf:	74 10                	je     c0107ac1 <strncmp+0x32>
c0107ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ab4:	0f b6 10             	movzbl (%eax),%edx
c0107ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107aba:	0f b6 00             	movzbl (%eax),%eax
c0107abd:	38 c2                	cmp    %al,%dl
c0107abf:	74 d7                	je     c0107a98 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0107ac1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107ac5:	74 18                	je     c0107adf <strncmp+0x50>
c0107ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107aca:	0f b6 00             	movzbl (%eax),%eax
c0107acd:	0f b6 d0             	movzbl %al,%edx
c0107ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ad3:	0f b6 00             	movzbl (%eax),%eax
c0107ad6:	0f b6 c0             	movzbl %al,%eax
c0107ad9:	29 c2                	sub    %eax,%edx
c0107adb:	89 d0                	mov    %edx,%eax
c0107add:	eb 05                	jmp    c0107ae4 <strncmp+0x55>
c0107adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107ae4:	5d                   	pop    %ebp
c0107ae5:	c3                   	ret    

c0107ae6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0107ae6:	f3 0f 1e fb          	endbr32 
c0107aea:	55                   	push   %ebp
c0107aeb:	89 e5                	mov    %esp,%ebp
c0107aed:	83 ec 04             	sub    $0x4,%esp
c0107af0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107af3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107af6:	eb 13                	jmp    c0107b0b <strchr+0x25>
        if (*s == c) {
c0107af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107afb:	0f b6 00             	movzbl (%eax),%eax
c0107afe:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0107b01:	75 05                	jne    c0107b08 <strchr+0x22>
            return (char *)s;
c0107b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b06:	eb 12                	jmp    c0107b1a <strchr+0x34>
        }
        s ++;
c0107b08:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0107b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b0e:	0f b6 00             	movzbl (%eax),%eax
c0107b11:	84 c0                	test   %al,%al
c0107b13:	75 e3                	jne    c0107af8 <strchr+0x12>
    }
    return NULL;
c0107b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b1a:	c9                   	leave  
c0107b1b:	c3                   	ret    

c0107b1c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0107b1c:	f3 0f 1e fb          	endbr32 
c0107b20:	55                   	push   %ebp
c0107b21:	89 e5                	mov    %esp,%ebp
c0107b23:	83 ec 04             	sub    $0x4,%esp
c0107b26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107b2c:	eb 0e                	jmp    c0107b3c <strfind+0x20>
        if (*s == c) {
c0107b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b31:	0f b6 00             	movzbl (%eax),%eax
c0107b34:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0107b37:	74 0f                	je     c0107b48 <strfind+0x2c>
            break;
        }
        s ++;
c0107b39:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0107b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b3f:	0f b6 00             	movzbl (%eax),%eax
c0107b42:	84 c0                	test   %al,%al
c0107b44:	75 e8                	jne    c0107b2e <strfind+0x12>
c0107b46:	eb 01                	jmp    c0107b49 <strfind+0x2d>
            break;
c0107b48:	90                   	nop
    }
    return (char *)s;
c0107b49:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107b4c:	c9                   	leave  
c0107b4d:	c3                   	ret    

c0107b4e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0107b4e:	f3 0f 1e fb          	endbr32 
c0107b52:	55                   	push   %ebp
c0107b53:	89 e5                	mov    %esp,%ebp
c0107b55:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0107b58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0107b5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107b66:	eb 03                	jmp    c0107b6b <strtol+0x1d>
        s ++;
c0107b68:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0107b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b6e:	0f b6 00             	movzbl (%eax),%eax
c0107b71:	3c 20                	cmp    $0x20,%al
c0107b73:	74 f3                	je     c0107b68 <strtol+0x1a>
c0107b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b78:	0f b6 00             	movzbl (%eax),%eax
c0107b7b:	3c 09                	cmp    $0x9,%al
c0107b7d:	74 e9                	je     c0107b68 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c0107b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b82:	0f b6 00             	movzbl (%eax),%eax
c0107b85:	3c 2b                	cmp    $0x2b,%al
c0107b87:	75 05                	jne    c0107b8e <strtol+0x40>
        s ++;
c0107b89:	ff 45 08             	incl   0x8(%ebp)
c0107b8c:	eb 14                	jmp    c0107ba2 <strtol+0x54>
    }
    else if (*s == '-') {
c0107b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b91:	0f b6 00             	movzbl (%eax),%eax
c0107b94:	3c 2d                	cmp    $0x2d,%al
c0107b96:	75 0a                	jne    c0107ba2 <strtol+0x54>
        s ++, neg = 1;
c0107b98:	ff 45 08             	incl   0x8(%ebp)
c0107b9b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0107ba2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107ba6:	74 06                	je     c0107bae <strtol+0x60>
c0107ba8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0107bac:	75 22                	jne    c0107bd0 <strtol+0x82>
c0107bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bb1:	0f b6 00             	movzbl (%eax),%eax
c0107bb4:	3c 30                	cmp    $0x30,%al
c0107bb6:	75 18                	jne    c0107bd0 <strtol+0x82>
c0107bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bbb:	40                   	inc    %eax
c0107bbc:	0f b6 00             	movzbl (%eax),%eax
c0107bbf:	3c 78                	cmp    $0x78,%al
c0107bc1:	75 0d                	jne    c0107bd0 <strtol+0x82>
        s += 2, base = 16;
c0107bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0107bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0107bce:	eb 29                	jmp    c0107bf9 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0107bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107bd4:	75 16                	jne    c0107bec <strtol+0x9e>
c0107bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bd9:	0f b6 00             	movzbl (%eax),%eax
c0107bdc:	3c 30                	cmp    $0x30,%al
c0107bde:	75 0c                	jne    c0107bec <strtol+0x9e>
        s ++, base = 8;
c0107be0:	ff 45 08             	incl   0x8(%ebp)
c0107be3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0107bea:	eb 0d                	jmp    c0107bf9 <strtol+0xab>
    }
    else if (base == 0) {
c0107bec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107bf0:	75 07                	jne    c0107bf9 <strtol+0xab>
        base = 10;
c0107bf2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0107bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bfc:	0f b6 00             	movzbl (%eax),%eax
c0107bff:	3c 2f                	cmp    $0x2f,%al
c0107c01:	7e 1b                	jle    c0107c1e <strtol+0xd0>
c0107c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c06:	0f b6 00             	movzbl (%eax),%eax
c0107c09:	3c 39                	cmp    $0x39,%al
c0107c0b:	7f 11                	jg     c0107c1e <strtol+0xd0>
            dig = *s - '0';
c0107c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c10:	0f b6 00             	movzbl (%eax),%eax
c0107c13:	0f be c0             	movsbl %al,%eax
c0107c16:	83 e8 30             	sub    $0x30,%eax
c0107c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107c1c:	eb 48                	jmp    c0107c66 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0107c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c21:	0f b6 00             	movzbl (%eax),%eax
c0107c24:	3c 60                	cmp    $0x60,%al
c0107c26:	7e 1b                	jle    c0107c43 <strtol+0xf5>
c0107c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c2b:	0f b6 00             	movzbl (%eax),%eax
c0107c2e:	3c 7a                	cmp    $0x7a,%al
c0107c30:	7f 11                	jg     c0107c43 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0107c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c35:	0f b6 00             	movzbl (%eax),%eax
c0107c38:	0f be c0             	movsbl %al,%eax
c0107c3b:	83 e8 57             	sub    $0x57,%eax
c0107c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107c41:	eb 23                	jmp    c0107c66 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0107c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c46:	0f b6 00             	movzbl (%eax),%eax
c0107c49:	3c 40                	cmp    $0x40,%al
c0107c4b:	7e 3b                	jle    c0107c88 <strtol+0x13a>
c0107c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c50:	0f b6 00             	movzbl (%eax),%eax
c0107c53:	3c 5a                	cmp    $0x5a,%al
c0107c55:	7f 31                	jg     c0107c88 <strtol+0x13a>
            dig = *s - 'A' + 10;
c0107c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c5a:	0f b6 00             	movzbl (%eax),%eax
c0107c5d:	0f be c0             	movsbl %al,%eax
c0107c60:	83 e8 37             	sub    $0x37,%eax
c0107c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0107c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c69:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107c6c:	7d 19                	jge    c0107c87 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c0107c6e:	ff 45 08             	incl   0x8(%ebp)
c0107c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107c74:	0f af 45 10          	imul   0x10(%ebp),%eax
c0107c78:	89 c2                	mov    %eax,%edx
c0107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c7d:	01 d0                	add    %edx,%eax
c0107c7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0107c82:	e9 72 ff ff ff       	jmp    c0107bf9 <strtol+0xab>
            break;
c0107c87:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0107c88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107c8c:	74 08                	je     c0107c96 <strtol+0x148>
        *endptr = (char *) s;
c0107c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c91:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c94:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0107c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107c9a:	74 07                	je     c0107ca3 <strtol+0x155>
c0107c9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107c9f:	f7 d8                	neg    %eax
c0107ca1:	eb 03                	jmp    c0107ca6 <strtol+0x158>
c0107ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0107ca6:	c9                   	leave  
c0107ca7:	c3                   	ret    

c0107ca8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0107ca8:	f3 0f 1e fb          	endbr32 
c0107cac:	55                   	push   %ebp
c0107cad:	89 e5                	mov    %esp,%ebp
c0107caf:	57                   	push   %edi
c0107cb0:	83 ec 24             	sub    $0x24,%esp
c0107cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cb6:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0107cb9:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0107cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0107cc3:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0107cc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0107ccc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107ccf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0107cd3:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0107cd6:	89 d7                	mov    %edx,%edi
c0107cd8:	f3 aa                	rep stos %al,%es:(%edi)
c0107cda:	89 fa                	mov    %edi,%edx
c0107cdc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0107cdf:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0107ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0107ce5:	83 c4 24             	add    $0x24,%esp
c0107ce8:	5f                   	pop    %edi
c0107ce9:	5d                   	pop    %ebp
c0107cea:	c3                   	ret    

c0107ceb <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0107ceb:	f3 0f 1e fb          	endbr32 
c0107cef:	55                   	push   %ebp
c0107cf0:	89 e5                	mov    %esp,%ebp
c0107cf2:	57                   	push   %edi
c0107cf3:	56                   	push   %esi
c0107cf4:	53                   	push   %ebx
c0107cf5:	83 ec 30             	sub    $0x30,%esp
c0107cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107d04:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d07:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0107d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d0d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107d10:	73 42                	jae    c0107d54 <memmove+0x69>
c0107d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d21:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d27:	c1 e8 02             	shr    $0x2,%eax
c0107d2a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0107d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d32:	89 d7                	mov    %edx,%edi
c0107d34:	89 c6                	mov    %eax,%esi
c0107d36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107d38:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107d3b:	83 e1 03             	and    $0x3,%ecx
c0107d3e:	74 02                	je     c0107d42 <memmove+0x57>
c0107d40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107d42:	89 f0                	mov    %esi,%eax
c0107d44:	89 fa                	mov    %edi,%edx
c0107d46:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0107d49:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107d4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0107d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0107d52:	eb 36                	jmp    c0107d8a <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0107d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d57:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d5d:	01 c2                	add    %eax,%edx
c0107d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d62:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0107d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d68:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0107d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d6e:	89 c1                	mov    %eax,%ecx
c0107d70:	89 d8                	mov    %ebx,%eax
c0107d72:	89 d6                	mov    %edx,%esi
c0107d74:	89 c7                	mov    %eax,%edi
c0107d76:	fd                   	std    
c0107d77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107d79:	fc                   	cld    
c0107d7a:	89 f8                	mov    %edi,%eax
c0107d7c:	89 f2                	mov    %esi,%edx
c0107d7e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0107d81:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0107d84:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0107d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0107d8a:	83 c4 30             	add    $0x30,%esp
c0107d8d:	5b                   	pop    %ebx
c0107d8e:	5e                   	pop    %esi
c0107d8f:	5f                   	pop    %edi
c0107d90:	5d                   	pop    %ebp
c0107d91:	c3                   	ret    

c0107d92 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0107d92:	f3 0f 1e fb          	endbr32 
c0107d96:	55                   	push   %ebp
c0107d97:	89 e5                	mov    %esp,%ebp
c0107d99:	57                   	push   %edi
c0107d9a:	56                   	push   %esi
c0107d9b:	83 ec 20             	sub    $0x20,%esp
c0107d9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107da4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107daa:	8b 45 10             	mov    0x10(%ebp),%eax
c0107dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107db3:	c1 e8 02             	shr    $0x2,%eax
c0107db6:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0107db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107dbe:	89 d7                	mov    %edx,%edi
c0107dc0:	89 c6                	mov    %eax,%esi
c0107dc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107dc4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0107dc7:	83 e1 03             	and    $0x3,%ecx
c0107dca:	74 02                	je     c0107dce <memcpy+0x3c>
c0107dcc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107dce:	89 f0                	mov    %esi,%eax
c0107dd0:	89 fa                	mov    %edi,%edx
c0107dd2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0107dd5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0107ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0107dde:	83 c4 20             	add    $0x20,%esp
c0107de1:	5e                   	pop    %esi
c0107de2:	5f                   	pop    %edi
c0107de3:	5d                   	pop    %ebp
c0107de4:	c3                   	ret    

c0107de5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0107de5:	f3 0f 1e fb          	endbr32 
c0107de9:	55                   	push   %ebp
c0107dea:	89 e5                	mov    %esp,%ebp
c0107dec:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0107def:	8b 45 08             	mov    0x8(%ebp),%eax
c0107df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0107df5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0107dfb:	eb 2e                	jmp    c0107e2b <memcmp+0x46>
        if (*s1 != *s2) {
c0107dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107e00:	0f b6 10             	movzbl (%eax),%edx
c0107e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107e06:	0f b6 00             	movzbl (%eax),%eax
c0107e09:	38 c2                	cmp    %al,%dl
c0107e0b:	74 18                	je     c0107e25 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0107e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107e10:	0f b6 00             	movzbl (%eax),%eax
c0107e13:	0f b6 d0             	movzbl %al,%edx
c0107e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107e19:	0f b6 00             	movzbl (%eax),%eax
c0107e1c:	0f b6 c0             	movzbl %al,%eax
c0107e1f:	29 c2                	sub    %eax,%edx
c0107e21:	89 d0                	mov    %edx,%eax
c0107e23:	eb 18                	jmp    c0107e3d <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0107e25:	ff 45 fc             	incl   -0x4(%ebp)
c0107e28:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0107e2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107e31:	89 55 10             	mov    %edx,0x10(%ebp)
c0107e34:	85 c0                	test   %eax,%eax
c0107e36:	75 c5                	jne    c0107dfd <memcmp+0x18>
    }
    return 0;
c0107e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107e3d:	c9                   	leave  
c0107e3e:	c3                   	ret    

c0107e3f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107e3f:	f3 0f 1e fb          	endbr32 
c0107e43:	55                   	push   %ebp
c0107e44:	89 e5                	mov    %esp,%ebp
c0107e46:	83 ec 58             	sub    $0x58,%esp
c0107e49:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107e4f:	8b 45 14             	mov    0x14(%ebp),%eax
c0107e52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107e5e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107e61:	8b 45 18             	mov    0x18(%ebp),%eax
c0107e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107e6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107e70:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107e7d:	74 1c                	je     c0107e9b <printnum+0x5c>
c0107e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e82:	ba 00 00 00 00       	mov    $0x0,%edx
c0107e87:	f7 75 e4             	divl   -0x1c(%ebp)
c0107e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e90:	ba 00 00 00 00       	mov    $0x0,%edx
c0107e95:	f7 75 e4             	divl   -0x1c(%ebp)
c0107e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ea1:	f7 75 e4             	divl   -0x1c(%ebp)
c0107ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107ea7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107eb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107eb3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107eb9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107ebc:	8b 45 18             	mov    0x18(%ebp),%eax
c0107ebf:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ec4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0107ec7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107eca:	19 d1                	sbb    %edx,%ecx
c0107ecc:	72 4c                	jb     c0107f1a <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107ece:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107ed1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107ed4:	8b 45 20             	mov    0x20(%ebp),%eax
c0107ed7:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107edb:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107edf:	8b 45 18             	mov    0x18(%ebp),%eax
c0107ee2:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ee9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107eec:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ef0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0107efe:	89 04 24             	mov    %eax,(%esp)
c0107f01:	e8 39 ff ff ff       	call   c0107e3f <printnum>
c0107f06:	eb 1b                	jmp    c0107f23 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107f08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f0f:	8b 45 20             	mov    0x20(%ebp),%eax
c0107f12:	89 04 24             	mov    %eax,(%esp)
c0107f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f18:	ff d0                	call   *%eax
        while (-- width > 0)
c0107f1a:	ff 4d 1c             	decl   0x1c(%ebp)
c0107f1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107f21:	7f e5                	jg     c0107f08 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107f23:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107f26:	05 40 9c 10 c0       	add    $0xc0109c40,%eax
c0107f2b:	0f b6 00             	movzbl (%eax),%eax
c0107f2e:	0f be c0             	movsbl %al,%eax
c0107f31:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107f34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f38:	89 04 24             	mov    %eax,(%esp)
c0107f3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f3e:	ff d0                	call   *%eax
}
c0107f40:	90                   	nop
c0107f41:	c9                   	leave  
c0107f42:	c3                   	ret    

c0107f43 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107f43:	f3 0f 1e fb          	endbr32 
c0107f47:	55                   	push   %ebp
c0107f48:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107f4a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107f4e:	7e 14                	jle    c0107f64 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0107f50:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f53:	8b 00                	mov    (%eax),%eax
c0107f55:	8d 48 08             	lea    0x8(%eax),%ecx
c0107f58:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f5b:	89 0a                	mov    %ecx,(%edx)
c0107f5d:	8b 50 04             	mov    0x4(%eax),%edx
c0107f60:	8b 00                	mov    (%eax),%eax
c0107f62:	eb 30                	jmp    c0107f94 <getuint+0x51>
    }
    else if (lflag) {
c0107f64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107f68:	74 16                	je     c0107f80 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0107f6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6d:	8b 00                	mov    (%eax),%eax
c0107f6f:	8d 48 04             	lea    0x4(%eax),%ecx
c0107f72:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f75:	89 0a                	mov    %ecx,(%edx)
c0107f77:	8b 00                	mov    (%eax),%eax
c0107f79:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f7e:	eb 14                	jmp    c0107f94 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0107f80:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f83:	8b 00                	mov    (%eax),%eax
c0107f85:	8d 48 04             	lea    0x4(%eax),%ecx
c0107f88:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f8b:	89 0a                	mov    %ecx,(%edx)
c0107f8d:	8b 00                	mov    (%eax),%eax
c0107f8f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107f94:	5d                   	pop    %ebp
c0107f95:	c3                   	ret    

c0107f96 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107f96:	f3 0f 1e fb          	endbr32 
c0107f9a:	55                   	push   %ebp
c0107f9b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107f9d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107fa1:	7e 14                	jle    c0107fb7 <getint+0x21>
        return va_arg(*ap, long long);
c0107fa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa6:	8b 00                	mov    (%eax),%eax
c0107fa8:	8d 48 08             	lea    0x8(%eax),%ecx
c0107fab:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fae:	89 0a                	mov    %ecx,(%edx)
c0107fb0:	8b 50 04             	mov    0x4(%eax),%edx
c0107fb3:	8b 00                	mov    (%eax),%eax
c0107fb5:	eb 28                	jmp    c0107fdf <getint+0x49>
    }
    else if (lflag) {
c0107fb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107fbb:	74 12                	je     c0107fcf <getint+0x39>
        return va_arg(*ap, long);
c0107fbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fc0:	8b 00                	mov    (%eax),%eax
c0107fc2:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fc5:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fc8:	89 0a                	mov    %ecx,(%edx)
c0107fca:	8b 00                	mov    (%eax),%eax
c0107fcc:	99                   	cltd   
c0107fcd:	eb 10                	jmp    c0107fdf <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0107fcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fd2:	8b 00                	mov    (%eax),%eax
c0107fd4:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fda:	89 0a                	mov    %ecx,(%edx)
c0107fdc:	8b 00                	mov    (%eax),%eax
c0107fde:	99                   	cltd   
    }
}
c0107fdf:	5d                   	pop    %ebp
c0107fe0:	c3                   	ret    

c0107fe1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0107fe1:	f3 0f 1e fb          	endbr32 
c0107fe5:	55                   	push   %ebp
c0107fe6:	89 e5                	mov    %esp,%ebp
c0107fe8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0107feb:	8d 45 14             	lea    0x14(%ebp),%eax
c0107fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0107ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ff8:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108002:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108006:	8b 45 08             	mov    0x8(%ebp),%eax
c0108009:	89 04 24             	mov    %eax,(%esp)
c010800c:	e8 03 00 00 00       	call   c0108014 <vprintfmt>
    va_end(ap);
}
c0108011:	90                   	nop
c0108012:	c9                   	leave  
c0108013:	c3                   	ret    

c0108014 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108014:	f3 0f 1e fb          	endbr32 
c0108018:	55                   	push   %ebp
c0108019:	89 e5                	mov    %esp,%ebp
c010801b:	56                   	push   %esi
c010801c:	53                   	push   %ebx
c010801d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108020:	eb 17                	jmp    c0108039 <vprintfmt+0x25>
            if (ch == '\0') {
c0108022:	85 db                	test   %ebx,%ebx
c0108024:	0f 84 c0 03 00 00    	je     c01083ea <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c010802a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010802d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108031:	89 1c 24             	mov    %ebx,(%esp)
c0108034:	8b 45 08             	mov    0x8(%ebp),%eax
c0108037:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108039:	8b 45 10             	mov    0x10(%ebp),%eax
c010803c:	8d 50 01             	lea    0x1(%eax),%edx
c010803f:	89 55 10             	mov    %edx,0x10(%ebp)
c0108042:	0f b6 00             	movzbl (%eax),%eax
c0108045:	0f b6 d8             	movzbl %al,%ebx
c0108048:	83 fb 25             	cmp    $0x25,%ebx
c010804b:	75 d5                	jne    c0108022 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010804d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108051:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010805b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010805e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108065:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108068:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010806b:	8b 45 10             	mov    0x10(%ebp),%eax
c010806e:	8d 50 01             	lea    0x1(%eax),%edx
c0108071:	89 55 10             	mov    %edx,0x10(%ebp)
c0108074:	0f b6 00             	movzbl (%eax),%eax
c0108077:	0f b6 d8             	movzbl %al,%ebx
c010807a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010807d:	83 f8 55             	cmp    $0x55,%eax
c0108080:	0f 87 38 03 00 00    	ja     c01083be <vprintfmt+0x3aa>
c0108086:	8b 04 85 64 9c 10 c0 	mov    -0x3fef639c(,%eax,4),%eax
c010808d:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108090:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108094:	eb d5                	jmp    c010806b <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108096:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010809a:	eb cf                	jmp    c010806b <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010809c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01080a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01080a6:	89 d0                	mov    %edx,%eax
c01080a8:	c1 e0 02             	shl    $0x2,%eax
c01080ab:	01 d0                	add    %edx,%eax
c01080ad:	01 c0                	add    %eax,%eax
c01080af:	01 d8                	add    %ebx,%eax
c01080b1:	83 e8 30             	sub    $0x30,%eax
c01080b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01080b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01080ba:	0f b6 00             	movzbl (%eax),%eax
c01080bd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01080c0:	83 fb 2f             	cmp    $0x2f,%ebx
c01080c3:	7e 38                	jle    c01080fd <vprintfmt+0xe9>
c01080c5:	83 fb 39             	cmp    $0x39,%ebx
c01080c8:	7f 33                	jg     c01080fd <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c01080ca:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01080cd:	eb d4                	jmp    c01080a3 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01080cf:	8b 45 14             	mov    0x14(%ebp),%eax
c01080d2:	8d 50 04             	lea    0x4(%eax),%edx
c01080d5:	89 55 14             	mov    %edx,0x14(%ebp)
c01080d8:	8b 00                	mov    (%eax),%eax
c01080da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01080dd:	eb 1f                	jmp    c01080fe <vprintfmt+0xea>

        case '.':
            if (width < 0)
c01080df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01080e3:	79 86                	jns    c010806b <vprintfmt+0x57>
                width = 0;
c01080e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01080ec:	e9 7a ff ff ff       	jmp    c010806b <vprintfmt+0x57>

        case '#':
            altflag = 1;
c01080f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01080f8:	e9 6e ff ff ff       	jmp    c010806b <vprintfmt+0x57>
            goto process_precision;
c01080fd:	90                   	nop

        process_precision:
            if (width < 0)
c01080fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108102:	0f 89 63 ff ff ff    	jns    c010806b <vprintfmt+0x57>
                width = precision, precision = -1;
c0108108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010810b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010810e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108115:	e9 51 ff ff ff       	jmp    c010806b <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010811a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010811d:	e9 49 ff ff ff       	jmp    c010806b <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108122:	8b 45 14             	mov    0x14(%ebp),%eax
c0108125:	8d 50 04             	lea    0x4(%eax),%edx
c0108128:	89 55 14             	mov    %edx,0x14(%ebp)
c010812b:	8b 00                	mov    (%eax),%eax
c010812d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108130:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108134:	89 04 24             	mov    %eax,(%esp)
c0108137:	8b 45 08             	mov    0x8(%ebp),%eax
c010813a:	ff d0                	call   *%eax
            break;
c010813c:	e9 a4 02 00 00       	jmp    c01083e5 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108141:	8b 45 14             	mov    0x14(%ebp),%eax
c0108144:	8d 50 04             	lea    0x4(%eax),%edx
c0108147:	89 55 14             	mov    %edx,0x14(%ebp)
c010814a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010814c:	85 db                	test   %ebx,%ebx
c010814e:	79 02                	jns    c0108152 <vprintfmt+0x13e>
                err = -err;
c0108150:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108152:	83 fb 06             	cmp    $0x6,%ebx
c0108155:	7f 0b                	jg     c0108162 <vprintfmt+0x14e>
c0108157:	8b 34 9d 24 9c 10 c0 	mov    -0x3fef63dc(,%ebx,4),%esi
c010815e:	85 f6                	test   %esi,%esi
c0108160:	75 23                	jne    c0108185 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0108162:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108166:	c7 44 24 08 51 9c 10 	movl   $0xc0109c51,0x8(%esp)
c010816d:	c0 
c010816e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108175:	8b 45 08             	mov    0x8(%ebp),%eax
c0108178:	89 04 24             	mov    %eax,(%esp)
c010817b:	e8 61 fe ff ff       	call   c0107fe1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108180:	e9 60 02 00 00       	jmp    c01083e5 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0108185:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108189:	c7 44 24 08 5a 9c 10 	movl   $0xc0109c5a,0x8(%esp)
c0108190:	c0 
c0108191:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108194:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108198:	8b 45 08             	mov    0x8(%ebp),%eax
c010819b:	89 04 24             	mov    %eax,(%esp)
c010819e:	e8 3e fe ff ff       	call   c0107fe1 <printfmt>
            break;
c01081a3:	e9 3d 02 00 00       	jmp    c01083e5 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01081a8:	8b 45 14             	mov    0x14(%ebp),%eax
c01081ab:	8d 50 04             	lea    0x4(%eax),%edx
c01081ae:	89 55 14             	mov    %edx,0x14(%ebp)
c01081b1:	8b 30                	mov    (%eax),%esi
c01081b3:	85 f6                	test   %esi,%esi
c01081b5:	75 05                	jne    c01081bc <vprintfmt+0x1a8>
                p = "(null)";
c01081b7:	be 5d 9c 10 c0       	mov    $0xc0109c5d,%esi
            }
            if (width > 0 && padc != '-') {
c01081bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01081c0:	7e 76                	jle    c0108238 <vprintfmt+0x224>
c01081c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01081c6:	74 70                	je     c0108238 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01081c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081cf:	89 34 24             	mov    %esi,(%esp)
c01081d2:	e8 ba f7 ff ff       	call   c0107991 <strnlen>
c01081d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01081da:	29 c2                	sub    %eax,%edx
c01081dc:	89 d0                	mov    %edx,%eax
c01081de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081e1:	eb 16                	jmp    c01081f9 <vprintfmt+0x1e5>
                    putch(padc, putdat);
c01081e3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01081e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081ee:	89 04 24             	mov    %eax,(%esp)
c01081f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01081f4:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01081f6:	ff 4d e8             	decl   -0x18(%ebp)
c01081f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01081fd:	7f e4                	jg     c01081e3 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01081ff:	eb 37                	jmp    c0108238 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108201:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108205:	74 1f                	je     c0108226 <vprintfmt+0x212>
c0108207:	83 fb 1f             	cmp    $0x1f,%ebx
c010820a:	7e 05                	jle    c0108211 <vprintfmt+0x1fd>
c010820c:	83 fb 7e             	cmp    $0x7e,%ebx
c010820f:	7e 15                	jle    c0108226 <vprintfmt+0x212>
                    putch('?', putdat);
c0108211:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108214:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108218:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010821f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108222:	ff d0                	call   *%eax
c0108224:	eb 0f                	jmp    c0108235 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0108226:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108229:	89 44 24 04          	mov    %eax,0x4(%esp)
c010822d:	89 1c 24             	mov    %ebx,(%esp)
c0108230:	8b 45 08             	mov    0x8(%ebp),%eax
c0108233:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108235:	ff 4d e8             	decl   -0x18(%ebp)
c0108238:	89 f0                	mov    %esi,%eax
c010823a:	8d 70 01             	lea    0x1(%eax),%esi
c010823d:	0f b6 00             	movzbl (%eax),%eax
c0108240:	0f be d8             	movsbl %al,%ebx
c0108243:	85 db                	test   %ebx,%ebx
c0108245:	74 27                	je     c010826e <vprintfmt+0x25a>
c0108247:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010824b:	78 b4                	js     c0108201 <vprintfmt+0x1ed>
c010824d:	ff 4d e4             	decl   -0x1c(%ebp)
c0108250:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108254:	79 ab                	jns    c0108201 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0108256:	eb 16                	jmp    c010826e <vprintfmt+0x25a>
                putch(' ', putdat);
c0108258:	8b 45 0c             	mov    0xc(%ebp),%eax
c010825b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010825f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108266:	8b 45 08             	mov    0x8(%ebp),%eax
c0108269:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c010826b:	ff 4d e8             	decl   -0x18(%ebp)
c010826e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108272:	7f e4                	jg     c0108258 <vprintfmt+0x244>
            }
            break;
c0108274:	e9 6c 01 00 00       	jmp    c01083e5 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108279:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010827c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108280:	8d 45 14             	lea    0x14(%ebp),%eax
c0108283:	89 04 24             	mov    %eax,(%esp)
c0108286:	e8 0b fd ff ff       	call   c0107f96 <getint>
c010828b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010828e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108294:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108297:	85 d2                	test   %edx,%edx
c0108299:	79 26                	jns    c01082c1 <vprintfmt+0x2ad>
                putch('-', putdat);
c010829b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010829e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082a2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01082a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ac:	ff d0                	call   *%eax
                num = -(long long)num;
c01082ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01082b4:	f7 d8                	neg    %eax
c01082b6:	83 d2 00             	adc    $0x0,%edx
c01082b9:	f7 da                	neg    %edx
c01082bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082be:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01082c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01082c8:	e9 a8 00 00 00       	jmp    c0108375 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01082cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082d4:	8d 45 14             	lea    0x14(%ebp),%eax
c01082d7:	89 04 24             	mov    %eax,(%esp)
c01082da:	e8 64 fc ff ff       	call   c0107f43 <getuint>
c01082df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01082e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01082ec:	e9 84 00 00 00       	jmp    c0108375 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01082f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082f8:	8d 45 14             	lea    0x14(%ebp),%eax
c01082fb:	89 04 24             	mov    %eax,(%esp)
c01082fe:	e8 40 fc ff ff       	call   c0107f43 <getuint>
c0108303:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108306:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0108309:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108310:	eb 63                	jmp    c0108375 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0108312:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108315:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108319:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108320:	8b 45 08             	mov    0x8(%ebp),%eax
c0108323:	ff d0                	call   *%eax
            putch('x', putdat);
c0108325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108328:	89 44 24 04          	mov    %eax,0x4(%esp)
c010832c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108333:	8b 45 08             	mov    0x8(%ebp),%eax
c0108336:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108338:	8b 45 14             	mov    0x14(%ebp),%eax
c010833b:	8d 50 04             	lea    0x4(%eax),%edx
c010833e:	89 55 14             	mov    %edx,0x14(%ebp)
c0108341:	8b 00                	mov    (%eax),%eax
c0108343:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010834d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108354:	eb 1f                	jmp    c0108375 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108356:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108359:	89 44 24 04          	mov    %eax,0x4(%esp)
c010835d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108360:	89 04 24             	mov    %eax,(%esp)
c0108363:	e8 db fb ff ff       	call   c0107f43 <getuint>
c0108368:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010836b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010836e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108375:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108379:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010837c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108380:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108383:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108387:	89 44 24 10          	mov    %eax,0x10(%esp)
c010838b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010838e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108391:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108395:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108399:	8b 45 0c             	mov    0xc(%ebp),%eax
c010839c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a3:	89 04 24             	mov    %eax,(%esp)
c01083a6:	e8 94 fa ff ff       	call   c0107e3f <printnum>
            break;
c01083ab:	eb 38                	jmp    c01083e5 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01083ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083b4:	89 1c 24             	mov    %ebx,(%esp)
c01083b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ba:	ff d0                	call   *%eax
            break;
c01083bc:	eb 27                	jmp    c01083e5 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01083be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01083cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01083cf:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01083d1:	ff 4d 10             	decl   0x10(%ebp)
c01083d4:	eb 03                	jmp    c01083d9 <vprintfmt+0x3c5>
c01083d6:	ff 4d 10             	decl   0x10(%ebp)
c01083d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01083dc:	48                   	dec    %eax
c01083dd:	0f b6 00             	movzbl (%eax),%eax
c01083e0:	3c 25                	cmp    $0x25,%al
c01083e2:	75 f2                	jne    c01083d6 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c01083e4:	90                   	nop
    while (1) {
c01083e5:	e9 36 fc ff ff       	jmp    c0108020 <vprintfmt+0xc>
                return;
c01083ea:	90                   	nop
        }
    }
}
c01083eb:	83 c4 40             	add    $0x40,%esp
c01083ee:	5b                   	pop    %ebx
c01083ef:	5e                   	pop    %esi
c01083f0:	5d                   	pop    %ebp
c01083f1:	c3                   	ret    

c01083f2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01083f2:	f3 0f 1e fb          	endbr32 
c01083f6:	55                   	push   %ebp
c01083f7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01083f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083fc:	8b 40 08             	mov    0x8(%eax),%eax
c01083ff:	8d 50 01             	lea    0x1(%eax),%edx
c0108402:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108405:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010840b:	8b 10                	mov    (%eax),%edx
c010840d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108410:	8b 40 04             	mov    0x4(%eax),%eax
c0108413:	39 c2                	cmp    %eax,%edx
c0108415:	73 12                	jae    c0108429 <sprintputch+0x37>
        *b->buf ++ = ch;
c0108417:	8b 45 0c             	mov    0xc(%ebp),%eax
c010841a:	8b 00                	mov    (%eax),%eax
c010841c:	8d 48 01             	lea    0x1(%eax),%ecx
c010841f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108422:	89 0a                	mov    %ecx,(%edx)
c0108424:	8b 55 08             	mov    0x8(%ebp),%edx
c0108427:	88 10                	mov    %dl,(%eax)
    }
}
c0108429:	90                   	nop
c010842a:	5d                   	pop    %ebp
c010842b:	c3                   	ret    

c010842c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010842c:	f3 0f 1e fb          	endbr32 
c0108430:	55                   	push   %ebp
c0108431:	89 e5                	mov    %esp,%ebp
c0108433:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108436:	8d 45 14             	lea    0x14(%ebp),%eax
c0108439:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010843c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010843f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108443:	8b 45 10             	mov    0x10(%ebp),%eax
c0108446:	89 44 24 08          	mov    %eax,0x8(%esp)
c010844a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010844d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108451:	8b 45 08             	mov    0x8(%ebp),%eax
c0108454:	89 04 24             	mov    %eax,(%esp)
c0108457:	e8 08 00 00 00       	call   c0108464 <vsnprintf>
c010845c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010845f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108462:	c9                   	leave  
c0108463:	c3                   	ret    

c0108464 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108464:	f3 0f 1e fb          	endbr32 
c0108468:	55                   	push   %ebp
c0108469:	89 e5                	mov    %esp,%ebp
c010846b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010846e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108471:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108477:	8d 50 ff             	lea    -0x1(%eax),%edx
c010847a:	8b 45 08             	mov    0x8(%ebp),%eax
c010847d:	01 d0                	add    %edx,%eax
c010847f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010848d:	74 0a                	je     c0108499 <vsnprintf+0x35>
c010848f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108492:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108495:	39 c2                	cmp    %eax,%edx
c0108497:	76 07                	jbe    c01084a0 <vsnprintf+0x3c>
        return -E_INVAL;
c0108499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010849e:	eb 2a                	jmp    c01084ca <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01084a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01084a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01084a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01084aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01084b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084b5:	c7 04 24 f2 83 10 c0 	movl   $0xc01083f2,(%esp)
c01084bc:	e8 53 fb ff ff       	call   c0108014 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01084c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084c4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01084c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084ca:	c9                   	leave  
c01084cb:	c3                   	ret    
