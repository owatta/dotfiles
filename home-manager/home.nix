{ inputs, lib, config, pkgs, ... }:

{ imports = [];
  
  home = { username = "user"; homeDirectory = "/home/user";
  };

  # link the configuration file in current directory to the specified location in home directory
  home.file.".emacs.d" = { source = ./emacs; recursive = true; # link recursively
  };

  home.file.".config/hypr" = { source = ./hypr; recursive = true; # link recursively
  };
    
  home.file.".config/wofi" = { source = ./wofi; recursive = true;
  };
  
  home.file.".config/waybar" = { source = ./waybar; recursive = true; # link recursively
  };

  # encode the file content in nix configuration file directly home.file.".xxx".text = '' xxx
  # '';

  programs.git = {
    enable = true;
    userName = "owatta";
    userEmail = "arsenii.korniec@bk.ru";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    ly
    hyprpaper
    wofi
    waybar
    eww-wayland
    glib # for gsettings

    fantasque-sans-mono
    bibata-cursors
    open-sans
    fira-code
    font-awesome

    grim
    wl-clipboard
    slurp

    libnotify
    dunst
    
    
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
    # glamoroustoolkit

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
    telegram-desktop
    
  ];

  programs.bash = { enable = true; enableCompletion = true; bashrcExtra = '' export PATH="$PATH:/usr/local/bin" # set PATH here
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
    };
  };

  # This value determines the home Manager release that your configuration is compatible with. This helps avoid breakage when a new home Manager release 
  # introduces backwards incompatible changes.
  #
  # You can update home Manager without changing this value. See the home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

}
