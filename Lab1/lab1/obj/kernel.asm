
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 0d 11 00       	mov    $0x110d80,%eax
  10000f:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100027:	e8 16 2f 00 00       	call   102f42 <memset>

    cons_init();                // init the console
  10002c:	e8 04 16 00 00       	call   101635 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 37 10 00 	movl   $0x103780,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  100046:	e8 48 02 00 00       	call   100293 <cprintf>

    print_kerninfo();
  10004b:	e8 06 09 00 00       	call   100956 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 97 2b 00 00       	call   102bf1 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 2b 17 00 00       	call   10178a <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 d0 18 00 00       	call   101934 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 51 0d 00 00       	call   100dba <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 68 18 00 00       	call   1018d6 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 86 01 00 00       	call   1001f9 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 09 0d 00 00       	call   100da4 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  10014c:	e8 42 01 00 00       	call   100293 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 af 37 10 00 	movl   $0x1037af,(%esp)
  10016b:	e8 23 01 00 00       	call   100293 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 bd 37 10 00 	movl   $0x1037bd,(%esp)
  10018a:	e8 04 01 00 00       	call   100293 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 cb 37 10 00 	movl   $0x1037cb,(%esp)
  1001a9:	e8 e5 00 00 00       	call   100293 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 d9 37 10 00 	movl   $0x1037d9,(%esp)
  1001c8:	e8 c6 00 00 00       	call   100293 <cprintf>
    round ++;
  1001cd:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001e2:	16                   	push   %ss
  1001e3:	54                   	push   %esp
  1001e4:	cd 78                	int    $0x78
  1001e6:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e8:	90                   	nop
  1001e9:	5d                   	pop    %ebp
  1001ea:	c3                   	ret    

001001eb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001eb:	f3 0f 1e fb          	endbr32 
  1001ef:	55                   	push   %ebp
  1001f0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001f2:	cd 79                	int    $0x79
  1001f4:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        : 
        : "i"(T_SWITCH_TOK)
    );
}
  1001f6:	90                   	nop
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001f9:	f3 0f 1e fb          	endbr32 
  1001fd:	55                   	push   %ebp
  1001fe:	89 e5                	mov    %esp,%ebp
  100200:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100203:	e8 11 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100208:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  10020f:	e8 7f 00 00 00       	call   100293 <cprintf>
    lab1_switch_to_user();
  100214:	e8 c2 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  100219:	e8 fb fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021e:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  100225:	e8 69 00 00 00       	call   100293 <cprintf>
    lab1_switch_to_kernel();
  10022a:	e8 bc ff ff ff       	call   1001eb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022f:	e8 e5 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100234:	90                   	nop
  100235:	c9                   	leave  
  100236:	c3                   	ret    

00100237 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100237:	f3 0f 1e fb          	endbr32 
  10023b:	55                   	push   %ebp
  10023c:	89 e5                	mov    %esp,%ebp
  10023e:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100241:	8b 45 08             	mov    0x8(%ebp),%eax
  100244:	89 04 24             	mov    %eax,(%esp)
  100247:	e8 1a 14 00 00       	call   101666 <cons_putc>
    (*cnt) ++;
  10024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024f:	8b 00                	mov    (%eax),%eax
  100251:	8d 50 01             	lea    0x1(%eax),%edx
  100254:	8b 45 0c             	mov    0xc(%ebp),%eax
  100257:	89 10                	mov    %edx,(%eax)
}
  100259:	90                   	nop
  10025a:	c9                   	leave  
  10025b:	c3                   	ret    

0010025c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025c:	f3 0f 1e fb          	endbr32 
  100260:	55                   	push   %ebp
  100261:	89 e5                	mov    %esp,%ebp
  100263:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100270:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100274:	8b 45 08             	mov    0x8(%ebp),%eax
  100277:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100282:	c7 04 24 37 02 10 00 	movl   $0x100237,(%esp)
  100289:	e8 20 30 00 00       	call   1032ae <vprintfmt>
    return cnt;
  10028e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100291:	c9                   	leave  
  100292:	c3                   	ret    

00100293 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100293:	f3 0f 1e fb          	endbr32 
  100297:	55                   	push   %ebp
  100298:	89 e5                	mov    %esp,%ebp
  10029a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029d:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ad:	89 04 24             	mov    %eax,(%esp)
  1002b0:	e8 a7 ff ff ff       	call   10025c <vcprintf>
  1002b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bb:	c9                   	leave  
  1002bc:	c3                   	ret    

001002bd <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002bd:	f3 0f 1e fb          	endbr32 
  1002c1:	55                   	push   %ebp
  1002c2:	89 e5                	mov    %esp,%ebp
  1002c4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	89 04 24             	mov    %eax,(%esp)
  1002cd:	e8 94 13 00 00       	call   101666 <cons_putc>
}
  1002d2:	90                   	nop
  1002d3:	c9                   	leave  
  1002d4:	c3                   	ret    

001002d5 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d5:	f3 0f 1e fb          	endbr32 
  1002d9:	55                   	push   %ebp
  1002da:	89 e5                	mov    %esp,%ebp
  1002dc:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e6:	eb 13                	jmp    1002fb <cputs+0x26>
        cputch(c, &cnt);
  1002e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f3:	89 04 24             	mov    %eax,(%esp)
  1002f6:	e8 3c ff ff ff       	call   100237 <cputch>
    while ((c = *str ++) != '\0') {
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	8d 50 01             	lea    0x1(%eax),%edx
  100301:	89 55 08             	mov    %edx,0x8(%ebp)
  100304:	0f b6 00             	movzbl (%eax),%eax
  100307:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030e:	75 d8                	jne    1002e8 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100310:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100313:	89 44 24 04          	mov    %eax,0x4(%esp)
  100317:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031e:	e8 14 ff ff ff       	call   100237 <cputch>
    return cnt;
  100323:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100326:	c9                   	leave  
  100327:	c3                   	ret    

00100328 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100328:	f3 0f 1e fb          	endbr32 
  10032c:	55                   	push   %ebp
  10032d:	89 e5                	mov    %esp,%ebp
  10032f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100332:	90                   	nop
  100333:	e8 5c 13 00 00       	call   101694 <cons_getc>
  100338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10033f:	74 f2                	je     100333 <getchar+0xb>
        /* do nothing */;
    return c;
  100341:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100344:	c9                   	leave  
  100345:	c3                   	ret    

00100346 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100346:	f3 0f 1e fb          	endbr32 
  10034a:	55                   	push   %ebp
  10034b:	89 e5                	mov    %esp,%ebp
  10034d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100350:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100354:	74 13                	je     100369 <readline+0x23>
        cprintf("%s", prompt);
  100356:	8b 45 08             	mov    0x8(%ebp),%eax
  100359:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035d:	c7 04 24 27 38 10 00 	movl   $0x103827,(%esp)
  100364:	e8 2a ff ff ff       	call   100293 <cprintf>
    }
    int i = 0, c;
  100369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100370:	e8 b3 ff ff ff       	call   100328 <getchar>
  100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100378:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037c:	79 07                	jns    100385 <readline+0x3f>
            return NULL;
  10037e:	b8 00 00 00 00       	mov    $0x0,%eax
  100383:	eb 78                	jmp    1003fd <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100385:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100389:	7e 28                	jle    1003b3 <readline+0x6d>
  10038b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100392:	7f 1f                	jg     1003b3 <readline+0x6d>
            cputchar(c);
  100394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100397:	89 04 24             	mov    %eax,(%esp)
  10039a:	e8 1e ff ff ff       	call   1002bd <cputchar>
            buf[i ++] = c;
  10039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a2:	8d 50 01             	lea    0x1(%eax),%edx
  1003a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ab:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  1003b1:	eb 45                	jmp    1003f8 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b7:	75 16                	jne    1003cf <readline+0x89>
  1003b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003bd:	7e 10                	jle    1003cf <readline+0x89>
            cputchar(c);
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c2:	89 04 24             	mov    %eax,(%esp)
  1003c5:	e8 f3 fe ff ff       	call   1002bd <cputchar>
            i --;
  1003ca:	ff 4d f4             	decl   -0xc(%ebp)
  1003cd:	eb 29                	jmp    1003f8 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003cf:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d3:	74 06                	je     1003db <readline+0x95>
  1003d5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003d9:	75 95                	jne    100370 <readline+0x2a>
            cputchar(c);
  1003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003de:	89 04 24             	mov    %eax,(%esp)
  1003e1:	e8 d7 fe ff ff       	call   1002bd <cputchar>
            buf[i] = '\0';
  1003e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e9:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003ee:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f1:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003f6:	eb 05                	jmp    1003fd <readline+0xb7>
        c = getchar();
  1003f8:	e9 73 ff ff ff       	jmp    100370 <readline+0x2a>
        }
    }
}
  1003fd:	c9                   	leave  
  1003fe:	c3                   	ret    

001003ff <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003ff:	f3 0f 1e fb          	endbr32 
  100403:	55                   	push   %ebp
  100404:	89 e5                	mov    %esp,%ebp
  100406:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100409:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  10040e:	85 c0                	test   %eax,%eax
  100410:	75 5b                	jne    10046d <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100412:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100419:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041c:	8d 45 14             	lea    0x14(%ebp),%eax
  10041f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100422:	8b 45 0c             	mov    0xc(%ebp),%eax
  100425:	89 44 24 08          	mov    %eax,0x8(%esp)
  100429:	8b 45 08             	mov    0x8(%ebp),%eax
  10042c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100430:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  100437:	e8 57 fe ff ff       	call   100293 <cprintf>
    vcprintf(fmt, ap);
  10043c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10043f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100443:	8b 45 10             	mov    0x10(%ebp),%eax
  100446:	89 04 24             	mov    %eax,(%esp)
  100449:	e8 0e fe ff ff       	call   10025c <vcprintf>
    cprintf("\n");
  10044e:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100455:	e8 39 fe ff ff       	call   100293 <cprintf>
    
    cprintf("stack trackback:\n");
  10045a:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100461:	e8 2d fe ff ff       	call   100293 <cprintf>
    print_stackframe();
  100466:	e8 3d 06 00 00       	call   100aa8 <print_stackframe>
  10046b:	eb 01                	jmp    10046e <__panic+0x6f>
        goto panic_dead;
  10046d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046e:	e8 6f 14 00 00       	call   1018e2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100473:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047a:	e8 4c 08 00 00       	call   100ccb <kmonitor>
  10047f:	eb f2                	jmp    100473 <__panic+0x74>

00100481 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100481:	f3 0f 1e fb          	endbr32 
  100485:	55                   	push   %ebp
  100486:	89 e5                	mov    %esp,%ebp
  100488:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048b:	8d 45 14             	lea    0x14(%ebp),%eax
  10048e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100491:	8b 45 0c             	mov    0xc(%ebp),%eax
  100494:	89 44 24 08          	mov    %eax,0x8(%esp)
  100498:	8b 45 08             	mov    0x8(%ebp),%eax
  10049b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10049f:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  1004a6:	e8 e8 fd ff ff       	call   100293 <cprintf>
    vcprintf(fmt, ap);
  1004ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b5:	89 04 24             	mov    %eax,(%esp)
  1004b8:	e8 9f fd ff ff       	call   10025c <vcprintf>
    cprintf("\n");
  1004bd:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  1004c4:	e8 ca fd ff ff       	call   100293 <cprintf>
    va_end(ap);
}
  1004c9:	90                   	nop
  1004ca:	c9                   	leave  
  1004cb:	c3                   	ret    

001004cc <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cc:	f3 0f 1e fb          	endbr32 
  1004d0:	55                   	push   %ebp
  1004d1:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d3:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  1004d8:	5d                   	pop    %ebp
  1004d9:	c3                   	ret    

001004da <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004da:	f3 0f 1e fb          	endbr32 
  1004de:	55                   	push   %ebp
  1004df:	89 e5                	mov    %esp,%ebp
  1004e1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e7:	8b 00                	mov    (%eax),%eax
  1004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ef:	8b 00                	mov    (%eax),%eax
  1004f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fb:	e9 ca 00 00 00       	jmp    1005ca <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100500:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	89 c2                	mov    %eax,%edx
  10050a:	c1 ea 1f             	shr    $0x1f,%edx
  10050d:	01 d0                	add    %edx,%eax
  10050f:	d1 f8                	sar    %eax
  100511:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100517:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051a:	eb 03                	jmp    10051f <stab_binsearch+0x45>
            m --;
  10051c:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100522:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100525:	7c 1f                	jl     100546 <stab_binsearch+0x6c>
  100527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052a:	89 d0                	mov    %edx,%eax
  10052c:	01 c0                	add    %eax,%eax
  10052e:	01 d0                	add    %edx,%eax
  100530:	c1 e0 02             	shl    $0x2,%eax
  100533:	89 c2                	mov    %eax,%edx
  100535:	8b 45 08             	mov    0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053e:	0f b6 c0             	movzbl %al,%eax
  100541:	39 45 14             	cmp    %eax,0x14(%ebp)
  100544:	75 d6                	jne    10051c <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054c:	7d 09                	jge    100557 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100551:	40                   	inc    %eax
  100552:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100555:	eb 73                	jmp    1005ca <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100557:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100561:	89 d0                	mov    %edx,%eax
  100563:	01 c0                	add    %eax,%eax
  100565:	01 d0                	add    %edx,%eax
  100567:	c1 e0 02             	shl    $0x2,%eax
  10056a:	89 c2                	mov    %eax,%edx
  10056c:	8b 45 08             	mov    0x8(%ebp),%eax
  10056f:	01 d0                	add    %edx,%eax
  100571:	8b 40 08             	mov    0x8(%eax),%eax
  100574:	39 45 18             	cmp    %eax,0x18(%ebp)
  100577:	76 11                	jbe    10058a <stab_binsearch+0xb0>
            *region_left = m;
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100584:	40                   	inc    %eax
  100585:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100588:	eb 40                	jmp    1005ca <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058d:	89 d0                	mov    %edx,%eax
  10058f:	01 c0                	add    %eax,%eax
  100591:	01 d0                	add    %edx,%eax
  100593:	c1 e0 02             	shl    $0x2,%eax
  100596:	89 c2                	mov    %eax,%edx
  100598:	8b 45 08             	mov    0x8(%ebp),%eax
  10059b:	01 d0                	add    %edx,%eax
  10059d:	8b 40 08             	mov    0x8(%eax),%eax
  1005a0:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a3:	73 14                	jae    1005b9 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ae:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b3:	48                   	dec    %eax
  1005b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b7:	eb 11                	jmp    1005ca <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bf:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c7:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d0:	0f 8e 2a ff ff ff    	jle    100500 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005da:	75 0f                	jne    1005eb <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	8b 00                	mov    (%eax),%eax
  1005e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e7:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005e9:	eb 3e                	jmp    100629 <stab_binsearch+0x14f>
        l = *region_right;
  1005eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ee:	8b 00                	mov    (%eax),%eax
  1005f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f3:	eb 03                	jmp    1005f8 <stab_binsearch+0x11e>
  1005f5:	ff 4d fc             	decl   -0x4(%ebp)
  1005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fb:	8b 00                	mov    (%eax),%eax
  1005fd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100600:	7e 1f                	jle    100621 <stab_binsearch+0x147>
  100602:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100605:	89 d0                	mov    %edx,%eax
  100607:	01 c0                	add    %eax,%eax
  100609:	01 d0                	add    %edx,%eax
  10060b:	c1 e0 02             	shl    $0x2,%eax
  10060e:	89 c2                	mov    %eax,%edx
  100610:	8b 45 08             	mov    0x8(%ebp),%eax
  100613:	01 d0                	add    %edx,%eax
  100615:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100619:	0f b6 c0             	movzbl %al,%eax
  10061c:	39 45 14             	cmp    %eax,0x14(%ebp)
  10061f:	75 d4                	jne    1005f5 <stab_binsearch+0x11b>
        *region_left = l;
  100621:	8b 45 0c             	mov    0xc(%ebp),%eax
  100624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100627:	89 10                	mov    %edx,(%eax)
}
  100629:	90                   	nop
  10062a:	c9                   	leave  
  10062b:	c3                   	ret    

0010062c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062c:	f3 0f 1e fb          	endbr32 
  100630:	55                   	push   %ebp
  100631:	89 e5                	mov    %esp,%ebp
  100633:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100636:	8b 45 0c             	mov    0xc(%ebp),%eax
  100639:	c7 00 78 38 10 00    	movl   $0x103878,(%eax)
    info->eip_line = 0;
  10063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100649:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064c:	c7 40 08 78 38 10 00 	movl   $0x103878,0x8(%eax)
    info->eip_fn_namelen = 9;
  100653:	8b 45 0c             	mov    0xc(%ebp),%eax
  100656:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100660:	8b 55 08             	mov    0x8(%ebp),%edx
  100663:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100670:	c7 45 f4 cc 40 10 00 	movl   $0x1040cc,-0xc(%ebp)
    stab_end = __STAB_END__;
  100677:	c7 45 f0 e0 ce 10 00 	movl   $0x10cee0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067e:	c7 45 ec e1 ce 10 00 	movl   $0x10cee1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100685:	c7 45 e8 ed ef 10 00 	movl   $0x10efed,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10068f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100692:	76 0b                	jbe    10069f <debuginfo_eip+0x73>
  100694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100697:	48                   	dec    %eax
  100698:	0f b6 00             	movzbl (%eax),%eax
  10069b:	84 c0                	test   %al,%al
  10069d:	74 0a                	je     1006a9 <debuginfo_eip+0x7d>
        return -1;
  10069f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a4:	e9 ab 02 00 00       	jmp    100954 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b6:	c1 f8 02             	sar    $0x2,%eax
  1006b9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006bf:	48                   	dec    %eax
  1006c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ca:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d1:	00 
  1006d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	89 04 24             	mov    %eax,(%esp)
  1006e6:	e8 ef fd ff ff       	call   1004da <stab_binsearch>
    if (lfile == 0)
  1006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ee:	85 c0                	test   %eax,%eax
  1006f0:	75 0a                	jne    1006fc <debuginfo_eip+0xd0>
        return -1;
  1006f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f7:	e9 58 02 00 00       	jmp    100954 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100705:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100716:	00 
  100717:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 aa fd ff ff       	call   1004da <stab_binsearch>

    if (lfun <= rfun) {
  100730:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100733:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 78                	jg     1007b2 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	8b 10                	mov    (%eax),%edx
  100751:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100754:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100757:	39 c2                	cmp    %eax,%edx
  100759:	73 22                	jae    10077d <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	89 d0                	mov    %edx,%eax
  100762:	01 c0                	add    %eax,%eax
  100764:	01 d0                	add    %edx,%eax
  100766:	c1 e0 02             	shl    $0x2,%eax
  100769:	89 c2                	mov    %eax,%edx
  10076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	8b 10                	mov    (%eax),%edx
  100772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100775:	01 c2                	add    %eax,%edx
  100777:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100780:	89 c2                	mov    %eax,%edx
  100782:	89 d0                	mov    %edx,%eax
  100784:	01 c0                	add    %eax,%eax
  100786:	01 d0                	add    %edx,%eax
  100788:	c1 e0 02             	shl    $0x2,%eax
  10078b:	89 c2                	mov    %eax,%edx
  10078d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100790:	01 d0                	add    %edx,%eax
  100792:	8b 50 08             	mov    0x8(%eax),%edx
  100795:	8b 45 0c             	mov    0xc(%ebp),%eax
  100798:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079e:	8b 40 10             	mov    0x10(%eax),%eax
  1007a1:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b0:	eb 15                	jmp    1007c7 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d4:	00 
  1007d5:	89 04 24             	mov    %eax,(%esp)
  1007d8:	e8 d9 25 00 00       	call   102db6 <strfind>
  1007dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e0:	8b 52 08             	mov    0x8(%edx),%edx
  1007e3:	29 d0                	sub    %edx,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ea:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f4:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fb:	00 
  1007fc:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  100803:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100806:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080d:	89 04 24             	mov    %eax,(%esp)
  100810:	e8 c5 fc ff ff       	call   1004da <stab_binsearch>
    if (lline <= rline) {
  100815:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100818:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7f 23                	jg     100842 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  10081f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100822:	89 c2                	mov    %eax,%edx
  100824:	89 d0                	mov    %edx,%eax
  100826:	01 c0                	add    %eax,%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	c1 e0 02             	shl    $0x2,%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100832:	01 d0                	add    %edx,%eax
  100834:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100840:	eb 11                	jmp    100853 <debuginfo_eip+0x227>
        return -1;
  100842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100847:	e9 08 01 00 00       	jmp    100954 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	48                   	dec    %eax
  100850:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100859:	39 c2                	cmp    %eax,%edx
  10085b:	7c 56                	jl     1008b3 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100860:	89 c2                	mov    %eax,%edx
  100862:	89 d0                	mov    %edx,%eax
  100864:	01 c0                	add    %eax,%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	c1 e0 02             	shl    $0x2,%eax
  10086b:	89 c2                	mov    %eax,%edx
  10086d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100870:	01 d0                	add    %edx,%eax
  100872:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100876:	3c 84                	cmp    $0x84,%al
  100878:	74 39                	je     1008b3 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087d:	89 c2                	mov    %eax,%edx
  10087f:	89 d0                	mov    %edx,%eax
  100881:	01 c0                	add    %eax,%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	c1 e0 02             	shl    $0x2,%eax
  100888:	89 c2                	mov    %eax,%edx
  10088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088d:	01 d0                	add    %edx,%eax
  10088f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100893:	3c 64                	cmp    $0x64,%al
  100895:	75 b5                	jne    10084c <debuginfo_eip+0x220>
  100897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089a:	89 c2                	mov    %eax,%edx
  10089c:	89 d0                	mov    %edx,%eax
  10089e:	01 c0                	add    %eax,%eax
  1008a0:	01 d0                	add    %edx,%eax
  1008a2:	c1 e0 02             	shl    $0x2,%eax
  1008a5:	89 c2                	mov    %eax,%edx
  1008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	8b 40 08             	mov    0x8(%eax),%eax
  1008af:	85 c0                	test   %eax,%eax
  1008b1:	74 99                	je     10084c <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008b9:	39 c2                	cmp    %eax,%edx
  1008bb:	7c 42                	jl     1008ff <debuginfo_eip+0x2d3>
  1008bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c0:	89 c2                	mov    %eax,%edx
  1008c2:	89 d0                	mov    %edx,%eax
  1008c4:	01 c0                	add    %eax,%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	c1 e0 02             	shl    $0x2,%eax
  1008cb:	89 c2                	mov    %eax,%edx
  1008cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d0:	01 d0                	add    %edx,%eax
  1008d2:	8b 10                	mov    (%eax),%edx
  1008d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008da:	39 c2                	cmp    %eax,%edx
  1008dc:	73 21                	jae    1008ff <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e1:	89 c2                	mov    %eax,%edx
  1008e3:	89 d0                	mov    %edx,%eax
  1008e5:	01 c0                	add    %eax,%eax
  1008e7:	01 d0                	add    %edx,%eax
  1008e9:	c1 e0 02             	shl    $0x2,%eax
  1008ec:	89 c2                	mov    %eax,%edx
  1008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f1:	01 d0                	add    %edx,%eax
  1008f3:	8b 10                	mov    (%eax),%edx
  1008f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f8:	01 c2                	add    %eax,%edx
  1008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fd:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100902:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100905:	39 c2                	cmp    %eax,%edx
  100907:	7d 46                	jge    10094f <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100909:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090c:	40                   	inc    %eax
  10090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100910:	eb 16                	jmp    100928 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100912:	8b 45 0c             	mov    0xc(%ebp),%eax
  100915:	8b 40 14             	mov    0x14(%eax),%eax
  100918:	8d 50 01             	lea    0x1(%eax),%edx
  10091b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100921:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100924:	40                   	inc    %eax
  100925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100928:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092b:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092e:	39 c2                	cmp    %eax,%edx
  100930:	7d 1d                	jge    10094f <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100932:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100935:	89 c2                	mov    %eax,%edx
  100937:	89 d0                	mov    %edx,%eax
  100939:	01 c0                	add    %eax,%eax
  10093b:	01 d0                	add    %edx,%eax
  10093d:	c1 e0 02             	shl    $0x2,%eax
  100940:	89 c2                	mov    %eax,%edx
  100942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100945:	01 d0                	add    %edx,%eax
  100947:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094b:	3c a0                	cmp    $0xa0,%al
  10094d:	74 c3                	je     100912 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  10094f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100954:	c9                   	leave  
  100955:	c3                   	ret    

00100956 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100956:	f3 0f 1e fb          	endbr32 
  10095a:	55                   	push   %ebp
  10095b:	89 e5                	mov    %esp,%ebp
  10095d:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100960:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100967:	e8 27 f9 ff ff       	call   100293 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096c:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100973:	00 
  100974:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  10097b:	e8 13 f9 ff ff       	call   100293 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100980:	c7 44 24 04 66 37 10 	movl   $0x103766,0x4(%esp)
  100987:	00 
  100988:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  10098f:	e8 ff f8 ff ff       	call   100293 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100994:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  10099b:	00 
  10099c:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  1009a3:	e8 eb f8 ff ff       	call   100293 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a8:	c7 44 24 04 80 0d 11 	movl   $0x110d80,0x4(%esp)
  1009af:	00 
  1009b0:	c7 04 24 e3 38 10 00 	movl   $0x1038e3,(%esp)
  1009b7:	e8 d7 f8 ff ff       	call   100293 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bc:	b8 80 0d 11 00       	mov    $0x110d80,%eax
  1009c1:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c6:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cb:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d1:	85 c0                	test   %eax,%eax
  1009d3:	0f 48 c2             	cmovs  %edx,%eax
  1009d6:	c1 f8 0a             	sar    $0xa,%eax
  1009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009dd:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  1009e4:	e8 aa f8 ff ff       	call   100293 <cprintf>
}
  1009e9:	90                   	nop
  1009ea:	c9                   	leave  
  1009eb:	c3                   	ret    

001009ec <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ec:	f3 0f 1e fb          	endbr32 
  1009f0:	55                   	push   %ebp
  1009f1:	89 e5                	mov    %esp,%ebp
  1009f3:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a00:	8b 45 08             	mov    0x8(%ebp),%eax
  100a03:	89 04 24             	mov    %eax,(%esp)
  100a06:	e8 21 fc ff ff       	call   10062c <debuginfo_eip>
  100a0b:	85 c0                	test   %eax,%eax
  100a0d:	74 15                	je     100a24 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a16:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100a1d:	e8 71 f8 ff ff       	call   100293 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a22:	eb 6c                	jmp    100a90 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2b:	eb 1b                	jmp    100a48 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a33:	01 d0                	add    %edx,%eax
  100a35:	0f b6 10             	movzbl (%eax),%edx
  100a38:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a41:	01 c8                	add    %ecx,%eax
  100a43:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a45:	ff 45 f4             	incl   -0xc(%ebp)
  100a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4e:	7c dd                	jl     100a2d <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a50:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a59:	01 d0                	add    %edx,%eax
  100a5b:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a61:	8b 55 08             	mov    0x8(%ebp),%edx
  100a64:	89 d1                	mov    %edx,%ecx
  100a66:	29 c1                	sub    %eax,%ecx
  100a68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a72:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a78:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a84:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100a8b:	e8 03 f8 ff ff       	call   100293 <cprintf>
}
  100a90:	90                   	nop
  100a91:	c9                   	leave  
  100a92:	c3                   	ret    

