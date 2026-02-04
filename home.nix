{ config, pkgs, ... }:
let
  ### All packages installed in computer
  homePackagesList = binaryPackagesList ++ haskellPackagesList ++ nodePackagesList;

  ### Binary Unix packages
  binaryPackagesList = with pkgs; [
    tree
    sshpass

    # servers and related
    caddy

    # haskell related
    ihp-new
    cachix

    # rust related
    rust-analyzer

    # python related
    pixi # better conda

    # R related
    R
    rPackages.tidyverse
    rPackages.languageserver
    rstudio

    #julia related
    julia-bin #works but path needs to be set to override juliaup installation

    # other languages
    elixir
    cbqn # bqn language, similar to J and APL

    #pandoc related. Pandoc requires texlive, the full version gives me all the math and geometry latex stuff
    pandoc
    texlive.combined.scheme-full
    jinja2-cli

    # git of course
    git
    git-filter-repo

    #yaml and json tools
    jq # tool to query json
    # yq wraps around jq to do yaml, the go version is better
    yq-go #yq-go is the golang version, yq is the python version, they have different syntaxes

    # front end stuff
    bun # a better node runtime
    pnpm # a better npm also includes pnpx

    #music
    lilypond
    # frescobaldi


    # purescript stuff, might need to go if I can't get it to work properly
    # purescript
    # spago
  ];


  ### Haskell related packages
  haskellPackagesList = with pkgs.haskellPackages; [
    haskell-language-server
    ghcid
    # ghc
    myGhc #instead of ghc alone
    cabal-install
    stack
    cairo #used by ihaskell
    retrie # used by language server plugin
  ];
  # custom ghc for haskell development
  myGhc = pkgs.haskellPackages.ghcWithPackages myGhcDevelopmentLibraries;
  # haskell development libraries
  myGhcDevelopmentLibraries = ps: with ps; [
    wai
    servant-server
    servant
    mtl
    parsec
    cassava
    hspec
    hmatrix
    free
    unordered-containers
    warp
    servius #barebones warp server from command line, port 3000
    math-functions
    witch
  ];

  ### Node related packages
  nodePackagesList = with pkgs.nodePackages_latest; [
    nodejs
  ];

  # to set env vars and get the paths to work in shells

  #homebrew stuff
  homebrewBase = "/opt/homebrew";
  homebrewPath = "${homebrewBase}/bin:${homebrewBase}/sbin";

  #conda stuff
  condaBase = "${homebrewBase}/Caskroom/miniconda/base";

  #mojo stuff
  modularHome = "${config.home.homeDirectory}/.modular";
  mojoPath = "${modularHome}/pkg/packages.modular.com_mojo/bin";

  #rust stuff
  cargoHome = "${config.home.homeDirectory}/.cargo";
  cargoPath = "${cargoHome}/bin";

  #lean stuff
  elanHome = "${config.home.homeDirectory}/.elan";
  elanPath = "${elanHome}/bin";

  #deno stuff
  denoHome = "${config.home.homeDirectory}/.deno";
  denoPath = "${denoHome}/bin";

  #pnpm stuff
  pnpmPath = "${config.home.homeDirectory}/Library/pnpm";


in
{

  # TODO fix this later, maybe update versions or find a better way or remove whatever depends on electron
  # silence the electron insecure bullshit for now
  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fg";
  home.homeDirectory = "/Users/fg";
  home.sessionPath = [
    "${config.home.profileDirectory}/bin"
    "${cargoPath}"
    "${elanPath}"
    "${denoPath}"
    "${pnpmPath}"
    "${mojoPath}"
    "${homebrewPath}"
  ];



  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = homePackagesList;

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
    # R_LIBS_USER = "${pkgs.rPackages}/library";
    # R_LIBS_SITE = "${pkgs.rPackages}/library";
    # EDITOR = "emacs";
    EDITOR = "code --wait";
    TERMINAL = "iterm2";
    SHELL = "zsh";

    # mojo stuff
    MODULAR_HOME = modularHome;

    # Homewbrew stuff
    HOMEBREW_PREFIX="${homebrewBase}";
    HOMEBREW_CELLAR="${homebrewBase}/Cellar";
    HOMEBREW_REPOSITORY="${homebrewBase}";
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

  # #vscode
programs.vscode = {
  enable = true;
  package = pkgs.vscodium;
  profiles.default.extensions = with pkgs.vscode-extensions; [
      # vscodevim.vim
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
      # #   error: The features of 'typst-preview' have been consolidated to 'tinymist', an all-in-one language server for typst
      myriad-dreamin.tinymist
      # # mgt19937.typst-preview
      # nvarner.typst-lsp

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

  programs.bun.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # fish-like goodies
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    # TODO remove Conda stuff after I make sure I don't need it anymore
    # initContent = ''
    #   # Conda initialization for zsh
    #   if [ -f "${condaBase}/etc/profile.d/conda.sh" ]; then
    #     source "${condaBase}/etc/profile.d/conda.sh"
    #   else
    #     export PATH="${condaBase}/bin:$PATH"
    #   fi
    #   # Homebrew initialization
    #   eval "$(/opt/homebrew/bin/brew shellenv)"
    # '';

    shellAliases = {
      # better ls
      ll = "eza -al";
      la = "eza -a";
      l = "eza";
      # home manager shortcuts
      hm = "home-manager switch --flake ~/.config/home-manager#fg"; # daily workhorse
      hmu = " nix flake update && home-manager switch --flake ~/.config/home-manager#fg"; # update flake and apply
      hmb = "home-manager build --flake ~/.config/home-manager#fg"; # dry run to see changes without applying
    };

  };

# better ls
programs.eza = {
  enable = true;
  enableBashIntegration = true;
};

# nice prompt for zsh
  programs.starship = {
  enable = true;
  enableZshIntegration = true;
   settings = {
    nix_shell.disabled = false;
    shlvl.disabled = false;
  };
};

# fuzzy finder fzf
programs.fzf = {
  enable = true;
  enableZshIntegration = true;
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
        program = "zsh";
        args = [ ];
      };
    };
  };


  #others
  programs.htop.enable = true;

  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.nix-mode epkgs.magit ];
  };

}
