""" Browse into audio/ dir and run:
python text2speech.py
to convert the audio files into a .wav file"""



import os
import re
import subprocess
from pydub import AudioSegment


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

    # Perform conversion.
    text = " " + text + "  "
    text = text.replace("\n"," ")
    text = re.sub(prefixes,"\\1<prd>",text)
    text = re.sub(websites,"<prd>\\1",text)
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

def convert_sentences_to_wav_files(filename: str,output_dir:str ,sentences: list):
    soundbite_filepaths=[]
    for i,sentence in enumerate(sentences):
        soundbite_filepath=f"{output_dir}/{filename}_{i}.wav"
        command=f'tts --text "{sentence}" --out_path {soundbite_filepath}'
        print(f'command={command}')
        subprocess.Popen(command, shell=True, stdout=subprocess.PIPE).stdout.read()
        soundbite_filepaths.append(soundbite_filepath)
    return soundbite_filepaths
    
def install_ffmpeg_if_needed(format):
    if format =="mp3":
        subprocess.Popen("yes | sudo apt install ffmpeg", shell=True, stdout=subprocess.PIPE).stdout.read()

def merge_wav_files_into_single_mp3(format: str,output_dir:str,output_filename:str,soundbite_filepaths:list):
    if format not in ["mp3","wav"]:
        raise Exception(f"Format:{format} not supported.")
    install_ffmpeg_if_needed(format)

    output_filepath=f"{output_dir}/{output_filename}.{format}"
    print(f'output_filepath={output_filepath}')

    
    combined_sounds=None
    for soundbite_filepath in soundbite_filepaths:
        print(f'soundbite_filepath={soundbite_filepath}')
        some_sound=AudioSegment.from_wav(soundbite_filepath)
        if combined_sounds is None:
            combined_sounds=some_sound    
        else:
            combined_sounds=combined_sounds+some_sound

    #combined_sounds = sound1 + sound2
    #combined_sounds.export("/output/path.wav", format="wav")
    #combined_sounds.export("/output/path.mp3", format="mp3")
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


# Specify the audio output dir.
output_dir="output"
soundbite_filename="soundbite"
output_filename="Spoken_text"
extension="mp3"
# TODO: ensure and verify output dir exists.

# TODO: Clear out output directory before starting.

# TODO: allow manually overwriting a single soundbite without converting the entire text.

# Optional: If you already generated the separate .wav soundbites and would like to merge.
# merge_without_converting(extension, output_dir,output_filename,soundbite_filename)

# Load the presentation text from file.
text=load_txt_from_file("text.txt")
# Separate the text into smaller sentences.
sentences=split_into_sentences(text)
print(f'sentences={sentences}')

# TODO: Verify the sentences are short enough.

# Convert the sentences into .wav files
soundbite_filepaths= convert_sentences_to_wav_files(soundbite_filename,output_dir,sentences)

# Merge the .wav files into a single .wav file
merge_wav_files_into_single_mp3(extension,output_dir,output_filename,soundbite_filepaths)