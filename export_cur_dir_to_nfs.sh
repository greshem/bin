#!/bin/bash
pwd=$(pwd);
if ! grep $pwd  /etc/exports ;then
	echo $pwd   \*\(sync,rw,no_root_squash\) >> /etc/exports
fi
