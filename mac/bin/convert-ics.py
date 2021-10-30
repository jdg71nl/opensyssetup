#!/usr/local/bin/python

# Python info:
# https://docs.python.org/2.7/library/argparse.html
# https://docs.python.org/2/howto/argparse.html
import argparse
import sys

# https://pypi.python.org/pypi/ics/
# http://icspy.readthedocs.io/en/v0.3/
# http://icspy.readthedocs.io/en/v0.3.1/
from ics import Calendar

PROGNAME = "convert-ics.py"

parser = argparse.ArgumentParser(
  formatter_class=argparse.RawDescriptionHelpFormatter,
  description= PROGNAME+" (convert iCalendar.ics files into tab-delimeted format)",
)
#parser.add_argument('--window', action='store_true', help='Start the monitor in fullscreen window')
parser.add_argument('--file', metavar='FILENAME', help='filename.isc to be read')
args = parser.parse_args()
if len(sys.argv)==1:
        parser.print_help()
        sys.exit(1)

with open (args.file, "r") as myfile:
	data=myfile.readlines()
c = Calendar(data)
for e in c.events:
	print "{}\t{}\t{}".format(e.begin, e.duration, e.name)

#
