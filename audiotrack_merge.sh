#!/bin/bash
## audio track merge
# Merge audio track into video.


video_file=$1
translation_track=$2
output="$(basename "$video_file" .mp4)_mixed.mp4"

[ $# -eq 0 ] && { echo "Usage: $0 <video_file> <translation_track>"; exit 1; }

ffmpeg -i $translation_track -i $video_file -filter_complex \
"[0:a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo,volume=1.0[a1]; \
 [1:a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo,volume=0.2[a2]; \
 [a1][a2]amerge,pan=stereo:c0<c0+c2:c1<c1+c3[out]" \
-map 1:v -map "[out]" -c:v copy -c:a aac -shortest $output
