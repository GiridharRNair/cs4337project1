October 23, 2025, 2:06 PM

I am planning to first write a function to calculate the prefix notation expression.
I will worry about handling input, history, and other features later.

October 23, 2025, 7:23 PM

I am going to implement the history feature next, so the prefix notation calculator function
can refer back to prior results if needed.

I also installed a Racket library to format the source code nicely.

Command: raco fmt -i <filename>.rkt
raco fmt -i mode.rkt

October 23, 2025 7:55 PM

I am going to implement a function(s) to format the input to evaluate the prefix expressions.
I need to consider leading/trailing spaces, multiple spaces between tokens, and invalid characters.
I removed unnecessary history functions like clear-history and show-history for now to keep the code simple.

Instead of creating a function to format the input, I created a tokenize function that handles
trimming spaces and splitting the expression into tokens. This will make it easier to evaluate the expressions.

October 23, 2025 8:28 PM

I am going to remove unused functions to clean up the code.
I have removed both prior format input functions since the tokenize function now handles input formatting.

October 23, 2025 9:03 PM

I am going to implement the logic to prompt the user for an input expression and display the output.
I added a simple REPL loop to read user input, tokenize it, and print the tokens for now.

I am going to create a comprehensive, organized test suite for this project.

