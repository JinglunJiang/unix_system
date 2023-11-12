class CacheInfo:
    def __init__(self, max_size):
        self.max_size = max_size
        self.misses = 0
        self.hits = 0
        self.cur_size = 0

    def __repr__(self):
        return f"CacheInfo(hits={self.hits}, misses={self.misses}, max_size={self.max_size}, cur_size={self.cur_size})"

def lru_cache(max_size=128):
    """
    The purpose is to make the decorator can take additional argument (max_size)
    This is a decorator factory function that returns the decorator
    Input: an integer represent the maximum size of the cache
    Output: the decorator function

    """
    def lru_cache_decorator(func):
        """
        The decorator function which will be returned by the factory function
        Input: the function that uses this decorator
        Output: returns the wrapped function
        """
        cache = {}
        order = []
        info = CacheInfo(max_size)

        def ordering(key):
            """
            The ordering function which change the sequence in the order list
            Keep track of the most recently used key.
            Input: a tuple which is the key
            Output: no output, just the sequence inside the list will be changed
            """
            if key in order:
                order.remove(key)
            order.append(key)

        def key_convert(args, kwargs):
            """
            Change the inputs into a key that can be hashed
            Input: args, and keywordargs
            Output: a tuple which is hashable, inside the tuple there's a bunch of tuple stores paired
            type and args, and another bunch of tuple store paired type of kwargs and kwargs themselves
            """
            key = (tuple((arg, type(arg)) for arg in args), tuple((k, v, type(v)) for k, v in kwargs.items()))
            return key

        def wrapped(*args, **kwargs):
            """
            The wrapped function takes in the args and keyword args, return the result of the function
            Input: args and kwargs
            Output: the result of the func
            """
            key = key_convert(args, kwargs)

            if key in cache:
                info.hits += 1
                ordering(key)
            else:
                info.misses += 1
                value = func(*args, **kwargs) 
                cache[key] = value
                ordering(key)
                info.cur_size += 1
                if info.cur_size > info.max_size:
                    delete_key = order[0]
                    order.pop(0)
                    cache.pop(delete_key)
                    info.cur_size -= 1

            return cache[key]
        
        wrapped.cache_info = info

        return wrapped

    return lru_cache_decorator