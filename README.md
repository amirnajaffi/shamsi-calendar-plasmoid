# KDE Plasma Shamsi Calendar

Integrate the Persian (Shamsi - Jalali) calendar into your KDE Plasma desktop with the Shamsi Calendar Plasmoid. Developed with precision and user-centric design, this plasmoid has evolved from a personal project to a feature-rich tool tailored to your needs.

You can find and download the Shamsi Calendar plugin on the KDE Store [here](https://store.kde.org/p/1460130/).

**Features**

- Multi-language support for a personalized experience.
- 5 adjustable events types.
- Navigate using stack navigation.
- Display dual parallel configurable texts (Primary and Secondary) on the panel.
- Personalize colors, fonts, sizes, and events to suit your style.
- And more!

![Shamsi Calendar Plasmoidscreenshot](./img/featured.png)

[KDE Store](https://store.kde.org/p/1460130/) - [CHANGELOG](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/blob/main/CHANGELOG.md)

## Requirement

| Plasma Version | Widget Version                                                         |
| -------------- | ---------------------------------------------------------------------- |
| 5.25 and above | 2.x                                                                    |
| 5.24 and below | [1.x](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/tree/v1) |

Check: `plasmashell --version`

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

**\*Optional:** If you want to install v1 run:

```
git checkout v1
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

- [i18next](https://github.com/i18next/i18next)
- [jalaali-js](https://github.com/jalaali/jalaali-js)
- [Persian Date](https://github.com/babakhani/PersianDate)
- [Persian Calendar for Gnome-Shell](https://github.com/omid/Persian-Calendar-for-Gnome-Shell)
- [Gnome Shamsi Calendar](https://github.com/SCR-IR/gnome-shamsi-calendar)
- [Vazirmatn Font](https://github.com/rastikerdar/vazirmatn)

## FAQ

- **Having Trouble Installing or Updating via KDE Store?**
If you're facing issues with installation or updates from the KDE Store, don't worry! We've got you covered with a simple [manual installation guide](https://github.com/amirnajaffi/shamsi-calendar-plasmoid#installupdate).

- **Encountering Errors After Installation?**
Sometimes, errors might pop up after installation, and that's okay. Often, these errors are caused by having an older version of Plasma. Make sure you have at least the [minimum required Plasma version](https://github.com/amirnajaffi/shamsi-calendar-plasmoid#requirement) installed. If you're still facing issues, feel free to open a new issue – we're here to help!
