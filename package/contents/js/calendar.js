.pragma library

Qt.calendar = {
  setDate: function (dateTimeObj) {
    // Check for store initialization before set (caused by early function call within PlasmaCore.DataSource)
    if (!Qt.store) return;
    const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
    // First run
    if (!Qt.store.calendarSlice.gToday || !Qt.store.calendarSlice.jToday) {
      this.dispatchSetDate(gDateArr);
      return;
    }
    // Date not changed
    if (
      Qt.store.calendarSlice.gToday[0] === gDateArr[0] &&
      Qt.store.calendarSlice.gToday[1] === gDateArr[1] &&
      Qt.store.calendarSlice.gToday[2] === gDateArr[2]
    ) {
      return;
    }
    // Date changed
    this.dispatchSetDate(gDateArr);
    return;
  },

  dispatchSetDate: function (gDateArr) {
    const jDate = Qt.jalaali.toJalaali(...gDateArr);
    const jDateArr = Object.keys(jDate).map((key) => jDate[key]);
    Qt.store.calendarSlice.gToday = gDateArr;
    Qt.store.calendarSlice.jToday = jDateArr;
  },
};
