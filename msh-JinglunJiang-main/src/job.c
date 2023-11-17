#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "job.h"
#include "shell.h"

bool add_job(job_t *jobs, int max_jobs, pid_t pid, job_state_t state, const char *cmd_line){
  for (int i = 0; i < max_jobs; i++){
    if (jobs[i].state == UNDEFINED){
      jobs[i].pid = pid;
      jobs[i].state = state;
      jobs[i].cmd_line = strdup(cmd_line); // allocate memory and copy the command line
      return true;
    }
  }
  return false; // when there's no space left for the to be added job
}

bool delete_job(job_t *jobs, int max_jobs, pid_t pid){
  for (int i = 0; i < max_jobs; i++){
    if (jobs[i].pid == pid && jobs[i].state != UNDEFINED){
      free(jobs[i].cmd_line);
      jobs[i].state = UNDEFINED;
      return true;
    }
  }
  return false;
}

void free_jobs(job_t *jobs, int max_jobs){
  for (int i = 0; i < max_jobs; i++){
    if (jobs[i].state != UNDEFINED){
      free(jobs[i].cmd_line); // The command lines need to be freed
    }
  }
  free(jobs);
}