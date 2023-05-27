# oobawebui_setup
Simple bash script to quickly setup an oobabooga webui server on a Runpod instance.
Clone this via the web terminal and then run via ./webui_setup.sh from /oobawebui_setup directory
Git clones this filder by default to /text-generation-webui after a pod is initialized.

Runpod setup directions here: https://www.youtube.com/watch?v=TP2yID7Ubr4
You MUST set container image to runpod/oobabooga:1.1.0
Set Disk size to at least 50GB.
Use a fresh pod if able, or minimally reset it if there are errors present.
Edit the pod and remove the pygmalion model autoload ENVIRONMENT VARIABLE to quicken the installation.  By default llama is flagged to load in this script to prevent pyg from loading, though llama doesn't actually load (on purpose).
Cloudflared api url takes an intial server setup to fully init at times, so the server.py script re-inits once purposely.
