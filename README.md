# DebianBas
My Debian configuration

DebianBas contains full instructions to setup a newly installed debian.

Script running order.
```
mono.sh - checks mirror, update && upgrade debian, installs nala, change shell to Bash
di.sh - enables snapd, flatpak
tri.sh - installes packages, fonts, configures neovim/lunarvim, installes christitus-mybash with config, enables brew,installes dependency with brew

```

After mono.sh, di.sh, tri.sh system will reboot!

tri.sh package list.
From Debian-testing
```
build-essential procps curl file wget git gimp krita inkscape thunderbird htop stacer okular calibre flameshot lutris kazam kadenlive gnome-software redshift app-outlet gnome-software discover clamav clamtk app-outlet synaptic qt5-style-kvantum

```
If app-outlet is not available in the repo, then uncomment line 57-60.

From custom :ppa
```
flatpak - onlyoffice
snap - rambox
brave-browser, fsearch, spotify, vscode, steam

```

Fonts
```
FiraCode, Meslo, Roboto, fontsawesome

```
plasma config
```
theme - layan
widgets, 
        org.kde.plasma.betterkicker
        org.kde.plasma.eventcalendar
        org.kde.windowtitle
        org.kxn.cornerMenu/KppleMenu
        GlobalMenu
        WindowButton
        Search
        Icons-only Task Manager
kwin,
     Exquisite
     Hide Titles
     Minimize All
     Toogle panel screen edge - panel 0n
```

Bash & ZSH shell configuration is not complete yet!