00100a93 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a93:	f3 0f 1e fb          	endbr32 
  100a97:	55                   	push   %ebp
  100a98:	89 e5                	mov    %esp,%ebp
  100a9a:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9d:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa6:	c9                   	leave  
  100aa7:	c3                   	ret    

00100aa8 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa8:	f3 0f 1e fb          	endbr32 
  100aac:	55                   	push   %ebp
  100aad:	89 e5                	mov    %esp,%ebp
  100aaf:	53                   	push   %ebx
  100ab0:	83 ec 34             	sub    $0x34,%esp
    首先通过函数读取ebp、eip寄存器值，分别表示指向栈底的地址、当前指令的地址；
    ss:[ebp + 8]为函数第一个参数地址，ss:[ebp + 12]为第二个参数地址；
    ss:[ebp]处为上一级函数的ebp地址，ss:[ebp+4]为返回地址；
    可通过指针索引的方式访问指针所指内容
    */
    uint32_t *ebp = 0;                  
  100ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32_t esp = 0;                   
  100aba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ac1:	89 e8                	mov    %ebp,%eax
  100ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax

    ebp = (uint32_t *)read_ebp();           //函数读取ebp、eip寄存器值
  100ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    esp = read_eip();                       //
  100acc:	e8 c2 ff ff ff       	call   100a93 <read_eip>
  100ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp)                             //当栈底元素不为空的时候,迭代打印
  100ad4:	eb 73                	jmp    100b49 <print_stackframe+0xa1>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
  100ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100adc:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae4:	c7 04 24 54 39 10 00 	movl   $0x103954,(%esp)
  100aeb:	e8 a3 f7 ff ff       	call   100293 <cprintf>
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
  100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af3:	83 c0 14             	add    $0x14,%eax
  100af6:	8b 18                	mov    (%eax),%ebx
  100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afb:	83 c0 10             	add    $0x10,%eax
  100afe:	8b 08                	mov    (%eax),%ecx
  100b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b03:	83 c0 0c             	add    $0xc,%eax
  100b06:	8b 10                	mov    (%eax),%edx
  100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0b:	83 c0 08             	add    $0x8,%eax
  100b0e:	8b 00                	mov    (%eax),%eax
  100b10:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b14:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b18:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b20:	c7 04 24 70 39 10 00 	movl   $0x103970,(%esp)
  100b27:	e8 67 f7 ff ff       	call   100293 <cprintf>

        print_debuginfo(esp - 1);
  100b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b2f:	48                   	dec    %eax
  100b30:	89 04 24             	mov    %eax,(%esp)
  100b33:	e8 b4 fe ff ff       	call   1009ec <print_debuginfo>

        esp = ebp[1];                       //迭代,将ebp[1]-----> esp, *[*ebp]指向下一个地址,将它赋值给ebp
  100b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b3b:	8b 40 04             	mov    0x4(%eax),%eax
  100b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = (uint32_t *)*ebp;
  100b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b44:	8b 00                	mov    (%eax),%eax
  100b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (ebp)                             //当栈底元素不为空的时候,迭代打印
  100b49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b4d:	75 87                	jne    100ad6 <print_stackframe+0x2e>
    }
}
  100b4f:	90                   	nop
  100b50:	90                   	nop
  100b51:	83 c4 34             	add    $0x34,%esp
  100b54:	5b                   	pop    %ebx
  100b55:	5d                   	pop    %ebp
  100b56:	c3                   	ret    

00100b57 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b57:	f3 0f 1e fb          	endbr32 
  100b5b:	55                   	push   %ebp
  100b5c:	89 e5                	mov    %esp,%ebp
  100b5e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b68:	eb 0c                	jmp    100b76 <parse+0x1f>
            *buf ++ = '\0';
  100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6d:	8d 50 01             	lea    0x1(%eax),%edx
  100b70:	89 55 08             	mov    %edx,0x8(%ebp)
  100b73:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b76:	8b 45 08             	mov    0x8(%ebp),%eax
  100b79:	0f b6 00             	movzbl (%eax),%eax
  100b7c:	84 c0                	test   %al,%al
  100b7e:	74 1d                	je     100b9d <parse+0x46>
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	0f be c0             	movsbl %al,%eax
  100b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8d:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  100b94:	e8 e7 21 00 00       	call   102d80 <strchr>
  100b99:	85 c0                	test   %eax,%eax
  100b9b:	75 cd                	jne    100b6a <parse+0x13>
        }
        if (*buf == '\0') {
  100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba0:	0f b6 00             	movzbl (%eax),%eax
  100ba3:	84 c0                	test   %al,%al
  100ba5:	74 65                	je     100c0c <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ba7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bab:	75 14                	jne    100bc1 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bad:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bb4:	00 
  100bb5:	c7 04 24 15 3a 10 00 	movl   $0x103a15,(%esp)
  100bbc:	e8 d2 f6 ff ff       	call   100293 <cprintf>
        }
        argv[argc ++] = buf;
  100bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc4:	8d 50 01             	lea    0x1(%eax),%edx
  100bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bd4:	01 c2                	add    %eax,%edx
  100bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bdb:	eb 03                	jmp    100be0 <parse+0x89>
            buf ++;
  100bdd:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100be0:	8b 45 08             	mov    0x8(%ebp),%eax
  100be3:	0f b6 00             	movzbl (%eax),%eax
  100be6:	84 c0                	test   %al,%al
  100be8:	74 8c                	je     100b76 <parse+0x1f>
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	0f b6 00             	movzbl (%eax),%eax
  100bf0:	0f be c0             	movsbl %al,%eax
  100bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf7:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  100bfe:	e8 7d 21 00 00       	call   102d80 <strchr>
  100c03:	85 c0                	test   %eax,%eax
  100c05:	74 d6                	je     100bdd <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c07:	e9 6a ff ff ff       	jmp    100b76 <parse+0x1f>
            break;
  100c0c:	90                   	nop
        }
    }
    return argc;
  100c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c10:	c9                   	leave  
  100c11:	c3                   	ret    

00100c12 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c12:	f3 0f 1e fb          	endbr32 
  100c16:	55                   	push   %ebp
  100c17:	89 e5                	mov    %esp,%ebp
  100c19:	53                   	push   %ebx
  100c1a:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c1d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c24:	8b 45 08             	mov    0x8(%ebp),%eax
  100c27:	89 04 24             	mov    %eax,(%esp)
  100c2a:	e8 28 ff ff ff       	call   100b57 <parse>
  100c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c36:	75 0a                	jne    100c42 <runcmd+0x30>
        return 0;
  100c38:	b8 00 00 00 00       	mov    $0x0,%eax
  100c3d:	e9 83 00 00 00       	jmp    100cc5 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c49:	eb 5a                	jmp    100ca5 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c4b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c51:	89 d0                	mov    %edx,%eax
  100c53:	01 c0                	add    %eax,%eax
  100c55:	01 d0                	add    %edx,%eax
  100c57:	c1 e0 02             	shl    $0x2,%eax
  100c5a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c5f:	8b 00                	mov    (%eax),%eax
  100c61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c65:	89 04 24             	mov    %eax,(%esp)
  100c68:	e8 6f 20 00 00       	call   102cdc <strcmp>
  100c6d:	85 c0                	test   %eax,%eax
  100c6f:	75 31                	jne    100ca2 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c74:	89 d0                	mov    %edx,%eax
  100c76:	01 c0                	add    %eax,%eax
  100c78:	01 d0                	add    %edx,%eax
  100c7a:	c1 e0 02             	shl    $0x2,%eax
  100c7d:	05 08 f0 10 00       	add    $0x10f008,%eax
  100c82:	8b 10                	mov    (%eax),%edx
  100c84:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c87:	83 c0 04             	add    $0x4,%eax
  100c8a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c8d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9b:	89 1c 24             	mov    %ebx,(%esp)
  100c9e:	ff d2                	call   *%edx
  100ca0:	eb 23                	jmp    100cc5 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca2:	ff 45 f4             	incl   -0xc(%ebp)
  100ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca8:	83 f8 02             	cmp    $0x2,%eax
  100cab:	76 9e                	jbe    100c4b <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb4:	c7 04 24 33 3a 10 00 	movl   $0x103a33,(%esp)
  100cbb:	e8 d3 f5 ff ff       	call   100293 <cprintf>
    return 0;
  100cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc5:	83 c4 64             	add    $0x64,%esp
  100cc8:	5b                   	pop    %ebx
  100cc9:	5d                   	pop    %ebp
  100cca:	c3                   	ret    

00100ccb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ccb:	f3 0f 1e fb          	endbr32 
  100ccf:	55                   	push   %ebp
  100cd0:	89 e5                	mov    %esp,%ebp
  100cd2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cd5:	c7 04 24 4c 3a 10 00 	movl   $0x103a4c,(%esp)
  100cdc:	e8 b2 f5 ff ff       	call   100293 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ce1:	c7 04 24 74 3a 10 00 	movl   $0x103a74,(%esp)
  100ce8:	e8 a6 f5 ff ff       	call   100293 <cprintf>

    if (tf != NULL) {
  100ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cf1:	74 0b                	je     100cfe <kmonitor+0x33>
        print_trapframe(tf);
  100cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf6:	89 04 24             	mov    %eax,(%esp)
  100cf9:	e8 fb 0d 00 00       	call   101af9 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cfe:	c7 04 24 99 3a 10 00 	movl   $0x103a99,(%esp)
  100d05:	e8 3c f6 ff ff       	call   100346 <readline>
  100d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d11:	74 eb                	je     100cfe <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d13:	8b 45 08             	mov    0x8(%ebp),%eax
  100d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d1d:	89 04 24             	mov    %eax,(%esp)
  100d20:	e8 ed fe ff ff       	call   100c12 <runcmd>
  100d25:	85 c0                	test   %eax,%eax
  100d27:	78 02                	js     100d2b <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d29:	eb d3                	jmp    100cfe <kmonitor+0x33>
                break;
  100d2b:	90                   	nop
            }
        }
    }
}
  100d2c:	90                   	nop
  100d2d:	c9                   	leave  
  100d2e:	c3                   	ret    

00100d2f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d2f:	f3 0f 1e fb          	endbr32 
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
  100d36:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d40:	eb 3d                	jmp    100d7f <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d45:	89 d0                	mov    %edx,%eax
  100d47:	01 c0                	add    %eax,%eax
  100d49:	01 d0                	add    %edx,%eax
  100d4b:	c1 e0 02             	shl    $0x2,%eax
  100d4e:	05 04 f0 10 00       	add    $0x10f004,%eax
  100d53:	8b 08                	mov    (%eax),%ecx
  100d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d58:	89 d0                	mov    %edx,%eax
  100d5a:	01 c0                	add    %eax,%eax
  100d5c:	01 d0                	add    %edx,%eax
  100d5e:	c1 e0 02             	shl    $0x2,%eax
  100d61:	05 00 f0 10 00       	add    $0x10f000,%eax
  100d66:	8b 00                	mov    (%eax),%eax
  100d68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d70:	c7 04 24 9d 3a 10 00 	movl   $0x103a9d,(%esp)
  100d77:	e8 17 f5 ff ff       	call   100293 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d7c:	ff 45 f4             	incl   -0xc(%ebp)
  100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d82:	83 f8 02             	cmp    $0x2,%eax
  100d85:	76 bb                	jbe    100d42 <mon_help+0x13>
    }
    return 0;
  100d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d8c:	c9                   	leave  
  100d8d:	c3                   	ret    

00100d8e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d8e:	f3 0f 1e fb          	endbr32 
  100d92:	55                   	push   %ebp
  100d93:	89 e5                	mov    %esp,%ebp
  100d95:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d98:	e8 b9 fb ff ff       	call   100956 <print_kerninfo>
    return 0;
  100d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da2:	c9                   	leave  
  100da3:	c3                   	ret    

00100da4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100da4:	f3 0f 1e fb          	endbr32 
  100da8:	55                   	push   %ebp
  100da9:	89 e5                	mov    %esp,%ebp
  100dab:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dae:	e8 f5 fc ff ff       	call   100aa8 <print_stackframe>
    return 0;
  100db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db8:	c9                   	leave  
  100db9:	c3                   	ret    

00100dba <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dba:	f3 0f 1e fb          	endbr32 
  100dbe:	55                   	push   %ebp
  100dbf:	89 e5                	mov    %esp,%ebp
  100dc1:	83 ec 28             	sub    $0x28,%esp
  100dc4:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dca:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd6:	ee                   	out    %al,(%dx)
}
  100dd7:	90                   	nop
  100dd8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dde:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dea:	ee                   	out    %al,(%dx)
}
  100deb:	90                   	nop
  100dec:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100df2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dfa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dfe:	ee                   	out    %al,(%dx)
}
  100dff:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e00:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100e07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e0a:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  100e11:	e8 7d f4 ff ff       	call   100293 <cprintf>
    pic_enable(IRQ_TIMER);
  100e16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e1d:	e8 31 09 00 00       	call   101753 <pic_enable>
}
  100e22:	90                   	nop
  100e23:	c9                   	leave  
  100e24:	c3                   	ret    

00100e25 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e25:	f3 0f 1e fb          	endbr32 
  100e29:	55                   	push   %ebp
  100e2a:	89 e5                	mov    %esp,%ebp
  100e2c:	83 ec 10             	sub    $0x10,%esp
  100e2f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e35:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e3f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e45:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e49:	89 c2                	mov    %eax,%edx
  100e4b:	ec                   	in     (%dx),%al
  100e4c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e59:	89 c2                	mov    %eax,%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e5f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e65:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	ec                   	in     (%dx),%al
  100e6c:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6f:	90                   	nop
  100e70:	c9                   	leave  
  100e71:	c3                   	ret    

00100e72 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e72:	f3 0f 1e fb          	endbr32 
  100e76:	55                   	push   %ebp
  100e77:	89 e5                	mov    %esp,%ebp
  100e79:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e7c:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	0f b7 00             	movzwl (%eax),%eax
  100e89:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e90:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e98:	0f b7 00             	movzwl (%eax),%eax
  100e9b:	0f b7 c0             	movzwl %ax,%eax
  100e9e:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ea3:	74 12                	je     100eb7 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ea5:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100eac:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100eb3:	b4 03 
  100eb5:	eb 13                	jmp    100eca <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eba:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ebe:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ec1:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100ec8:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100eca:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ed5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100edd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ee1:	ee                   	out    %al,(%dx)
}
  100ee2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ee3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eea:	40                   	inc    %eax
  100eeb:	0f b7 c0             	movzwl %ax,%eax
  100eee:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ef6:	89 c2                	mov    %eax,%edx
  100ef8:	ec                   	in     (%dx),%al
  100ef9:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100efc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f00:	0f b6 c0             	movzbl %al,%eax
  100f03:	c1 e0 08             	shl    $0x8,%eax
  100f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f09:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f10:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f14:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f18:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
}
  100f21:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f22:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f29:	40                   	inc    %eax
  100f2a:	0f b7 c0             	movzwl %ax,%eax
  100f2d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f31:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f35:	89 c2                	mov    %eax,%edx
  100f37:	ec                   	in     (%dx),%al
  100f38:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f3b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f3f:	0f b6 c0             	movzbl %al,%eax
  100f42:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f48:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f50:	0f b7 c0             	movzwl %ax,%eax
  100f53:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f59:	90                   	nop
  100f5a:	c9                   	leave  
  100f5b:	c3                   	ret    

00100f5c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f5c:	f3 0f 1e fb          	endbr32 
  100f60:	55                   	push   %ebp
  100f61:	89 e5                	mov    %esp,%ebp
  100f63:	83 ec 48             	sub    $0x48,%esp
  100f66:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f6c:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f70:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f74:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
}
  100f79:	90                   	nop
  100f7a:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f80:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f84:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f88:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f8c:	ee                   	out    %al,(%dx)
}
  100f8d:	90                   	nop
  100f8e:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f94:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f98:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f9c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
}
  100fa1:	90                   	nop
  100fa2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fa8:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fac:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
}
  100fb5:	90                   	nop
  100fb6:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fbc:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
}
  100fc9:	90                   	nop
  100fca:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fd0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fd8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
}
  100fdd:	90                   	nop
  100fde:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fe4:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fec:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ff0:	ee                   	out    %al,(%dx)
}
  100ff1:	90                   	nop
  100ff2:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ff8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ffc:	89 c2                	mov    %eax,%edx
  100ffe:	ec                   	in     (%dx),%al
  100fff:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101002:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101006:	3c ff                	cmp    $0xff,%al
  101008:	0f 95 c0             	setne  %al
  10100b:	0f b6 c0             	movzbl %al,%eax
  10100e:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  101013:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101019:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10101d:	89 c2                	mov    %eax,%edx
  10101f:	ec                   	in     (%dx),%al
  101020:	88 45 f1             	mov    %al,-0xf(%ebp)
  101023:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101029:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10102d:	89 c2                	mov    %eax,%edx
  10102f:	ec                   	in     (%dx),%al
  101030:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101033:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101038:	85 c0                	test   %eax,%eax
  10103a:	74 0c                	je     101048 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101043:	e8 0b 07 00 00       	call   101753 <pic_enable>
    }
}
  101048:	90                   	nop
  101049:	c9                   	leave  
  10104a:	c3                   	ret    

0010104b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10104b:	f3 0f 1e fb          	endbr32 
  10104f:	55                   	push   %ebp
  101050:	89 e5                	mov    %esp,%ebp
  101052:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10105c:	eb 08                	jmp    101066 <lpt_putc_sub+0x1b>
        delay();
  10105e:	e8 c2 fd ff ff       	call   100e25 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101063:	ff 45 fc             	incl   -0x4(%ebp)
  101066:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10106c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101070:	89 c2                	mov    %eax,%edx
  101072:	ec                   	in     (%dx),%al
  101073:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101076:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10107a:	84 c0                	test   %al,%al
  10107c:	78 09                	js     101087 <lpt_putc_sub+0x3c>
  10107e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101085:	7e d7                	jle    10105e <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101087:	8b 45 08             	mov    0x8(%ebp),%eax
  10108a:	0f b6 c0             	movzbl %al,%eax
  10108d:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101093:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101096:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10109a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10109e:	ee                   	out    %al,(%dx)
}
  10109f:	90                   	nop
  1010a0:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010a6:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010aa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010b2:	ee                   	out    %al,(%dx)
}
  1010b3:	90                   	nop
  1010b4:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010ba:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010be:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010c2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010c6:	ee                   	out    %al,(%dx)
}
  1010c7:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c8:	90                   	nop
  1010c9:	c9                   	leave  
  1010ca:	c3                   	ret    

001010cb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010cb:	f3 0f 1e fb          	endbr32 
  1010cf:	55                   	push   %ebp
  1010d0:	89 e5                	mov    %esp,%ebp
  1010d2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010d5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d9:	74 0d                	je     1010e8 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010db:	8b 45 08             	mov    0x8(%ebp),%eax
  1010de:	89 04 24             	mov    %eax,(%esp)
  1010e1:	e8 65 ff ff ff       	call   10104b <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010e6:	eb 24                	jmp    10110c <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ef:	e8 57 ff ff ff       	call   10104b <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010f4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010fb:	e8 4b ff ff ff       	call   10104b <lpt_putc_sub>
        lpt_putc_sub('\b');
  101100:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101107:	e8 3f ff ff ff       	call   10104b <lpt_putc_sub>
}
  10110c:	90                   	nop
  10110d:	c9                   	leave  
  10110e:	c3                   	ret    

