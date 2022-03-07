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
## :page_with_curl: License

Dotfiles made public under the [MIT license](LICENSE).
