#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include "shell.h"
#define _GNU_SOURCE

int main(int argc, char *argv[])
{
  int max_history = 0;
  int max_jobs = 0;
  int max_line = 0;

  int opt;
  while ((opt = getopt(argc, argv, "s:j:l:")) != -1)
  {
    int option_value;
    if (optarg == NULL || sscanf(optarg, "%d", &option_value) != 1 || option_value <= 0)
    {
      printf("Usage: msh [-s NUMBER] [-j NUMBER] [-l NUMBER]\n");
      return 1;
    }

    switch (opt)
    {
    case 's':
      max_history = option_value;
      break;
    case 'j':
      max_jobs = option_value;
      break;
    case 'l':
      max_line = option_value;
      break;
    }
  }

  msh_t *shell = alloc_shell(max_jobs, max_line, max_history);

  char *line = NULL;
  long int len = 0;

  while (1)
  {
    printf("msh> ");
    long nRead = getline(&line, &len, stdin);

    if (nRead > 0 && line[nRead - 1] == '\n') {
      line[nRead - 1] = '\0'; // Replace '\n' with '\0' to remove it
    }

    if (nRead == -1)
    {
      break;
    }

    if (strcmp(line, "exit") == 0)
    {
      break;
    }

    evaluate(shell, line);
    line = NULL;
  }
  exit_shell(shell);
  return 0;
}