import QtQuick 2.12

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "../js/store.js" as Store
import "../js/utils.js" as Utils
import "../js/constants.js" as Constants
import "../js/translate.js" as Translate
import "../js/bin/persian-date.js" as PersianDate
import "../js/bin/jalaali.js" as Jalaali
import "../js/bin/jalalidate.js" as JalaliDate
import "../js/events.js" as Events
import "../js/calendar.js" as CalendarJS
import "../js/calendar-ui.js" as CalendarUI

Item {
  id: root

  property bool hideOnWindowDeactivate: true
  property string toolTipMainText
  property string toolTipSubText
  property string fontFamily: {
    if (Plasmoid.configuration.fontStatus === Qt._sc_.const.font.MANUAL && Plasmoid.configuration.fontFamily !== '') {
      return Plasmoid.configuration.fontFamily;
    } else if(Plasmoid.configuration.fontStatus === Qt._sc_.const.font.VAZIR) {
      return vazirFont.name;
    }
    return PlasmaCore.Theme.defaultFont.family;
  }

  Plasmoid.compactRepresentation: DateDisplay {}
  Plasmoid.fullRepresentation: Calendar {}
  Plasmoid.toolTipMainText: root.toolTipMainText
  Plasmoid.toolTipSubText: root.toolTipSubText
  Plasmoid.hideOnWindowDeactivate: hideOnWindowDeactivate

  /* Debugging */
  Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

  FontLoader {
    id: vazirFont;
    source: "../fonts/Vazirmatn[wght].ttf"
  }

  QtObject {
    id: qmlStore
    objectName: 'qmlStore'
    property QtObject calendarSlice: QtObject {
      id: calendarSlice
      objectName: 'calendarSlice'
      property var jToday // array 3
      property var gToday // array 3
      property var selectedDate // array 3
      property var surface_yearAndMonth // array 2
      property var surface_daysOfMonth // array of arrays 3
      property var surface_yearsOfDecade // array 10
      property var events // array of arrays
      property var lang: 'en' //string
    }
    property QtObject configSlice: QtObject {
      id: configSlice
      objectName: 'configSlice'
      property string language: Plasmoid.configuration.language // string
      property string activeEvents: Plasmoid.configuration.activeEvents // string
    }
    property QtObject uiReference: QtObject {
      id: uiReference
      objectName: 'uiReference'
      property var stack
      property var monthLabel
      property var yearLabel
      property var todayButton
      property var previousButton
      property var nextButton
      property var yearViewComponent
      property var decadeViewComponent
    }
  }

  PlasmaCore.DataSource {
    id: localTime
    engine: "time"
    connectedSources: ["Local"]
    interval: 60000
    onNewData: (sourceName, data) => {
      Qt._sc_.calendar.baseDateChangeHandler(data.DateTime);
    }
  }

  /* Actions that needed to trigger after configuation changed */
  Connections {
    target: Plasmoid.configuration

    function onTempLanguageChanged() {
      Qt.i18next.changeLanguage(Plasmoid.configuration.tempLanguage, () => {
        Plasmoid.configuration.language = Plasmoid.configuration.tempLanguage
      });
    }

    function onActiveEventsChanged() {
      Qt._sc_.events.calculateAndSetSurfaceEvents(Qt._sc_.store.calendarSlice.surface_daysOfMonth);
    }
  }

  Component.onCompleted: {
    /* Boot calendar */
    Qt._sc_.storeUtils.setStore(qmlStore);
    Qt._sc_.calendar.baseDateChangeHandler(localTime.data.Local.DateTime);
    Qt._sc_.calendar.changeDecade(Qt._sc_.store.calendarSlice.jToday[0]);
    Qt.i18next.changeLanguage(Plasmoid.configuration.language);

    root.toolTipMainText = Qt.binding(function() {
      return  Qt._sc_.calendarUI.toolTipText(
        Qt._sc_.store.calendarSlice.jToday,
        'dddd',
        Qt._sc_.useLocale()
      )
    })
    root.toolTipSubText = Qt.binding(function() {
      return Qt._sc_.calendarUI.toolTipText(
        Qt._sc_.store.calendarSlice.jToday,
        'D MMMM YYYY',
        Qt._sc_.useLocale()
      )
    })
  }

}
