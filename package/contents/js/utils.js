.pragma library

Qt._sc_.utils = {
  pcgs_adapter: {
    /*
    PCGS = Persian Gnome Calendar = https://github.com/omid/Persian-Calendar-for-Gnome-Shell
    this functions use in event folder to easily converting PersianDate methods to jalaali functions
    */
    gregorianToPersian: function (...props) {
      const jDate = Qt.jalaali.toJalaali(...props);
      return { year: jDate.jy, month: jDate.jm, day: jDate.jd };
    },
    persianToGregorian: function (...props) {
      const jDate = Qt.jalaali.toGregorian(...props);
      return { year: jDate.gy, month: jDate.gm, day: jDate.gd };
    },
    isLeap: function (...props) {
      return Qt.jalaali.isLeapJalaaliYear(...props);
    },
  },
};