0010110f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10110f:	f3 0f 1e fb          	endbr32 
  101113:	55                   	push   %ebp
  101114:	89 e5                	mov    %esp,%ebp
  101116:	53                   	push   %ebx
  101117:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10111a:	8b 45 08             	mov    0x8(%ebp),%eax
  10111d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101122:	85 c0                	test   %eax,%eax
  101124:	75 07                	jne    10112d <cga_putc+0x1e>
        c |= 0x0700;
  101126:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10112d:	8b 45 08             	mov    0x8(%ebp),%eax
  101130:	0f b6 c0             	movzbl %al,%eax
  101133:	83 f8 0d             	cmp    $0xd,%eax
  101136:	74 72                	je     1011aa <cga_putc+0x9b>
  101138:	83 f8 0d             	cmp    $0xd,%eax
  10113b:	0f 8f a3 00 00 00    	jg     1011e4 <cga_putc+0xd5>
  101141:	83 f8 08             	cmp    $0x8,%eax
  101144:	74 0a                	je     101150 <cga_putc+0x41>
  101146:	83 f8 0a             	cmp    $0xa,%eax
  101149:	74 4c                	je     101197 <cga_putc+0x88>
  10114b:	e9 94 00 00 00       	jmp    1011e4 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101150:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101157:	85 c0                	test   %eax,%eax
  101159:	0f 84 af 00 00 00    	je     10120e <cga_putc+0xff>
            crt_pos --;
  10115f:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101166:	48                   	dec    %eax
  101167:	0f b7 c0             	movzwl %ax,%eax
  10116a:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101170:	8b 45 08             	mov    0x8(%ebp),%eax
  101173:	98                   	cwtl   
  101174:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101179:	98                   	cwtl   
  10117a:	83 c8 20             	or     $0x20,%eax
  10117d:	98                   	cwtl   
  10117e:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  101184:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  10118b:	01 c9                	add    %ecx,%ecx
  10118d:	01 ca                	add    %ecx,%edx
  10118f:	0f b7 c0             	movzwl %ax,%eax
  101192:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101195:	eb 77                	jmp    10120e <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101197:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10119e:	83 c0 50             	add    $0x50,%eax
  1011a1:	0f b7 c0             	movzwl %ax,%eax
  1011a4:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011aa:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  1011b1:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  1011b8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011bd:	89 c8                	mov    %ecx,%eax
  1011bf:	f7 e2                	mul    %edx
  1011c1:	c1 ea 06             	shr    $0x6,%edx
  1011c4:	89 d0                	mov    %edx,%eax
  1011c6:	c1 e0 02             	shl    $0x2,%eax
  1011c9:	01 d0                	add    %edx,%eax
  1011cb:	c1 e0 04             	shl    $0x4,%eax
  1011ce:	29 c1                	sub    %eax,%ecx
  1011d0:	89 c8                	mov    %ecx,%eax
  1011d2:	0f b7 c0             	movzwl %ax,%eax
  1011d5:	29 c3                	sub    %eax,%ebx
  1011d7:	89 d8                	mov    %ebx,%eax
  1011d9:	0f b7 c0             	movzwl %ax,%eax
  1011dc:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011e2:	eb 2b                	jmp    10120f <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011e4:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011ea:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f1:	8d 50 01             	lea    0x1(%eax),%edx
  1011f4:	0f b7 d2             	movzwl %dx,%edx
  1011f7:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011fe:	01 c0                	add    %eax,%eax
  101200:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101203:	8b 45 08             	mov    0x8(%ebp),%eax
  101206:	0f b7 c0             	movzwl %ax,%eax
  101209:	66 89 02             	mov    %ax,(%edx)
        break;
  10120c:	eb 01                	jmp    10120f <cga_putc+0x100>
        break;
  10120e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10120f:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101216:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10121b:	76 5d                	jbe    10127a <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10121d:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101222:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101228:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10122d:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101234:	00 
  101235:	89 54 24 04          	mov    %edx,0x4(%esp)
  101239:	89 04 24             	mov    %eax,(%esp)
  10123c:	e8 44 1d 00 00       	call   102f85 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101241:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101248:	eb 14                	jmp    10125e <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10124a:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10124f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101252:	01 d2                	add    %edx,%edx
  101254:	01 d0                	add    %edx,%eax
  101256:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10125b:	ff 45 f4             	incl   -0xc(%ebp)
  10125e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101265:	7e e3                	jle    10124a <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101267:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10126e:	83 e8 50             	sub    $0x50,%eax
  101271:	0f b7 c0             	movzwl %ax,%eax
  101274:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10127a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101281:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101285:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101289:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10128d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
}
  101292:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101293:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10129a:	c1 e8 08             	shr    $0x8,%eax
  10129d:	0f b7 c0             	movzwl %ax,%eax
  1012a0:	0f b6 c0             	movzbl %al,%eax
  1012a3:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012aa:	42                   	inc    %edx
  1012ab:	0f b7 d2             	movzwl %dx,%edx
  1012ae:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012b2:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
}
  1012be:	90                   	nop
    outb(addr_6845, 15);
  1012bf:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1012c6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012ca:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012d2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012d6:	ee                   	out    %al,(%dx)
}
  1012d7:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012d8:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012df:	0f b6 c0             	movzbl %al,%eax
  1012e2:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012e9:	42                   	inc    %edx
  1012ea:	0f b7 d2             	movzwl %dx,%edx
  1012ed:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012f1:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012f4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012f8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012fc:	ee                   	out    %al,(%dx)
}
  1012fd:	90                   	nop
}
  1012fe:	90                   	nop
  1012ff:	83 c4 34             	add    $0x34,%esp
  101302:	5b                   	pop    %ebx
  101303:	5d                   	pop    %ebp
  101304:	c3                   	ret    

00101305 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101305:	f3 0f 1e fb          	endbr32 
  101309:	55                   	push   %ebp
  10130a:	89 e5                	mov    %esp,%ebp
  10130c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10130f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101316:	eb 08                	jmp    101320 <serial_putc_sub+0x1b>
        delay();
  101318:	e8 08 fb ff ff       	call   100e25 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10131d:	ff 45 fc             	incl   -0x4(%ebp)
  101320:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101326:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10132a:	89 c2                	mov    %eax,%edx
  10132c:	ec                   	in     (%dx),%al
  10132d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101330:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101334:	0f b6 c0             	movzbl %al,%eax
  101337:	83 e0 20             	and    $0x20,%eax
  10133a:	85 c0                	test   %eax,%eax
  10133c:	75 09                	jne    101347 <serial_putc_sub+0x42>
  10133e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101345:	7e d1                	jle    101318 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101347:	8b 45 08             	mov    0x8(%ebp),%eax
  10134a:	0f b6 c0             	movzbl %al,%eax
  10134d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101353:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101356:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10135a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10135e:	ee                   	out    %al,(%dx)
}
  10135f:	90                   	nop
}
  101360:	90                   	nop
  101361:	c9                   	leave  
  101362:	c3                   	ret    

00101363 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101363:	f3 0f 1e fb          	endbr32 
  101367:	55                   	push   %ebp
  101368:	89 e5                	mov    %esp,%ebp
  10136a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10136d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101371:	74 0d                	je     101380 <serial_putc+0x1d>
        serial_putc_sub(c);
  101373:	8b 45 08             	mov    0x8(%ebp),%eax
  101376:	89 04 24             	mov    %eax,(%esp)
  101379:	e8 87 ff ff ff       	call   101305 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10137e:	eb 24                	jmp    1013a4 <serial_putc+0x41>
        serial_putc_sub('\b');
  101380:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101387:	e8 79 ff ff ff       	call   101305 <serial_putc_sub>
        serial_putc_sub(' ');
  10138c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101393:	e8 6d ff ff ff       	call   101305 <serial_putc_sub>
        serial_putc_sub('\b');
  101398:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10139f:	e8 61 ff ff ff       	call   101305 <serial_putc_sub>
}
  1013a4:	90                   	nop
  1013a5:	c9                   	leave  
  1013a6:	c3                   	ret    

001013a7 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013a7:	f3 0f 1e fb          	endbr32 
  1013ab:	55                   	push   %ebp
  1013ac:	89 e5                	mov    %esp,%ebp
  1013ae:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013b1:	eb 33                	jmp    1013e6 <cons_intr+0x3f>
        if (c != 0) {
  1013b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013b7:	74 2d                	je     1013e6 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013b9:	a1 84 00 11 00       	mov    0x110084,%eax
  1013be:	8d 50 01             	lea    0x1(%eax),%edx
  1013c1:	89 15 84 00 11 00    	mov    %edx,0x110084
  1013c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ca:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013d0:	a1 84 00 11 00       	mov    0x110084,%eax
  1013d5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013da:	75 0a                	jne    1013e6 <cons_intr+0x3f>
                cons.wpos = 0;
  1013dc:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013e3:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e9:	ff d0                	call   *%eax
  1013eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013ee:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013f2:	75 bf                	jne    1013b3 <cons_intr+0xc>
            }
        }
    }
}
  1013f4:	90                   	nop
  1013f5:	90                   	nop
  1013f6:	c9                   	leave  
  1013f7:	c3                   	ret    

001013f8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013f8:	f3 0f 1e fb          	endbr32 
  1013fc:	55                   	push   %ebp
  1013fd:	89 e5                	mov    %esp,%ebp
  1013ff:	83 ec 10             	sub    $0x10,%esp
  101402:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101408:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10140c:	89 c2                	mov    %eax,%edx
  10140e:	ec                   	in     (%dx),%al
  10140f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101412:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101416:	0f b6 c0             	movzbl %al,%eax
  101419:	83 e0 01             	and    $0x1,%eax
  10141c:	85 c0                	test   %eax,%eax
  10141e:	75 07                	jne    101427 <serial_proc_data+0x2f>
        return -1;
  101420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101425:	eb 2a                	jmp    101451 <serial_proc_data+0x59>
  101427:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10142d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101431:	89 c2                	mov    %eax,%edx
  101433:	ec                   	in     (%dx),%al
  101434:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101437:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10143b:	0f b6 c0             	movzbl %al,%eax
  10143e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101441:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101445:	75 07                	jne    10144e <serial_proc_data+0x56>
        c = '\b';
  101447:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10144e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101451:	c9                   	leave  
  101452:	c3                   	ret    

00101453 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101453:	f3 0f 1e fb          	endbr32 
  101457:	55                   	push   %ebp
  101458:	89 e5                	mov    %esp,%ebp
  10145a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10145d:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101462:	85 c0                	test   %eax,%eax
  101464:	74 0c                	je     101472 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101466:	c7 04 24 f8 13 10 00 	movl   $0x1013f8,(%esp)
  10146d:	e8 35 ff ff ff       	call   1013a7 <cons_intr>
    }
}
  101472:	90                   	nop
  101473:	c9                   	leave  
  101474:	c3                   	ret    

00101475 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101475:	f3 0f 1e fb          	endbr32 
  101479:	55                   	push   %ebp
  10147a:	89 e5                	mov    %esp,%ebp
  10147c:	83 ec 38             	sub    $0x38,%esp
  10147f:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101488:	89 c2                	mov    %eax,%edx
  10148a:	ec                   	in     (%dx),%al
  10148b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10148e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101492:	0f b6 c0             	movzbl %al,%eax
  101495:	83 e0 01             	and    $0x1,%eax
  101498:	85 c0                	test   %eax,%eax
  10149a:	75 0a                	jne    1014a6 <kbd_proc_data+0x31>
        return -1;
  10149c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a1:	e9 56 01 00 00       	jmp    1015fc <kbd_proc_data+0x187>
  1014a6:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	ec                   	in     (%dx),%al
  1014b2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014b5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014b9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014bc:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014c0:	75 17                	jne    1014d9 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014c2:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c7:	83 c8 40             	or     $0x40,%eax
  1014ca:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d4:	e9 23 01 00 00       	jmp    1015fc <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014d9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014dd:	84 c0                	test   %al,%al
  1014df:	79 45                	jns    101526 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014e1:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e6:	83 e0 40             	and    $0x40,%eax
  1014e9:	85 c0                	test   %eax,%eax
  1014eb:	75 08                	jne    1014f5 <kbd_proc_data+0x80>
  1014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f1:	24 7f                	and    $0x7f,%al
  1014f3:	eb 04                	jmp    1014f9 <kbd_proc_data+0x84>
  1014f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f9:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101500:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101507:	0c 40                	or     $0x40,%al
  101509:	0f b6 c0             	movzbl %al,%eax
  10150c:	f7 d0                	not    %eax
  10150e:	89 c2                	mov    %eax,%edx
  101510:	a1 88 00 11 00       	mov    0x110088,%eax
  101515:	21 d0                	and    %edx,%eax
  101517:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10151c:	b8 00 00 00 00       	mov    $0x0,%eax
  101521:	e9 d6 00 00 00       	jmp    1015fc <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101526:	a1 88 00 11 00       	mov    0x110088,%eax
  10152b:	83 e0 40             	and    $0x40,%eax
  10152e:	85 c0                	test   %eax,%eax
  101530:	74 11                	je     101543 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101532:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101536:	a1 88 00 11 00       	mov    0x110088,%eax
  10153b:	83 e0 bf             	and    $0xffffffbf,%eax
  10153e:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101543:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101547:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10154e:	0f b6 d0             	movzbl %al,%edx
  101551:	a1 88 00 11 00       	mov    0x110088,%eax
  101556:	09 d0                	or     %edx,%eax
  101558:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101561:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101568:	0f b6 d0             	movzbl %al,%edx
  10156b:	a1 88 00 11 00       	mov    0x110088,%eax
  101570:	31 d0                	xor    %edx,%eax
  101572:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101577:	a1 88 00 11 00       	mov    0x110088,%eax
  10157c:	83 e0 03             	and    $0x3,%eax
  10157f:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158a:	01 d0                	add    %edx,%eax
  10158c:	0f b6 00             	movzbl (%eax),%eax
  10158f:	0f b6 c0             	movzbl %al,%eax
  101592:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101595:	a1 88 00 11 00       	mov    0x110088,%eax
  10159a:	83 e0 08             	and    $0x8,%eax
  10159d:	85 c0                	test   %eax,%eax
  10159f:	74 22                	je     1015c3 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015a1:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015a5:	7e 0c                	jle    1015b3 <kbd_proc_data+0x13e>
  1015a7:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015ab:	7f 06                	jg     1015b3 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015ad:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015b1:	eb 10                	jmp    1015c3 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015b3:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015b7:	7e 0a                	jle    1015c3 <kbd_proc_data+0x14e>
  1015b9:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015bd:	7f 04                	jg     1015c3 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015bf:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015c3:	a1 88 00 11 00       	mov    0x110088,%eax
  1015c8:	f7 d0                	not    %eax
  1015ca:	83 e0 06             	and    $0x6,%eax
  1015cd:	85 c0                	test   %eax,%eax
  1015cf:	75 28                	jne    1015f9 <kbd_proc_data+0x184>
  1015d1:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015d8:	75 1f                	jne    1015f9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015da:	c7 04 24 c1 3a 10 00 	movl   $0x103ac1,(%esp)
  1015e1:	e8 ad ec ff ff       	call   100293 <cprintf>
  1015e6:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015ec:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015f0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015f7:	ee                   	out    %al,(%dx)
}
  1015f8:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015fc:	c9                   	leave  
  1015fd:	c3                   	ret    

001015fe <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015fe:	f3 0f 1e fb          	endbr32 
  101602:	55                   	push   %ebp
  101603:	89 e5                	mov    %esp,%ebp
  101605:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101608:	c7 04 24 75 14 10 00 	movl   $0x101475,(%esp)
  10160f:	e8 93 fd ff ff       	call   1013a7 <cons_intr>
}
  101614:	90                   	nop
  101615:	c9                   	leave  
  101616:	c3                   	ret    

00101617 <kbd_init>:

static void
kbd_init(void) {
  101617:	f3 0f 1e fb          	endbr32 
  10161b:	55                   	push   %ebp
  10161c:	89 e5                	mov    %esp,%ebp
  10161e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101621:	e8 d8 ff ff ff       	call   1015fe <kbd_intr>
    pic_enable(IRQ_KBD);
  101626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10162d:	e8 21 01 00 00       	call   101753 <pic_enable>
}
  101632:	90                   	nop
  101633:	c9                   	leave  
  101634:	c3                   	ret    

00101635 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101635:	f3 0f 1e fb          	endbr32 
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10163f:	e8 2e f8 ff ff       	call   100e72 <cga_init>
    serial_init();
  101644:	e8 13 f9 ff ff       	call   100f5c <serial_init>
    kbd_init();
  101649:	e8 c9 ff ff ff       	call   101617 <kbd_init>
    if (!serial_exists) {
  10164e:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101653:	85 c0                	test   %eax,%eax
  101655:	75 0c                	jne    101663 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101657:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  10165e:	e8 30 ec ff ff       	call   100293 <cprintf>
    }
}
  101663:	90                   	nop
  101664:	c9                   	leave  
  101665:	c3                   	ret    

00101666 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101666:	f3 0f 1e fb          	endbr32 
  10166a:	55                   	push   %ebp
  10166b:	89 e5                	mov    %esp,%ebp
  10166d:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101670:	8b 45 08             	mov    0x8(%ebp),%eax
  101673:	89 04 24             	mov    %eax,(%esp)
  101676:	e8 50 fa ff ff       	call   1010cb <lpt_putc>
    cga_putc(c);
  10167b:	8b 45 08             	mov    0x8(%ebp),%eax
  10167e:	89 04 24             	mov    %eax,(%esp)
  101681:	e8 89 fa ff ff       	call   10110f <cga_putc>
    serial_putc(c);
  101686:	8b 45 08             	mov    0x8(%ebp),%eax
  101689:	89 04 24             	mov    %eax,(%esp)
  10168c:	e8 d2 fc ff ff       	call   101363 <serial_putc>
}
  101691:	90                   	nop
  101692:	c9                   	leave  
  101693:	c3                   	ret    

00101694 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101694:	f3 0f 1e fb          	endbr32 
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10169e:	e8 b0 fd ff ff       	call   101453 <serial_intr>
    kbd_intr();
  1016a3:	e8 56 ff ff ff       	call   1015fe <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016a8:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1016ae:	a1 84 00 11 00       	mov    0x110084,%eax
  1016b3:	39 c2                	cmp    %eax,%edx
  1016b5:	74 36                	je     1016ed <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016b7:	a1 80 00 11 00       	mov    0x110080,%eax
  1016bc:	8d 50 01             	lea    0x1(%eax),%edx
  1016bf:	89 15 80 00 11 00    	mov    %edx,0x110080
  1016c5:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  1016cc:	0f b6 c0             	movzbl %al,%eax
  1016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016d2:	a1 80 00 11 00       	mov    0x110080,%eax
  1016d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016dc:	75 0a                	jne    1016e8 <cons_getc+0x54>
            cons.rpos = 0;
  1016de:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1016e5:	00 00 00 
        }
        return c;
  1016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016eb:	eb 05                	jmp    1016f2 <cons_getc+0x5e>
    }
    return 0;
  1016ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016f2:	c9                   	leave  
  1016f3:	c3                   	ret    

001016f4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016f4:	f3 0f 1e fb          	endbr32 
  1016f8:	55                   	push   %ebp
  1016f9:	89 e5                	mov    %esp,%ebp
  1016fb:	83 ec 14             	sub    $0x14,%esp
  1016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101701:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101708:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  10170e:	a1 8c 00 11 00       	mov    0x11008c,%eax
  101713:	85 c0                	test   %eax,%eax
  101715:	74 39                	je     101750 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171a:	0f b6 c0             	movzbl %al,%eax
  10171d:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101723:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101726:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10172a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10172e:	ee                   	out    %al,(%dx)
}
  10172f:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101730:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101734:	c1 e8 08             	shr    $0x8,%eax
  101737:	0f b7 c0             	movzwl %ax,%eax
  10173a:	0f b6 c0             	movzbl %al,%eax
  10173d:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101743:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101746:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10174a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10174e:	ee                   	out    %al,(%dx)
}
  10174f:	90                   	nop
    }
}
  101750:	90                   	nop
  101751:	c9                   	leave  
  101752:	c3                   	ret    

00101753 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101753:	f3 0f 1e fb          	endbr32 
  101757:	55                   	push   %ebp
  101758:	89 e5                	mov    %esp,%ebp
  10175a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10175d:	8b 45 08             	mov    0x8(%ebp),%eax
  101760:	ba 01 00 00 00       	mov    $0x1,%edx
  101765:	88 c1                	mov    %al,%cl
  101767:	d3 e2                	shl    %cl,%edx
  101769:	89 d0                	mov    %edx,%eax
  10176b:	98                   	cwtl   
  10176c:	f7 d0                	not    %eax
  10176e:	0f bf d0             	movswl %ax,%edx
  101771:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101778:	98                   	cwtl   
  101779:	21 d0                	and    %edx,%eax
  10177b:	98                   	cwtl   
  10177c:	0f b7 c0             	movzwl %ax,%eax
  10177f:	89 04 24             	mov    %eax,(%esp)
  101782:	e8 6d ff ff ff       	call   1016f4 <pic_setmask>
}
  101787:	90                   	nop
  101788:	c9                   	leave  
  101789:	c3                   	ret    

0010178a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10178a:	f3 0f 1e fb          	endbr32 
  10178e:	55                   	push   %ebp
  10178f:	89 e5                	mov    %esp,%ebp
  101791:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101794:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10179b:	00 00 00 
  10179e:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017a4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ac:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
}
  1017b1:	90                   	nop
  1017b2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017b8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017bc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
}
  1017c5:	90                   	nop
  1017c6:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017cc:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d0:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017d4:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
}
  1017d9:	90                   	nop
  1017da:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017e0:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e4:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017e8:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
}
  1017ed:	90                   	nop
  1017ee:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017f4:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f8:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fc:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
}
  101801:	90                   	nop
  101802:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101808:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101810:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101814:	ee                   	out    %al,(%dx)
}
  101815:	90                   	nop
  101816:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10181c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101820:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101824:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
}
  101829:	90                   	nop
  10182a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101830:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101834:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101838:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10183c:	ee                   	out    %al,(%dx)
}
  10183d:	90                   	nop
  10183e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101844:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101848:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10184c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101850:	ee                   	out    %al,(%dx)
}
  101851:	90                   	nop
  101852:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101858:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101860:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101864:	ee                   	out    %al,(%dx)
}
  101865:	90                   	nop
  101866:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10186c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101870:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101874:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101878:	ee                   	out    %al,(%dx)
}
  101879:	90                   	nop
  10187a:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101880:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101884:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101888:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10188c:	ee                   	out    %al,(%dx)
}
  10188d:	90                   	nop
  10188e:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101894:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101898:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10189c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018a0:	ee                   	out    %al,(%dx)
}
  1018a1:	90                   	nop
  1018a2:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018a8:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018ac:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018b0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018b4:	ee                   	out    %al,(%dx)
}
  1018b5:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018b6:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018bd:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018c2:	74 0f                	je     1018d3 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018c4:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018cb:	89 04 24             	mov    %eax,(%esp)
  1018ce:	e8 21 fe ff ff       	call   1016f4 <pic_setmask>
    }
}
  1018d3:	90                   	nop
  1018d4:	c9                   	leave  
  1018d5:	c3                   	ret    

