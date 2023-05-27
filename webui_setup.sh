#!/bin/bash

#Runpod setup directions here: https://www.youtube.com/watch?v=TP2yID7Ubr4

# Stop on error
set -e

cd /text-generation-webui

# Ask the user if they are using "Silly Tavern"
read -p "Are you using 'Silly Tavern'? (y/n) " SILLY_TAVERN

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

echo "Setting up server..."

# Run server and get its PID
if [ "$SILLY_TAVERN" = "y" ]
then
    python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt api &
else
    python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt elevenlabs_tts api &
fi
SERVER_PID=$!

# Print message and wait for 5 seconds
echo "Setup complete.  Restarting server..."
sleep 5

# Kill the server process and restart it
kill $SERVER_PID
if [ "$SILLY_TAVERN" = "y" ]
then
    python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt api
else
    python server.py --share --public-api --api --trust-remote-code --chat --auto-devices --model llama --extension whisper_stt elevenlabs_tts api
fi
