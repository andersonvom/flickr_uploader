flickr_uploader
===============

This is a tool that allows you to easily upload huge amounts of pictures
to Flickr without the hassle of going through the web interface, which
is far from ideal when you're dealing with thousands of photos at once.
Photos will be uploaded privately and can easily be made public using
Flickr's web interface later.


### Installation

Just run `bundle install`.  It will install the only dependency so far
(flickraw) and you're good to go.

### Usage

Just run:

    flickr_uploader /path/to/your/pictures

Several paths, as well as wildcards, can be passed at once, allowing
multiple folders to be uploaded:

    flickr_uploader /path/to/pics1 /path/to/more/pics-*

This will search all files under the given paths and upload them to
flickr inside sets that are generated from the folder structure of the
given paths.  Suppose you have photos in a folder called `pictures` and
it also contains subfolders `subfolder1` and `subfolder1/subsubfolder1`,
this is how they'll be uploaded to Flickr:

    # set_name / photo_name
    # pictures/photo1.jpg
    # pictures/photo2.jpg
    # pictures/photo3.jpg
    # subfolder1/photo10.jpg
    # subfolder1/photo20.jpg
    # subfolder1/photo30.jpg
    # subfolder1-subsubfolder1/photo100.jpg
    # subfolder1-subsubfolder1/photo200.jpg
    # subfolder1-subsubfolder1/photo300.jpg

Since Flickr doesn't support subsets, subfolder names are appended to
the original first folder name and a new set is created.  As most users
tend to have photos stored in folders, the root folder name is only used
if there are pictures there, otherwise, the folder names are used as set
names (note how `pictures` is only used for the first three photos).

