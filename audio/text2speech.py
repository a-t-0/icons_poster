""" Browse into audio/ dir and run:
python text2speech.py
to convert the audio files into a .wav file"""

from os import walk

import os
from pprint import pprint
import re
import subprocess
from pydub import AudioSegment
import hashlib

def get_tts_models():
    tts_models=["tts_models/multilingual/multi-dataset/your_tts",
    "tts_models/en/ek1/tacotron2",
    "tts_models/en/ljspeech/tacotron2-DDC",
    "tts_models/en/ljspeech/tacotron2-DDC_ph",
    "tts_models/en/ljspeech/glow-tts",
    "tts_models/en/ljspeech/speedy-speech",
    "tts_models/en/ljspeech/tacotron2-DCA",
    "tts_models/en/ljspeech/vits",
    "tts_models/en/ljspeech/fast_pitch",
    "tts_models/en/vctk/vits",
    "tts_models/en/vctk/fast_pitch",
    "tts_models/en/sam/tacotron-DDC",
    "tts_models/en/blizzard2013/capacitron-t2-c50",
    "tts_models/en/blizzard2013/capacitron-t2-c150",
    "tts_models/es/mai/tacotron2-DDC",
    "tts_models/fr/mai/tacotron2-DDC",
    "tts_models/uk/mai/glow-tts",
    "tts_models/zh-CN/baker/tacotron2-DDC-GST",
    "tts_models/nl/mai/tacotron2-DDC",
    "tts_models/de/thorsten/tacotron2-DCA",
    "tts_models/de/thorsten/vits",
    "tts_models/ja/kokoro/tacotron2-DDC",
    "tts_models/tr/common-voice/glow-tts",
    "tts_models/it/mai_female/glow-tts",
    "tts_models/it/mai_female/vits",
    "tts_models/it/mai_male/glow-tts",
    "tts_models/it/mai_male/vits",
    "tts_models/ewe/openbible/vits",
    "tts_models/hau/openbible/vits",
    "tts_models/lin/openbible/vits",
    "tts_models/tw_akuapem/openbible/vits",
    "tts_models/tw_asante/openbible/vits",
    "tts_models/yor/openbible/vits",
    "vocoder_models/universal/libri-tts/wavegrad",
    "vocoder_models/universal/libri-tts/fullband-melgan",
    "vocoder_models/en/ek1/wavegrad",
    "vocoder_models/en/ljspeech/multiband-melgan",
    "vocoder_models/en/ljspeech/hifigan_v2",
    "vocoder_models/en/ljspeech/univnet",
    "vocoder_models/en/blizzard2013/hifigan_v2",
    "vocoder_models/en/vctk/hifigan_v2",
    "vocoder_models/en/sam/hifigan_v2",
    "vocoder_models/nl/mai/parallel-wavegan",
    "vocoder_models/de/thorsten/wavegrad",
    "vocoder_models/de/thorsten/fullband-melgan",
    "vocoder_models/ja/kokoro/hifigan_v1",
    "vocoder_models/uk/mai/multiband-melgan",
    "vocoder_models/tr/common-voice/hifigan",
    ]
    return tts_models


def split_into_sentences_using_nlp():
    import nltk.data
    nltk.download()

    tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
    fp = open("text.txt")
    data = fp.read()
    sentences='\n-----\n'.join(tokenizer.tokenize(data))
    return sentences


def load_txt_from_file(filename):
    fp = open(filename)
    text = fp.read()
    return text



