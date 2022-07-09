pip install TTS
git clone git@github.com:coqui-ai/TTS.git
cd TTS
#pip install -e .[all,dev,notebooks]  # Select the relevant extras
mkdir -p "output/path/"
tts --text "Text for TTS" --out_path output/path/speech.wav

#the_text='"'$(cat text.txt)'"'
the_text='"'$(cat t1.txt)'"'
tts --text "$the_text" --out_path output/path/text.wav

# The TTS does not allow for long sentences, so to work around this, you could:
# Source: https://github.com/coqui-ai/TTS/issues/1333

# Open the configuration of the default model, 
# (which is en--ljspeech--hifigan_v2), located at:
# ~/.local/share/tts/vocoder_models--en--ljspeech--hifigan_v2/config.json

# Then add/ensure it contains:
# "max_decoder_steps": 5000

# In short, make the last lines of the config.json look like:
#    // PATHS
#    "output_path": "/home/erogol/gdrive/Trainings/sam/",
#    // Custom limit made larger
#    "max_decoder_steps": 5000
#}