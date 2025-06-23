import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3

import "../js/store.js" as Store
import "../js/calendar.js" as CalendarJS
import "../js/translate.js" as Translate
import "../js/utils.js" as Utils

Item {
  id: displayDate

  property int secondaryHeight: Math.round(((Plasmoid.configuration.secondaryTextHeight / 100) * parent.height))
  property double _width: Plasmoid.configuration.secondaryText 
    ? Math.max(primaryTextHidden.paintedWidth, secondaryTextHidden.paintedWidth)
    : primaryTextHidden.paintedWidth

  Layout.preferredWidth: _width
  Layout.minimumWidth: _width
  Layout.maximumWidth: _width

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (!root.expanded) {
        CalendarJS.goCurrentDay();
      }
      root.expanded = !root.expanded;
    }
  }

  Column {
    anchors.fill: parent

    /* Start Primary Text */
    /*
    Use a hidden label with infinite width to calculate paintedWidth of text while fitted vertically
    and set width of the root to paintedWidth of the label
    Why hidden labels? because we need a width for the root component that suits fitted text!
    otherwise, we need a complex calculation to find out whats the proper width of root!(Or so I think)
    I've checked Event Calendar and Digital Clock. They are doing calculations because of their specific need, I don't, at least for now.
    */
    PlasmaComponents3.Label {
      visible: false
      enabled: false
      id: primaryTextHidden
      width: 1000 // big number need for get max possible paintedWidth of text characters after vertically fitted
      height: Plasmoid.configuration.secondaryText
        ? parent.height - displayDate.secondaryHeight
        : parent.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      textFormat: Text.StyledText
      font.family: root.fontFamily
      minimumPixelSize: 1
      font.pixelSize: Plasmoid.configuration.panelPrimaryTextFontSizeMode === 'fit' ? 1000 : Plasmoid.configuration.panelPrimaryTextPixelSize
      fontSizeMode: Plasmoid.configuration.panelPrimaryTextFontSizeMode === 'fit' ? Text.Fit : Text.FixedSize 
      text: Utils.richDateFormatParser(
        Store.store.calendarSlice.jToday,
        Plasmoid.configuration.panelPrimaryTextFormat,
        Translate.useLocale()
      )
    }

    PlasmaComponents3.Label {
      id: primaryText
      width: parent.width
      height: primaryTextHidden.height
      horizontalAlignment: primaryTextHidden.horizontalAlignment
      verticalAlignment: primaryTextHidden.verticalAlignment
      textFormat: primaryTextHidden.textFormat
      font.family: primaryTextHidden.font.family
      minimumPixelSize: primaryTextHidden.minimumPixelSize
      font.pixelSize: primaryTextHidden.font.pixelSize
      fontSizeMode: primaryTextHidden.fontSizeMode
      text: primaryTextHidden.text
    }
    /* End Primary Text */

    /* Start Secondary Text */
    /* See Primary Text comment */
    PlasmaComponents3.Label {
      visible: false
      enabled: false
      id: secondaryTextHidden
      width: 1000
      height: displayDate.secondaryHeight
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      textFormat: Text.StyledText
      font.family: root.fontFamily
      minimumPixelSize: 1
      font.pixelSize: Plasmoid.configuration.panelSecondaryTextFontSizeMode === 'fit' ? 1000 : Plasmoid.configuration.panelSecondaryTextPixelSize
      fontSizeMode: Plasmoid.configuration.panelSecondaryTextFontSizeMode === 'fit' ? Text.Fit : Text.FixedSize 
      text: Utils.richDateFormatParser(
        Store.store.calendarSlice.jToday,
        Plasmoid.configuration.panelSecondaryTextFormat,
        Translate.useLocale()
      )
    }

    PlasmaComponents3.Label {
      id: secondaryText
      visible: Plasmoid.configuration.secondaryText
      width: parent.width
      height: secondaryTextHidden.height
      horizontalAlignment: secondaryTextHidden.horizontalAlignment
      verticalAlignment: secondaryTextHidden.verticalAlignment
      textFormat: secondaryTextHidden.textFormat
      font.family: secondaryTextHidden.font.family
      minimumPixelSize: secondaryTextHidden.minimumPixelSize
      font.pixelSize: secondaryTextHidden.font.pixelSize
      fontSizeMode: secondaryTextHidden.fontSizeMode
      text: secondaryTextHidden.text
    }
    /* End Secondary Text */
  }
}