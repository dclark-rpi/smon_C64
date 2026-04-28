import subprocess

# Name of vasm source to compile
src_code = 'src/smon.asm'

# Name of the vasm output file
bin_6502 = 'smon.prg'

def compile() -> subprocess.CompletedProcess:
    compile_cmd = [
        'vasm6502_oldstyle',
        '-Fbin',
        '-esc',
        '-cbm-prg',
        '-dotdir',
        '-c02',
        '-o', bin_6502,
        src_code
    ]
    cp = subprocess.run(compile_cmd)
    if cp.returncode != 0:
        sys.exit(cp.returncode)

if __name__ == '__main__':
    compile()