def split_into_sentences(text):
    # Specify regex values.
    alphabets= "([A-Za-z])"
    prefixes = "(Mr|St|Mrs|Ms|Dr)[.]"
    suffixes = "(Inc|Ltd|Jr|Sr|Co)"
    starters = "(Mr|Mrs|Ms|Dr|He\s|She\s|It\s|They\s|Their\s|Our\s|We\s|But\s|However\s|That\s|This\s|Wherever)"
    acronyms = "([A-Z][.][A-Z][.](?:[A-Z][.])?)"
    websites = "[.](com|net|org|io|gov)"
    digits = "([0-9])"

    # Perform conversion.
    text = " " + text + "  "
    text = text.replace("\n"," ")
    text = re.sub(prefixes,"\\1<prd>",text)
    text = re.sub(websites,"<prd>\\1",text)
    text = re.sub(digits + "[.]" + digits,"\\1<prd>\\2",text)
    if "..." in text: text = text.replace("...","<prd><prd><prd>")
    if "Ph.D" in text: text = text.replace("Ph.D.","Ph<prd>D<prd>")
    text = re.sub("\s" + alphabets + "[.] "," \\1<prd> ",text)
    text = re.sub(acronyms+" "+starters,"\\1<stop> \\2",text)
    text = re.sub(alphabets + "[.]" + alphabets + "[.]" + alphabets + "[.]","\\1<prd>\\2<prd>\\3<prd>",text)
    text = re.sub(alphabets + "[.]" + alphabets + "[.]","\\1<prd>\\2<prd>",text)
    text = re.sub(" "+suffixes+"[.] "+starters," \\1<stop> \\2",text)
    text = re.sub(" "+suffixes+"[.]"," \\1<prd>",text)
    text = re.sub(" " + alphabets + "[.]"," \\1<prd>",text)
    if "”" in text: text = text.replace(".”","”.")
    if "\"" in text: text = text.replace(".\"","\".")
    if "!" in text: text = text.replace("!\"","\"!")
    if "?" in text: text = text.replace("?\"","\"?")
    text = text.replace(".",".<stop>")
    text = text.replace("?","?<stop>")
    text = text.replace("!","!<stop>")
    text = text.replace("<prd>",".")
    
    sentences = text.split("<stop>")
    sentences = sentences[:-1]
    sentences = [s.strip() for s in sentences]
    return sentences

def convert_sentences_to_wav_files(filename: str,output_dir:str ,sentences: list,use_hash:bool):
    soundbite_filepaths=[]
    for i,sentence in enumerate(sentences):
        
        # Compute filename
        if use_hash:
            soundbite_filepath=f"{output_dir}/{get_hash(sentence)}.wav"
        else:
            soundbite_filepath=f"{output_dir}/{filename}_{i}.wav"
        
        # Generate command to convert sentence to spoken .wav file.
        command=f'tts --text "{sentence}" --model_name "{tts_model}" --out_path {soundbite_filepath}'
        print(f'command={command}')

        # Execute command to convert sentence to spoken.wav file.
        subprocess.Popen(command, shell=True, stdout=subprocess.PIPE).stdout.read()

        # Store the filepath.
        soundbite_filepaths.append(soundbite_filepath)

    return soundbite_filepaths
    
def get_hash(string:str):
    return hashlib.sha256(string.encode("utf-8")).hexdigest()
def install_ffmpeg_if_needed(format):
    if format =="mp3":
        # Check if ffmpeg already installed
        if not is_ffmpeg_installed():    
            subprocess.Popen("yes | sudo apt install ffmpeg", shell=True, stdout=subprocess.PIPE).stdout.read()

def is_ffmpeg_installed():
    import subprocess
    result = subprocess.run(['apt', 'list', '--installed'], stdout=subprocess.PIPE)
    if "ffmpeg" in result.stdout.decode('utf-8'):
        return True
    return False

def merge_wav_files_into_single_mp3(format: str,output_dir:str,output_filename:str,soundbite_filepaths:list):
    
    # Verify the output format and install requirements if needed.
    if format not in ["mp3","wav"]:
        raise Exception(f"Format:{format} not supported.")
    install_ffmpeg_if_needed(format)

    # Create output filepath of merged audio file.
    output_filepath=f"{output_dir}/{output_filename}.{format}"
    

    # Start merging the soundbites into one audio file.
    combined_sounds=None
    for soundbite_filepath in soundbite_filepaths:
        
        some_sound=AudioSegment.from_wav(soundbite_filepath)
        if combined_sounds is None:
            combined_sounds=some_sound    
        else:
            combined_sounds=combined_sounds+some_sound
    combined_sounds.export(output_filepath, format=format)

def get_output_files(output_dir,soundbite_filename):
    soundbite_filepaths=[]
    for i in range(0,10000):
        soundbite_filepath=f"{output_dir}/{soundbite_filename}_{i}.wav"
        if os.path.isfile(soundbite_filepath):
            soundbite_filepaths.append(soundbite_filepath)
    return soundbite_filepaths

