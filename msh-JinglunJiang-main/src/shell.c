#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shell.h"

const int MAX_LINE = 1024;
const int MAX_JOBS = 16;
const int MAX_HISTORY = 10;

msh_t *alloc_shell(int max_jobs, int max_line, int max_history)
{

  msh_t *shell = malloc(sizeof(msh_t));

  shell->max_jobs = (max_jobs != 0) ? max_jobs : MAX_JOBS;
  shell->max_line = (max_line != 0) ? max_line : MAX_LINE;
  shell->max_history = (max_history != 0) ? max_history : MAX_HISTORY;

  return shell;
}

static char *internal_ptr = NULL;

char *parse_tok(char *line, int *job_type) {
  if (line != NULL) {
    internal_ptr = line;
  }

  if (*internal_ptr == '\0') {
    *job_type = -1;
    return NULL;
  }

  char *job = internal_ptr; // Keep track of the place after the last call
  bool met_separator = false;
  char *last_non_space = NULL;

  while (*internal_ptr != '\0') {
    if (*internal_ptr == '&') {
      *job_type = 0;
      *internal_ptr = '\0';
      met_separator = true;
      internal_ptr++;
      return job;
    }
    if (*internal_ptr == ';') {
      *job_type = 1;
      *internal_ptr = '\0';
      met_separator = true;
      internal_ptr++;
      return job;
    }
    if (*internal_ptr != ' ') {
      last_non_space = internal_ptr; // Update the last non-space position
    }
    internal_ptr++;
  }

  if (*internal_ptr == '\0') {
    if (last_non_space != NULL) {
      *job_type = 1;
      internal_ptr = last_non_space + 1; 
      return job;
    } else {
      *job_type = -1;
      return NULL;
    }
  }

  if (!met_separator) {
    *job_type = 1;
  }
  return job;
}

char **separate_args(char *line, int *argc, bool *is_builtin)
{

  *argc = 0;

  if (line == NULL || line[0] == '\0')
  {
    return NULL;
  }

  void compute_num_args()
  { // helper function used to pre-calculated the number of arguments
    int i = 0;
    int inArgument = 0; // keep track whether the pointer is currently inside an argument
    while (line[i] != '\0')
    {
      if (line[i] == ' ')
      {
        inArgument = 0;
      }
      else
      {
        if (inArgument == 0)
        {
          (*argc)++;
        }
        inArgument = 1;
      }
      i++;
    }
  }

  compute_num_args(); // calculate the number of arguments

  char **argv = malloc((*argc + 1) * sizeof(char *)); // allocate memory for the number of arguments
  char *ptr = line;
  int argIndex = 0;

  while (*ptr != '\0')
  {
    while (*ptr == ' ')
    { // ignoring extra spaces
      ptr++;
    }
    char *argStart = ptr; // the start of current argument
    while (*ptr != ' ' && *ptr != '\0')
    {
      ptr++;
    }
    int argLength = ptr - argStart;
    argv[argIndex] = malloc(sizeof(char) * (argLength + 1)); // allocate memory for each argument
    strncpy(argv[argIndex], argStart, argLength);            // copy the argument into the array
    argv[argIndex][argLength] = '\0';                        // end of an argument
    argIndex++;                                              // increment index to the next item in the array
  }

  argv[*argc] = NULL; // the last item in the array assigned to NULL

  return argv;
}

int evaluate(msh_t *shell, char *line)
{

  if (strlen(line) > shell->max_line)
  {
    printf("error: reached the maximum line limit\n");
    return 1;
  }

  int job_type;
  char *job;

  job = parse_tok(line, &job_type);
  while (job != NULL) {
    int argc;
    bool is_builtin;
    char **job_args = separate_args(job, &argc, &is_builtin);
    
    for (int i = 0; i < argc; i++) {
      printf("argv[%d]=%s\n", i, job_args[i]);
    }
    printf("argc=%d\n", argc);
    
    job = parse_tok(NULL, &job_type); // Call inside the loop

    if (job == NULL) {
      break;
    }
  }
  return 0;
}


void exit_shell(msh_t *shell)
{
  free(shell);
}