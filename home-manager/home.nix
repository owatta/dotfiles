{ inputs, lib, config, pkgs, ... }:

{
  imports = [];
  
  home = {
    username = "user";
    homeDirectory = "/home/user";
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "owatta";
    userEmail = "arsenii.korniec@bk.ru";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    ly
    # hyprland # see configuration.nix
    hyprpaper
    wofi
    fantasque-sans-mono
    fira-code
    font-awesome
    google-cursor
    waybar
    open-sans

    grim
    wl-clipboard
    slurp
    
    btop
    neofetch

    killall
    wget
    git
    gnupg
    zip
    unzip
    gnutar
    gawk

    firefox
    emacs
    glamoroustoolkit

    mpv
    imv

    sbcl
    ghc
    gdb
    gnumake
    gcc

    xorg.xinit
    xorg.xauth

    usbutils
    pciutils
    android-tools
    android-file-transfer
    
    alacritty
    
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:/usr/local/bin" # set PATH here
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
