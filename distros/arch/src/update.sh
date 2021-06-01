#/bin/bash

update=$(checkupdates+aur | wc -l)
#update="1"
if [[ "$update" != 0 ]]
then
echo " $update "
else
echo 
fi

