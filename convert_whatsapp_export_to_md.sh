#!/bin/bash
# This script converts exported WhatsApp-Chats to markdown format

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# One more  " to fix syntax highlighting in mcedit
SOURCE=${WORKDIR}/data/chat001

echo ${SOURCE} 
echo


# Find exported chat txt-file
find ${SOURCE} -type f -name "WhatsApp Chat *.txt" -print0 | while IFS= read -r -d '' chat; do
  CHATFILENAME="$( basename "${chat}")"
  CHATFILENAMEMD="$( basename "${chat}" .txt).md"
  echo "CHAT: ${CHATFILENAME}"

  # copy txt file to md file
  cp "${SOURCE}/${CHATFILENAME}" "${SOURCE}/${CHATFILENAMEMD}"

  # find all other (media) files
  find ${SOURCE} -type f -name "*" -print0 | while IFS= read -r -d '' file; do
    FILENAME="$( basename "${file}")"

    # Ignore .txt and .md files
    if [[ "${FILENAME}" =~ .*\.(txt|md) ]]; then
       continue
    fi
    echo "  File: ${FILENAME}"

    
    # replace filenames in md file with image tags
    sed -i -e "s/$FILENAME/![$FILENAME](.\/$FILENAME)/g" "${SOURCE}/${CHATFILENAMEMD}"

  done
done