001018d6 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018d6:	f3 0f 1e fb          	endbr32 
  1018da:	55                   	push   %ebp
  1018db:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018dd:	fb                   	sti    
}
  1018de:	90                   	nop
    sti();
}
  1018df:	90                   	nop
  1018e0:	5d                   	pop    %ebp
  1018e1:	c3                   	ret    

001018e2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018e2:	f3 0f 1e fb          	endbr32 
  1018e6:	55                   	push   %ebp
  1018e7:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018e9:	fa                   	cli    
}
  1018ea:	90                   	nop
    cli();
}
  1018eb:	90                   	nop
  1018ec:	5d                   	pop    %ebp
  1018ed:	c3                   	ret    

001018ee <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1018ee:	f3 0f 1e fb          	endbr32 
  1018f2:	55                   	push   %ebp
  1018f3:	89 e5                	mov    %esp,%ebp
  1018f5:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018f8:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018ff:	00 
  101900:	c7 04 24 00 3b 10 00 	movl   $0x103b00,(%esp)
  101907:	e8 87 e9 ff ff       	call   100293 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10190c:	c7 04 24 0a 3b 10 00 	movl   $0x103b0a,(%esp)
  101913:	e8 7b e9 ff ff       	call   100293 <cprintf>
    panic("EOT: kernel seems ok.");
  101918:	c7 44 24 08 18 3b 10 	movl   $0x103b18,0x8(%esp)
  10191f:	00 
  101920:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101927:	00 
  101928:	c7 04 24 2e 3b 10 00 	movl   $0x103b2e,(%esp)
  10192f:	e8 cb ea ff ff       	call   1003ff <__panic>

00101934 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101934:	f3 0f 1e fb          	endbr32 
  101938:	55                   	push   %ebp
  101939:	89 e5                	mov    %esp,%ebp
  10193b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10193e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101945:	e9 c4 00 00 00       	jmp    101a0e <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101954:	0f b7 d0             	movzwl %ax,%edx
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  101961:	00 
  101962:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101965:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  10196c:	00 08 00 
  10196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101972:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  101979:	00 
  10197a:	80 e2 e0             	and    $0xe0,%dl
  10197d:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  10198e:	00 
  10198f:	80 e2 1f             	and    $0x1f,%dl
  101992:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199c:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019a3:	00 
  1019a4:	80 e2 f0             	and    $0xf0,%dl
  1019a7:	80 ca 0e             	or     $0xe,%dl
  1019aa:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b4:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019bb:	00 
  1019bc:	80 e2 ef             	and    $0xef,%dl
  1019bf:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c9:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019d0:	00 
  1019d1:	80 e2 9f             	and    $0x9f,%dl
  1019d4:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019de:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019e5:	00 
  1019e6:	80 ca 80             	or     $0x80,%dl
  1019e9:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f3:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1019fa:	c1 e8 10             	shr    $0x10,%eax
  1019fd:	0f b7 d0             	movzwl %ax,%edx
  101a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a03:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  101a0a:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a0b:	ff 45 fc             	incl   -0x4(%ebp)
  101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a11:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a16:	0f 86 2e ff ff ff    	jbe    10194a <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a1c:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a21:	0f b7 c0             	movzwl %ax,%eax
  101a24:	66 a3 68 04 11 00    	mov    %ax,0x110468
  101a2a:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  101a31:	08 00 
  101a33:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  101a3a:	24 e0                	and    $0xe0,%al
  101a3c:	a2 6c 04 11 00       	mov    %al,0x11046c
  101a41:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  101a48:	24 1f                	and    $0x1f,%al
  101a4a:	a2 6c 04 11 00       	mov    %al,0x11046c
  101a4f:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a56:	24 f0                	and    $0xf0,%al
  101a58:	0c 0e                	or     $0xe,%al
  101a5a:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a5f:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a66:	24 ef                	and    $0xef,%al
  101a68:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a6d:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a74:	0c 60                	or     $0x60,%al
  101a76:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a7b:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a82:	0c 80                	or     $0x80,%al
  101a84:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a89:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a8e:	c1 e8 10             	shr    $0x10,%eax
  101a91:	0f b7 c0             	movzwl %ax,%eax
  101a94:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  101a9a:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aa4:	0f 01 18             	lidtl  (%eax)
}
  101aa7:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101aa8:	90                   	nop
  101aa9:	c9                   	leave  
  101aaa:	c3                   	ret    

00101aab <trapname>:

static const char *
trapname(int trapno) {
  101aab:	f3 0f 1e fb          	endbr32 
  101aaf:	55                   	push   %ebp
  101ab0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	83 f8 13             	cmp    $0x13,%eax
  101ab8:	77 0c                	ja     101ac6 <trapname+0x1b>
        return excnames[trapno];
  101aba:	8b 45 08             	mov    0x8(%ebp),%eax
  101abd:	8b 04 85 80 3e 10 00 	mov    0x103e80(,%eax,4),%eax
  101ac4:	eb 18                	jmp    101ade <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ac6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aca:	7e 0d                	jle    101ad9 <trapname+0x2e>
  101acc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ad0:	7f 07                	jg     101ad9 <trapname+0x2e>
        return "Hardware Interrupt";
  101ad2:	b8 3f 3b 10 00       	mov    $0x103b3f,%eax
  101ad7:	eb 05                	jmp    101ade <trapname+0x33>
    }
    return "(unknown trap)";
  101ad9:	b8 52 3b 10 00       	mov    $0x103b52,%eax
}
  101ade:	5d                   	pop    %ebp
  101adf:	c3                   	ret    

00101ae0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ae0:	f3 0f 1e fb          	endbr32 
  101ae4:	55                   	push   %ebp
  101ae5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aee:	83 f8 08             	cmp    $0x8,%eax
  101af1:	0f 94 c0             	sete   %al
  101af4:	0f b6 c0             	movzbl %al,%eax
}
  101af7:	5d                   	pop    %ebp
  101af8:	c3                   	ret    

00101af9 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101af9:	f3 0f 1e fb          	endbr32 
  101afd:	55                   	push   %ebp
  101afe:	89 e5                	mov    %esp,%ebp
  101b00:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0a:	c7 04 24 93 3b 10 00 	movl   $0x103b93,(%esp)
  101b11:	e8 7d e7 ff ff       	call   100293 <cprintf>
    print_regs(&tf->tf_regs);
  101b16:	8b 45 08             	mov    0x8(%ebp),%eax
  101b19:	89 04 24             	mov    %eax,(%esp)
  101b1c:	e8 8d 01 00 00       	call   101cae <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2c:	c7 04 24 a4 3b 10 00 	movl   $0x103ba4,(%esp)
  101b33:	e8 5b e7 ff ff       	call   100293 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b43:	c7 04 24 b7 3b 10 00 	movl   $0x103bb7,(%esp)
  101b4a:	e8 44 e7 ff ff       	call   100293 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 ca 3b 10 00 	movl   $0x103bca,(%esp)
  101b61:	e8 2d e7 ff ff       	call   100293 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b71:	c7 04 24 dd 3b 10 00 	movl   $0x103bdd,(%esp)
  101b78:	e8 16 e7 ff ff       	call   100293 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b80:	8b 40 30             	mov    0x30(%eax),%eax
  101b83:	89 04 24             	mov    %eax,(%esp)
  101b86:	e8 20 ff ff ff       	call   101aab <trapname>
  101b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  101b8e:	8b 52 30             	mov    0x30(%edx),%edx
  101b91:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b95:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b99:	c7 04 24 f0 3b 10 00 	movl   $0x103bf0,(%esp)
  101ba0:	e8 ee e6 ff ff       	call   100293 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	8b 40 34             	mov    0x34(%eax),%eax
  101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baf:	c7 04 24 02 3c 10 00 	movl   $0x103c02,(%esp)
  101bb6:	e8 d8 e6 ff ff       	call   100293 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 38             	mov    0x38(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 11 3c 10 00 	movl   $0x103c11,(%esp)
  101bcc:	e8 c2 e6 ff ff       	call   100293 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 20 3c 10 00 	movl   $0x103c20,(%esp)
  101be3:	e8 ab e6 ff ff       	call   100293 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 40             	mov    0x40(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 33 3c 10 00 	movl   $0x103c33,(%esp)
  101bf9:	e8 95 e6 ff ff       	call   100293 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c0c:	eb 3d                	jmp    101c4b <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 50 40             	mov    0x40(%eax),%edx
  101c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c17:	21 d0                	and    %edx,%eax
  101c19:	85 c0                	test   %eax,%eax
  101c1b:	74 28                	je     101c45 <print_trapframe+0x14c>
  101c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c20:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c27:	85 c0                	test   %eax,%eax
  101c29:	74 1a                	je     101c45 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c2e:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	c7 04 24 42 3c 10 00 	movl   $0x103c42,(%esp)
  101c40:	e8 4e e6 ff ff       	call   100293 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c45:	ff 45 f4             	incl   -0xc(%ebp)
  101c48:	d1 65 f0             	shll   -0x10(%ebp)
  101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4e:	83 f8 17             	cmp    $0x17,%eax
  101c51:	76 bb                	jbe    101c0e <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 40             	mov    0x40(%eax),%eax
  101c59:	c1 e8 0c             	shr    $0xc,%eax
  101c5c:	83 e0 03             	and    $0x3,%eax
  101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c63:	c7 04 24 46 3c 10 00 	movl   $0x103c46,(%esp)
  101c6a:	e8 24 e6 ff ff       	call   100293 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	89 04 24             	mov    %eax,(%esp)
  101c75:	e8 66 fe ff ff       	call   101ae0 <trap_in_kernel>
  101c7a:	85 c0                	test   %eax,%eax
  101c7c:	75 2d                	jne    101cab <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c81:	8b 40 44             	mov    0x44(%eax),%eax
  101c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c88:	c7 04 24 4f 3c 10 00 	movl   $0x103c4f,(%esp)
  101c8f:	e8 ff e5 ff ff       	call   100293 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9f:	c7 04 24 5e 3c 10 00 	movl   $0x103c5e,(%esp)
  101ca6:	e8 e8 e5 ff ff       	call   100293 <cprintf>
    }
}
  101cab:	90                   	nop
  101cac:	c9                   	leave  
  101cad:	c3                   	ret    

00101cae <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cae:	f3 0f 1e fb          	endbr32 
  101cb2:	55                   	push   %ebp
  101cb3:	89 e5                	mov    %esp,%ebp
  101cb5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbb:	8b 00                	mov    (%eax),%eax
  101cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc1:	c7 04 24 71 3c 10 00 	movl   $0x103c71,(%esp)
  101cc8:	e8 c6 e5 ff ff       	call   100293 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd0:	8b 40 04             	mov    0x4(%eax),%eax
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 80 3c 10 00 	movl   $0x103c80,(%esp)
  101cde:	e8 b0 e5 ff ff       	call   100293 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 40 08             	mov    0x8(%eax),%eax
  101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ced:	c7 04 24 8f 3c 10 00 	movl   $0x103c8f,(%esp)
  101cf4:	e8 9a e5 ff ff       	call   100293 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 9e 3c 10 00 	movl   $0x103c9e,(%esp)
  101d0a:	e8 84 e5 ff ff       	call   100293 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d12:	8b 40 10             	mov    0x10(%eax),%eax
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 ad 3c 10 00 	movl   $0x103cad,(%esp)
  101d20:	e8 6e e5 ff ff       	call   100293 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d25:	8b 45 08             	mov    0x8(%ebp),%eax
  101d28:	8b 40 14             	mov    0x14(%eax),%eax
  101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2f:	c7 04 24 bc 3c 10 00 	movl   $0x103cbc,(%esp)
  101d36:	e8 58 e5 ff ff       	call   100293 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 40 18             	mov    0x18(%eax),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 cb 3c 10 00 	movl   $0x103ccb,(%esp)
  101d4c:	e8 42 e5 ff ff       	call   100293 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 da 3c 10 00 	movl   $0x103cda,(%esp)
  101d62:	e8 2c e5 ff ff       	call   100293 <cprintf>
}
  101d67:	90                   	nop
  101d68:	c9                   	leave  
  101d69:	c3                   	ret    

00101d6a <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d6a:	f3 0f 1e fb          	endbr32 
  101d6e:	55                   	push   %ebp
  101d6f:	89 e5                	mov    %esp,%ebp
  101d71:	57                   	push   %edi
  101d72:	56                   	push   %esi
  101d73:	53                   	push   %ebx
  101d74:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d77:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7a:	8b 40 30             	mov    0x30(%eax),%eax
  101d7d:	83 f8 79             	cmp    $0x79,%eax
  101d80:	0f 84 c6 01 00 00    	je     101f4c <trap_dispatch+0x1e2>
  101d86:	83 f8 79             	cmp    $0x79,%eax
  101d89:	0f 87 3a 02 00 00    	ja     101fc9 <trap_dispatch+0x25f>
  101d8f:	83 f8 78             	cmp    $0x78,%eax
  101d92:	0f 84 d0 00 00 00    	je     101e68 <trap_dispatch+0xfe>
  101d98:	83 f8 78             	cmp    $0x78,%eax
  101d9b:	0f 87 28 02 00 00    	ja     101fc9 <trap_dispatch+0x25f>
  101da1:	83 f8 2f             	cmp    $0x2f,%eax
  101da4:	0f 87 1f 02 00 00    	ja     101fc9 <trap_dispatch+0x25f>
  101daa:	83 f8 2e             	cmp    $0x2e,%eax
  101dad:	0f 83 4b 02 00 00    	jae    101ffe <trap_dispatch+0x294>
  101db3:	83 f8 24             	cmp    $0x24,%eax
  101db6:	74 5e                	je     101e16 <trap_dispatch+0xac>
  101db8:	83 f8 24             	cmp    $0x24,%eax
  101dbb:	0f 87 08 02 00 00    	ja     101fc9 <trap_dispatch+0x25f>
  101dc1:	83 f8 20             	cmp    $0x20,%eax
  101dc4:	74 0a                	je     101dd0 <trap_dispatch+0x66>
  101dc6:	83 f8 21             	cmp    $0x21,%eax
  101dc9:	74 74                	je     101e3f <trap_dispatch+0xd5>
  101dcb:	e9 f9 01 00 00       	jmp    101fc9 <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
  101dd0:	a1 08 09 11 00       	mov    0x110908,%eax
  101dd5:	40                   	inc    %eax
  101dd6:	a3 08 09 11 00       	mov    %eax,0x110908
        if (ticks % TICK_NUM == 0) {
  101ddb:	8b 0d 08 09 11 00    	mov    0x110908,%ecx
  101de1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101de6:	89 c8                	mov    %ecx,%eax
  101de8:	f7 e2                	mul    %edx
  101dea:	c1 ea 05             	shr    $0x5,%edx
  101ded:	89 d0                	mov    %edx,%eax
  101def:	c1 e0 02             	shl    $0x2,%eax
  101df2:	01 d0                	add    %edx,%eax
  101df4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101dfb:	01 d0                	add    %edx,%eax
  101dfd:	c1 e0 02             	shl    $0x2,%eax
  101e00:	29 c1                	sub    %eax,%ecx
  101e02:	89 ca                	mov    %ecx,%edx
  101e04:	85 d2                	test   %edx,%edx
  101e06:	0f 85 f5 01 00 00    	jne    102001 <trap_dispatch+0x297>
            print_ticks();
  101e0c:	e8 dd fa ff ff       	call   1018ee <print_ticks>
        }
        break;
  101e11:	e9 eb 01 00 00       	jmp    102001 <trap_dispatch+0x297>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e16:	e8 79 f8 ff ff       	call   101694 <cons_getc>
  101e1b:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e1e:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e22:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e26:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e2e:	c7 04 24 e9 3c 10 00 	movl   $0x103ce9,(%esp)
  101e35:	e8 59 e4 ff ff       	call   100293 <cprintf>
        break;
  101e3a:	e9 c9 01 00 00       	jmp    102008 <trap_dispatch+0x29e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e3f:	e8 50 f8 ff ff       	call   101694 <cons_getc>
  101e44:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e47:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e4b:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e4f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e57:	c7 04 24 fb 3c 10 00 	movl   $0x103cfb,(%esp)
  101e5e:	e8 30 e4 ff ff       	call   100293 <cprintf>
        break;
  101e63:	e9 a0 01 00 00       	jmp    102008 <trap_dispatch+0x29e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e6f:	83 f8 1b             	cmp    $0x1b,%eax
  101e72:	0f 84 8c 01 00 00    	je     102004 <trap_dispatch+0x29a>
            switchk2u = *tf;
  101e78:	8b 55 08             	mov    0x8(%ebp),%edx
  101e7b:	b8 20 09 11 00       	mov    $0x110920,%eax
  101e80:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e85:	89 c1                	mov    %eax,%ecx
  101e87:	83 e1 01             	and    $0x1,%ecx
  101e8a:	85 c9                	test   %ecx,%ecx
  101e8c:	74 0c                	je     101e9a <trap_dispatch+0x130>
  101e8e:	0f b6 0a             	movzbl (%edx),%ecx
  101e91:	88 08                	mov    %cl,(%eax)
  101e93:	8d 40 01             	lea    0x1(%eax),%eax
  101e96:	8d 52 01             	lea    0x1(%edx),%edx
  101e99:	4b                   	dec    %ebx
  101e9a:	89 c1                	mov    %eax,%ecx
  101e9c:	83 e1 02             	and    $0x2,%ecx
  101e9f:	85 c9                	test   %ecx,%ecx
  101ea1:	74 0f                	je     101eb2 <trap_dispatch+0x148>
  101ea3:	0f b7 0a             	movzwl (%edx),%ecx
  101ea6:	66 89 08             	mov    %cx,(%eax)
  101ea9:	8d 40 02             	lea    0x2(%eax),%eax
  101eac:	8d 52 02             	lea    0x2(%edx),%edx
  101eaf:	83 eb 02             	sub    $0x2,%ebx
  101eb2:	89 df                	mov    %ebx,%edi
  101eb4:	83 e7 fc             	and    $0xfffffffc,%edi
  101eb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ebc:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ebf:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ec2:	83 c1 04             	add    $0x4,%ecx
  101ec5:	39 f9                	cmp    %edi,%ecx
  101ec7:	72 f3                	jb     101ebc <trap_dispatch+0x152>
  101ec9:	01 c8                	add    %ecx,%eax
  101ecb:	01 ca                	add    %ecx,%edx
  101ecd:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ed2:	89 de                	mov    %ebx,%esi
  101ed4:	83 e6 02             	and    $0x2,%esi
  101ed7:	85 f6                	test   %esi,%esi
  101ed9:	74 0b                	je     101ee6 <trap_dispatch+0x17c>
  101edb:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101edf:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101ee3:	83 c1 02             	add    $0x2,%ecx
  101ee6:	83 e3 01             	and    $0x1,%ebx
  101ee9:	85 db                	test   %ebx,%ebx
  101eeb:	74 07                	je     101ef4 <trap_dispatch+0x18a>
  101eed:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101ef1:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101ef4:	66 c7 05 5c 09 11 00 	movw   $0x1b,0x11095c
  101efb:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101efd:	66 c7 05 68 09 11 00 	movw   $0x23,0x110968
  101f04:	23 00 
  101f06:	0f b7 05 68 09 11 00 	movzwl 0x110968,%eax
  101f0d:	66 a3 48 09 11 00    	mov    %ax,0x110948
  101f13:	0f b7 05 48 09 11 00 	movzwl 0x110948,%eax
  101f1a:	66 a3 4c 09 11 00    	mov    %ax,0x11094c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f20:	8b 45 08             	mov    0x8(%ebp),%eax
  101f23:	83 c0 44             	add    $0x44,%eax
  101f26:	a3 64 09 11 00       	mov    %eax,0x110964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f2b:	a1 60 09 11 00       	mov    0x110960,%eax
  101f30:	0d 00 30 00 00       	or     $0x3000,%eax
  101f35:	a3 60 09 11 00       	mov    %eax,0x110960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	83 e8 04             	sub    $0x4,%eax
  101f40:	ba 20 09 11 00       	mov    $0x110920,%edx
  101f45:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f47:	e9 b8 00 00 00       	jmp    102004 <trap_dispatch+0x29a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f53:	83 f8 08             	cmp    $0x8,%eax
  101f56:	0f 84 ab 00 00 00    	je     102007 <trap_dispatch+0x29d>
            tf->tf_cs = KERNEL_CS;
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f65:	8b 45 08             	mov    0x8(%ebp),%eax
  101f68:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f75:	8b 45 08             	mov    0x8(%ebp),%eax
  101f78:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7f:	8b 40 40             	mov    0x40(%eax),%eax
  101f82:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f87:	89 c2                	mov    %eax,%edx
  101f89:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8c:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f92:	8b 40 44             	mov    0x44(%eax),%eax
  101f95:	83 e8 44             	sub    $0x44,%eax
  101f98:	a3 6c 09 11 00       	mov    %eax,0x11096c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f9d:	a1 6c 09 11 00       	mov    0x11096c,%eax
  101fa2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fa9:	00 
  101faa:	8b 55 08             	mov    0x8(%ebp),%edx
  101fad:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fb1:	89 04 24             	mov    %eax,(%esp)
  101fb4:	e8 cc 0f 00 00       	call   102f85 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fb9:	8b 15 6c 09 11 00    	mov    0x11096c,%edx
  101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc2:	83 e8 04             	sub    $0x4,%eax
  101fc5:	89 10                	mov    %edx,(%eax)
        }
        break;
  101fc7:	eb 3e                	jmp    102007 <trap_dispatch+0x29d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fcc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fd0:	83 e0 03             	and    $0x3,%eax
  101fd3:	85 c0                	test   %eax,%eax
  101fd5:	75 31                	jne    102008 <trap_dispatch+0x29e>
            print_trapframe(tf);
  101fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101fda:	89 04 24             	mov    %eax,(%esp)
  101fdd:	e8 17 fb ff ff       	call   101af9 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101fe2:	c7 44 24 08 0a 3d 10 	movl   $0x103d0a,0x8(%esp)
  101fe9:	00 
  101fea:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  101ff1:	00 
  101ff2:	c7 04 24 2e 3b 10 00 	movl   $0x103b2e,(%esp)
  101ff9:	e8 01 e4 ff ff       	call   1003ff <__panic>
        break;
  101ffe:	90                   	nop
  101fff:	eb 07                	jmp    102008 <trap_dispatch+0x29e>
        break;
  102001:	90                   	nop
  102002:	eb 04                	jmp    102008 <trap_dispatch+0x29e>
        break;
  102004:	90                   	nop
  102005:	eb 01                	jmp    102008 <trap_dispatch+0x29e>
        break;
  102007:	90                   	nop
        }
    }
}
  102008:	90                   	nop
  102009:	83 c4 2c             	add    $0x2c,%esp
  10200c:	5b                   	pop    %ebx
  10200d:	5e                   	pop    %esi
  10200e:	5f                   	pop    %edi
  10200f:	5d                   	pop    %ebp
  102010:	c3                   	ret    

