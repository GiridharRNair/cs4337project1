### October 23, 2025, 2:06 PM

#### Initial Thoughts:

I am going to implement a prefix notation calculator in Racket.
I understand that prefix notation (also known as Polish notation) is a mathematical notation in which every operator precedes its operands.
For example, the expression "+ 3 4" in prefix notation is equivalent to "3 + 4" in infix notation.

I also understand that there needs to be 2 execution modes implemented:
Interactive - with prompts
Batch - results only

#### Plan for This Session:

I am planning to first write a function to calculate the prefix notation expression. I will worry about handling input, history, and other features later. My goal is to get basic expression evaluation working with hardcoded test cases before adding complexity.

### October 23, 2025, 5:50 PM

#### Session Reflection:
Successfully implemented a basic prefix notation evaluator. The recursive approach works well - each operator consumes its operands and returns both the result and remaining characters. This makes it easy to handle nested expressions.

#### Accomplishments:
Created parse functions for numbers and opeators.
Implemented recursive evaluation that consumes input left-to-right
Basic arithmetic operations (+, *, /) working correctly
Added division by zero checking

#### Challenges:
Initially struggled with how to handle the "remaining input" - solved by returning pairs of (result, remaining-chars)
Had to think carefully about the order of operands for division (left operand divided by right operand)

### October 23, 2025, 7:23 PM

#### Thoughts Since Last Session:
The basic evaluator is working, which gives me confidence. Now I need to add the history feature, which is central to this project. I'm thinking about how to structure this - the specification says to use a functional approach with history as a parameter to the eval loop.

I also installed a Racket library to format the source code nicely.

Command: raco fmt -i <filename>.rkt
For future reference: raco fmt -i mode.rkt

#### Plan for This Session:
I am going to implement the history feature next, so the prefix notation calculator function can refer back to prior results if needed.

#### Goals:
Add history parameter to the evaluation function
Implement $n parsing to extract history references
Test that history lookups work correctly with proper indexing (1-based, not 0-based)
Handle errors for invalid history indices

### October 23, 2025 7:55 PM

#### Plan for This Session:
I am going to implement a function(s) to format the input to evaluate the prefix expressions. I need to consider leading/trailing spaces, multiple spaces between tokens, and invalid characters.
I initially created some history helper functions (clear-history, show-history) but removed them to keep the code simple since they aren't required by the specification.

#### Work Notes:
Instead of creating a separate function to format the input, I created a tokenize function that handles trimming spaces and splitting the expression into tokens. This will make it easier to evaluate the expressions since I can work with a clean list of tokens.
The tokenize function uses regular expressions to match valid tokens (numbers, operators, and history references) and returns a list of tokens. 

This approach handles:
Leading/trailing whitespace
Multiple spaces between tokens
Invalid characters (by only matching valid patterns)

### October 23, 2025 8:28 PM

#### Plan for This Session
I am going to remove unused functions to clean up the code. I have removed both prior format input functions since the tokenize function now handles input formatting better.
Code is getting cleaner and more focused on the core requirements.

### October 23, 2025 9:03 PM

#### Plan for This Session:
I am going to implement the logic to prompt the user for an input expression and display the output. Need to build the REPL (Read-Eval-Print Loop) that handles:

Prompting user with "> " in interactive mode
Reading input lines
Detecting "quit" command
Displaying results with history IDs

#### Work Notes:
Added a simple REPL loop to read user input, tokenize it, and print the tokens for now. This is a starting point before full evaluation.
Important realization: my logic for history involved mutable hash-based history. This goes against the functional programming paradigm we should be using! I switched to using an immutable list-based history that gets passed as a parameter to the REPL function. Each successful evaluation cons-es the new result onto the history list.
I also implemented logic to display the evaluated result of the prefix expression in the REPL loop with the history id. The format is: "id: result" where id starts at 1 and increments.

#### Session Reflection:
Good progress tonight. The REPL is working and I've made the important switch from mutable to immutable data structures for history. This is much more aligned with functional programming principles.

Challenges:
Initially used a hash table for history (bad for functional style)
Had to think about how history IDs work - they're 1-based, and the list is in reverse order (most recent first)
Needed to reverse the history list when looking up by ID

The tokenize approach with regex is working but feels a bit un-functional. Might revisit this.

Next session:
Test thoroughly with complex expressions
Add comprehensive test cases
Ensure error handling is robust

### October 24, 2025 10:23 AM

#### Thoughts Since Last Session:

Looking at the code from last night, I realize I need to test the batch mode functionality and make sure the minus operator is implemented correctly. The spec is very specific that there's no binary subtraction - only unary negation.

#### Plan for This Session:
Implement batch-mode evaluation properly
Fix the unary minus operator (it should negate, not subtract)
Create test cases for both modes
Test edge cases like division by zero, invalid history references, and malformed expressions

#### Work Notes:
Implemented batch-mode evaluation for prefix expressions. The key difference is that batch mode doesn't print prompts or extra text - just results or errors.
During testing, a critical problem was discovered with the unary minus: it had been handled as binary subtraction, which the project specification explicitly disallows. Because subtraction should be expressed as addition of a negative number (e.g., "5 - 3" becomes "+ 5 - 3"), the evaluator was changed to treat unary minus as numeric negation only.
Tests were added and the batching/history logic was updated so negative values propagate correctly through the history system.

#### Session Reflection:
Major bug fix today with the minus operator. This could have cost significant points if not caught! The spec is very clear that there's no subtraction operator - only negation.
Batch mode is working correctly now.

### October 24, 2025 11:07 AM

#### Thoughts Since Last Session
The tokenize function works but uses regular expressions, which feels less functional. I want to refactor it to use a more purely functional character-by-character parsing approach. This will also give me more control over error messages and edge cases.

#### Plan for This Session
The current tokenize function uses regular expressions to identify valid tokens in the input expression. I am going to refactor the tokenize function to use a more functional approach without regular expressions.

### October 24, 2025 11:34 AM

#### Thoughts Since Last Session
Looking back at my devlog, I realize it's been too sparse and doesn't fully document my development process. Since the devlog is worth 50% of the grade, I need to make sure it properly showcases all the invisible work - my thinking process, problems encountered, and solutions implemented.

I also need to write a README file that clearly explains how to run the program in both interactive and batch modes, along with examples.

#### Plan for This Session
I am going to go back through my development process and fill in the gaps in the devlog. I will add more detailed reflections on each session, including challenges faced and how I overcame them.
Additionally, I will create a README file that includes:
Overview of the project
Instructions for running in interactive mode
Instructions for running in batch mode
Examples of usage

### October 24, 2025 2:00 PM

#### Plan for This Session
I am going to create a test file with various test cases to thoroughly test the prefix notation calculator in batch mode. 
This will help ensure all features work as expected and edge cases are handled properly.

My main goal this session is to complete this project and get ready for submission.

I will also update the README.md accordingly to reflect any changes made during testing.