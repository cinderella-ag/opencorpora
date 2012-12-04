# coding: utf-8

import sys
import random
from utils import Corpus, Sentence, read_corpus, write_corpus


def get_random_sentences(corpus, n):
    return random.sample(corpus, n)


def get_corpora(corpus, c, n):
    """
    Get c instances of Corpus() made of n sentences.
    Returns iterator!
    """
    for i in range(c):
        yield (i, get_random_sentences(corpus, n))


if __name__ == '__main__':
    args = sys.argv[1:]
    n = 1
    c = 1
    for i in range(len(args)):
        if args[i] == '-n':
            n = int(args[i + 1])
        if args[i] == '-c':
            c = int(args[i + 1])
    inc = sys.stdin.read()
    inc = read_corpus(inc)
    for sample in get_corpora(inc, c, n):
        outc = write_corpus(sample[1], sys.stdout)
