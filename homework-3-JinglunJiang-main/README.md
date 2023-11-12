[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/6-TEvgSW)
# Homework 3

This homework provides practice:

* Understanding scope/closure rules. (Problem 1)
* Implementing a large function by breaking it down into smaller subproblems on your own without step-by-step guidance. (Problem 1)
* Working with generators (Problem 2).
* Problem 1 also introduces the concept of a `class`.  We will cover classes in detail next week, but you will use a user-defined class (and may, but do not have to, make modifications to it).

## Problem 1

Memoization is an optimization technique for speeding up function calls by caching the function result for a given set of inputs.

The standard library provides a decorator `functools.lru_cache` that performs memoization of any function it wraps.
It only stores results from the N most recent calls.  This is called a least recently used (LRU) cache.

For this problem, you will write your own version of `@lru_cache`.

`lru_cache(max_size=128)` should be a decorator that does the following:

- Return the wrapped function with its arbitrary arguments.
- Maintain an LRU cache that stores up to `max_size` arguments and their corresponding results.
    - Function arguments of different types must be cached separately.  For example `f(3)` and `f(3.0)` are distinct calls.
    - The cache must use a LRU policy, a good illustration of this is at
      https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)
    - Add a `cache_info` property to the returned wrapped function object, of type `CacheInfo` below.


### `CacheInfo`

We have provided a class called `CacheInfo`. It has the following public attributes:

- `hits`: Number of calls to the function where the result was returned from the cache.
- `misses`: Number of calls to the function where the result needed to be calculated by calling the function.
- `max_size`: The maximum number of entries the cache can store.
- `cur_size`: The number of entries currently stored.

The class also provide its own string representation for printing.  Here's an example of how CacheInfo may be called:

```python
>>> from problem1 import CacheInfo
>>> cache_info = CacheInfo(max_size=4)
>>> print(cache_info)
CacheInfo(hits=0, misses=0, max_size=4, cur_size=0)
>>> cache_info.hits += 1    # note: class instances are mutable, this is how you would update an attribute
>>> print(cache_info)
CacheInfo(hits=1, misses=0, max_size=4, cur_size=0)
```

You are allowed to add methods/properties to the class to support your implementation, but do not remove/modify what is provided.


### Example
```python

@lru_cache(5)
def add(a, b):
    print(f"add({a}, {b})")
    return a + b

add(1, 2)  # will print add(1, 2)
add(2, 1)  # will print add(2, 1)
add(2, 2)  # will print add(2, 2)
add(1, 2)  # will return 3 without printing, since the cache will be used

print(add.cache_info)
# will print CacheInfo(hits=1, misses=3, max_size=5, cur_size=3)

# make 10 additional calls
for x in range(10):
    add(x, x)

# will again print add(1, 2)
add(1, 2)
# because prior 10 calls will have bumped add(1, 2) from the LRU cache
```

### Hints

* This is a large function, the most complex you've written so far for this class. The key to tackling a problem like this is to break it down into smaller problems.  Write helper functions as needed (e.g. how will you determine a cache key for a set of args/kwargs?). This will both help you get started with a large task and ensure your design grade remains high.
* This is an implementation in `functools.lru_cache` that is highly optimized and in no way resembles the intended solution for this course. Your implementation **SHOULD NOT** be based on the one that Python provides. (example: your implementation **must** use a dictionary, and not a list for storing the cache)
* You can assign attributes to a function, since functions are objects. (e.g. `my_func.cache_info = CacheInfo(...)`)

## Problem 2

Implement the function `grep` with the following definition:

```
def grep(pattern, lines, ignore_case=False):
    pass
```

`pattern` is a string that represents text we're searching for within each line.

`lines` is an *iterable* of strings to search within.

`ignore_case` indicates whether or not the comparison should be done in a case-sensitive manner or not. It is an optional parameter that defaults to `False`.

**You must implement grep as a generator function.  It must not return a list.**

The below example shows expected behavior, as well as some useful ways to test your generator function from the REPL:

```python
>>> import problem2

>>> lines = ["I went to Poland.", "He went to Spain.", "She is very happy."]

>>> gen = problem2.grep("went", lines)

# useful to call `list` on the generator to see results all at once
>>> list(gen)
["I went to Poland.", "He went to Spain."]

>>> gen = problem2.grep("he", lines, ignore_case=True)
>>> next(gen)
"He went to Spain."
>>> next(gen)
"She is very happy."
>>> next(gen)
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
```
