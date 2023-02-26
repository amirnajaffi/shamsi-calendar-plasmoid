.pragma library

Qt._sc_.calendar = {
  reevaluateSurfaceDates: function (toDate) {
    const nextYearAndMonth = [toDate[0], toDate[1]];
    const nextDaysOfMonthList = this.calculateDaysOfMonth(nextYearAndMonth);
    this.reducers.setYearAndMonth(nextYearAndMonth);
    this.reducers.setDaysOfMonth(nextDaysOfMonthList);
    this.changeDecade(nextYearAndMonth[0]);
  },

  changeMonth: function (monthOrYearAndMonthArr) {
    let nextMonthData;
    if (Array.isArray(monthOrYearAndMonthArr)) {
      nextMonthData = monthOrYearAndMonthArr;
    } else {
      const calendarSlice = Qt._sc_.store.calendarSlice;
      nextMonthData = [calendarSlice.surface_yearAndMonth[0], monthOrYearAndMonthArr];
    }
    this.reevaluateSurfaceDates(nextMonthData);
  },

  changeYear: function (year) {
    const calendarSlice = Qt._sc_.store.calendarSlice;
    this.reevaluateSurfaceDates([year, calendarSlice.surface_yearAndMonth[1]]);
  },

  changeDecade: function (year) {
    const { surface_yearsOfDecade } = Qt._sc_.store.calendarSlice;
    const nextDecadeList = this.calculateDecadeRange(year);
    // means same decade is going to set! so no need to change decade array.
    if (surface_yearsOfDecade && surface_yearsOfDecade[0] === nextDecadeList[0]) return;
    this.reducers.setYearsOfDecade(nextDecadeList);
  },

  /* Navigation methods */
  goCurrentDay: function () {
    const calendarSlice = Qt._sc_.store.calendarSlice;
    this.changeMonth(calendarSlice.jToday);
    this.reducers.setSelectedDate(calendarSlice.jToday);
  },

  goNextMonth: function () {
    const currentYearAndMonth = this.getYearAndMonth();
    let nextMonth;
    if (currentYearAndMonth[1] === 12) {
      nextMonth = [currentYearAndMonth[0] + 1, 1];
    } else {
      nextMonth = [currentYearAndMonth[0], currentYearAndMonth[1] + 1];
    }
    this.changeMonth(nextMonth);
  },

  goPrevMonth: function () {
    const currentYearAndMonth = this.getYearAndMonth();
    let prevMonth;
    if (currentYearAndMonth[1] === 1) {
      prevMonth = [currentYearAndMonth[0] - 1, 12];
    } else {
      prevMonth = [currentYearAndMonth[0], currentYearAndMonth[1] - 1];
    }
    this.changeMonth(prevMonth);
  },

  goCurrentYear: function () {
    const { jToday } = Qt._sc_.store.calendarSlice;
    this.changeYear(jToday[0]);
  },

  goNextYear: function () {
    const { surface_yearAndMonth } = Qt._sc_.store.calendarSlice;
    this.changeYear(surface_yearAndMonth[0] + 1);
  },

  goPrevYear: function () {
    const { surface_yearAndMonth } = Qt._sc_.store.calendarSlice;
    this.changeYear(surface_yearAndMonth[0] - 1);
  },

  goCurrentDecade: function () {
    const { jToday } = Qt._sc_.store.calendarSlice;
    this.changeDecade(jToday[0]);
    this.changeYear(jToday[0]);
  },

  goNextDecade: function () {
    const { surface_yearsOfDecade } = Qt._sc_.store.calendarSlice;
    this.changeDecade(surface_yearsOfDecade[5] + 10);
  },

  goPrevDecade: function () {
    const { surface_yearsOfDecade } = Qt._sc_.store.calendarSlice;
    this.changeDecade(surface_yearsOfDecade[5] - 10);
  },
  /* End navigation methods */

  newBaseDate: function (dateTimeObj) {
    const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
    const jDate = Qt.jalaali.toJalaali(...gDateArr);
    const jDateArr = Object.keys(jDate).map((key) => jDate[key]);
    this.reducers.setGToday(gDateArr);
    this.reducers.setJToday(jDateArr);
  },

  baseDateChangeHandler: function (dateTimeObj) {
    const dateChanged = this.shouldBaseDateChange(dateTimeObj);
    const isFirstRun = this.isBaseDateSet();
    if (dateChanged) {
      const calendarSlice = Qt._sc_.store.calendarSlice;
      this.newBaseDate(dateTimeObj);
      if (isFirstRun) {
        // Don't want to ruin user experience(mostly navigation) by changing surface dates automatically when base date changes
        // so run in first shot only
        // TODO: Maybe in future check for isFullRepresentationClose and then run reevaluateSurfaceDates()
        this.reevaluateSurfaceDates([calendarSlice.jToday[0], calendarSlice.jToday[1]]);
      }
    }
  },

  isBaseDateSet: function () {
    if (!Qt._sc_.store) return false;
    // First run
    if (!Qt._sc_.store.calendarSlice.gToday || !Qt._sc_.store.calendarSlice.jToday) {
      return true;
    }
    return false;
  },

  shouldBaseDateChange: function (dateTimeObj) {
    // Check for store initialization (caused by early function call within PlasmaCore.DataSource main.qml)
    if (!Qt._sc_.store) return false;
    // First run
    if (!Qt._sc_.store.calendarSlice.gToday || !Qt._sc_.store.calendarSlice.jToday) {
      return true;
    }
    const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
    // Date not changed
    if (
      Qt._sc_.store.calendarSlice.gToday[0] === gDateArr[0] &&
      Qt._sc_.store.calendarSlice.gToday[1] === gDateArr[1] &&
      Qt._sc_.store.calendarSlice.gToday[2] === gDateArr[2]
    ) {
      return false;
    }
    // Date changed
    return true;
  },

  calculateDecadeRange: function (year) {
    const baseYearSplitted = year.toString().split('');
    baseYearSplitted[baseYearSplitted.length - 1] = 0;
    const startDecadeYearOfBaseDate = parseInt(baseYearSplitted.join(''));
    const res = [];
    const resStart = startDecadeYearOfBaseDate - 1;
    const resEnd = startDecadeYearOfBaseDate + 10;
    for (let i = resStart; i <= resEnd; i++) {
      res.push(i);
    }
    return res;
  },

  calculateDaysOfMonth: function (baseYearAndMonth) {
    const baseDate = [...baseYearAndMonth, 1];
    const firstDayOfMonth = [baseDate[0], baseDate[1], 1];
    const firstWeekOfMonth = Qt.jalaali.jalaaliWeek(...firstDayOfMonth);
    const firstWeekSaturday = firstWeekOfMonth.saturday;
    const firstWeekFriday = firstWeekOfMonth.friday;
    const daysLimit = 42;

    // prev month offset
    const prevMonthDates = [];
    if (firstWeekSaturday.jm !== firstWeekFriday.jm) {
      const prevMonthLength = Qt.jalaali.jalaaliMonthLength(firstWeekSaturday.jy, firstWeekSaturday.jm);
      for (let i = firstWeekSaturday.jd; i <= prevMonthLength; i++) {
        prevMonthDates.push([firstWeekSaturday.jy, firstWeekSaturday.jm, i]);
      }
    }

    // current month
    const currentMonthDates = [];
    const currentMonthLength = Qt.jalaali.jalaaliMonthLength(baseDate[0], baseDate[1]);
    for (let i = 1; i <= currentMonthLength; i++) {
      currentMonthDates.push([baseDate[0], baseDate[1], i]);
    }

    // next month offset
    const nextMonthDates = [];
    const nextMonthOffset = daysLimit - (prevMonthDates.length + currentMonthDates.length);
    let nextMonthYear = baseDate[0];
    let nextMonthMonth = baseDate[1] + 1;
    if (nextMonthMonth > 12) {
      nextMonthYear = nextMonthYear + 1;
      nextMonthMonth = 1;
    }
    for (let i = 1; i <= nextMonthOffset; i++) {
      nextMonthDates.push([nextMonthYear, nextMonthMonth, i]);
    }
    return [...prevMonthDates, ...currentMonthDates, ...nextMonthDates];
  },

  getYearAndMonth: function () {
    const calendarSlice = Qt._sc_.store.calendarSlice;
    return [calendarSlice.surface_yearAndMonth[0], calendarSlice.surface_yearAndMonth[1]];
  },

  reducers: {
    setJToday: function (payload) {
      Qt._sc_.store.calendarSlice.jToday = [...payload];
    },
    setGToday: function (payload) {
      Qt._sc_.store.calendarSlice.gToday = [...payload];
    },
    setSelectedDate: function (payload) {
      Qt._sc_.store.calendarSlice.selectedDate = [payload[0], payload[1], payload[2]];
    },
    clearSelectedDate: function () {
      Qt._sc_.store.calendarSlice.selectedDate = [];
    },
    setYearAndMonth: function (payload) {
      Qt._sc_.store.calendarSlice.surface_yearAndMonth = [payload[0], payload[1]];
    },
    setDaysOfMonth: function (payload) {
      Qt._sc_.store.calendarSlice.surface_daysOfMonth = [...payload];
    },
    setYearsOfDecade: function (payload) {
      Qt._sc_.store.calendarSlice.surface_yearsOfDecade = [...payload];
    },
  },
};
