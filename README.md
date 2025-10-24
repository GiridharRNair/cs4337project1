# Prefix Notation Calculator

## Project Overview

This project implements a prefix notation (Polish notation) calculator written in Racket. The calculator evaluates arithmetic expressions written in prefix notation, where operators precede their operands (e.g., `+ 3 4` instead of `3 + 4`).

## Files and Their Roles

- `mode.rkt` — Main program: parser, evaluator, history management, REPL (interactive + batch), and error handling.
- `devlog.md` — Development log documenting design decisions, challenges, refactors, and testing.
- `tests/` — Contains test inputs and expected outputs used to verify program behavior.

## Supported Operations

- Addition: `+ operand1 operand2`
- Multiplication: `* operand1 operand2`
- Division: `/ operand1 operand2` (integer division; division-by-zero handled as an error)
- Unary negation: `- operand` (there is no binary subtraction; use `+ a - b` for "a - b")
- History references: `$n` where `n` is the 1-based index of a previous result

## How to Compile / Run

### Prerequisites

- Racket must be installed and `racket` available on your PATH.

### Interactive Mode

Run with no flags to start a REPL (prompted):

```bash
racket mode.rkt
```

Interactive behavior:

- Prompt: `> `
- Enter prefix expressions and press Enter
- Results are printed with history IDs, e.g. `1: 7.0`
- Use `$n` (1-based) to reference history results
- Type `quit` to exit

Interactive examples:

```
> + 3 4
1: 7.0
> * $1 2
2: 14.0
> / $2 - 7
3: -2.0
> quit
```

### Batch Mode

Use the `-b` or `--batch` flag to run without prompts and suitable for piping input:

```bash
racket mode.rkt -b
```

Behavior in batch mode:

- No interactive prompt
- Each input line is processed; output is printed line-by-line
- Output format matches interactive mode: results are prefixed with history id (1-based), e.g., `3: 14.0`
- Suitable for automated testing and piping

Batch mode examples:

```bash
echo "+ 3 4" | racket mode.rkt -b
# prints: 1: 7.0

echo -e "+ 1 2\n* 3 4\n+ 1 \$1" | racket mode.rkt -b
# prints:
# 1: 3.0
# 2: 12.0
# 3: 4.0
```

## Tests (how to run and verify)

This repository includes a simple test setup under `tests/` to exercise batch-mode evaluation and compare results with expected output.

Files in `tests/`:

- `tests/testcases.txt` — Input expressions, one per line. These are fed to the program in batch mode.
- `tests/expected_results.txt` — The expected output lines corresponding to `testcases.txt`.
- `tests/testcases-execution.txt` — A convenient file name used to capture actual program output when running the test pipeline.

Basic test run (zsh / macOS):

```bash
# run testcases through the calculator and save actual results
cat tests/testcases.txt | racket mode.rkt -b > tests/testcases-execution.txt

# compare actual output to expected output
diff -u tests/expected_results.txt tests/testcases-execution.txt || true

# Or, to see only mismatches and get a helpful exit code (0 when identical):
if diff -q tests/expected_results.txt tests/testcases-execution.txt >/dev/null; then
	echo "Tests OK: output matches expected_results.txt"
else
	echo "Tests FAILED: see diff below"
	diff -u tests/expected_results.txt tests/testcases-execution.txt
fi
```






