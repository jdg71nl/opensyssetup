#!/bin/sh

#rsync -rtv --include='*.jpg' /Users/jdgraaff/Pictures/iPhoto\ Library/Originals/ /Users/jdgraaff/Pictures/copy-iPhoto-MacBook-jdg/
#rsync -rtv --include='*.jpg' /Users/jdgraaff/Pictures/iPhoto\ Library/Modified/  /Users/jdgraaff/Pictures/copy-iPhoto-MacBook-jdg/
#rsync -rtv --delete /Users/jdgraaff/Pictures/copy-iPhoto-MacBook-jdg/ rsync://172.24.2.50/copy-iPhoto-MacBook-jdg/

rsync -rtv --delete --delete-after /Users/jdgraaff/Pictures/links-iPhoto-MacBook-jdg/ rsync://172.24.2.50/copy-iPhoto-MacBook-jdg/

