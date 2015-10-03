RandomBag
===

Swift framework with random number utility functions.

It uses the SecRandomCopyBytes() function to retrieve random data.

Included:

* wrappers for SecRandomCopyBytes() for working with bytes, bits, ...
* common algorithms (e.g. Knuth-Fisher-Yates shuffle, etc.)
* some NIST tests from the 800-22 rev1a document (http://csrc.nist.gov/groups/ST/toolkit/rng/documents/SP800-22rev1a.pdf)
