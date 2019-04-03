# Helm wrapper

Bash wrapper to run Helm backed up by a local Tiller instance.

The first time the wrapper it's used, it initializes Tiller for you, then it
just works as the helm command.

If Tiller session expires the script will attempt to restart Tiller before
running Helm again.
