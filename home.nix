{ config, pkgs, ... }:

# had to do a let in to deal with conda which can't be installed by nix yet
let 
  #homebrew stuff
  homebrewBase = "/opt/homebrew";
  homebrewPath = "${homebrewBase}/bin";

  #conda stuff
  condaBase = "${homebrewBase}/Caskroom/miniconda/base";
  
  
  #mojo stuff

  modularHome = "${config.home.homeDirectory}/.modular";
  mojoPath = "${modularHome}/pkg/packages.modular.com_mojo/bin";

  #rust stuff

  cargoHome ="${config.home.homeDirectory}/.cargo";
  cargoPath ="${cargoHome}/bin";

in 
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fg";
  home.homeDirectory = "/Users/fg";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.haskellPackages.haskell-language-server
    pkgs.haskellPackages.ghcid
    pkgs.haskellPackages.ghc
    pkgs.haskellPackages.cabal-install
    pkgs.haskellPackages.stack
    pkgs.ihp-new

    pkgs.cachix

    pkgs.julia-bin #works but path needs to be set to override juliaup installation

    # this works, but interferes with conda's python
    # pkgs.python312

    pkgs.nodePackages_latest.nodejs
    # pkgs.nodePackages_latest.npm

    pkgs.R
    pkgs.elixir
    # deno's version is better directly with cargo
    # pkgs.deno
    #pandoc requires texlive, the full version gives me all the math and geometry latex stuff
    pkgs.pandoc
    pkgs.texlive.combined.scheme-full


    # list of pkgs I've tried and didn't work
    # pkgs.python
    # pkgs.python312Packages.conda
    # pkgs.julia
    # pkgs.haskellPackages.ghcup
    # pkgs.rstudio

    #try brew and rust
    # pkgs.homebrew
    # pkgs.rustup
    



    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fg/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "codium";
    TERMINAL = "rio";
    SHELL = "fish";
    # mojo stuff
    MODULAR_HOME = modularHome;
    # Homewbrew stuff
    HOMEBREW_PREFIX="${homebrewBase}";
    HOMEBREW_CELLAR="${homebrewBase}/Cellar";
    HOMEBREW_REPOSITORY="${homebrewBase}";

    # this should be last
    # prepend the home manager binaries to the path so it prefers programs installed here over brew or native
    PATH = "${config.home.profileDirectory}/bin:${cargoPath}:${mojoPath}:${homebrewPath}:$PATH";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # other programs and configurations I added inspired on andy's

  #direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # git
  programs.git = {
    enable = true;
    userName = "Francisco Gutierrez";
    userEmail = "97089+freefrancisco@users.noreply.github.com";
    extraConfig = {
      color = { ui = "auto"; };
      push = { default = "simple"; };
      pull = { rebase = true; };
      branch = { autosetuprebase = "always"; };
      init = { defaultBranch = "main"; };
    };
  };


  #vscode
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      jnoortheen.nix-ide

      haskell.haskell
      justusadam.language-haskell
      mkhl.direnv

      ms-python.python
      ms-toolsai.jupyter

      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      denoland.vscode-deno
      dhall.dhall-lang
      julialang.language-julia
      mgt19937.typst-preview
      nvarner.typst-lsp

      humao.rest-client

      # hsx, need to install manually for now
      # s0kil.vscode-hsx
      

      ### these three don't work

      # nwolverson.ide-purescript
      # nwolverson.language-purescript
      # s0kil.vscode-hsx

      ### haven't tried these yet from vscode 

      # be5invis.toml
      # digitalassetholdingsllc.daml
      # formulahendry.code-runner
      # github.codespaces
      # github.vscode-github-actions
      gruntfuggly.todo-tree
      # marp-team.marp-vscode
      # mechatroner.rainbow-csv
      # ms-azuretools.vscode-docker
      # ms-kubernetes-tools.vscode-kubernetes-tools
      # ms-python.debugpy
      # ms-python.isort
      # ms-python.python
      # ms-python.vscode-pylance
      # ms-toolsai.jupyter-keymap
      # ms-toolsai.jupyter-renderers
      # ms-toolsai.vscode-jupyter-cell-tags
      # ms-toolsai.vscode-jupyter-slideshow
      # ms-vscode-remote.remote-containers
      # ms-vscode.cmake-tools
      # ms-vscode.cpptools
      # ms-vscode.cpptools-extension-pack
      # ms-vscode.cpptools-themes
      # ms-vscode.makefile-tools
      # nickdemayo.vscode-json-editor
      # redhat.vscode-yaml
      # ronnidc.nunjucks
      # rubymaniac.vscode-direnv
      # sastan.twind-intellisense
      # searking.preview-vscode
      # tomoki1207.pdf
      # twxs.cmake
      # unifiedjs.vscode-mdx
      # vue.volar
      # whitphx.vscode-stlite

    ];
  };

  #shells, bash and fish
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;

  };
  programs.fish = {
    enable = true;
    # conda needs this
    shellInit = ''
      if test -f "${condaBase}/etc/fish/conf.d/conda.fish"
        source "${condaBase}/etc/fish/conf.d/conda.fish"
      else
        set -gx PATH "${condaBase}/bin" $PATH
      end
    '';
  };

  # terminal, rio
  programs.rio = {
    enable = true;
    settings = {
      window = {
        # background-opacity = 0.6;
        # blur = true;
        height = 720;
        width = 1280;
      };
      shell = {
        program = "fish";
        args = [ ];
      };
    };
  };


  #others
  programs.htop.enable = true;

  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.nix-mode epkgs.magit ];
  };



}
