# dotfiles
Personal dotfiles &amp; config

## :floppy_disk: Install Instructions

Install [**yadm**](https://yadm.io/) using distribution specific [package manager](https://yadm.io/docs/install#).

### Debian/Ubuntu

Install from the standard package repositories.

```
# apt install yadm
```

### Clone Dotfiles Repository

Clone the dotfiles repository using `yadm`.

```
$ yadm clone https://github.com/charliewilson/dotfiles.git
```

#### Force Overwrite of Local Dotfiles

The `clone` and `pull` command may result in warnings because of pre-existing dotfiles. Overwrite the existing files with commands below.

```
$ yadm fetch --all
$ yadm reset --hard origin/master
```

## :arrow_up: Updating Dotfiles

`yadm status` will show you any updates to existing added dotfiles

```shell
$ yadm status

On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   .config/Code/User/settings.json

Untracked files not listed (use -u option to show untracked files)
```

`yadm commit -a` autocommits **only** the modified and deleted dotfiles.

```
$ yadm commit -a -m "updated settings.json"
$ yadm push
```

## :page_with_curl: License

Dotfiles made public under the [MIT license](LICENSE).