def merge_without_converting(extension, output_dir,output_filename,soundbite_filename):
    soundbite_filepaths=get_output_files(output_dir,soundbite_filename)
    print(f'soundbite_filepaths={soundbite_filepaths}')
    merge_wav_files_into_single_mp3(extension,output_dir,output_filename,soundbite_filepaths)
    exit()

def find_already_created_soundbites(output_dir, sentences):
    
    existing_soundbites=[]
    soundbite_filenames = next(walk(output_dir), (None, None, []))[2]  # [] if no file

    for sentence in sentences:
        for soundbite_filename in soundbite_filenames:
            if get_hash(sentence) == soundbite_filename[:-4]:
                existing_soundbites.append(sentence)
    
    return existing_soundbites
        
def get_filepaths_to_be_merged(output_dir,sentences,soundbite_extension):
    filepaths=[]
    for sentence in sentences:
        filepath=f"{output_dir}/{get_hash(sentence)}.{soundbite_extension}"
        if os.path.isfile(filepath):
            filepaths.append(filepath)
        else:
            raise Exception("Error, the file for sentence:{sentence}"
            +f" does not exist at:{filepath}")
    return filepaths

def create_target_dir_if_not_exists(path, new_dir_name):
    """Creates an output dir for graph plots.

    :param path: param new_dir_name:
    :param new_dir_name:
    """

    #create_root_dir_if_not_exists(path)
    if not os.path.exists(f"{path}/{new_dir_name}"):
        os.makedirs(f"{path}/{new_dir_name}")


def create_model_output_dirs(output_dir,model_name):
    """Results directory structure is: <repository root_dir>/audio/output/<model name>.
    """
    # Execute command to convert sentence to spoken.wav file.
    subprocess.Popen(f"mkdir -p {output_dir}/{model_name}", shell=True, stdout=subprocess.PIPE).stdout.read()
    #create_target_dir_if_not_exists(f"{output_dir}/", model_name)
    # TODO: assert directory: <repo root dir>/results/stage_1" exists


def create_output(extension,output_dir,output_filename,soundbite_extension,soundbite_filename,tts_model):

    # TODO: ensure and verify output dir exists.
    create_model_output_dirs(output_dir,tts_model)
    model_output_dir=f"{output_dir}/{tts_model}"

    # TODO: Clear out output directory before starting.

    # TODO: allow manually overwriting a single soundbite without converting the entire text.

    # Optional: If you already generated the separate .wav soundbites and would like to merge.
    #merge_without_converting(extension, output_dir,output_filename,soundbite_filename)

    # Load the presentation text from file.
    text=load_txt_from_file("text.txt")

    # Separate the text into smaller sentences.
    sentences=split_into_sentences(text)

    # TODO: Verify the sentences are short enough.

    # Verify which sentences have been unchanged based on the file hash name,
    already_created_soundbites  = find_already_created_soundbites(model_output_dir, sentences)
    # Eliminate unchanged sentences from list.
    sentences_to_create = list(set(sentences)^set(already_created_soundbites))

    # Convert the sentences into .wav files
    convert_sentences_to_wav_files(soundbite_filename,model_output_dir,sentences_to_create,use_hash=True)

    # Get the list of filepaths that will be merged.
    soundbite_filepaths=get_filepaths_to_be_merged(model_output_dir,sentences,soundbite_extension)

    # Merge the .wav files into a single .wav file
    merge_wav_files_into_single_mp3(extension,model_output_dir,output_filename,soundbite_filepaths)
    print(f'done')

    # TODO: Allow user to remove unused soundbites.

# Specify the audio output dir.
output_dir="output"
soundbite_filename="soundbite"
output_filename="Spoken_text"
soundbite_extension="wav"
extension="mp3"

sentences=["An algorithm is.","Part of my space."]
#Best in 2:5
best_so_far="tts_models/en/ljspeech/tacotron2-DDC_ph"
tts_models=get_tts_models()
for tts_model in [best_so_far]:
    create_output(extension,output_dir,output_filename,soundbite_extension,soundbite_filename,tts_model)