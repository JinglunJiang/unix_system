import problem2
import pytest

lines = ["I went to Poland.", "He went to Spain.", "She is very happy."]


def test_example1():
    gen = problem2.grep("went", lines)
    assert list(gen) == [
        "I went to Poland.",
        "He went to Spain.",
    ]


def test_example2():
    gen = problem2.grep("he", lines, ignore_case=True)
    assert next(gen) == "He went to Spain."
    assert next(gen) == "She is very happy."
    with pytest.raises(StopIteration):
        next(gen)


def test_example2_case_sensitive():
    gen = problem2.grep("he", lines, ignore_case=False)
    assert next(gen) == "She is very happy."
    with pytest.raises(StopIteration):
        next(gen)


def test_case_pattern():
    assert list(problem2.grep("poland", lines)) == []
    assert list(problem2.grep("Poland", lines)) == ["I went to Poland."]
    assert list(problem2.grep("poland", lines, ignore_case=True)) == [
        "I went to Poland."
    ]
    assert list(problem2.grep("POLAND", lines)) == []
    assert list(problem2.grep("POLAND", lines, ignore_case=True)) == [
        "I went to Poland."
    ]


def test_non_greedy():
    def strings_4eva():
        while True:
            yield "strings"

    gen = problem2.grep("string", strings_4eva())
    assert next(gen) == "strings"
    assert next(gen) == "strings"
    assert next(gen) == "strings"
