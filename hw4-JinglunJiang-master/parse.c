#include "parse.h"
#include <stdio.h>

int compute_num_args(const char *line){
  int count = 0;
  int i = 0;
  int inArgument = 0; // Either 0 or 1 to see if is currently inside the argument
  
  while (line[i] != '\0'){
    if (line[i] == ' '){
      inArgument = 0;
    }
    else {
      if (inArgument == 0){ // Changing from a space to non-space count++
        count++;
      }
      inArgument = 1;
    }
    i++;
  }

  return count;
}

int find_arg(const char *line, const int index, char *argument) {
  int numOfArgs = compute_num_args(line);
  if (index >= numOfArgs){
    return 1;
  }
  int current = 0;
  int i = 0;
  int j = 0;
  while (line[i] != '\0'){
    while (line[i] == ' '){
      i++;
    }
    if (line[i] != '\0'){
      if (index == current){
        while (line[i] != ' ' && line[i] != '\0'){
          argument[j] = line[i];
          i++;
          j++;
        }
        argument[j] = '\0';
        return 0;
      }
      while(line[i] != '\0' && line[i] != ' '){
        if (line[i] != ' ' && (i == 0 || line[i - 1] == ' ')){
          current++;
        }
        i++;
      }
    }
  }
  return 1;
}

shellinfo_t parse_lines(const char* lines[], const int lines_len) {
  int foreground = 0;
  int background = 0;

  for (int i = 0; i < lines_len; i++){
    int delimeter = 0;
    int bg = 0;
    int j = 0;
    while (lines[i][j] == ' '){
      j++;
    }
    if (lines[i] == NULL || lines[i][j] == '\0'){
      continue;
    }
    while (lines[i][j] != '\0'){
      if (lines[i][j] == '&'){
        bg++;
        while (lines[i][j + 1] == ' '){
          j++;
        }
        if (lines[i][j + 1] != '\0'){
          delimeter++;
        }
      }
      else if (lines[i][j] == ';' && lines[i][j + 1] != '\0'){
        delimeter++;
      }
      j++;
    }
    background += bg;
    foreground += delimeter + 1 - bg;
  }
    
  shellinfo_t result;
  result.fg = foreground;
  result.bg = background;
  return result;
}