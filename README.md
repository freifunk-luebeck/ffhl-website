# Freifunk Lübeck Website


## How to build

use [Hugo](https://gohugo.io/documentation/)

1. Clone Repo: `git clone --recurse-submodules https://git.luebeck.freifunk.net/FreifunkLuebeck/ffhl-website.git`
2. [Install Hugo](https://gohugo.io/getting-started/installing/): `sudo apt install hugo`
3. `hugo build` or `hugo serve`

To create a new post: `hugo new content/posts/$(date +"%Y-%m-%d")-<TITLE>.md`