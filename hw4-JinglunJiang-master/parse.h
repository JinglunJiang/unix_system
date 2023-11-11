#ifndef PARSE
#define PARSE

//Holds information about the number of foreground and background jobs.
typedef struct shellinfo {
    int fg;            // Total number of foreground jobs
    int bg;            // Total number of background jobs
}shellinfo_t;

// Function prototypes
/*
* compute_num_args - computes the number of arguments in the provided command line string
*
* line: a string that represents text from a shell's command line
*
* Assumptions: You can assume the line does not contain more than a single command (i.e., we do not have "&" or ";" in the line string).
*
* Returns: the total number of arguments for the command including the command name
*/
int compute_num_args(const char *line);

/*
* find_arg - finds the argument at a specific index from within the command line string
*
* line: a string that represents text from a shell's command line
*
* index: the index of the argument that is being requested.
*
* argument: the string to copy the requested argument into.
*
* Assumptions: O-indexing is assume. the parameter ("argument") is big enough to hold its value.
*              You can assume the line does not contain more than a single command (i.e., we do not have "&" or ";" in the line string).
* Returns: the following error codes based on execution:
*      0 - success. Was able to find the argument as the specified index
*      1 - failure. Index was not valid (i.e., not within the range of 0 to maximum number of arguments in the line)
*/
int find_arg(const char *line, const int index, char *argument);

/*
* parse_lines - Counts the total number of background and foreground jobs in the array of lines provided.
*
* lines: an array of strings that contain strings representing command line strings
*
* lines_len: the length of the lines array.
*
* Assumption: You can assume that the command line strings will only contain "&" and ";" characters to run multiple commands on a single line.
*
* Returns: a shellinfo_t with the total counts of the the number of background and foreground jobs.
*/
shellinfo_t parse_lines(const char*lines[], const int lines_len);

#endif