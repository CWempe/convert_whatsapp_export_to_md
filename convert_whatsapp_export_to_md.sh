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


  # add new lines between messages
  sed -i -e "/^[0-9][0-9].[0-9][0-9].[0-9][0-9], [0-9][0-9]:[0-9][0-9] - /i \ " "${SOURCE}/${CHATFILENAMEMD}"

  # emphasis timestamp and sender name
  sed -i -e "s/^\([0-9][0-9].[0-9][0-9].[0-9][0-9], [0-9][0-9]:[0-9][0-9]\)\( -\) \(.*\):/*\1* \2 **\3**:/g"  "${SOURCE}/${CHATFILENAMEMD}"

  # emphasis status messages
  sed -i -e "s/^\([0-9][0-9].[0-9][0-9].[0-9][0-9], [0-9][0-9]:[0-9][0-9]\)\( -\) \([^:]*\)$/*\1* \2 *\3*:/g"  "${SOURCE}/${CHATFILENAMEMD}"


  # find all other (media) files
  find ${SOURCE} -type f -name "*" -print0 | while IFS= read -r -d '' file; do
    FILENAME="$( basename "${file}")"
    EXTENSION="${FILENAME##*.}"

    # Ignore specific file types like txt, md and pdf
    if [[ "${EXTENSION}" =~ (txt|md|pdf) ]]; then
       echo "Ignore file \"${FILENAME}\"."
       continue
    fi
    echo "  File: ${FILENAME}"

    
    # replace filenames in md file with image tags
    sed -i -e "s/$FILENAME (.*)/![$FILENAME](.\/$FILENAME)/g" "${SOURCE}/${CHATFILENAMEMD}"

  done
done
