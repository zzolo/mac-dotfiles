# Use beetcopy to run beet and copy config/db to mounted volume 
beetcopy import ./path/to/music;

# Use beetnocopy to run beet only if can connect to mounted volume 
beetnocopy query "something";

# Import use -t (timid) to not do any auto import
beetcopy import -t ./path/to/music;

# Find non-ascii files
# To fix these, run beet not on a Mac, since the mount of the share
# doesn't read these files
LC_ALL=C find /share/Multimedia/tunes/albums/A/ -name '*[! -~]*';

# Rename files for certain artists
beetcopy move "albumartist::AFI";
beetcopy move "albumartist::(A|a)[a-f].*";

# Or pretend
beetnocopy move -p "albumartist::AFI";