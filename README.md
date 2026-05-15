Things I need to do:
1. Figure out secrets management

Things to add:
* impermanence
* secrets
* better desktop environment
* dev environment
* direnv or equivalent
* autoformatting and linting
* virtual machines
* iso
* gaming setup
* workstation setup
* sys admin tools
* firewall setup
* home server setup


Flake file:
nix run .#write-flake # whenever you need to regen flake.nix

nix flake check # will make sure your flake.nix is up-to-date

Documentation & Resources:
Mostly copy-pasted from: https://github.com/Doc-Steve/dendritic-design-with-flake-parts