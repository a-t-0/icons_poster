pip install TTS


# Not needed:
#git clone git@github.com:coqui-ai/TTS.git
#cd TTS
#pip install -e .[all,dev,notebooks]  # Select the relevant extras


# The TTS does not allow for long sentences, so to work around this, 
# you could increase the permitted max_decoder_steps.
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

mkdir -p "output/"
tts --text "An algorithm is selected." --out_path output/speech.wav
tts --text "An algo-rithm is selected." --out_path output/speech.wav

the_text='"'$(cat text.txt)'"'
tts --text "$the_text" --out_path output/text.wav

tts --text "An algorithm is selected." --model_name "tts_models/en/ljspeech/glow-tts" --out_path output/speech1.wav
tts --text "An algorithm is selected." --model_name "tts_models/en/ljspeech/tacotron2-DDC" --out_path output/speech2.wav
