# Prefix Notation Calculator

## Project Overview

This project implements a prefix notation (Polish notation) calculator written in Racket. The calculator evaluates arithmetic expressions written in prefix notation, where operators precede their operands (e.g., `+ 3 4` instead of `3 + 4`).

## Files and Their Roles

### `mode.rkt`
The main program file containing:
- **Parser functions**: `parse-number()`, `parse-history()`, `skip-whitespace()` for tokenizing input
- **Evaluator**: `eval-prefix()` recursively evaluates prefix expressions using character-by-character parsing
- **History management**: Maintains a functional history list of previous calculations
- **REPL**: Interactive Read-Eval-Print Loop with both interactive and batch modes
- **Error handling**: Comprehensive error checking for invalid expressions, division by zero, and invalid history references

### `devlog.md`
Development log documenting the entire programming process, including:
- Design decisions and implementation approaches
- Challenges encountered and solutions implemented
- Code refactoring and optimization steps
- Testing and debugging process

## Supported Operations

- **Addition**: `+ operand1 operand2`
- **Multiplication**: `* operand1 operand2` 
- **Division**: `/ operand1 operand2` (integer division with zero-checking)
- **Unary negation**: `- operand` (Note: No binary subtraction - use addition with negation instead)
- **History references**: `$n` where n is the 1-based index of a previous result

## How to Compile/Run the Program

### Prerequisites
- Racket must be installed on your system
- Ensure `racket` is available in your system PATH

### Interactive Mode
Run the program without any command-line arguments:
```bash
racket mode.rkt
```

In interactive mode:
- The program displays a `> ` prompt
- Enter prefix notation expressions and press Enter
- Results are displayed with history IDs (e.g., `1: 7.0`)
- Type `quit` to exit
- Use `$n` to reference previous results by their history ID

#### Interactive Mode Examples
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
Run the program with the `-b` or `--batch` flag:
```bash
racket mode.rkt -b
```

In batch mode:
- No prompts are displayed
- Only results or error messages are printed
- Input can be piped from stdin or entered directly
- Each line of input is processed as a separate expression

#### Batch Mode Examples
```bash
echo "+ 3 4" | racket mode.rkt -b
# Output: 7.0

echo -e "+ 1 2\n* 3 4\n + 1 \$1" | racket mode.rkt -b
# Output: 
# 3.0
# 12.0
# 4.0
```

### Expression Format
- **Numbers**: Integer literals (e.g., `42`, `-5`)
- **Operators**: Must precede their operands
- **Whitespace**: Leading/trailing spaces and multiple spaces between tokens are handled
- **History**: Use `$1`, `$2`, etc. to reference previous results (1-based indexing)

### Error Handling
The program handles various error conditions:
- **Invalid expressions**: Malformed syntax or unrecognized tokens
- **Division by zero**: Displays "Invalid Expression" error
- **Invalid history references**: Out-of-range or malformed history indices
- **Incomplete expressions**: Missing operands or operators

## Implementation Notes

### Design Decisions
- **Functional approach**: Uses immutable data structures and recursive evaluation
- **Character-level parsing**: Processes input character by character for precise control
- **History as parameter**: History list is passed functionally through the REPL loop
- **Error propagation**: Comprehensive error handling with meaningful messages

### Key Features
- **Two execution modes**: Interactive with prompts vs. batch for automation
- **History system**: Maintains and references previous calculation results
- **Robust parsing**: Handles whitespace and validates input thoroughly
- **Functional programming**: Follows Racket/functional programming best practices

## Notes for Grading

1. **No binary subtraction**: The specification explicitly states there's no subtraction operator. Use addition with unary negation instead (e.g., `+ 5 - 3` for "5 - 3").

2. **History indexing**: History references use 1-based indexing (`$1` for the first result, `$2` for the second, etc.).

3. **Division behavior**: Performs integer division using Racket's `quotient` function.

4. **Error messages**: All error conditions display "Invalid Expression" as specified, with additional context in development/debug scenarios.

5. **Mode detection**: The program automatically detects batch mode via command-line arguments (`-b` or `--batch`) and adjusts output formatting accordingly.

The implementation prioritizes correctness, robustness, and adherence to functional programming principles while meeting all specified requirements for the prefix notation calculator.