import urllib
import requests
import os.path
import sys
import zipfile
import subprocess

class Installer:

    githubUrl = 'https://api.github.com/repos/amirnajaffi/shamsi-calendar-plasmoid/releases/latest'
    isInstalled = False
    installedVersion = 0
    latestVersion = 0

    def __init__(self):
        print('Checking for Shamsi Calendar on your system...')
        self.isInstalled = os.path.exists(os.path.expanduser('~/.local/share/plasma/plasmoids/org.kde.plasma.shamsi-calendar'))
        self.getLatestVersion()
        self.getInstalledVersion()

    def getLatestVersion(self):
        print('Checking for latest version...')
        response = requests.get(self.githubUrl)
        lastVersion = response.json()['name'].strip()
        self.latestVersion = lastVersion
        print('Latest Version:', lastVersion)
        
        return lastVersion

    def getInstalledVersion(self):
        print('Checking for installed version...')
        file = open(os.path.expanduser('~/.local/share/plasma/plasmoids/org.kde.plasma.shamsi-calendar/metadata.desktop'), "r")
        for line in file.readlines():
            lineList = line.partition('=')
            if (lineList[0] == "X-KDE-PluginInfo-Version" and lineList[2]):
                installedVer = lineList[2].strip()
                print('Installed Version:', installedVer)
                self.installedVersion = installedVer
                return installedVer
        print('You have not install Shamsi Calendar')
        return False

    def update(self):
        response = requests.get(self.githubUrl)
        tmpZipFile = '/tmp/shamsi-calendar.zip'
        tempFolder = '/tmp/shamsi-calendar/'
        urllib.request.urlretrieve(response.json()['zipball_url'], tmpZipFile)

        with zipfile.ZipFile(tmpZipFile, 'r') as zipRef:
            zipRef.extractall(tempFolder)
            names = [info.filename for info in zipRef.infolist() if info.is_dir()]
        
        subprocess.run(['kpackagetool5 -t Plasma/Applet --remove org.kde.plasma.shamsi-calendar'], shell=True)
        subprocess.run(['kpackagetool5 -t Plasma/Applet --install ' + tempFolder + names[0] + 'package'], shell=True)
        print('Shamsi Calendar updated successfully')
        sys.exit()

    def install(self):
        response = requests.get(self.githubUrl)
        tmpZipFile = '/tmp/shamsi-calendar.zip'
        tempFolder = '/tmp/shamsi-calendar/'
        urllib.request.urlretrieve(response.json()['zipball_url'], tmpZipFile)

        with zipfile.ZipFile(tmpZipFile, 'r') as zipRef:
            zipRef.extractall(tempFolder)
            names = [info.filename for info in zipRef.infolist() if info.is_dir()]
        
        subprocess.run(['kpackagetool5 -t Plasma/Applet --install ' + tempFolder + names[0] + 'package'], shell=True)
        print('Shamsi Calendar installed successfully')
        sys.exit()

# Executing...
installer = Installer()

if not installer.isInstalled:
    print('You have not installed Shamsi Calendar')
    installer.install()

if installer.isInstalled:
    print('You have installed Shamsi Calender')

    latestVersion = installer.latestVersion.replace('.', '')
    installedVersion = installer.installedVersion.replace('.', '')

    # print('Checking for update...')
    if (installedVersion == latestVersion ):
        print('You have already installed latest version')
        sys.exit()
    
    if (installedVersion < latestVersion):
        print('There is newer version of Shamsi Calendar')
        print('Updating...')
        installer.update()
        sys.exit()