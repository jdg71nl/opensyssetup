#!/usr/bin/env python3

# http://stackoverflow.com/questions/490195/split-a-multi-page-pdf-file-into-multiple-pdf-files-with-python

# Usage:
# > for x in *.pdf; do echo $x ; /usr/local/syssetup/bin/pdf_split_pages.py $x; done

#> pip3 install pyPdf
#> pip3 install pdf
# JDG: does not work??
# File "/Library/Frameworks/Python.framework/Versions/3.5/lib/python3.5/site-packages/pyPdf/__init__.py", line 1, in <module>
#     from pdf import PdfFileReader, PdfFileWriter
# ImportError: No module named 'pdf'

# Error: NameError: name 'xrange' is not defined
# http://pythoncentral.io/how-to-use-pythons-xrange-and-range/
# Deprecation of Python's xrange
# One more thing to add. In Python 3.x, the xrange function does not exist anymore. The range function now does what xrange does in Python 2.x, so to keep your code portable, you might want to stick to using range instead. 
# https://docs.python.org/3.5/library/functions.html

#> pip3 install PyPDF2

import sys
import os
#from pyPdf import PdfFileWriter, PdfFileReader
from PyPDF2 import PdfFileWriter, PdfFileReader

infile = ''
try:
	infile = sys.argv[1]
except:
	pass
if len(sys.argv)==1 or infile is None or infile == '':
	print('# Error: provide filename.pdf')
	sys.exit(0)
if not os.path.exists(infile):
	print('# Error: cannot open {}'.format(infile))
	sys.exit(0)

inputpdf = PdfFileReader(open(infile, "rb"))

# http://www.python-course.eu/python3_formatted_output.php

#for i in xrange(inputpdf.numPages):
for i in range(inputpdf.numPages):
	output = PdfFileWriter()
	output.addPage(inputpdf.getPage(i))
	outfile = '{}.{:03d}.pdf'.format(infile,i)
	with open(outfile, "wb") as outputStream:
		output.write(outputStream)

