def grep(pattern, lines, ignore_case=False):
    """
    Grepping by matching the "pattern" in "lines", can choose if need to be case sensitive
    Inputs: pattern: a string to match
            lines: an iteration of strings we need to search
            ignorecase: boolean means if should be case sensitive
    Outputs: one at a time of the line(a string) consists of "pattern" 
    """
    for line in lines:
        if ignore_case:
            if pattern.lower() in line.lower():
               yield line
        else:
          if pattern in line:
            yield line
        