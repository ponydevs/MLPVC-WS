#!/usr/bin/env bash
read oldrev newrev refname
echo "Push triggered update to revision $newrev ($refname)"

CMD_PWD="cd .. && pwd"
CMD_FETCH="env -i git fetch"
CMD_YARN="yarn install --production"
CMD_RESTART="pm2 restart pm2.json"

echo "$ $CMD_PWD"
eval $CMD_PWD
echo "$ $CMD_FETCH"
eval $CMD_FETCH

if git diff --name-only $oldrev $newrev | grep "^yarn.lock"; then
	echo "$ $CMD_YARN"
	eval $CMD_YARN
else
	echo "# Skipping yarn install, lockfile not modified"
fi

if git diff --name-only $oldrev $newrev | grep "^server.js"; then
	echo "$ $CMD_RESTART"
	eval $CMD_RESTART
else
	echo "# Skipping server restart, serve file not modified"
fi
