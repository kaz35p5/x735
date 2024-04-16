#
# Regular cron jobs for the x735 package.
#
0 4	* * *	root	[ -x /usr/bin/x735_maintenance ] && /usr/bin/x735_maintenance
