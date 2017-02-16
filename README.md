# Supported tags and respective `Dockerfile` links

- [`armhf` (*Dockerfile*)](https://github.com/syphr42/docker-jasper/blob/master/Dockerfile.armhf)


Table of Contents
=================

  * [Introduction](#introduction)
  * [About This Image](#about-this-image)
  * [Download](#download)
  * [Usage](#usage)
  * [Parameters](#parameters)
  * [Building the image](#building-the-image)
  * [License](#license)

# Introduction
Jasper is a system that connects various speech-to-text (STT) engines to various text-to-speech (TTS) engines with processing in between. It listens over a microphone for voice input, converts it to text (STT), and locates a module to handle the input. The module interprets the textual input, takes an action, and then can respond to the user by converting text back to a voice (TTS) to be played from a speaker.

This repository is not affiliated with the Jasper Project.

For more information, visit the [Jasper Project](https://jasperproject.github.io).

# About This Image

Jasper is configured with the PocketSphinx STT and the Pico TTS. If you supply your own profile, please note the following items are necessary to use these preconfigured engines:

```python
stt_engine: sphinx
tts_engine: pico-tts

pocketsphinx:
  fst_model: '/jasper/phonetisaurus/g014b2b/g014b2b.fst'
  hmm_dir: '/usr/share/pocketsphinx/model/hmm/en_US/hub4wsj_sc_8k'

pico-tts:
  language: en-US
```

# Download

```bash
docker pull syphr/jasper:armhf
```

# Usage

If you start the container without any profile (no file found at '/jasper/config/profile.yml'), it will attemp to run the profile initializer included with Jasper. For this to work properly, the container must be running in interactive mode with a console and not detached.  

The simplest way to start is with the following command:

```bash
docker run \
    -it
    --name jasper \
    --privileged \
    --volume /dev/snd/pcmC0D0p:/dev/snd/pcmC1D0p \
    --volume /dev/snd/pcmC1D0c:/dev/snd/pcmC0D0c \
    --volume /dev/snd/controlC0:/dev/snd/controlC1 \
    --volume /dev/snd/controlC1:/dev/snd/controlC0 \
    --volume /data/jasper/config:/jasper/config \
    syphr/jasper:armhf
```

Let's take a look at each argument to ``docker run``:

``--it``
This tells Docker to run in interactive mode and assign a console. This is required only if you want to run the profile setup wizard when the container first starts. The wizard will run only if no profile.yml exists.

``--privileged``
To access the sound devices (capture and playback), the container needs to run as privileged.
*If you know of a way to avoid this requirement, please start a pull request.*

``--volume /dev/snd/pcmC0D0p:/dev/snd/pcmC1D0p``
This is mapping Card 0/Device 0 for playback ('p') from the host to Card 1/Device 0 for playback in the container. Card 1/Device 0 must be the playback device in the container so you will need to map whatever is on your host appropriately.

``--volume /dev/snd/pcmC1D0c:/dev/snd/pcmC0D0c``
This is mapping Card 1/Device 0 for capture ('c') from the host to Card 0/Device 0 for capture in the container. Card 0/Device 0 must be the capture device in the container so you will need to map whatever is on your host appropriately.

``--volume /dev/snd/controlC0:/dev/snd/controlC1``
Since I switched the order of my cards in the statements above, I am doing the same with the control devices. This is Card 0 on the host mapped to Card 1 in the container.

``--volume /dev/snd/controlC1:/dev/snd/controlC0``
Since I switched the order of my cards in the statements above, I am doing the same with the control devices. This is Card 1 on the host mapped to Card 0 in the container.

``--volume /data/jasper/config:/jasper/config``
Map the configuration directory to '/data/jasper/config' on the host so the profile persists after the container is removed.

``syphr/jasper:armhf``
This is the image to run.

# Parameters

* `--volume /jasper/config` - Jasper profile and other configs

# Building the image

Checkout the github repository and then run these commands:
```bash
$ docker build -t syphr/jasper:armhf -f Dockerfile.armhf .
```

Optionally, you can build with an alternate repository for the Jasper codebase:
```bash
$ docker build \
    -t syphr/jasper:armhf \
    -f Dockerfile.armhf \
    --build-arg JASPER_GIT_URL=https://github.com/syphr42/jasper-client \
    .
```

# License

[![Apache 2.0 License](https://img.shields.io/badge/license-Apache-blue.svg)](https://raw.githubusercontent.com/syphr42/docker-jasper/master/LICENSE)
