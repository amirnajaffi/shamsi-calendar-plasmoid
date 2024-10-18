import QtQuick

import org.kde.plasma.configuration
import org.kde.plasma.plasmoid

import "../js/translate.js" as Translate

ConfigModel {

  ConfigCategory {
    name: Translate.tConfigScope('appearance', {lng: Plasmoid.configuration.language})
    icon: "preferences-desktop-color"
    source: "config/appearance.qml"
  }

  ConfigCategory {
    name: Translate.tConfigScope('event', {lng: Plasmoid.configuration.language})
    icon: "view-calendar-week"
    source: "config/event.qml"
  }

  ConfigCategory {
    name: Translate.tConfigScope('other', {lng: Plasmoid.configuration.language})
    icon: "view-more-horizontal-symbolic"
    source: "config/other.qml"
  }

}