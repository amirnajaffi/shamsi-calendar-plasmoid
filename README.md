# KDE Plasma Shamsi Calendar
This is a plasmoid that is used to show Shamsi Calendar (also known as Persian Calendar or Jalali Calendar) in KDE Plasma available in the [KDE store](https://store.kde.org/p/1460130/). The Calendar supports official holidays.

## Requirement
Plasma > 5.25

Check: `plasmashell --version`

For older plasma versions use [v1](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/releases/tag/1.0.0)

## Install/Update
You can install from [KDE Store](https://store.kde.org/p/1460130/) or follow the instructions below

**1. Remove previous version:**
```
kpackagetool5 -t Plasma/Applet --remove org.kde.plasma.shamsi-calendar
```
**2. Log Out/In**

**3. Clone/Download repo:**
```
git clone https://github.com/amirnajaffi/shamsi-calendar-plasmoid.git
```
**4. Open directory:**
```
cd shamsi-calendar-plasmoid
```
**5. Install:**
```
kpackagetool5 -t Plasma/Applet --install package 
```

## Contributing
Thank you for considering contributing to the KDE Plasma Shamsi Calendar! Any contributions you make are greatly appreciated. You can also check [this list](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/issues/10).

For major changes, please open an issue first to discuss what you would like to change.

## License
Distributed under the GPL v3 License. See LICENSE for more information.

## Acknowledgements
* [i18next](https://github.com/i18next/i18next)
* [jalaali-js](https://github.com/jalaali/jalaali-js)
* [Persian Date](https://github.com/babakhani/PersianDate)
* [Persian Calendar for Gnome-Shell](https://github.com/omid/Persian-Calendar-for-Gnome-Shell)
* [Gnome Shamsi Calendar](https://github.com/SCR-IR/gnome-shamsi-calendar)

## FAQ

* **I have problems installing/updating from KDE Store**

  Check [manual installation](https://github.com/amirnajaffi/shamsi-calendar-plasmoid#installupdate)

* **I get errors after installation**

  Errors are usually displayed due to the low plasma version. [Make sure that the minimum version of Plasma required to run this program is installed](https://github.com/amirnajaffi/shamsi-calendar-plasmoid#requirement). If problem still exists please open a new issue.
