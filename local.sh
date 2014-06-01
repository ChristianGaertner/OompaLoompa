export HUBOT_IRC_SERVER=kornbluth.freenode.net
export HUBOT_IRC_ROOMS="#OompaLoompa,#DaPing"
export HUBOT_MAIN_CHANNEL="$HUBOT_IRC_ROOMS"
export HUBOT_IRC_NICK="OompaLoompaTest"
export HUBOT_IRC_DEBUG=true
export HUBOT_LOG_LEVEL="debug"
export PORT=4000
export HUBOT_MAIN_CHANNEL="#OompaLoompa"
echo "RUN REDIS SERVER!!!!!!!!"

./bin/hubot -a irc -n "$HUBOT_IRC_NICK" -l oompa