00102011 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102011:	f3 0f 1e fb          	endbr32 
  102015:	55                   	push   %ebp
  102016:	89 e5                	mov    %esp,%ebp
  102018:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10201b:	8b 45 08             	mov    0x8(%ebp),%eax
  10201e:	89 04 24             	mov    %eax,(%esp)
  102021:	e8 44 fd ff ff       	call   101d6a <trap_dispatch>
}
  102026:	90                   	nop
  102027:	c9                   	leave  
  102028:	c3                   	ret    

00102029 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $0
  10202b:	6a 00                	push   $0x0
  jmp __alltraps
  10202d:	e9 69 0a 00 00       	jmp    102a9b <__alltraps>

00102032 <vector1>:
.globl vector1
vector1:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $1
  102034:	6a 01                	push   $0x1
  jmp __alltraps
  102036:	e9 60 0a 00 00       	jmp    102a9b <__alltraps>

0010203b <vector2>:
.globl vector2
vector2:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $2
  10203d:	6a 02                	push   $0x2
  jmp __alltraps
  10203f:	e9 57 0a 00 00       	jmp    102a9b <__alltraps>

00102044 <vector3>:
.globl vector3
vector3:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $3
  102046:	6a 03                	push   $0x3
  jmp __alltraps
  102048:	e9 4e 0a 00 00       	jmp    102a9b <__alltraps>

0010204d <vector4>:
.globl vector4
vector4:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $4
  10204f:	6a 04                	push   $0x4
  jmp __alltraps
  102051:	e9 45 0a 00 00       	jmp    102a9b <__alltraps>

00102056 <vector5>:
.globl vector5
vector5:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $5
  102058:	6a 05                	push   $0x5
  jmp __alltraps
  10205a:	e9 3c 0a 00 00       	jmp    102a9b <__alltraps>

0010205f <vector6>:
.globl vector6
vector6:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $6
  102061:	6a 06                	push   $0x6
  jmp __alltraps
  102063:	e9 33 0a 00 00       	jmp    102a9b <__alltraps>

00102068 <vector7>:
.globl vector7
vector7:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $7
  10206a:	6a 07                	push   $0x7
  jmp __alltraps
  10206c:	e9 2a 0a 00 00       	jmp    102a9b <__alltraps>

00102071 <vector8>:
.globl vector8
vector8:
  pushl $8
  102071:	6a 08                	push   $0x8
  jmp __alltraps
  102073:	e9 23 0a 00 00       	jmp    102a9b <__alltraps>

00102078 <vector9>:
.globl vector9
vector9:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $9
  10207a:	6a 09                	push   $0x9
  jmp __alltraps
  10207c:	e9 1a 0a 00 00       	jmp    102a9b <__alltraps>

00102081 <vector10>:
.globl vector10
vector10:
  pushl $10
  102081:	6a 0a                	push   $0xa
  jmp __alltraps
  102083:	e9 13 0a 00 00       	jmp    102a9b <__alltraps>

00102088 <vector11>:
.globl vector11
vector11:
  pushl $11
  102088:	6a 0b                	push   $0xb
  jmp __alltraps
  10208a:	e9 0c 0a 00 00       	jmp    102a9b <__alltraps>

0010208f <vector12>:
.globl vector12
vector12:
  pushl $12
  10208f:	6a 0c                	push   $0xc
  jmp __alltraps
  102091:	e9 05 0a 00 00       	jmp    102a9b <__alltraps>

00102096 <vector13>:
.globl vector13
vector13:
  pushl $13
  102096:	6a 0d                	push   $0xd
  jmp __alltraps
  102098:	e9 fe 09 00 00       	jmp    102a9b <__alltraps>

0010209d <vector14>:
.globl vector14
vector14:
  pushl $14
  10209d:	6a 0e                	push   $0xe
  jmp __alltraps
  10209f:	e9 f7 09 00 00       	jmp    102a9b <__alltraps>

001020a4 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $15
  1020a6:	6a 0f                	push   $0xf
  jmp __alltraps
  1020a8:	e9 ee 09 00 00       	jmp    102a9b <__alltraps>

001020ad <vector16>:
.globl vector16
vector16:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $16
  1020af:	6a 10                	push   $0x10
  jmp __alltraps
  1020b1:	e9 e5 09 00 00       	jmp    102a9b <__alltraps>

001020b6 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020b6:	6a 11                	push   $0x11
  jmp __alltraps
  1020b8:	e9 de 09 00 00       	jmp    102a9b <__alltraps>

001020bd <vector18>:
.globl vector18
vector18:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $18
  1020bf:	6a 12                	push   $0x12
  jmp __alltraps
  1020c1:	e9 d5 09 00 00       	jmp    102a9b <__alltraps>

001020c6 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $19
  1020c8:	6a 13                	push   $0x13
  jmp __alltraps
  1020ca:	e9 cc 09 00 00       	jmp    102a9b <__alltraps>

001020cf <vector20>:
.globl vector20
vector20:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $20
  1020d1:	6a 14                	push   $0x14
  jmp __alltraps
  1020d3:	e9 c3 09 00 00       	jmp    102a9b <__alltraps>

001020d8 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $21
  1020da:	6a 15                	push   $0x15
  jmp __alltraps
  1020dc:	e9 ba 09 00 00       	jmp    102a9b <__alltraps>

001020e1 <vector22>:
.globl vector22
vector22:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $22
  1020e3:	6a 16                	push   $0x16
  jmp __alltraps
  1020e5:	e9 b1 09 00 00       	jmp    102a9b <__alltraps>

001020ea <vector23>:
.globl vector23
vector23:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $23
  1020ec:	6a 17                	push   $0x17
  jmp __alltraps
  1020ee:	e9 a8 09 00 00       	jmp    102a9b <__alltraps>

001020f3 <vector24>:
.globl vector24
vector24:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $24
  1020f5:	6a 18                	push   $0x18
  jmp __alltraps
  1020f7:	e9 9f 09 00 00       	jmp    102a9b <__alltraps>

001020fc <vector25>:
.globl vector25
vector25:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $25
  1020fe:	6a 19                	push   $0x19
  jmp __alltraps
  102100:	e9 96 09 00 00       	jmp    102a9b <__alltraps>

00102105 <vector26>:
.globl vector26
vector26:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $26
  102107:	6a 1a                	push   $0x1a
  jmp __alltraps
  102109:	e9 8d 09 00 00       	jmp    102a9b <__alltraps>

0010210e <vector27>:
.globl vector27
vector27:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $27
  102110:	6a 1b                	push   $0x1b
  jmp __alltraps
  102112:	e9 84 09 00 00       	jmp    102a9b <__alltraps>

00102117 <vector28>:
.globl vector28
vector28:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $28
  102119:	6a 1c                	push   $0x1c
  jmp __alltraps
  10211b:	e9 7b 09 00 00       	jmp    102a9b <__alltraps>

00102120 <vector29>:
.globl vector29
vector29:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $29
  102122:	6a 1d                	push   $0x1d
  jmp __alltraps
  102124:	e9 72 09 00 00       	jmp    102a9b <__alltraps>

00102129 <vector30>:
.globl vector30
vector30:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $30
  10212b:	6a 1e                	push   $0x1e
  jmp __alltraps
  10212d:	e9 69 09 00 00       	jmp    102a9b <__alltraps>

00102132 <vector31>:
.globl vector31
vector31:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $31
  102134:	6a 1f                	push   $0x1f
  jmp __alltraps
  102136:	e9 60 09 00 00       	jmp    102a9b <__alltraps>

0010213b <vector32>:
.globl vector32
vector32:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $32
  10213d:	6a 20                	push   $0x20
  jmp __alltraps
  10213f:	e9 57 09 00 00       	jmp    102a9b <__alltraps>

00102144 <vector33>:
.globl vector33
vector33:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $33
  102146:	6a 21                	push   $0x21
  jmp __alltraps
  102148:	e9 4e 09 00 00       	jmp    102a9b <__alltraps>

0010214d <vector34>:
.globl vector34
vector34:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $34
  10214f:	6a 22                	push   $0x22
  jmp __alltraps
  102151:	e9 45 09 00 00       	jmp    102a9b <__alltraps>

00102156 <vector35>:
.globl vector35
vector35:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $35
  102158:	6a 23                	push   $0x23
  jmp __alltraps
  10215a:	e9 3c 09 00 00       	jmp    102a9b <__alltraps>

0010215f <vector36>:
.globl vector36
vector36:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $36
  102161:	6a 24                	push   $0x24
  jmp __alltraps
  102163:	e9 33 09 00 00       	jmp    102a9b <__alltraps>

00102168 <vector37>:
.globl vector37
vector37:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $37
  10216a:	6a 25                	push   $0x25
  jmp __alltraps
  10216c:	e9 2a 09 00 00       	jmp    102a9b <__alltraps>

00102171 <vector38>:
.globl vector38
vector38:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $38
  102173:	6a 26                	push   $0x26
  jmp __alltraps
  102175:	e9 21 09 00 00       	jmp    102a9b <__alltraps>

0010217a <vector39>:
.globl vector39
vector39:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $39
  10217c:	6a 27                	push   $0x27
  jmp __alltraps
  10217e:	e9 18 09 00 00       	jmp    102a9b <__alltraps>

00102183 <vector40>:
.globl vector40
vector40:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $40
  102185:	6a 28                	push   $0x28
  jmp __alltraps
  102187:	e9 0f 09 00 00       	jmp    102a9b <__alltraps>

0010218c <vector41>:
.globl vector41
vector41:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $41
  10218e:	6a 29                	push   $0x29
  jmp __alltraps
  102190:	e9 06 09 00 00       	jmp    102a9b <__alltraps>

00102195 <vector42>:
.globl vector42
vector42:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $42
  102197:	6a 2a                	push   $0x2a
  jmp __alltraps
  102199:	e9 fd 08 00 00       	jmp    102a9b <__alltraps>

0010219e <vector43>:
.globl vector43
vector43:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $43
  1021a0:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021a2:	e9 f4 08 00 00       	jmp    102a9b <__alltraps>

001021a7 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $44
  1021a9:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021ab:	e9 eb 08 00 00       	jmp    102a9b <__alltraps>

001021b0 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $45
  1021b2:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021b4:	e9 e2 08 00 00       	jmp    102a9b <__alltraps>

001021b9 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $46
  1021bb:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021bd:	e9 d9 08 00 00       	jmp    102a9b <__alltraps>

001021c2 <vector47>:
.globl vector47
vector47:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $47
  1021c4:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021c6:	e9 d0 08 00 00       	jmp    102a9b <__alltraps>

001021cb <vector48>:
.globl vector48
vector48:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $48
  1021cd:	6a 30                	push   $0x30
  jmp __alltraps
  1021cf:	e9 c7 08 00 00       	jmp    102a9b <__alltraps>

001021d4 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $49
  1021d6:	6a 31                	push   $0x31
  jmp __alltraps
  1021d8:	e9 be 08 00 00       	jmp    102a9b <__alltraps>

001021dd <vector50>:
.globl vector50
vector50:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $50
  1021df:	6a 32                	push   $0x32
  jmp __alltraps
  1021e1:	e9 b5 08 00 00       	jmp    102a9b <__alltraps>

001021e6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $51
  1021e8:	6a 33                	push   $0x33
  jmp __alltraps
  1021ea:	e9 ac 08 00 00       	jmp    102a9b <__alltraps>

001021ef <vector52>:
.globl vector52
vector52:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $52
  1021f1:	6a 34                	push   $0x34
  jmp __alltraps
  1021f3:	e9 a3 08 00 00       	jmp    102a9b <__alltraps>

001021f8 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $53
  1021fa:	6a 35                	push   $0x35
  jmp __alltraps
  1021fc:	e9 9a 08 00 00       	jmp    102a9b <__alltraps>

00102201 <vector54>:
.globl vector54
vector54:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $54
  102203:	6a 36                	push   $0x36
  jmp __alltraps
  102205:	e9 91 08 00 00       	jmp    102a9b <__alltraps>

0010220a <vector55>:
.globl vector55
vector55:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $55
  10220c:	6a 37                	push   $0x37
  jmp __alltraps
  10220e:	e9 88 08 00 00       	jmp    102a9b <__alltraps>

00102213 <vector56>:
.globl vector56
vector56:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $56
  102215:	6a 38                	push   $0x38
  jmp __alltraps
  102217:	e9 7f 08 00 00       	jmp    102a9b <__alltraps>

0010221c <vector57>:
.globl vector57
vector57:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $57
  10221e:	6a 39                	push   $0x39
  jmp __alltraps
  102220:	e9 76 08 00 00       	jmp    102a9b <__alltraps>

00102225 <vector58>:
.globl vector58
vector58:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $58
  102227:	6a 3a                	push   $0x3a
  jmp __alltraps
  102229:	e9 6d 08 00 00       	jmp    102a9b <__alltraps>

0010222e <vector59>:
.globl vector59
vector59:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $59
  102230:	6a 3b                	push   $0x3b
  jmp __alltraps
  102232:	e9 64 08 00 00       	jmp    102a9b <__alltraps>

00102237 <vector60>:
.globl vector60
vector60:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $60
  102239:	6a 3c                	push   $0x3c
  jmp __alltraps
  10223b:	e9 5b 08 00 00       	jmp    102a9b <__alltraps>

00102240 <vector61>:
.globl vector61
vector61:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $61
  102242:	6a 3d                	push   $0x3d
  jmp __alltraps
  102244:	e9 52 08 00 00       	jmp    102a9b <__alltraps>

00102249 <vector62>:
.globl vector62
vector62:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $62
  10224b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10224d:	e9 49 08 00 00       	jmp    102a9b <__alltraps>

00102252 <vector63>:
.globl vector63
vector63:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $63
  102254:	6a 3f                	push   $0x3f
  jmp __alltraps
  102256:	e9 40 08 00 00       	jmp    102a9b <__alltraps>

0010225b <vector64>:
.globl vector64
vector64:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $64
  10225d:	6a 40                	push   $0x40
  jmp __alltraps
  10225f:	e9 37 08 00 00       	jmp    102a9b <__alltraps>

00102264 <vector65>:
.globl vector65
vector65:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $65
  102266:	6a 41                	push   $0x41
  jmp __alltraps
  102268:	e9 2e 08 00 00       	jmp    102a9b <__alltraps>

0010226d <vector66>:
.globl vector66
vector66:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $66
  10226f:	6a 42                	push   $0x42
  jmp __alltraps
  102271:	e9 25 08 00 00       	jmp    102a9b <__alltraps>

00102276 <vector67>:
.globl vector67
vector67:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $67
  102278:	6a 43                	push   $0x43
  jmp __alltraps
  10227a:	e9 1c 08 00 00       	jmp    102a9b <__alltraps>

0010227f <vector68>:
.globl vector68
vector68:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $68
  102281:	6a 44                	push   $0x44
  jmp __alltraps
  102283:	e9 13 08 00 00       	jmp    102a9b <__alltraps>

00102288 <vector69>:
.globl vector69
vector69:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $69
  10228a:	6a 45                	push   $0x45
  jmp __alltraps
  10228c:	e9 0a 08 00 00       	jmp    102a9b <__alltraps>

00102291 <vector70>:
.globl vector70
vector70:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $70
  102293:	6a 46                	push   $0x46
  jmp __alltraps
  102295:	e9 01 08 00 00       	jmp    102a9b <__alltraps>

0010229a <vector71>:
.globl vector71
vector71:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $71
  10229c:	6a 47                	push   $0x47
  jmp __alltraps
  10229e:	e9 f8 07 00 00       	jmp    102a9b <__alltraps>

001022a3 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $72
  1022a5:	6a 48                	push   $0x48
  jmp __alltraps
  1022a7:	e9 ef 07 00 00       	jmp    102a9b <__alltraps>

001022ac <vector73>:
.globl vector73
vector73:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $73
  1022ae:	6a 49                	push   $0x49
  jmp __alltraps
  1022b0:	e9 e6 07 00 00       	jmp    102a9b <__alltraps>

001022b5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $74
  1022b7:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022b9:	e9 dd 07 00 00       	jmp    102a9b <__alltraps>

001022be <vector75>:
.globl vector75
vector75:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $75
  1022c0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022c2:	e9 d4 07 00 00       	jmp    102a9b <__alltraps>

001022c7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $76
  1022c9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022cb:	e9 cb 07 00 00       	jmp    102a9b <__alltraps>

001022d0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $77
  1022d2:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022d4:	e9 c2 07 00 00       	jmp    102a9b <__alltraps>

001022d9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $78
  1022db:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022dd:	e9 b9 07 00 00       	jmp    102a9b <__alltraps>

001022e2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $79
  1022e4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022e6:	e9 b0 07 00 00       	jmp    102a9b <__alltraps>

001022eb <vector80>:
.globl vector80
vector80:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $80
  1022ed:	6a 50                	push   $0x50
  jmp __alltraps
  1022ef:	e9 a7 07 00 00       	jmp    102a9b <__alltraps>

001022f4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $81
  1022f6:	6a 51                	push   $0x51
  jmp __alltraps
  1022f8:	e9 9e 07 00 00       	jmp    102a9b <__alltraps>

001022fd <vector82>:
.globl vector82
vector82:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $82
  1022ff:	6a 52                	push   $0x52
  jmp __alltraps
  102301:	e9 95 07 00 00       	jmp    102a9b <__alltraps>

00102306 <vector83>:
.globl vector83
vector83:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $83
  102308:	6a 53                	push   $0x53
  jmp __alltraps
  10230a:	e9 8c 07 00 00       	jmp    102a9b <__alltraps>

0010230f <vector84>:
.globl vector84
vector84:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $84
  102311:	6a 54                	push   $0x54
  jmp __alltraps
  102313:	e9 83 07 00 00       	jmp    102a9b <__alltraps>

00102318 <vector85>:
.globl vector85
vector85:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $85
  10231a:	6a 55                	push   $0x55
  jmp __alltraps
  10231c:	e9 7a 07 00 00       	jmp    102a9b <__alltraps>

00102321 <vector86>:
.globl vector86
vector86:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $86
  102323:	6a 56                	push   $0x56
  jmp __alltraps
  102325:	e9 71 07 00 00       	jmp    102a9b <__alltraps>

0010232a <vector87>:
.globl vector87
vector87:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $87
  10232c:	6a 57                	push   $0x57
  jmp __alltraps
  10232e:	e9 68 07 00 00       	jmp    102a9b <__alltraps>

00102333 <vector88>:
.globl vector88
vector88:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $88
  102335:	6a 58                	push   $0x58
  jmp __alltraps
  102337:	e9 5f 07 00 00       	jmp    102a9b <__alltraps>

0010233c <vector89>:
.globl vector89
vector89:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $89
  10233e:	6a 59                	push   $0x59
  jmp __alltraps
  102340:	e9 56 07 00 00       	jmp    102a9b <__alltraps>

00102345 <vector90>:
.globl vector90
vector90:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $90
  102347:	6a 5a                	push   $0x5a
  jmp __alltraps
  102349:	e9 4d 07 00 00       	jmp    102a9b <__alltraps>

0010234e <vector91>:
.globl vector91
vector91:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $91
  102350:	6a 5b                	push   $0x5b
  jmp __alltraps
  102352:	e9 44 07 00 00       	jmp    102a9b <__alltraps>

00102357 <vector92>:
.globl vector92
vector92:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $92
  102359:	6a 5c                	push   $0x5c
  jmp __alltraps
  10235b:	e9 3b 07 00 00       	jmp    102a9b <__alltraps>

00102360 <vector93>:
.globl vector93
vector93:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $93
  102362:	6a 5d                	push   $0x5d
  jmp __alltraps
  102364:	e9 32 07 00 00       	jmp    102a9b <__alltraps>

00102369 <vector94>:
.globl vector94
vector94:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $94
  10236b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10236d:	e9 29 07 00 00       	jmp    102a9b <__alltraps>

00102372 <vector95>:
.globl vector95
vector95:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $95
  102374:	6a 5f                	push   $0x5f
  jmp __alltraps
  102376:	e9 20 07 00 00       	jmp    102a9b <__alltraps>

0010237b <vector96>:
.globl vector96
vector96:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $96
  10237d:	6a 60                	push   $0x60
  jmp __alltraps
  10237f:	e9 17 07 00 00       	jmp    102a9b <__alltraps>

00102384 <vector97>:
.globl vector97
vector97:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $97
  102386:	6a 61                	push   $0x61
  jmp __alltraps
  102388:	e9 0e 07 00 00       	jmp    102a9b <__alltraps>

0010238d <vector98>:
.globl vector98
vector98:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $98
  10238f:	6a 62                	push   $0x62
  jmp __alltraps
  102391:	e9 05 07 00 00       	jmp    102a9b <__alltraps>

00102396 <vector99>:
.globl vector99
vector99:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $99
  102398:	6a 63                	push   $0x63
  jmp __alltraps
  10239a:	e9 fc 06 00 00       	jmp    102a9b <__alltraps>

0010239f <vector100>:
.globl vector100
vector100:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $100
  1023a1:	6a 64                	push   $0x64
  jmp __alltraps
  1023a3:	e9 f3 06 00 00       	jmp    102a9b <__alltraps>

001023a8 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $101
  1023aa:	6a 65                	push   $0x65
  jmp __alltraps
  1023ac:	e9 ea 06 00 00       	jmp    102a9b <__alltraps>

001023b1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $102
  1023b3:	6a 66                	push   $0x66
  jmp __alltraps
  1023b5:	e9 e1 06 00 00       	jmp    102a9b <__alltraps>

001023ba <vector103>:
.globl vector103
vector103:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $103
  1023bc:	6a 67                	push   $0x67
  jmp __alltraps
  1023be:	e9 d8 06 00 00       	jmp    102a9b <__alltraps>

001023c3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $104
  1023c5:	6a 68                	push   $0x68
  jmp __alltraps
  1023c7:	e9 cf 06 00 00       	jmp    102a9b <__alltraps>

001023cc <vector105>:
.globl vector105
vector105:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $105
  1023ce:	6a 69                	push   $0x69
  jmp __alltraps
  1023d0:	e9 c6 06 00 00       	jmp    102a9b <__alltraps>

001023d5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $106
  1023d7:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023d9:	e9 bd 06 00 00       	jmp    102a9b <__alltraps>

001023de <vector107>:
.globl vector107
vector107:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $107
  1023e0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023e2:	e9 b4 06 00 00       	jmp    102a9b <__alltraps>

001023e7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $108
  1023e9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023eb:	e9 ab 06 00 00       	jmp    102a9b <__alltraps>

001023f0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $109
  1023f2:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023f4:	e9 a2 06 00 00       	jmp    102a9b <__alltraps>

001023f9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $110
  1023fb:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023fd:	e9 99 06 00 00       	jmp    102a9b <__alltraps>

00102402 <vector111>:
.globl vector111
vector111:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $111
  102404:	6a 6f                	push   $0x6f
  jmp __alltraps
  102406:	e9 90 06 00 00       	jmp    102a9b <__alltraps>

0010240b <vector112>:
.globl vector112
vector112:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $112
  10240d:	6a 70                	push   $0x70
  jmp __alltraps
  10240f:	e9 87 06 00 00       	jmp    102a9b <__alltraps>

