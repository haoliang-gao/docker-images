
# personal workstation


it based on docker, and include tools for my daily development workflow.

in use
----

* `$ ./startup.sh # this will run a container named workspace in daemon mode`
* `$ docker exec -it workspace /usr/bin/zsh # connect to workspace container, and run your magic commands`


why?
----

Mac OS is not suit for me. I currently using a macbook pro and can not choose it's OS.

what tools will it takes ?
----

* archlinux
* vim
* tmux
* mycli
* ag
* git
* composer
* shadowsocks
* proxychains-ng

personal contents will locate in:
----

* /root
* /srv/http

notes
----

* developping within docker container, I/O is really slow.

FAQ
----

* tmux erred: lost server
    * run `$ script` first, before using `tmux`
    * if you did not instantiate the image as daemon, but `docker run --it`, this issue won't occur.

