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
import "../js/main.js" as Scripts

Item {
  id: root
  property bool hideOnWindowDeactivate: true
  property string lang: 'en' // temp

  Plasmoid.compactRepresentation: DateDisplay {}
  Plasmoid.fullRepresentation: Calendar {}
  /* TODO: Tooltip
  Plasmoid.toolTipMainText: todayDate.format('dddd')
  Plasmoid.toolTipSubText: todayDate.format('D MMMM YYYY')
  */
  Plasmoid.hideOnWindowDeactivate: hideOnWindowDeactivate

  /* Debugging */
  // Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

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
  }

}