00102414 <vector113>:
.globl vector113
vector113:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $113
  102416:	6a 71                	push   $0x71
  jmp __alltraps
  102418:	e9 7e 06 00 00       	jmp    102a9b <__alltraps>

0010241d <vector114>:
.globl vector114
vector114:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $114
  10241f:	6a 72                	push   $0x72
  jmp __alltraps
  102421:	e9 75 06 00 00       	jmp    102a9b <__alltraps>

00102426 <vector115>:
.globl vector115
vector115:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $115
  102428:	6a 73                	push   $0x73
  jmp __alltraps
  10242a:	e9 6c 06 00 00       	jmp    102a9b <__alltraps>

0010242f <vector116>:
.globl vector116
vector116:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $116
  102431:	6a 74                	push   $0x74
  jmp __alltraps
  102433:	e9 63 06 00 00       	jmp    102a9b <__alltraps>

00102438 <vector117>:
.globl vector117
vector117:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $117
  10243a:	6a 75                	push   $0x75
  jmp __alltraps
  10243c:	e9 5a 06 00 00       	jmp    102a9b <__alltraps>

00102441 <vector118>:
.globl vector118
vector118:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $118
  102443:	6a 76                	push   $0x76
  jmp __alltraps
  102445:	e9 51 06 00 00       	jmp    102a9b <__alltraps>

0010244a <vector119>:
.globl vector119
vector119:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $119
  10244c:	6a 77                	push   $0x77
  jmp __alltraps
  10244e:	e9 48 06 00 00       	jmp    102a9b <__alltraps>

00102453 <vector120>:
.globl vector120
vector120:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $120
  102455:	6a 78                	push   $0x78
  jmp __alltraps
  102457:	e9 3f 06 00 00       	jmp    102a9b <__alltraps>

0010245c <vector121>:
.globl vector121
vector121:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $121
  10245e:	6a 79                	push   $0x79
  jmp __alltraps
  102460:	e9 36 06 00 00       	jmp    102a9b <__alltraps>

00102465 <vector122>:
.globl vector122
vector122:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $122
  102467:	6a 7a                	push   $0x7a
  jmp __alltraps
  102469:	e9 2d 06 00 00       	jmp    102a9b <__alltraps>

0010246e <vector123>:
.globl vector123
vector123:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $123
  102470:	6a 7b                	push   $0x7b
  jmp __alltraps
  102472:	e9 24 06 00 00       	jmp    102a9b <__alltraps>

00102477 <vector124>:
.globl vector124
vector124:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $124
  102479:	6a 7c                	push   $0x7c
  jmp __alltraps
  10247b:	e9 1b 06 00 00       	jmp    102a9b <__alltraps>

00102480 <vector125>:
.globl vector125
vector125:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $125
  102482:	6a 7d                	push   $0x7d
  jmp __alltraps
  102484:	e9 12 06 00 00       	jmp    102a9b <__alltraps>

00102489 <vector126>:
.globl vector126
vector126:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $126
  10248b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10248d:	e9 09 06 00 00       	jmp    102a9b <__alltraps>

00102492 <vector127>:
.globl vector127
vector127:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $127
  102494:	6a 7f                	push   $0x7f
  jmp __alltraps
  102496:	e9 00 06 00 00       	jmp    102a9b <__alltraps>

0010249b <vector128>:
.globl vector128
vector128:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $128
  10249d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024a2:	e9 f4 05 00 00       	jmp    102a9b <__alltraps>

001024a7 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $129
  1024a9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024ae:	e9 e8 05 00 00       	jmp    102a9b <__alltraps>

001024b3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $130
  1024b5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024ba:	e9 dc 05 00 00       	jmp    102a9b <__alltraps>

001024bf <vector131>:
.globl vector131
vector131:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $131
  1024c1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024c6:	e9 d0 05 00 00       	jmp    102a9b <__alltraps>

001024cb <vector132>:
.globl vector132
vector132:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $132
  1024cd:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024d2:	e9 c4 05 00 00       	jmp    102a9b <__alltraps>

001024d7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $133
  1024d9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024de:	e9 b8 05 00 00       	jmp    102a9b <__alltraps>

001024e3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $134
  1024e5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024ea:	e9 ac 05 00 00       	jmp    102a9b <__alltraps>

001024ef <vector135>:
.globl vector135
vector135:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $135
  1024f1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024f6:	e9 a0 05 00 00       	jmp    102a9b <__alltraps>

001024fb <vector136>:
.globl vector136
vector136:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $136
  1024fd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102502:	e9 94 05 00 00       	jmp    102a9b <__alltraps>

00102507 <vector137>:
.globl vector137
vector137:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $137
  102509:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10250e:	e9 88 05 00 00       	jmp    102a9b <__alltraps>

00102513 <vector138>:
.globl vector138
vector138:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $138
  102515:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10251a:	e9 7c 05 00 00       	jmp    102a9b <__alltraps>

0010251f <vector139>:
.globl vector139
vector139:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $139
  102521:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102526:	e9 70 05 00 00       	jmp    102a9b <__alltraps>

0010252b <vector140>:
.globl vector140
vector140:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $140
  10252d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102532:	e9 64 05 00 00       	jmp    102a9b <__alltraps>

00102537 <vector141>:
.globl vector141
vector141:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $141
  102539:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10253e:	e9 58 05 00 00       	jmp    102a9b <__alltraps>

00102543 <vector142>:
.globl vector142
vector142:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $142
  102545:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10254a:	e9 4c 05 00 00       	jmp    102a9b <__alltraps>

0010254f <vector143>:
.globl vector143
vector143:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $143
  102551:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102556:	e9 40 05 00 00       	jmp    102a9b <__alltraps>

0010255b <vector144>:
.globl vector144
vector144:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $144
  10255d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102562:	e9 34 05 00 00       	jmp    102a9b <__alltraps>

00102567 <vector145>:
.globl vector145
vector145:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $145
  102569:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10256e:	e9 28 05 00 00       	jmp    102a9b <__alltraps>

00102573 <vector146>:
.globl vector146
vector146:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $146
  102575:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10257a:	e9 1c 05 00 00       	jmp    102a9b <__alltraps>

0010257f <vector147>:
.globl vector147
vector147:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $147
  102581:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102586:	e9 10 05 00 00       	jmp    102a9b <__alltraps>

0010258b <vector148>:
.globl vector148
vector148:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $148
  10258d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102592:	e9 04 05 00 00       	jmp    102a9b <__alltraps>

00102597 <vector149>:
.globl vector149
vector149:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $149
  102599:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10259e:	e9 f8 04 00 00       	jmp    102a9b <__alltraps>

001025a3 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $150
  1025a5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025aa:	e9 ec 04 00 00       	jmp    102a9b <__alltraps>

001025af <vector151>:
.globl vector151
vector151:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $151
  1025b1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025b6:	e9 e0 04 00 00       	jmp    102a9b <__alltraps>

001025bb <vector152>:
.globl vector152
vector152:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $152
  1025bd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025c2:	e9 d4 04 00 00       	jmp    102a9b <__alltraps>

001025c7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $153
  1025c9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025ce:	e9 c8 04 00 00       	jmp    102a9b <__alltraps>

001025d3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $154
  1025d5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025da:	e9 bc 04 00 00       	jmp    102a9b <__alltraps>

001025df <vector155>:
.globl vector155
vector155:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $155
  1025e1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025e6:	e9 b0 04 00 00       	jmp    102a9b <__alltraps>

001025eb <vector156>:
.globl vector156
vector156:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $156
  1025ed:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025f2:	e9 a4 04 00 00       	jmp    102a9b <__alltraps>

001025f7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $157
  1025f9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025fe:	e9 98 04 00 00       	jmp    102a9b <__alltraps>

00102603 <vector158>:
.globl vector158
vector158:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $158
  102605:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10260a:	e9 8c 04 00 00       	jmp    102a9b <__alltraps>

0010260f <vector159>:
.globl vector159
vector159:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $159
  102611:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102616:	e9 80 04 00 00       	jmp    102a9b <__alltraps>

0010261b <vector160>:
.globl vector160
vector160:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $160
  10261d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102622:	e9 74 04 00 00       	jmp    102a9b <__alltraps>

00102627 <vector161>:
.globl vector161
vector161:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $161
  102629:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10262e:	e9 68 04 00 00       	jmp    102a9b <__alltraps>

00102633 <vector162>:
.globl vector162
vector162:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $162
  102635:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10263a:	e9 5c 04 00 00       	jmp    102a9b <__alltraps>

0010263f <vector163>:
.globl vector163
vector163:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $163
  102641:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102646:	e9 50 04 00 00       	jmp    102a9b <__alltraps>

0010264b <vector164>:
.globl vector164
vector164:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $164
  10264d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102652:	e9 44 04 00 00       	jmp    102a9b <__alltraps>

00102657 <vector165>:
.globl vector165
vector165:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $165
  102659:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10265e:	e9 38 04 00 00       	jmp    102a9b <__alltraps>

00102663 <vector166>:
.globl vector166
vector166:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $166
  102665:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10266a:	e9 2c 04 00 00       	jmp    102a9b <__alltraps>

0010266f <vector167>:
.globl vector167
vector167:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $167
  102671:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102676:	e9 20 04 00 00       	jmp    102a9b <__alltraps>

0010267b <vector168>:
.globl vector168
vector168:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $168
  10267d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102682:	e9 14 04 00 00       	jmp    102a9b <__alltraps>

00102687 <vector169>:
.globl vector169
vector169:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $169
  102689:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10268e:	e9 08 04 00 00       	jmp    102a9b <__alltraps>

00102693 <vector170>:
.globl vector170
vector170:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $170
  102695:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10269a:	e9 fc 03 00 00       	jmp    102a9b <__alltraps>

0010269f <vector171>:
.globl vector171
vector171:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $171
  1026a1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026a6:	e9 f0 03 00 00       	jmp    102a9b <__alltraps>

001026ab <vector172>:
.globl vector172
vector172:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $172
  1026ad:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026b2:	e9 e4 03 00 00       	jmp    102a9b <__alltraps>

001026b7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $173
  1026b9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026be:	e9 d8 03 00 00       	jmp    102a9b <__alltraps>

001026c3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $174
  1026c5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026ca:	e9 cc 03 00 00       	jmp    102a9b <__alltraps>

001026cf <vector175>:
.globl vector175
vector175:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $175
  1026d1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026d6:	e9 c0 03 00 00       	jmp    102a9b <__alltraps>

001026db <vector176>:
.globl vector176
vector176:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $176
  1026dd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026e2:	e9 b4 03 00 00       	jmp    102a9b <__alltraps>

001026e7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $177
  1026e9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026ee:	e9 a8 03 00 00       	jmp    102a9b <__alltraps>

001026f3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $178
  1026f5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026fa:	e9 9c 03 00 00       	jmp    102a9b <__alltraps>

001026ff <vector179>:
.globl vector179
vector179:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $179
  102701:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102706:	e9 90 03 00 00       	jmp    102a9b <__alltraps>

0010270b <vector180>:
.globl vector180
vector180:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $180
  10270d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102712:	e9 84 03 00 00       	jmp    102a9b <__alltraps>

00102717 <vector181>:
.globl vector181
vector181:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $181
  102719:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10271e:	e9 78 03 00 00       	jmp    102a9b <__alltraps>

00102723 <vector182>:
.globl vector182
vector182:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $182
  102725:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10272a:	e9 6c 03 00 00       	jmp    102a9b <__alltraps>

0010272f <vector183>:
.globl vector183
vector183:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $183
  102731:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102736:	e9 60 03 00 00       	jmp    102a9b <__alltraps>

0010273b <vector184>:
.globl vector184
vector184:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $184
  10273d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102742:	e9 54 03 00 00       	jmp    102a9b <__alltraps>

00102747 <vector185>:
.globl vector185
vector185:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $185
  102749:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10274e:	e9 48 03 00 00       	jmp    102a9b <__alltraps>

00102753 <vector186>:
.globl vector186
vector186:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $186
  102755:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10275a:	e9 3c 03 00 00       	jmp    102a9b <__alltraps>

0010275f <vector187>:
.globl vector187
vector187:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $187
  102761:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102766:	e9 30 03 00 00       	jmp    102a9b <__alltraps>

0010276b <vector188>:
.globl vector188
vector188:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $188
  10276d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102772:	e9 24 03 00 00       	jmp    102a9b <__alltraps>

00102777 <vector189>:
.globl vector189
vector189:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $189
  102779:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10277e:	e9 18 03 00 00       	jmp    102a9b <__alltraps>

00102783 <vector190>:
.globl vector190
vector190:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $190
  102785:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10278a:	e9 0c 03 00 00       	jmp    102a9b <__alltraps>

0010278f <vector191>:
.globl vector191
vector191:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $191
  102791:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102796:	e9 00 03 00 00       	jmp    102a9b <__alltraps>

0010279b <vector192>:
.globl vector192
vector192:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $192
  10279d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027a2:	e9 f4 02 00 00       	jmp    102a9b <__alltraps>

001027a7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $193
  1027a9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027ae:	e9 e8 02 00 00       	jmp    102a9b <__alltraps>

001027b3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $194
  1027b5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027ba:	e9 dc 02 00 00       	jmp    102a9b <__alltraps>

001027bf <vector195>:
.globl vector195
vector195:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $195
  1027c1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027c6:	e9 d0 02 00 00       	jmp    102a9b <__alltraps>

001027cb <vector196>:
.globl vector196
vector196:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $196
  1027cd:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027d2:	e9 c4 02 00 00       	jmp    102a9b <__alltraps>

001027d7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $197
  1027d9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027de:	e9 b8 02 00 00       	jmp    102a9b <__alltraps>

001027e3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $198
  1027e5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027ea:	e9 ac 02 00 00       	jmp    102a9b <__alltraps>

001027ef <vector199>:
.globl vector199
vector199:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $199
  1027f1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027f6:	e9 a0 02 00 00       	jmp    102a9b <__alltraps>

001027fb <vector200>:
.globl vector200
vector200:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $200
  1027fd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102802:	e9 94 02 00 00       	jmp    102a9b <__alltraps>

00102807 <vector201>:
.globl vector201
vector201:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $201
  102809:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10280e:	e9 88 02 00 00       	jmp    102a9b <__alltraps>

00102813 <vector202>:
.globl vector202
vector202:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $202
  102815:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10281a:	e9 7c 02 00 00       	jmp    102a9b <__alltraps>

0010281f <vector203>:
.globl vector203
vector203:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $203
  102821:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102826:	e9 70 02 00 00       	jmp    102a9b <__alltraps>

0010282b <vector204>:
.globl vector204
vector204:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $204
  10282d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102832:	e9 64 02 00 00       	jmp    102a9b <__alltraps>

00102837 <vector205>:
.globl vector205
vector205:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $205
  102839:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10283e:	e9 58 02 00 00       	jmp    102a9b <__alltraps>

00102843 <vector206>:
.globl vector206
vector206:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $206
  102845:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10284a:	e9 4c 02 00 00       	jmp    102a9b <__alltraps>

0010284f <vector207>:
.globl vector207
vector207:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $207
  102851:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102856:	e9 40 02 00 00       	jmp    102a9b <__alltraps>

0010285b <vector208>:
.globl vector208
vector208:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $208
  10285d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102862:	e9 34 02 00 00       	jmp    102a9b <__alltraps>

00102867 <vector209>:
.globl vector209
vector209:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $209
  102869:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10286e:	e9 28 02 00 00       	jmp    102a9b <__alltraps>

00102873 <vector210>:
.globl vector210
vector210:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $210
  102875:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10287a:	e9 1c 02 00 00       	jmp    102a9b <__alltraps>

0010287f <vector211>:
.globl vector211
vector211:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $211
  102881:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102886:	e9 10 02 00 00       	jmp    102a9b <__alltraps>

0010288b <vector212>:
.globl vector212
vector212:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $212
  10288d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102892:	e9 04 02 00 00       	jmp    102a9b <__alltraps>

00102897 <vector213>:
.globl vector213
vector213:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $213
  102899:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10289e:	e9 f8 01 00 00       	jmp    102a9b <__alltraps>

001028a3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $214
  1028a5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028aa:	e9 ec 01 00 00       	jmp    102a9b <__alltraps>

001028af <vector215>:
.globl vector215
vector215:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $215
  1028b1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028b6:	e9 e0 01 00 00       	jmp    102a9b <__alltraps>

001028bb <vector216>:
.globl vector216
vector216:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $216
  1028bd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028c2:	e9 d4 01 00 00       	jmp    102a9b <__alltraps>

001028c7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $217
  1028c9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028ce:	e9 c8 01 00 00       	jmp    102a9b <__alltraps>

001028d3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $218
  1028d5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028da:	e9 bc 01 00 00       	jmp    102a9b <__alltraps>

001028df <vector219>:
.globl vector219
vector219:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $219
  1028e1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028e6:	e9 b0 01 00 00       	jmp    102a9b <__alltraps>

001028eb <vector220>:
.globl vector220
vector220:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $220
  1028ed:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028f2:	e9 a4 01 00 00       	jmp    102a9b <__alltraps>

001028f7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $221
  1028f9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028fe:	e9 98 01 00 00       	jmp    102a9b <__alltraps>

00102903 <vector222>:
.globl vector222
vector222:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $222
  102905:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10290a:	e9 8c 01 00 00       	jmp    102a9b <__alltraps>

0010290f <vector223>:
.globl vector223
vector223:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $223
  102911:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102916:	e9 80 01 00 00       	jmp    102a9b <__alltraps>

0010291b <vector224>:
.globl vector224
vector224:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $224
  10291d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102922:	e9 74 01 00 00       	jmp    102a9b <__alltraps>

00102927 <vector225>:
.globl vector225
vector225:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $225
  102929:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10292e:	e9 68 01 00 00       	jmp    102a9b <__alltraps>

00102933 <vector226>:
.globl vector226
vector226:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $226
  102935:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10293a:	e9 5c 01 00 00       	jmp    102a9b <__alltraps>

0010293f <vector227>:
.globl vector227
vector227:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $227
  102941:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102946:	e9 50 01 00 00       	jmp    102a9b <__alltraps>

0010294b <vector228>:
.globl vector228
vector228:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $228
  10294d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102952:	e9 44 01 00 00       	jmp    102a9b <__alltraps>

00102957 <vector229>:
.globl vector229
vector229:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $229
  102959:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10295e:	e9 38 01 00 00       	jmp    102a9b <__alltraps>

00102963 <vector230>:
.globl vector230
vector230:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $230
  102965:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10296a:	e9 2c 01 00 00       	jmp    102a9b <__alltraps>

0010296f <vector231>:
.globl vector231
vector231:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $231
  102971:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102976:	e9 20 01 00 00       	jmp    102a9b <__alltraps>

0010297b <vector232>:
.globl vector232
vector232:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $232
  10297d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102982:	e9 14 01 00 00       	jmp    102a9b <__alltraps>

00102987 <vector233>:
.globl vector233
vector233:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $233
  102989:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10298e:	e9 08 01 00 00       	jmp    102a9b <__alltraps>

00102993 <vector234>:
.globl vector234
vector234:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $234
  102995:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10299a:	e9 fc 00 00 00       	jmp    102a9b <__alltraps>

0010299f <vector235>:
.globl vector235
vector235:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $235
  1029a1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029a6:	e9 f0 00 00 00       	jmp    102a9b <__alltraps>

001029ab <vector236>:
.globl vector236
vector236:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $236
  1029ad:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029b2:	e9 e4 00 00 00       	jmp    102a9b <__alltraps>

001029b7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $237
  1029b9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029be:	e9 d8 00 00 00       	jmp    102a9b <__alltraps>

001029c3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $238
  1029c5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029ca:	e9 cc 00 00 00       	jmp    102a9b <__alltraps>

001029cf <vector239>:
.globl vector239
vector239:
  pushl $0
  1029cf:	6a 00                	push   $0x0
  pushl $239
  1029d1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029d6:	e9 c0 00 00 00       	jmp    102a9b <__alltraps>

001029db <vector240>:
.globl vector240
vector240:
  pushl $0
  1029db:	6a 00                	push   $0x0
  pushl $240
  1029dd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029e2:	e9 b4 00 00 00       	jmp    102a9b <__alltraps>

001029e7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029e7:	6a 00                	push   $0x0
  pushl $241
  1029e9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029ee:	e9 a8 00 00 00       	jmp    102a9b <__alltraps>

001029f3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1029f3:	6a 00                	push   $0x0
  pushl $242
  1029f5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029fa:	e9 9c 00 00 00       	jmp    102a9b <__alltraps>

001029ff <vector243>:
.globl vector243
vector243:
  pushl $0
  1029ff:	6a 00                	push   $0x0
  pushl $243
  102a01:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a06:	e9 90 00 00 00       	jmp    102a9b <__alltraps>

00102a0b <vector244>:
.globl vector244
vector244:
  pushl $0
  102a0b:	6a 00                	push   $0x0
  pushl $244
  102a0d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a12:	e9 84 00 00 00       	jmp    102a9b <__alltraps>

00102a17 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a17:	6a 00                	push   $0x0
  pushl $245
  102a19:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a1e:	e9 78 00 00 00       	jmp    102a9b <__alltraps>

00102a23 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a23:	6a 00                	push   $0x0
  pushl $246
  102a25:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a2a:	e9 6c 00 00 00       	jmp    102a9b <__alltraps>

00102a2f <vector247>:
.globl vector247
vector247:
  pushl $0
  102a2f:	6a 00                	push   $0x0
  pushl $247
  102a31:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a36:	e9 60 00 00 00       	jmp    102a9b <__alltraps>

00102a3b <vector248>:
.globl vector248
vector248:
  pushl $0
  102a3b:	6a 00                	push   $0x0
  pushl $248
  102a3d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a42:	e9 54 00 00 00       	jmp    102a9b <__alltraps>

00102a47 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a47:	6a 00                	push   $0x0
  pushl $249
  102a49:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a4e:	e9 48 00 00 00       	jmp    102a9b <__alltraps>

00102a53 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a53:	6a 00                	push   $0x0
  pushl $250
  102a55:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a5a:	e9 3c 00 00 00       	jmp    102a9b <__alltraps>

00102a5f <vector251>:
.globl vector251
vector251:
  pushl $0
  102a5f:	6a 00                	push   $0x0
  pushl $251
  102a61:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a66:	e9 30 00 00 00       	jmp    102a9b <__alltraps>

00102a6b <vector252>:
.globl vector252
vector252:
  pushl $0
  102a6b:	6a 00                	push   $0x0
  pushl $252
  102a6d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a72:	e9 24 00 00 00       	jmp    102a9b <__alltraps>

00102a77 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a77:	6a 00                	push   $0x0
  pushl $253
  102a79:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a7e:	e9 18 00 00 00       	jmp    102a9b <__alltraps>

00102a83 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a83:	6a 00                	push   $0x0
  pushl $254
  102a85:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a8a:	e9 0c 00 00 00       	jmp    102a9b <__alltraps>

00102a8f <vector255>:
.globl vector255
vector255:
  pushl $0
  102a8f:	6a 00                	push   $0x0
  pushl $255
  102a91:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a96:	e9 00 00 00 00       	jmp    102a9b <__alltraps>

