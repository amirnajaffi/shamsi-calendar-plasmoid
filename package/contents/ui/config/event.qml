import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

import "../../js/translate.js" as Translate
import "../../js/utils.js" as Utils

KCM.SimpleKCM {
  id: eventConfig

  property string cfg_activeEvents

  Kirigami.FormLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
      Kirigami.FormData.label: Translate.tConfigScope('available_events', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Repeater {
        model: [
          { id: 'iransolar', label: 'events_list.iransolar_desc' },
          { id: 'iranlunar', label: 'events_list.iranlunar_desc' },
          { id: 'persian', label: 'events_list.persian_desc' },
          { id: 'persianpersonage', label: 'events_list.persianpersonage_desc' },
          { id: 'world', label: 'events_list.world_desc' },
        ]

        delegate: Controls.CheckBox {
          text: Translate.tConfigScope(modelData.label, {lng: Plasmoid.configuration.language})
          checked: isChecked()

          onClicked: {
            const activeEventsArray = Utils.stringToArray(eventConfig.cfg_activeEvents);
            if (checked) {
              activeEventsArray.push(modelData.id);
            } else {
              const index = activeEventsArray.indexOf(modelData.id);
              if (index > -1) {
                activeEventsArray.splice(index, 1);
              }
            }
            eventConfig.cfg_activeEvents = activeEventsArray.join();
            checked = Qt.binding(isChecked);
          }

          function isChecked() {
            const activeEventsArray = Utils.stringToArray(eventConfig.cfg_activeEvents);
            return activeEventsArray.some((item) => item === modelData.id);
          }
        }

      } // end Repeater

      Component.onCompleted: {
        eventConfig.cfg_activeEvents = Plasmoid.configuration.activeEvents;
      }
    } // end ColumnLayout

  } // Kirigami.FormLayout
} // end ColumnLayout