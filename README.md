# KDE Plasma Shamsi Calendar

Integrate the Persian Calendar into your KDE Plasma desktop. Also known as Shamsi Calenar or Jalali Calendar.

Download the plugin from the [KDE Store](https://store.kde.org/p/2216432/).

## Features

- Multi-language support
- Five adjustable event types
- Stack navigation
- Dual configurable texts on the panel
- Customize colors, fonts, sizes, and events

![Shamsi Calendar Plasmoid Screenshot](./img/featured.png)

[Changelog](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/blob/main/CHANGELOG.md)

## Requirements

| Plasma Version    | Widget Version                                                         | Link                                                   |
| ----------------- | ---------------------------------------------------------------------- | ------------------------------------------------------ |
| 6 and above       | 3.x                                                                    | [Plasma 6 Store](https://store.kde.org/p/2216432/) |
| 5.25 >= plasma < 6 | [2.x](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/tree/v2) | [Plasma 5 Store](https://store.kde.org/p/1460130/) |
| 5.24 and below    | [1.x](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/tree/v1) | [Plasma 5 Store](https://store.kde.org/p/1460130/) |

Check your Plasma version: `plasmashell --version`

## Install or Update

**Option 1: Install from KDE Store**

Download directly from the [KDE Store](https://store.kde.org/p/1460130/).

**Option 2: Manual Installation**

1. **Clone the repository:**
```
git clone https://github.com/amirnajaffi/shamsi-calendar-plasmoid.git
```

2. **Navigate to the directory:**
```
cd shamsi-calendar-plasmoid
```

3. **(Optional) Switch to version 1 for Plasma < 5.24, or version 2 for 5.25 > plasma < 6:**
```
git checkout v1 (or v2)
```

4. **Install the plasmoid:**
```
kpackagetool6 -t Plasma/Applet --install package
```
To upgrade from a previous version, use `--upgrade` instead of `--install`. There is a `--delete` flag too.
<br />
Alternatively use `kpackagetool5` for V1 and V2

5. **Log out and log back in.**

<br />

**Alternative Method:**
Download the latest `.plasmoid` file from [here](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/releases/latest) and install it using the command above.

## Contributing

Contributions are welcome! Please check [this list](https://github.com/amirnajaffi/shamsi-calendar-plasmoid/issues/10). For major changes, open an issue to discuss them first.


## License

Distributed under the GPL v3 License. See LICENSE for more information.

## Acknowledgements

- [i18next](https://github.com/i18next/i18next)
- [jalaali-js](https://github.com/jalaali/jalaali-js)
- [Persian Date](https://github.com/babakhani/PersianDate)
- [Persian Calendar for Gnome-Shell](https://github.com/omid/Persian-Calendar-for-Gnome-Shell)
- [tarikh-npm](https://github.com/SCR-IR/tarikh-npm)
- [Vazirmatn Font](https://github.com/rastikerdar/vazirmatn)

## FAQ

- **Trouble installing or updating via KDE Store?**

Try the [manual installation guide](#install-or-update) above.

- **Errors after installation?**

Ensure you meet the [minimum Plasma version requirements](#requirements). If issues persist, please open a new issue.