00102a9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a9b:	1e                   	push   %ds
    pushl %es
  102a9c:	06                   	push   %es
    pushl %fs
  102a9d:	0f a0                	push   %fs
    pushl %gs
  102a9f:	0f a8                	push   %gs
    pushal
  102aa1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102aa2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102aa7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102aa9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102aab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102aac:	e8 60 f5 ff ff       	call   102011 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ab1:	5c                   	pop    %esp

00102ab2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ab2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ab3:	0f a9                	pop    %gs
    popl %fs
  102ab5:	0f a1                	pop    %fs
    popl %es
  102ab7:	07                   	pop    %es
    popl %ds
  102ab8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ab9:	83 c4 08             	add    $0x8,%esp
    iret
  102abc:	cf                   	iret   

00102abd <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102abd:	55                   	push   %ebp
  102abe:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ac6:	b8 23 00 00 00       	mov    $0x23,%eax
  102acb:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102acd:	b8 23 00 00 00       	mov    $0x23,%eax
  102ad2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ad4:	b8 10 00 00 00       	mov    $0x10,%eax
  102ad9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102adb:	b8 10 00 00 00       	mov    $0x10,%eax
  102ae0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102ae2:	b8 10 00 00 00       	mov    $0x10,%eax
  102ae7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ae9:	ea f0 2a 10 00 08 00 	ljmp   $0x8,$0x102af0
}
  102af0:	90                   	nop
  102af1:	5d                   	pop    %ebp
  102af2:	c3                   	ret    

00102af3 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102af3:	f3 0f 1e fb          	endbr32 
  102af7:	55                   	push   %ebp
  102af8:	89 e5                	mov    %esp,%ebp
  102afa:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102afd:	b8 80 09 11 00       	mov    $0x110980,%eax
  102b02:	05 00 04 00 00       	add    $0x400,%eax
  102b07:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  102b0c:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102b13:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b15:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102b1c:	68 00 
  102b1e:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102b23:	0f b7 c0             	movzwl %ax,%eax
  102b26:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102b2c:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102b31:	c1 e8 10             	shr    $0x10,%eax
  102b34:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102b39:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b40:	24 f0                	and    $0xf0,%al
  102b42:	0c 09                	or     $0x9,%al
  102b44:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b49:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b50:	0c 10                	or     $0x10,%al
  102b52:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b57:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b5e:	24 9f                	and    $0x9f,%al
  102b60:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b65:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b6c:	0c 80                	or     $0x80,%al
  102b6e:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b73:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b7a:	24 f0                	and    $0xf0,%al
  102b7c:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b81:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b88:	24 ef                	and    $0xef,%al
  102b8a:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b8f:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b96:	24 df                	and    $0xdf,%al
  102b98:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b9d:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ba4:	0c 40                	or     $0x40,%al
  102ba6:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102bab:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102bb2:	24 7f                	and    $0x7f,%al
  102bb4:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102bb9:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102bbe:	c1 e8 18             	shr    $0x18,%eax
  102bc1:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102bc6:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bcd:	24 ef                	and    $0xef,%al
  102bcf:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102bd4:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102bdb:	e8 dd fe ff ff       	call   102abd <lgdt>
  102be0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102be6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bea:	0f 00 d8             	ltr    %ax
}
  102bed:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bee:	90                   	nop
  102bef:	c9                   	leave  
  102bf0:	c3                   	ret    

00102bf1 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bf1:	f3 0f 1e fb          	endbr32 
  102bf5:	55                   	push   %ebp
  102bf6:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102bf8:	e8 f6 fe ff ff       	call   102af3 <gdt_init>
}
  102bfd:	90                   	nop
  102bfe:	5d                   	pop    %ebp
  102bff:	c3                   	ret    

00102c00 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c00:	f3 0f 1e fb          	endbr32 
  102c04:	55                   	push   %ebp
  102c05:	89 e5                	mov    %esp,%ebp
  102c07:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c11:	eb 03                	jmp    102c16 <strlen+0x16>
        cnt ++;
  102c13:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c16:	8b 45 08             	mov    0x8(%ebp),%eax
  102c19:	8d 50 01             	lea    0x1(%eax),%edx
  102c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  102c1f:	0f b6 00             	movzbl (%eax),%eax
  102c22:	84 c0                	test   %al,%al
  102c24:	75 ed                	jne    102c13 <strlen+0x13>
    }
    return cnt;
  102c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c29:	c9                   	leave  
  102c2a:	c3                   	ret    

00102c2b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c2b:	f3 0f 1e fb          	endbr32 
  102c2f:	55                   	push   %ebp
  102c30:	89 e5                	mov    %esp,%ebp
  102c32:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c3c:	eb 03                	jmp    102c41 <strnlen+0x16>
        cnt ++;
  102c3e:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c44:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c47:	73 10                	jae    102c59 <strnlen+0x2e>
  102c49:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4c:	8d 50 01             	lea    0x1(%eax),%edx
  102c4f:	89 55 08             	mov    %edx,0x8(%ebp)
  102c52:	0f b6 00             	movzbl (%eax),%eax
  102c55:	84 c0                	test   %al,%al
  102c57:	75 e5                	jne    102c3e <strnlen+0x13>
    }
    return cnt;
  102c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c5c:	c9                   	leave  
  102c5d:	c3                   	ret    

00102c5e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c5e:	f3 0f 1e fb          	endbr32 
  102c62:	55                   	push   %ebp
  102c63:	89 e5                	mov    %esp,%ebp
  102c65:	57                   	push   %edi
  102c66:	56                   	push   %esi
  102c67:	83 ec 20             	sub    $0x20,%esp
  102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c7c:	89 d1                	mov    %edx,%ecx
  102c7e:	89 c2                	mov    %eax,%edx
  102c80:	89 ce                	mov    %ecx,%esi
  102c82:	89 d7                	mov    %edx,%edi
  102c84:	ac                   	lods   %ds:(%esi),%al
  102c85:	aa                   	stos   %al,%es:(%edi)
  102c86:	84 c0                	test   %al,%al
  102c88:	75 fa                	jne    102c84 <strcpy+0x26>
  102c8a:	89 fa                	mov    %edi,%edx
  102c8c:	89 f1                	mov    %esi,%ecx
  102c8e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c91:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c9a:	83 c4 20             	add    $0x20,%esp
  102c9d:	5e                   	pop    %esi
  102c9e:	5f                   	pop    %edi
  102c9f:	5d                   	pop    %ebp
  102ca0:	c3                   	ret    

00102ca1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102ca1:	f3 0f 1e fb          	endbr32 
  102ca5:	55                   	push   %ebp
  102ca6:	89 e5                	mov    %esp,%ebp
  102ca8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102cab:	8b 45 08             	mov    0x8(%ebp),%eax
  102cae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102cb1:	eb 1e                	jmp    102cd1 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb6:	0f b6 10             	movzbl (%eax),%edx
  102cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cbc:	88 10                	mov    %dl,(%eax)
  102cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cc1:	0f b6 00             	movzbl (%eax),%eax
  102cc4:	84 c0                	test   %al,%al
  102cc6:	74 03                	je     102ccb <strncpy+0x2a>
            src ++;
  102cc8:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102ccb:	ff 45 fc             	incl   -0x4(%ebp)
  102cce:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cd5:	75 dc                	jne    102cb3 <strncpy+0x12>
    }
    return dst;
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cda:	c9                   	leave  
  102cdb:	c3                   	ret    

00102cdc <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102cdc:	f3 0f 1e fb          	endbr32 
  102ce0:	55                   	push   %ebp
  102ce1:	89 e5                	mov    %esp,%ebp
  102ce3:	57                   	push   %edi
  102ce4:	56                   	push   %esi
  102ce5:	83 ec 20             	sub    $0x20,%esp
  102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfa:	89 d1                	mov    %edx,%ecx
  102cfc:	89 c2                	mov    %eax,%edx
  102cfe:	89 ce                	mov    %ecx,%esi
  102d00:	89 d7                	mov    %edx,%edi
  102d02:	ac                   	lods   %ds:(%esi),%al
  102d03:	ae                   	scas   %es:(%edi),%al
  102d04:	75 08                	jne    102d0e <strcmp+0x32>
  102d06:	84 c0                	test   %al,%al
  102d08:	75 f8                	jne    102d02 <strcmp+0x26>
  102d0a:	31 c0                	xor    %eax,%eax
  102d0c:	eb 04                	jmp    102d12 <strcmp+0x36>
  102d0e:	19 c0                	sbb    %eax,%eax
  102d10:	0c 01                	or     $0x1,%al
  102d12:	89 fa                	mov    %edi,%edx
  102d14:	89 f1                	mov    %esi,%ecx
  102d16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d19:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d1c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d22:	83 c4 20             	add    $0x20,%esp
  102d25:	5e                   	pop    %esi
  102d26:	5f                   	pop    %edi
  102d27:	5d                   	pop    %ebp
  102d28:	c3                   	ret    

00102d29 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d29:	f3 0f 1e fb          	endbr32 
  102d2d:	55                   	push   %ebp
  102d2e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d30:	eb 09                	jmp    102d3b <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d32:	ff 4d 10             	decl   0x10(%ebp)
  102d35:	ff 45 08             	incl   0x8(%ebp)
  102d38:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d3f:	74 1a                	je     102d5b <strncmp+0x32>
  102d41:	8b 45 08             	mov    0x8(%ebp),%eax
  102d44:	0f b6 00             	movzbl (%eax),%eax
  102d47:	84 c0                	test   %al,%al
  102d49:	74 10                	je     102d5b <strncmp+0x32>
  102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4e:	0f b6 10             	movzbl (%eax),%edx
  102d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d54:	0f b6 00             	movzbl (%eax),%eax
  102d57:	38 c2                	cmp    %al,%dl
  102d59:	74 d7                	je     102d32 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d5f:	74 18                	je     102d79 <strncmp+0x50>
  102d61:	8b 45 08             	mov    0x8(%ebp),%eax
  102d64:	0f b6 00             	movzbl (%eax),%eax
  102d67:	0f b6 d0             	movzbl %al,%edx
  102d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d6d:	0f b6 00             	movzbl (%eax),%eax
  102d70:	0f b6 c0             	movzbl %al,%eax
  102d73:	29 c2                	sub    %eax,%edx
  102d75:	89 d0                	mov    %edx,%eax
  102d77:	eb 05                	jmp    102d7e <strncmp+0x55>
  102d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d7e:	5d                   	pop    %ebp
  102d7f:	c3                   	ret    

00102d80 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d80:	f3 0f 1e fb          	endbr32 
  102d84:	55                   	push   %ebp
  102d85:	89 e5                	mov    %esp,%ebp
  102d87:	83 ec 04             	sub    $0x4,%esp
  102d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d8d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d90:	eb 13                	jmp    102da5 <strchr+0x25>
        if (*s == c) {
  102d92:	8b 45 08             	mov    0x8(%ebp),%eax
  102d95:	0f b6 00             	movzbl (%eax),%eax
  102d98:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d9b:	75 05                	jne    102da2 <strchr+0x22>
            return (char *)s;
  102d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102da0:	eb 12                	jmp    102db4 <strchr+0x34>
        }
        s ++;
  102da2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102da5:	8b 45 08             	mov    0x8(%ebp),%eax
  102da8:	0f b6 00             	movzbl (%eax),%eax
  102dab:	84 c0                	test   %al,%al
  102dad:	75 e3                	jne    102d92 <strchr+0x12>
    }
    return NULL;
  102daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102db4:	c9                   	leave  
  102db5:	c3                   	ret    

00102db6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102db6:	f3 0f 1e fb          	endbr32 
  102dba:	55                   	push   %ebp
  102dbb:	89 e5                	mov    %esp,%ebp
  102dbd:	83 ec 04             	sub    $0x4,%esp
  102dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dc6:	eb 0e                	jmp    102dd6 <strfind+0x20>
        if (*s == c) {
  102dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcb:	0f b6 00             	movzbl (%eax),%eax
  102dce:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dd1:	74 0f                	je     102de2 <strfind+0x2c>
            break;
        }
        s ++;
  102dd3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd9:	0f b6 00             	movzbl (%eax),%eax
  102ddc:	84 c0                	test   %al,%al
  102dde:	75 e8                	jne    102dc8 <strfind+0x12>
  102de0:	eb 01                	jmp    102de3 <strfind+0x2d>
            break;
  102de2:	90                   	nop
    }
    return (char *)s;
  102de3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102de6:	c9                   	leave  
  102de7:	c3                   	ret    

00102de8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102de8:	f3 0f 1e fb          	endbr32 
  102dec:	55                   	push   %ebp
  102ded:	89 e5                	mov    %esp,%ebp
  102def:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102df2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102df9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e00:	eb 03                	jmp    102e05 <strtol+0x1d>
        s ++;
  102e02:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	0f b6 00             	movzbl (%eax),%eax
  102e0b:	3c 20                	cmp    $0x20,%al
  102e0d:	74 f3                	je     102e02 <strtol+0x1a>
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	0f b6 00             	movzbl (%eax),%eax
  102e15:	3c 09                	cmp    $0x9,%al
  102e17:	74 e9                	je     102e02 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e19:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1c:	0f b6 00             	movzbl (%eax),%eax
  102e1f:	3c 2b                	cmp    $0x2b,%al
  102e21:	75 05                	jne    102e28 <strtol+0x40>
        s ++;
  102e23:	ff 45 08             	incl   0x8(%ebp)
  102e26:	eb 14                	jmp    102e3c <strtol+0x54>
    }
    else if (*s == '-') {
  102e28:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2b:	0f b6 00             	movzbl (%eax),%eax
  102e2e:	3c 2d                	cmp    $0x2d,%al
  102e30:	75 0a                	jne    102e3c <strtol+0x54>
        s ++, neg = 1;
  102e32:	ff 45 08             	incl   0x8(%ebp)
  102e35:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e40:	74 06                	je     102e48 <strtol+0x60>
  102e42:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e46:	75 22                	jne    102e6a <strtol+0x82>
  102e48:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4b:	0f b6 00             	movzbl (%eax),%eax
  102e4e:	3c 30                	cmp    $0x30,%al
  102e50:	75 18                	jne    102e6a <strtol+0x82>
  102e52:	8b 45 08             	mov    0x8(%ebp),%eax
  102e55:	40                   	inc    %eax
  102e56:	0f b6 00             	movzbl (%eax),%eax
  102e59:	3c 78                	cmp    $0x78,%al
  102e5b:	75 0d                	jne    102e6a <strtol+0x82>
        s += 2, base = 16;
  102e5d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e61:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e68:	eb 29                	jmp    102e93 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e6e:	75 16                	jne    102e86 <strtol+0x9e>
  102e70:	8b 45 08             	mov    0x8(%ebp),%eax
  102e73:	0f b6 00             	movzbl (%eax),%eax
  102e76:	3c 30                	cmp    $0x30,%al
  102e78:	75 0c                	jne    102e86 <strtol+0x9e>
        s ++, base = 8;
  102e7a:	ff 45 08             	incl   0x8(%ebp)
  102e7d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e84:	eb 0d                	jmp    102e93 <strtol+0xab>
    }
    else if (base == 0) {
  102e86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e8a:	75 07                	jne    102e93 <strtol+0xab>
        base = 10;
  102e8c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e93:	8b 45 08             	mov    0x8(%ebp),%eax
  102e96:	0f b6 00             	movzbl (%eax),%eax
  102e99:	3c 2f                	cmp    $0x2f,%al
  102e9b:	7e 1b                	jle    102eb8 <strtol+0xd0>
  102e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea0:	0f b6 00             	movzbl (%eax),%eax
  102ea3:	3c 39                	cmp    $0x39,%al
  102ea5:	7f 11                	jg     102eb8 <strtol+0xd0>
            dig = *s - '0';
  102ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eaa:	0f b6 00             	movzbl (%eax),%eax
  102ead:	0f be c0             	movsbl %al,%eax
  102eb0:	83 e8 30             	sub    $0x30,%eax
  102eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eb6:	eb 48                	jmp    102f00 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebb:	0f b6 00             	movzbl (%eax),%eax
  102ebe:	3c 60                	cmp    $0x60,%al
  102ec0:	7e 1b                	jle    102edd <strtol+0xf5>
  102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec5:	0f b6 00             	movzbl (%eax),%eax
  102ec8:	3c 7a                	cmp    $0x7a,%al
  102eca:	7f 11                	jg     102edd <strtol+0xf5>
            dig = *s - 'a' + 10;
  102ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecf:	0f b6 00             	movzbl (%eax),%eax
  102ed2:	0f be c0             	movsbl %al,%eax
  102ed5:	83 e8 57             	sub    $0x57,%eax
  102ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102edb:	eb 23                	jmp    102f00 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee0:	0f b6 00             	movzbl (%eax),%eax
  102ee3:	3c 40                	cmp    $0x40,%al
  102ee5:	7e 3b                	jle    102f22 <strtol+0x13a>
  102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eea:	0f b6 00             	movzbl (%eax),%eax
  102eed:	3c 5a                	cmp    $0x5a,%al
  102eef:	7f 31                	jg     102f22 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef4:	0f b6 00             	movzbl (%eax),%eax
  102ef7:	0f be c0             	movsbl %al,%eax
  102efa:	83 e8 37             	sub    $0x37,%eax
  102efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f03:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f06:	7d 19                	jge    102f21 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f08:	ff 45 08             	incl   0x8(%ebp)
  102f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f0e:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f12:	89 c2                	mov    %eax,%edx
  102f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f17:	01 d0                	add    %edx,%eax
  102f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f1c:	e9 72 ff ff ff       	jmp    102e93 <strtol+0xab>
            break;
  102f21:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f26:	74 08                	je     102f30 <strtol+0x148>
        *endptr = (char *) s;
  102f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f34:	74 07                	je     102f3d <strtol+0x155>
  102f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f39:	f7 d8                	neg    %eax
  102f3b:	eb 03                	jmp    102f40 <strtol+0x158>
  102f3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f40:	c9                   	leave  
  102f41:	c3                   	ret    

00102f42 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f42:	f3 0f 1e fb          	endbr32 
  102f46:	55                   	push   %ebp
  102f47:	89 e5                	mov    %esp,%ebp
  102f49:	57                   	push   %edi
  102f4a:	83 ec 24             	sub    $0x24,%esp
  102f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f50:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f53:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f57:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f5d:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f60:	8b 45 10             	mov    0x10(%ebp),%eax
  102f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f69:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f6d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f70:	89 d7                	mov    %edx,%edi
  102f72:	f3 aa                	rep stos %al,%es:(%edi)
  102f74:	89 fa                	mov    %edi,%edx
  102f76:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f79:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f7f:	83 c4 24             	add    $0x24,%esp
  102f82:	5f                   	pop    %edi
  102f83:	5d                   	pop    %ebp
  102f84:	c3                   	ret    

00102f85 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f85:	f3 0f 1e fb          	endbr32 
  102f89:	55                   	push   %ebp
  102f8a:	89 e5                	mov    %esp,%ebp
  102f8c:	57                   	push   %edi
  102f8d:	56                   	push   %esi
  102f8e:	53                   	push   %ebx
  102f8f:	83 ec 30             	sub    $0x30,%esp
  102f92:	8b 45 08             	mov    0x8(%ebp),%eax
  102f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102faa:	73 42                	jae    102fee <memmove+0x69>
  102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fc1:	c1 e8 02             	shr    $0x2,%eax
  102fc4:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fcc:	89 d7                	mov    %edx,%edi
  102fce:	89 c6                	mov    %eax,%esi
  102fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fd5:	83 e1 03             	and    $0x3,%ecx
  102fd8:	74 02                	je     102fdc <memmove+0x57>
  102fda:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fdc:	89 f0                	mov    %esi,%eax
  102fde:	89 fa                	mov    %edi,%edx
  102fe0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fe3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102fec:	eb 36                	jmp    103024 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff7:	01 c2                	add    %eax,%edx
  102ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ffc:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103008:	89 c1                	mov    %eax,%ecx
  10300a:	89 d8                	mov    %ebx,%eax
  10300c:	89 d6                	mov    %edx,%esi
  10300e:	89 c7                	mov    %eax,%edi
  103010:	fd                   	std    
  103011:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103013:	fc                   	cld    
  103014:	89 f8                	mov    %edi,%eax
  103016:	89 f2                	mov    %esi,%edx
  103018:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10301b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10301e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103021:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103024:	83 c4 30             	add    $0x30,%esp
  103027:	5b                   	pop    %ebx
  103028:	5e                   	pop    %esi
  103029:	5f                   	pop    %edi
  10302a:	5d                   	pop    %ebp
  10302b:	c3                   	ret    

0010302c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10302c:	f3 0f 1e fb          	endbr32 
  103030:	55                   	push   %ebp
  103031:	89 e5                	mov    %esp,%ebp
  103033:	57                   	push   %edi
  103034:	56                   	push   %esi
  103035:	83 ec 20             	sub    $0x20,%esp
  103038:	8b 45 08             	mov    0x8(%ebp),%eax
  10303b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10303e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103041:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103044:	8b 45 10             	mov    0x10(%ebp),%eax
  103047:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10304d:	c1 e8 02             	shr    $0x2,%eax
  103050:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103058:	89 d7                	mov    %edx,%edi
  10305a:	89 c6                	mov    %eax,%esi
  10305c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10305e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103061:	83 e1 03             	and    $0x3,%ecx
  103064:	74 02                	je     103068 <memcpy+0x3c>
  103066:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103068:	89 f0                	mov    %esi,%eax
  10306a:	89 fa                	mov    %edi,%edx
  10306c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10306f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103072:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103075:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103078:	83 c4 20             	add    $0x20,%esp
  10307b:	5e                   	pop    %esi
  10307c:	5f                   	pop    %edi
  10307d:	5d                   	pop    %ebp
  10307e:	c3                   	ret    

0010307f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10307f:	f3 0f 1e fb          	endbr32 
  103083:	55                   	push   %ebp
  103084:	89 e5                	mov    %esp,%ebp
  103086:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103089:	8b 45 08             	mov    0x8(%ebp),%eax
  10308c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103092:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103095:	eb 2e                	jmp    1030c5 <memcmp+0x46>
        if (*s1 != *s2) {
  103097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10309a:	0f b6 10             	movzbl (%eax),%edx
  10309d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030a0:	0f b6 00             	movzbl (%eax),%eax
  1030a3:	38 c2                	cmp    %al,%dl
  1030a5:	74 18                	je     1030bf <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030aa:	0f b6 00             	movzbl (%eax),%eax
  1030ad:	0f b6 d0             	movzbl %al,%edx
  1030b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030b3:	0f b6 00             	movzbl (%eax),%eax
  1030b6:	0f b6 c0             	movzbl %al,%eax
  1030b9:	29 c2                	sub    %eax,%edx
  1030bb:	89 d0                	mov    %edx,%eax
  1030bd:	eb 18                	jmp    1030d7 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1030bf:	ff 45 fc             	incl   -0x4(%ebp)
  1030c2:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030cb:	89 55 10             	mov    %edx,0x10(%ebp)
  1030ce:	85 c0                	test   %eax,%eax
  1030d0:	75 c5                	jne    103097 <memcmp+0x18>
    }
    return 0;
  1030d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030d7:	c9                   	leave  
  1030d8:	c3                   	ret    

001030d9 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030d9:	f3 0f 1e fb          	endbr32 
  1030dd:	55                   	push   %ebp
  1030de:	89 e5                	mov    %esp,%ebp
  1030e0:	83 ec 58             	sub    $0x58,%esp
  1030e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030e9:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1030fb:	8b 45 18             	mov    0x18(%ebp),%eax
  1030fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103104:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103107:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10310a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103117:	74 1c                	je     103135 <printnum+0x5c>
  103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10311c:	ba 00 00 00 00       	mov    $0x0,%edx
  103121:	f7 75 e4             	divl   -0x1c(%ebp)
  103124:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312a:	ba 00 00 00 00       	mov    $0x0,%edx
  10312f:	f7 75 e4             	divl   -0x1c(%ebp)
  103132:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10313b:	f7 75 e4             	divl   -0x1c(%ebp)
  10313e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103141:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103144:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103147:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10314a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10314d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103150:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103153:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103156:	8b 45 18             	mov    0x18(%ebp),%eax
  103159:	ba 00 00 00 00       	mov    $0x0,%edx
  10315e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103161:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103164:	19 d1                	sbb    %edx,%ecx
  103166:	72 4c                	jb     1031b4 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103168:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10316b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10316e:	8b 45 20             	mov    0x20(%ebp),%eax
  103171:	89 44 24 18          	mov    %eax,0x18(%esp)
  103175:	89 54 24 14          	mov    %edx,0x14(%esp)
  103179:	8b 45 18             	mov    0x18(%ebp),%eax
  10317c:	89 44 24 10          	mov    %eax,0x10(%esp)
  103180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103183:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103186:	89 44 24 08          	mov    %eax,0x8(%esp)
  10318a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103191:	89 44 24 04          	mov    %eax,0x4(%esp)
  103195:	8b 45 08             	mov    0x8(%ebp),%eax
  103198:	89 04 24             	mov    %eax,(%esp)
  10319b:	e8 39 ff ff ff       	call   1030d9 <printnum>
  1031a0:	eb 1b                	jmp    1031bd <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a9:	8b 45 20             	mov    0x20(%ebp),%eax
  1031ac:	89 04 24             	mov    %eax,(%esp)
  1031af:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b2:	ff d0                	call   *%eax
        while (-- width > 0)
  1031b4:	ff 4d 1c             	decl   0x1c(%ebp)
  1031b7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1031bb:	7f e5                	jg     1031a2 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1031bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031c0:	05 50 3f 10 00       	add    $0x103f50,%eax
  1031c5:	0f b6 00             	movzbl (%eax),%eax
  1031c8:	0f be c0             	movsbl %al,%eax
  1031cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031d2:	89 04 24             	mov    %eax,(%esp)
  1031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d8:	ff d0                	call   *%eax
}
  1031da:	90                   	nop
  1031db:	c9                   	leave  
  1031dc:	c3                   	ret    

