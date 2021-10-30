#!/usr/local/bin/python
PROGNAME = "convert-txt-to-ics.py"

# Python info:
# https://docs.python.org/2.7/library/argparse.html
# https://docs.python.org/2/howto/argparse.html
import argparse
import sys

# https://pypi.python.org/pypi/ics/
# http://icspy.readthedocs.io/en/v0.3/
# http://icspy.readthedocs.io/en/v0.3.1/
from ics import Calendar, Event
from datetime import timedelta

parser = argparse.ArgumentParser(
  formatter_class=argparse.RawDescriptionHelpFormatter,
  description= PROGNAME+" (convert tab-delimeted format into iCalendar.ics)",
)
#parser.add_argument('--window', action='store_true', help='Start the monitor in fullscreen window')
parser.add_argument('--file', metavar='FILENAME', help='filename.txt to be read')
args = parser.parse_args()
if len(sys.argv)==1:
        parser.print_help()
        sys.exit(1)

infile = args.file
outfile = infile + ".ics"

#print "{} - {}".format(infile, outfile)
#exit(0)

with open (infile, "r") as myfile:
	lines = myfile.readlines()

c = Calendar()
for line in lines:
	date, msg = line.split("\t")
	e = Event()
	e.name = "FFP1 sw devel (details in git-log)"
	e.description = msg
	e.begin = date
	e.duration = timedelta(hours=1)
	c.events.append(e)

with open(outfile, 'w') as myfile:
	myfile.writelines(c)

#
