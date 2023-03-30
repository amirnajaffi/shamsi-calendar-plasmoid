import QtQuick 2.0

import org.kde.plasma.configuration 2.0
import org.kde.plasma.plasmoid 2.0

import "../js/store.js" as Store
import "../js/constants.js" as Constants
import "../js/translate.js" as Translate
import "../js/utils.js" as Utils
import "../js/bin/persian-date.js" as PersianDate

ConfigModel {

  ConfigCategory {
    name: Qt.i18next.t('appearance', {lng: Plasmoid.configuration.language})
    icon: "preferences-desktop-color"
    source: "config/appearance.qml"
  }

  ConfigCategory {
    name: Qt.i18next.t('event', {lng: Plasmoid.configuration.language})
    icon: "view-calendar-week"
    source: "config/event.qml"
  }

  ConfigCategory {
    name: Qt.i18next.t('other', {lng: Plasmoid.configuration.language})
    icon: "view-more-horizontal"
    source: "config/other.qml"
  }

}