001031dd <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031dd:	f3 0f 1e fb          	endbr32 
  1031e1:	55                   	push   %ebp
  1031e2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031e8:	7e 14                	jle    1031fe <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	8b 00                	mov    (%eax),%eax
  1031ef:	8d 48 08             	lea    0x8(%eax),%ecx
  1031f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1031f5:	89 0a                	mov    %ecx,(%edx)
  1031f7:	8b 50 04             	mov    0x4(%eax),%edx
  1031fa:	8b 00                	mov    (%eax),%eax
  1031fc:	eb 30                	jmp    10322e <getuint+0x51>
    }
    else if (lflag) {
  1031fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103202:	74 16                	je     10321a <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  103204:	8b 45 08             	mov    0x8(%ebp),%eax
  103207:	8b 00                	mov    (%eax),%eax
  103209:	8d 48 04             	lea    0x4(%eax),%ecx
  10320c:	8b 55 08             	mov    0x8(%ebp),%edx
  10320f:	89 0a                	mov    %ecx,(%edx)
  103211:	8b 00                	mov    (%eax),%eax
  103213:	ba 00 00 00 00       	mov    $0x0,%edx
  103218:	eb 14                	jmp    10322e <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  10321a:	8b 45 08             	mov    0x8(%ebp),%eax
  10321d:	8b 00                	mov    (%eax),%eax
  10321f:	8d 48 04             	lea    0x4(%eax),%ecx
  103222:	8b 55 08             	mov    0x8(%ebp),%edx
  103225:	89 0a                	mov    %ecx,(%edx)
  103227:	8b 00                	mov    (%eax),%eax
  103229:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10322e:	5d                   	pop    %ebp
  10322f:	c3                   	ret    

00103230 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103230:	f3 0f 1e fb          	endbr32 
  103234:	55                   	push   %ebp
  103235:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103237:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10323b:	7e 14                	jle    103251 <getint+0x21>
        return va_arg(*ap, long long);
  10323d:	8b 45 08             	mov    0x8(%ebp),%eax
  103240:	8b 00                	mov    (%eax),%eax
  103242:	8d 48 08             	lea    0x8(%eax),%ecx
  103245:	8b 55 08             	mov    0x8(%ebp),%edx
  103248:	89 0a                	mov    %ecx,(%edx)
  10324a:	8b 50 04             	mov    0x4(%eax),%edx
  10324d:	8b 00                	mov    (%eax),%eax
  10324f:	eb 28                	jmp    103279 <getint+0x49>
    }
    else if (lflag) {
  103251:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103255:	74 12                	je     103269 <getint+0x39>
        return va_arg(*ap, long);
  103257:	8b 45 08             	mov    0x8(%ebp),%eax
  10325a:	8b 00                	mov    (%eax),%eax
  10325c:	8d 48 04             	lea    0x4(%eax),%ecx
  10325f:	8b 55 08             	mov    0x8(%ebp),%edx
  103262:	89 0a                	mov    %ecx,(%edx)
  103264:	8b 00                	mov    (%eax),%eax
  103266:	99                   	cltd   
  103267:	eb 10                	jmp    103279 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103269:	8b 45 08             	mov    0x8(%ebp),%eax
  10326c:	8b 00                	mov    (%eax),%eax
  10326e:	8d 48 04             	lea    0x4(%eax),%ecx
  103271:	8b 55 08             	mov    0x8(%ebp),%edx
  103274:	89 0a                	mov    %ecx,(%edx)
  103276:	8b 00                	mov    (%eax),%eax
  103278:	99                   	cltd   
    }
}
  103279:	5d                   	pop    %ebp
  10327a:	c3                   	ret    

0010327b <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10327b:	f3 0f 1e fb          	endbr32 
  10327f:	55                   	push   %ebp
  103280:	89 e5                	mov    %esp,%ebp
  103282:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103285:	8d 45 14             	lea    0x14(%ebp),%eax
  103288:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10328e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103292:	8b 45 10             	mov    0x10(%ebp),%eax
  103295:	89 44 24 08          	mov    %eax,0x8(%esp)
  103299:	8b 45 0c             	mov    0xc(%ebp),%eax
  10329c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a3:	89 04 24             	mov    %eax,(%esp)
  1032a6:	e8 03 00 00 00       	call   1032ae <vprintfmt>
    va_end(ap);
}
  1032ab:	90                   	nop
  1032ac:	c9                   	leave  
  1032ad:	c3                   	ret    

001032ae <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032ae:	f3 0f 1e fb          	endbr32 
  1032b2:	55                   	push   %ebp
  1032b3:	89 e5                	mov    %esp,%ebp
  1032b5:	56                   	push   %esi
  1032b6:	53                   	push   %ebx
  1032b7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032ba:	eb 17                	jmp    1032d3 <vprintfmt+0x25>
            if (ch == '\0') {
  1032bc:	85 db                	test   %ebx,%ebx
  1032be:	0f 84 c0 03 00 00    	je     103684 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  1032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032cb:	89 1c 24             	mov    %ebx,(%esp)
  1032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d1:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1032d6:	8d 50 01             	lea    0x1(%eax),%edx
  1032d9:	89 55 10             	mov    %edx,0x10(%ebp)
  1032dc:	0f b6 00             	movzbl (%eax),%eax
  1032df:	0f b6 d8             	movzbl %al,%ebx
  1032e2:	83 fb 25             	cmp    $0x25,%ebx
  1032e5:	75 d5                	jne    1032bc <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032e7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1032f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1032f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103302:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103305:	8b 45 10             	mov    0x10(%ebp),%eax
  103308:	8d 50 01             	lea    0x1(%eax),%edx
  10330b:	89 55 10             	mov    %edx,0x10(%ebp)
  10330e:	0f b6 00             	movzbl (%eax),%eax
  103311:	0f b6 d8             	movzbl %al,%ebx
  103314:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103317:	83 f8 55             	cmp    $0x55,%eax
  10331a:	0f 87 38 03 00 00    	ja     103658 <vprintfmt+0x3aa>
  103320:	8b 04 85 74 3f 10 00 	mov    0x103f74(,%eax,4),%eax
  103327:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10332a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10332e:	eb d5                	jmp    103305 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103330:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103334:	eb cf                	jmp    103305 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103336:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10333d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103340:	89 d0                	mov    %edx,%eax
  103342:	c1 e0 02             	shl    $0x2,%eax
  103345:	01 d0                	add    %edx,%eax
  103347:	01 c0                	add    %eax,%eax
  103349:	01 d8                	add    %ebx,%eax
  10334b:	83 e8 30             	sub    $0x30,%eax
  10334e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103351:	8b 45 10             	mov    0x10(%ebp),%eax
  103354:	0f b6 00             	movzbl (%eax),%eax
  103357:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10335a:	83 fb 2f             	cmp    $0x2f,%ebx
  10335d:	7e 38                	jle    103397 <vprintfmt+0xe9>
  10335f:	83 fb 39             	cmp    $0x39,%ebx
  103362:	7f 33                	jg     103397 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103364:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103367:	eb d4                	jmp    10333d <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103369:	8b 45 14             	mov    0x14(%ebp),%eax
  10336c:	8d 50 04             	lea    0x4(%eax),%edx
  10336f:	89 55 14             	mov    %edx,0x14(%ebp)
  103372:	8b 00                	mov    (%eax),%eax
  103374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103377:	eb 1f                	jmp    103398 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103379:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10337d:	79 86                	jns    103305 <vprintfmt+0x57>
                width = 0;
  10337f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103386:	e9 7a ff ff ff       	jmp    103305 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10338b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103392:	e9 6e ff ff ff       	jmp    103305 <vprintfmt+0x57>
            goto process_precision;
  103397:	90                   	nop

        process_precision:
            if (width < 0)
  103398:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10339c:	0f 89 63 ff ff ff    	jns    103305 <vprintfmt+0x57>
                width = precision, precision = -1;
  1033a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033af:	e9 51 ff ff ff       	jmp    103305 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033b4:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033b7:	e9 49 ff ff ff       	jmp    103305 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1033bc:	8b 45 14             	mov    0x14(%ebp),%eax
  1033bf:	8d 50 04             	lea    0x4(%eax),%edx
  1033c2:	89 55 14             	mov    %edx,0x14(%ebp)
  1033c5:	8b 00                	mov    (%eax),%eax
  1033c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033ce:	89 04 24             	mov    %eax,(%esp)
  1033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d4:	ff d0                	call   *%eax
            break;
  1033d6:	e9 a4 02 00 00       	jmp    10367f <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033db:	8b 45 14             	mov    0x14(%ebp),%eax
  1033de:	8d 50 04             	lea    0x4(%eax),%edx
  1033e1:	89 55 14             	mov    %edx,0x14(%ebp)
  1033e4:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033e6:	85 db                	test   %ebx,%ebx
  1033e8:	79 02                	jns    1033ec <vprintfmt+0x13e>
                err = -err;
  1033ea:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033ec:	83 fb 06             	cmp    $0x6,%ebx
  1033ef:	7f 0b                	jg     1033fc <vprintfmt+0x14e>
  1033f1:	8b 34 9d 34 3f 10 00 	mov    0x103f34(,%ebx,4),%esi
  1033f8:	85 f6                	test   %esi,%esi
  1033fa:	75 23                	jne    10341f <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1033fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103400:	c7 44 24 08 61 3f 10 	movl   $0x103f61,0x8(%esp)
  103407:	00 
  103408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10340f:	8b 45 08             	mov    0x8(%ebp),%eax
  103412:	89 04 24             	mov    %eax,(%esp)
  103415:	e8 61 fe ff ff       	call   10327b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10341a:	e9 60 02 00 00       	jmp    10367f <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10341f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103423:	c7 44 24 08 6a 3f 10 	movl   $0x103f6a,0x8(%esp)
  10342a:	00 
  10342b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10342e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103432:	8b 45 08             	mov    0x8(%ebp),%eax
  103435:	89 04 24             	mov    %eax,(%esp)
  103438:	e8 3e fe ff ff       	call   10327b <printfmt>
            break;
  10343d:	e9 3d 02 00 00       	jmp    10367f <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103442:	8b 45 14             	mov    0x14(%ebp),%eax
  103445:	8d 50 04             	lea    0x4(%eax),%edx
  103448:	89 55 14             	mov    %edx,0x14(%ebp)
  10344b:	8b 30                	mov    (%eax),%esi
  10344d:	85 f6                	test   %esi,%esi
  10344f:	75 05                	jne    103456 <vprintfmt+0x1a8>
                p = "(null)";
  103451:	be 6d 3f 10 00       	mov    $0x103f6d,%esi
            }
            if (width > 0 && padc != '-') {
  103456:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10345a:	7e 76                	jle    1034d2 <vprintfmt+0x224>
  10345c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103460:	74 70                	je     1034d2 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103465:	89 44 24 04          	mov    %eax,0x4(%esp)
  103469:	89 34 24             	mov    %esi,(%esp)
  10346c:	e8 ba f7 ff ff       	call   102c2b <strnlen>
  103471:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103474:	29 c2                	sub    %eax,%edx
  103476:	89 d0                	mov    %edx,%eax
  103478:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10347b:	eb 16                	jmp    103493 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10347d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103481:	8b 55 0c             	mov    0xc(%ebp),%edx
  103484:	89 54 24 04          	mov    %edx,0x4(%esp)
  103488:	89 04 24             	mov    %eax,(%esp)
  10348b:	8b 45 08             	mov    0x8(%ebp),%eax
  10348e:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103490:	ff 4d e8             	decl   -0x18(%ebp)
  103493:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103497:	7f e4                	jg     10347d <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103499:	eb 37                	jmp    1034d2 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10349b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10349f:	74 1f                	je     1034c0 <vprintfmt+0x212>
  1034a1:	83 fb 1f             	cmp    $0x1f,%ebx
  1034a4:	7e 05                	jle    1034ab <vprintfmt+0x1fd>
  1034a6:	83 fb 7e             	cmp    $0x7e,%ebx
  1034a9:	7e 15                	jle    1034c0 <vprintfmt+0x212>
                    putch('?', putdat);
  1034ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034b2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034bc:	ff d0                	call   *%eax
  1034be:	eb 0f                	jmp    1034cf <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c7:	89 1c 24             	mov    %ebx,(%esp)
  1034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cd:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034cf:	ff 4d e8             	decl   -0x18(%ebp)
  1034d2:	89 f0                	mov    %esi,%eax
  1034d4:	8d 70 01             	lea    0x1(%eax),%esi
  1034d7:	0f b6 00             	movzbl (%eax),%eax
  1034da:	0f be d8             	movsbl %al,%ebx
  1034dd:	85 db                	test   %ebx,%ebx
  1034df:	74 27                	je     103508 <vprintfmt+0x25a>
  1034e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034e5:	78 b4                	js     10349b <vprintfmt+0x1ed>
  1034e7:	ff 4d e4             	decl   -0x1c(%ebp)
  1034ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034ee:	79 ab                	jns    10349b <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1034f0:	eb 16                	jmp    103508 <vprintfmt+0x25a>
                putch(' ', putdat);
  1034f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103500:	8b 45 08             	mov    0x8(%ebp),%eax
  103503:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103505:	ff 4d e8             	decl   -0x18(%ebp)
  103508:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10350c:	7f e4                	jg     1034f2 <vprintfmt+0x244>
            }
            break;
  10350e:	e9 6c 01 00 00       	jmp    10367f <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103516:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351a:	8d 45 14             	lea    0x14(%ebp),%eax
  10351d:	89 04 24             	mov    %eax,(%esp)
  103520:	e8 0b fd ff ff       	call   103230 <getint>
  103525:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103528:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10352e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103531:	85 d2                	test   %edx,%edx
  103533:	79 26                	jns    10355b <vprintfmt+0x2ad>
                putch('-', putdat);
  103535:	8b 45 0c             	mov    0xc(%ebp),%eax
  103538:	89 44 24 04          	mov    %eax,0x4(%esp)
  10353c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103543:	8b 45 08             	mov    0x8(%ebp),%eax
  103546:	ff d0                	call   *%eax
                num = -(long long)num;
  103548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10354e:	f7 d8                	neg    %eax
  103550:	83 d2 00             	adc    $0x0,%edx
  103553:	f7 da                	neg    %edx
  103555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103558:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10355b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103562:	e9 a8 00 00 00       	jmp    10360f <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10356a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10356e:	8d 45 14             	lea    0x14(%ebp),%eax
  103571:	89 04 24             	mov    %eax,(%esp)
  103574:	e8 64 fc ff ff       	call   1031dd <getuint>
  103579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10357c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10357f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103586:	e9 84 00 00 00       	jmp    10360f <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10358b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10358e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103592:	8d 45 14             	lea    0x14(%ebp),%eax
  103595:	89 04 24             	mov    %eax,(%esp)
  103598:	e8 40 fc ff ff       	call   1031dd <getuint>
  10359d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035a3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035aa:	eb 63                	jmp    10360f <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1035ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035b3:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1035bd:	ff d0                	call   *%eax
            putch('x', putdat);
  1035bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1035d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1035d5:	8d 50 04             	lea    0x4(%eax),%edx
  1035d8:	89 55 14             	mov    %edx,0x14(%ebp)
  1035db:	8b 00                	mov    (%eax),%eax
  1035dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035e7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035ee:	eb 1f                	jmp    10360f <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1035f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035f7:	8d 45 14             	lea    0x14(%ebp),%eax
  1035fa:	89 04 24             	mov    %eax,(%esp)
  1035fd:	e8 db fb ff ff       	call   1031dd <getuint>
  103602:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103605:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103608:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10360f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103616:	89 54 24 18          	mov    %edx,0x18(%esp)
  10361a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10361d:	89 54 24 14          	mov    %edx,0x14(%esp)
  103621:	89 44 24 10          	mov    %eax,0x10(%esp)
  103625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10362b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10362f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103633:	8b 45 0c             	mov    0xc(%ebp),%eax
  103636:	89 44 24 04          	mov    %eax,0x4(%esp)
  10363a:	8b 45 08             	mov    0x8(%ebp),%eax
  10363d:	89 04 24             	mov    %eax,(%esp)
  103640:	e8 94 fa ff ff       	call   1030d9 <printnum>
            break;
  103645:	eb 38                	jmp    10367f <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103647:	8b 45 0c             	mov    0xc(%ebp),%eax
  10364a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10364e:	89 1c 24             	mov    %ebx,(%esp)
  103651:	8b 45 08             	mov    0x8(%ebp),%eax
  103654:	ff d0                	call   *%eax
            break;
  103656:	eb 27                	jmp    10367f <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10365b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103666:	8b 45 08             	mov    0x8(%ebp),%eax
  103669:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10366b:	ff 4d 10             	decl   0x10(%ebp)
  10366e:	eb 03                	jmp    103673 <vprintfmt+0x3c5>
  103670:	ff 4d 10             	decl   0x10(%ebp)
  103673:	8b 45 10             	mov    0x10(%ebp),%eax
  103676:	48                   	dec    %eax
  103677:	0f b6 00             	movzbl (%eax),%eax
  10367a:	3c 25                	cmp    $0x25,%al
  10367c:	75 f2                	jne    103670 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10367e:	90                   	nop
    while (1) {
  10367f:	e9 36 fc ff ff       	jmp    1032ba <vprintfmt+0xc>
                return;
  103684:	90                   	nop
        }
    }
}
  103685:	83 c4 40             	add    $0x40,%esp
  103688:	5b                   	pop    %ebx
  103689:	5e                   	pop    %esi
  10368a:	5d                   	pop    %ebp
  10368b:	c3                   	ret    

0010368c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10368c:	f3 0f 1e fb          	endbr32 
  103690:	55                   	push   %ebp
  103691:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103693:	8b 45 0c             	mov    0xc(%ebp),%eax
  103696:	8b 40 08             	mov    0x8(%eax),%eax
  103699:	8d 50 01             	lea    0x1(%eax),%edx
  10369c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10369f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a5:	8b 10                	mov    (%eax),%edx
  1036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036aa:	8b 40 04             	mov    0x4(%eax),%eax
  1036ad:	39 c2                	cmp    %eax,%edx
  1036af:	73 12                	jae    1036c3 <sprintputch+0x37>
        *b->buf ++ = ch;
  1036b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b4:	8b 00                	mov    (%eax),%eax
  1036b6:	8d 48 01             	lea    0x1(%eax),%ecx
  1036b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036bc:	89 0a                	mov    %ecx,(%edx)
  1036be:	8b 55 08             	mov    0x8(%ebp),%edx
  1036c1:	88 10                	mov    %dl,(%eax)
    }
}
  1036c3:	90                   	nop
  1036c4:	5d                   	pop    %ebp
  1036c5:	c3                   	ret    

001036c6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1036c6:	f3 0f 1e fb          	endbr32 
  1036ca:	55                   	push   %ebp
  1036cb:	89 e5                	mov    %esp,%ebp
  1036cd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1036d0:	8d 45 14             	lea    0x14(%ebp),%eax
  1036d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1036e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1036ee:	89 04 24             	mov    %eax,(%esp)
  1036f1:	e8 08 00 00 00       	call   1036fe <vsnprintf>
  1036f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1036fc:	c9                   	leave  
  1036fd:	c3                   	ret    

001036fe <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1036fe:	f3 0f 1e fb          	endbr32 
  103702:	55                   	push   %ebp
  103703:	89 e5                	mov    %esp,%ebp
  103705:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103708:	8b 45 08             	mov    0x8(%ebp),%eax
  10370b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103711:	8d 50 ff             	lea    -0x1(%eax),%edx
  103714:	8b 45 08             	mov    0x8(%ebp),%eax
  103717:	01 d0                	add    %edx,%eax
  103719:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10371c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103723:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103727:	74 0a                	je     103733 <vsnprintf+0x35>
  103729:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10372f:	39 c2                	cmp    %eax,%edx
  103731:	76 07                	jbe    10373a <vsnprintf+0x3c>
        return -E_INVAL;
  103733:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103738:	eb 2a                	jmp    103764 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10373a:	8b 45 14             	mov    0x14(%ebp),%eax
  10373d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103741:	8b 45 10             	mov    0x10(%ebp),%eax
  103744:	89 44 24 08          	mov    %eax,0x8(%esp)
  103748:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10374b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10374f:	c7 04 24 8c 36 10 00 	movl   $0x10368c,(%esp)
  103756:	e8 53 fb ff ff       	call   1032ae <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10375b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10375e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103761:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103764:	c9                   	leave  
  103765:	c3                   	ret    
