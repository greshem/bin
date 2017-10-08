git reset  --hard $(git log  |grep commit |tail -n 1 |awk '{print $2}' )

