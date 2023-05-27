#!/bin/bash

#Runpod setup directions here: https://www.youtube.com/watch?v=TP2yID7Ubr4
#You MUST set container image to runpod/oobabooga:1.1.0
#Set Disk size to at least 50GB
#Always use a fresh pod.
#git clone this file by default to /text-generation-webui

cd /text-generation-webui

# Ask the user if they are using "Silly Tavern"
read -p "Are you using a separate interface with TTS, such as silly tavern? (y/n) " SILLY_TAVERN
read -p "Stop installation on errors? (y/n) " ERROR_STOP

# Stop on error?
if [[ "$ERROR_STOP" != "n" ]]
then
	set -e
fi

# Update git repository
git pull
pip install -r requirements.txt

# Create repositories directory and clone GPTQ-for-LLaMa
mkdir -p repositories
cd repositories
git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git -b cuda
cd GPTQ-for-LLaMa
python setup_cuda.py install

# Install additional Python dependencies
cd /text-generation-webui
pip install scipy

# Update system packages and install ffmpeg
apt-get update
apt-get install -y ffmpeg

# Install Python dependencies for each extension
cd extensions/elevenlabs_tts
pip install -r requirements.txt

cd /text-generation-webui/extensions/whisper_stt
pip install -r requirements.txt

cd /text-generation-webui/extensions/api
pip install -r requirements.txt

# Go back to text-generation-webui
cd /text-generation-webui

echo -e "\e[32mStarting server... press Ctrl-C and re-run server.py if fails\e[0m"

# Run server and get its PID
if [ "$SILLY_TAVERN" = "y" ]
then
	echo -e "\e[32mrunning python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt api\e[0m"
	python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt api

else
	echo -e "\e[32mrunning python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt elevenlabs_tts api\e[0m"
    python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt elevenlabs_tts api
fi


