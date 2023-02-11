.pragma library

Qt._sc_.calendar = {
  setDate: function (dateTimeObj) {
    // Check for store initialization before set (caused by early function call within PlasmaCore.DataSource)
    if (!Qt._sc_.store) return;
    const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
    // First run
    if (!Qt._sc_.store.calendarSlice.gToday || !Qt._sc_.store.calendarSlice.jToday) {
      this.dispatchSetDate(gDateArr);
      return;
    }
    // Date not changed
    if (
      Qt._sc_.store.calendarSlice.gToday[0] === gDateArr[0] &&
      Qt._sc_.store.calendarSlice.gToday[1] === gDateArr[1] &&
      Qt._sc_.store.calendarSlice.gToday[2] === gDateArr[2]
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
    Qt._sc_.store.calendarSlice.gToday = gDateArr;
    Qt._sc_.store.calendarSlice.jToday = jDateArr;
  },
};
