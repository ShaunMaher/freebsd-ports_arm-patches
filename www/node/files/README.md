# node
This is an attempt to get node to build on FreeBSD on the ARM architecture.

## Resolved Issues
### Undefined symbol "__aeabi_uldivmod"
After a successful build, running the resulting executable results in the error:
```
Undefined symbol "__aeabi_uldivmod"
```

Adding -lgcc to the linker arguments resolves the issue.  I don't know if this is the best solution or if it causes other issues down the line but it gets you past the error.

### MemoryBarrier() is not implemented on this platform.
This issue is resolved in the NetBSD ports tree.  I have simply ported their patch "patch-deps_v8_src_base_atomicops__internals__arm__gcc.h,v 1.1 2015/10/21 23:46:28 jmcneill" to FreeBSD.

### OS::ArmUsingHardFloat
This function is implemented in "platform-openbsd.cc" but not in "platform-freebsd.cc" so I copied the OpenBSD code without modification.

### mcontext.mc_r15
During the build you get errors relating to "mcontext.mc_r15", "mcontext.mc_r13" and "mcontext.mc_r11".  I think these register names have been changed.  I've tried the match the amd64 registers a few lines above these ARM ones in "deps/v8/src/sampler.cc" to where they are defined in "sys/amd64/amd64/machdep.c" and then find the same definations in "sys/arm/arm/machdep.c".  I've no idea if this solution is correct and the way the result looks completely different to the amd64 code I was trying to cheat from worries me but it seems to work, at least as far as the build completing.

## Unresolved Issues
### Bus error (core dumped)
After a successful build and install, running "node" without arguments results in a crash and a core dump.  Running "node -v" and "node --help" work OK.  Actually running a script hasn't been tested yet.
