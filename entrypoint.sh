#!/bin/bash

set -euo pipefail

# determine if the default CMD was used (optionally with parameters)
[ "$1" = "./jasper.py" ]
DEFAULT_CMD=$?

# default STT and TTS config
append_default_config() {
	cat >> $1 <<-EOI
	
	tts_engine: pico-tts
	
	pocketsphinx:
	  fst_model: '/jasper/phonetisaurus/g014b2b/g014b2b.fst'
	  hmm_dir: '/usr/share/pocketsphinx/model/hmm/en_US/hub4wsj_sc_8k'
	
	pico-tts:
	  language: en-US
	EOI
}

# run setup if executing the default CMD and the profile is missing
if [ ${DEFAULT_CMD} -eq 0 ]; then
    JASPER_PROFILE=${JASPER_CONFIG}/profile.yml
    echo "Checking for Jasper profile at '${JASPER_PROFILE}'..."
    if [ ! -e "${JASPER_PROFILE}" ]; then
        echo "No profile found; running initial setup..."
        python client/populate.py
        append_default_config ${JASPER_PROFILE}
    else
        echo "Profile found; setup skipped."
    fi
fi

exec "$@"
