# Home Manager
A nix took that manages my setup so I can use it in a new machine instead of having to copy a bunch of dot files and configuration. Here is the [Documentation](https://nix-community.github.io/home-manager/) and here is the [Github Repo](https://github.com/nix-community/home-manager).


## Setting up my environment in a new machine

First install nix using the determinate systems installer [here]( https://github.com/DeterminateSystems/nix-installer)

then clone this repo anywhere in the new machine, and cd into the new folder. Once you are in the folder run `nix run .#homeConfigurations.fg.switch` that will create the correct folders for the user fg and the correct .confg/home-manager/ directory for these files and run home-manager for the first time. After this you can get rid of the cloned directory, home manager is in the computer and it's running from the correct directory. You can edit the home.nix there to make changes and run home manager with `home-manager switch`.

## How this was setup on the first place
The way this setup came to be on the first place, I followed the instructions in https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone and ran `nix run home-manager/master -- init --switch` to generate my flakes and directory and run it for the first time.


## updating the flakes

```
cd ~/.config/home-manager
nix flake update                      # update nixpkgs + home-manager
home-manager switch --flake .#fg      # apply the flake config
```
note that the .#fg assumes we are in the directory, for the more general we have to specify it, as seen in the shell extensions defined in home.nix
```
      # home manager shortcuts
      hm = "home-manager switch --flake ~/.config/home-manager#fg";
      hmu = " nix flake update && home-manager switch --flake ~/.config/home-manager#fg";
```
So now just use `hm` to do a `home-manager switch` with the right flags,
because doing it without them apparently doesn't use the flake, but rather whatever is in the system, which is not what I want for repeatability.