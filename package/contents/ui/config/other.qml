import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5 as Controls

import org.kde.kirigami 2.5 as Kirigami

ColumnLayout {
  id: otherConfig

  /* 
  Using 'tempLanguage' instead of 'language' directly, it's necessary for right components re-evalluate 
  as we need to change Plasmoid.configuration.language AFTER calling Qt.i18next.changeLanguage .
  flow: change tempLanguage -> call Qt.i18next.changeLanguage(to tempLanguage) -> change language(to tempLanguage).
  (check onTempLanguageChanged method on main.qml connections)
  */
  property string cfg_tempLanguage

  Kirigami.FormLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    RowLayout {
      Layout.fillWidth: true
      Kirigami.FormData.label: "Language:"

      Controls.ComboBox {
        id: language
        textRole: "label"
        model: [
          {
            label: 'English',
            value: 'en'
          },
          {
            label: 'Persian(فارسی)',
            value: 'fa'
          }
        ]
        
        onActivated: otherConfig.cfg_tempLanguage = model[index].value
        currentIndex: model.findIndex((item) => {
            return item.value === otherConfig.cfg_tempLanguage;
        })
      }
    }
  }
}
