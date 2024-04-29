# Setting up my environment in a new machine

First install nix using the determinate systems installer [here]( https://github.com/DeterminateSystems/nix-installer) or [ https://github.com/DeterminateSystems/nix-installer](here)

then clone this repo anywhere in the new machine, and cd into the new folder. Once you are in the folder run `nix run .#homeConfigurations.fg.switch` that will create the correct folders for the user fg and the correct .confg/home-manager/ directory for these files and run home-manager for the first time. After this you can get rid of the cloned directory, home manager is in the computer and it's running from the correct directory. You can edit the home.nix there to make changes and run home manager with `home-manager switch`. 

## How this was setup on the first place
The way this setup came to be on the first place, I followed the instructions in https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone and ran `nix run home-manager/master -- init --switch` to generate my flakes and directory and run it for the first time. 


## updating the flakes

```
cd ~/.config/home-manager
git pull
nix flake update
```







