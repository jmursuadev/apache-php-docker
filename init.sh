#!/bin/bash
exec /usr/bin/supervisord  -k -c /etc/supervisor/supervisord.conf
# exec supervisorctl -k -c /etc/supervisor/supervisord.conf

echo "DONE INIT"