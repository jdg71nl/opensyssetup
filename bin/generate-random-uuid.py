#!/usr/bin/python3
#!/bin/env python
# file: generate-random-uuid.py 

# UUID = 128 bits = hex-format: 00112233-4455-6677-8899-aabbccddeeff

# https://docs.python.org/3/library/functions.html#print

import random

rand = random.random() * 16**6
print("rand = %f" % rand)

import hashlib
string="pythonpool.com"
encoded=string.encode()
result = hashlib.sha256(encoded)
# print("String : ", end="")
# print(string)
# print("Hash Value : ", end="")
# print(result)
# print("Hexadecimal equivalent: ", result.hexdigest())
# print("Digest Size : ", end="")
# print(result.digest_size)
# print("Block Size : ", end="")
# print(result.block_size)

print("result             = ", result )
print("encoded            = ", encoded )
print("result.hexdigest() = ", result.hexdigest() )

#
