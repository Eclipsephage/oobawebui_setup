# oobawebui_setup
Simple bash script to quickly setup an oobabooga webui server on a Runpod instance and instantiate api access for a service such as Silly Tavern.

Example Runpod setup directions here: https://www.youtube.com/watch?v=TP2yID7Ubr4. \
You MUST set container image to runpod/oobabooga:1.1.0\
Set Disk size to at least 50GB.\
Use a fresh pod if able, or minimally reset it if there are errors present.

Edit the pod and remove the pygmalion model autoload ENVIRONMENT VARIABLE to quicken the installation. Regardless, llama is flagged to load in this script to prevent pyg from loading, though llama doesn't actually load (on purpose).

After runpod is active, press connect, then start and connect to the runpod web terminal.\
You are now in the /text-generation-webui directory.\
Type "git clone https://github.com/Eclipsephage/oobawebui_setup.git". \
Then "cd oobawebui_setup". \
Then type "./webui_setup.sh" from /oobawebui_setup directory . The setup sequence will begin.

Cloudflared api url takes an intial server setup to fully init at times, so the server.py script kills and re-inits once purposely and prompts the user to re-kill and rerun server.py as needed.
