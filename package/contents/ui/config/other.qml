import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

import "../../js/translate.js" as Translate

KCM.SimpleKCM {
  id: otherConfig

  /* 
  Using 'tempLanguage' instead of 'language' directly, it's necessary for right components re-evalluate 
  as we need to change Plasmoid.configuration.language AFTER calling I18next.instance.i18next.changeLanguage .
  flow: change tempLanguage -> call I18next.instance.i18next.changeLanguage(to tempLanguage) -> change language(to tempLanguage).
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
