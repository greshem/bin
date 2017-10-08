#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
windbg �������� Commands
"ENTER (Repeat Last Command)"
"$<, $><, $$<, $$><, $$>a< (Run Script File)"
"? (Command Help)"
"? (Evaluate Expression)"
"?? (Evaluate C++ Expression)"
"# (Search for Disassembly Pattern)"
"|| (System Status)"
"||s (Set Current System)"
"| (Process Status)"
"|s (Set Current Process)"
"~ (Thread Status)"
"~e (Thread-Specific Command)"
"~f (Freeze Thread)"
"~u (Unfreeze Thread)"
"~n (Suspend Thread)"
"~m (Resume Thread)"
"~s (Set Current Thread)"
"~s (Change Current Processor)"
"a (Assemble)"
"ad (Delete Alias)"
"ah (Assertion Handling)"
"al (List Aliases)"
"as, aS (Set Alias)"
"ba (Break on Access)"
"bc (Breakpoint Clear)"
"bd (Breakpoint Disable)"
"be (Breakpoint Enable)"
"bl (Breakpoint List)"
"bp, bu, bm (Set Breakpoint)"
"br (Breakpoint Renumber)"
"bs (Update Breakpoint Command)"
"bsc (Update Conditional Breakpoint)"
"c (Compare Memory)"
"d, da, db, dc, dd, dD, df, dp, dq, du, dw, dW, dyb, dyd (Display Memory)"
"dda, ddp, ddu, dpa, dpp, dpu, dqa, dqp, dqu (Display Referenced Memory)"
"dds, dps, dqs (Display Words and Symbols)"
"dg (Display Selector)"
"dl (Display Linked List)"
"ds, dS (Display String)"
"dt (Display Type)"
"dv (Display Local Variables)"
"e, ea, eb, ed, eD, ef, ep, eq, eu, ew, eza, ezu (Enter Values)"
"f, fp (Fill Memory)"
"g (Go)"
"gc (Go from Conditional Breakpoint)"
"gh (Go with Exception Handled)"
"gn, gN (Go with Exception Not Handled)"
"gu (Go Up)"
"ib, iw, id (Input from Port)"
"j (Execute If - Else)"
"k, kb, kc, kd, kp, kP, kv (Display Stack Backtrace)"
"l+, l- (Set Source Options)"
"ld (Load Symbols)"
"lm (List Loaded Modules)"
"ln (List Nearest Symbols)"
"ls, lsa (List Source Lines)"
"lsc (List Current Source)"
"lse (Launch Source Editor)"
"lsf, lsf- (Load or Unload Source File)"
"lsp (Set Number of Source Lines)"
"m (Move Memory)"
"n (Set Number Base)"
"ob, ow, od (Output to Port)"
"p (Step)"
"pa (Step to Address)"
"pc (Step to Next Call)"
"pct (Step to Next Call or Return)"
"ph (Step to Next Branching Instruction)"
"pt (Step to Next Return)"
"q, qq (Quit)"
"qd (Quit and Detach)"
"r (Registers)"
"rdmsr (Read MSR)"
"rm (Register Mask)"
"s (Search Memory)"
"so (Set Kernel Debugging Options)"
"sq (Set Quiet Mode)"
"ss (Set Symbol Suffix)"
"sx, sxd, sxe, sxi, sxn, sxr, sx- (Set Exceptions)"
"t (Trace)"
"ta (Trace to Address)"
"tb (Trace to Next Branch)"
"tc (Trace to Next Call)"
"tct (Trace to Next Call or Return)"
"th (Trace to Next Branching Instruction)"
"tt (Trace to Next Return)"
"u (Unassemble)| "
"uf (Unassemble Function)"
"up (Unassemble from Physical Memory)"
"ur (Unassemble Real Mode BIOS)"
"ux (Unassemble x86 BIOS)"
"vercommand (Show Debugger Command Line)"
"version (Show Debugger Version)"
"vertarget (Show Target Computer Version)"
"wrmsr (Write MSR)"
"wt (Trace and Watch Data)"
"x (Examine Symbols)"
"z (Execute While)"


