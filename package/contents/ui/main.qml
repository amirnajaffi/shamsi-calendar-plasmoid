pragma ComponentBehavior: Bound

import QtQuick

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

import "../js/store.js" as Store
import "../js/utils.js" as Utils
import "../js/constants.js" as Const
import "../js/translate.js" as Translate
import "../js/bin/persian-date.js" as PersianDate
import "../js/bin/jalaali.js" as Jalaali
import "../js/bin/hijri-date.js" as HijriDate
import "../js/bin/i18next.js" as I18next
import "../js/events.js" as Events
import "../js/calendar.js" as CalendarJS
import "../js/calendar-ui.js" as CalendarUI


PlasmoidItem {
  id: root

  // property bool _hideOnWindowDeactivate: true
  property string toolTipMainText
  property string toolTipSubText
  property string fontFamily: {
    if (Plasmoid.configuration.fontStatus === Const.constants.font.MANUAL && Plasmoid.configuration.fontFamily !== '') {
      return Plasmoid.configuration.fontFamily;
    } else if(Plasmoid.configuration.fontStatus === Const.constants.font.VAZIR) {
      return vazirFont.name;
    }
    return Kirigami.Theme.defaultFont.family;
  }

  compactRepresentation: DateDisplay {}
  fullRepresentation: Calendar {}
  toolTipMainText: root.toolTipMainText
  toolTipSubText: root.toolTipSubText
  hideOnWindowDeactivate: true

  /* Debugging */
  preferredRepresentation: compactRepresentation;

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

  P5Support.DataSource {
    id: localTime
    engine: "time"
    connectedSources: ["Local"]
    interval: 2000
    onNewData: (sourceName, data) => {
      CalendarJS.baseDateChangeHandler(data.DateTime);
    }
  }

  /* Actions that needed to trigger after configuation changed */
  Connections {
    target: Plasmoid.configuration

    function onTempLanguageChanged() {
      I18next.instance.i18next.changeLanguage(Plasmoid.configuration.tempLanguage, () => {
        Plasmoid.configuration.language = Plasmoid.configuration.tempLanguage
      });
    }

    function onActiveEventsChanged() {
      Events.calculateAndSetSurfaceEvents(Store.store.calendarSlice.surface_daysOfMonth);
    }
  }

  Component.onCompleted: {
    /* Boot calendar */
    Store.storeUtils.setStore(qmlStore);
    CalendarJS.baseDateChangeHandler(localTime.data.Local.DateTime);
    CalendarJS.changeDecade(Store.store.calendarSlice.jToday[0]);
    I18next.instance.i18next.changeLanguage(Plasmoid.configuration.language);

    root.toolTipMainText = Qt.binding(function() {
      return  CalendarUI.toolTipText(
        Store.store.calendarSlice.jToday,
        'dddd',
        Translate.useLocale()
      )
    })
    root.toolTipSubText = Qt.binding(function() {
      return CalendarUI.toolTipText(
        Store.store.calendarSlice.jToday,
        'D MMMM YYYY',
        Translate.useLocale()
      )
    })
  }

}
