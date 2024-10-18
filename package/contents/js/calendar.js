.pragma library

.import "./store.js" as Store
.import "./events.js" as Events
.import "./bin/jalaali.js" as Jalaali

function reevaluateSurfaceDates(toDate) {
  const nextYearAndMonth = [toDate[0], toDate[1]];
  const nextDaysOfMonthList = this.calculateDaysOfMonth(nextYearAndMonth);
  reducers.setYearAndMonth(nextYearAndMonth);
  reducers.setDaysOfMonth(nextDaysOfMonthList);
  this.changeDecade(nextYearAndMonth[0]);
  Events.calculateAndSetSurfaceEvents(Store.store.calendarSlice.surface_daysOfMonth);
}

function changeMonth(monthOrYearAndMonthArr) {
  let nextMonthData;
  if (Array.isArray(monthOrYearAndMonthArr)) {
    nextMonthData = monthOrYearAndMonthArr;
  } else {
    const calendarSlice = Store.store.calendarSlice;
    nextMonthData = [calendarSlice.surface_yearAndMonth[0], monthOrYearAndMonthArr];
  }
  this.reevaluateSurfaceDates(nextMonthData);
}

function changeYear(year) {
  const calendarSlice = Store.store.calendarSlice;
  this.reevaluateSurfaceDates([year, calendarSlice.surface_yearAndMonth[1]]);
}

function changeDecade(year) {
  const { surface_yearsOfDecade } = Store.store.calendarSlice;
  const nextDecadeList = this.calculateDecadeRange(year);
  // means same decade is going to set! so no need to change decade array.
  if (surface_yearsOfDecade && surface_yearsOfDecade[0] === nextDecadeList[0]) return;
  reducers.setYearsOfDecade(nextDecadeList);
}

/* Navigation methods */
function goCurrentDay() {
  const calendarSlice = Store.store.calendarSlice;
  this.changeMonth(calendarSlice.jToday);
  reducers.setSelectedDate(calendarSlice.jToday);
}

function goNextMonth() {
  const currentYearAndMonth = this.getYearAndMonth();
  let nextMonth;
  if (currentYearAndMonth[1] === 12) {
    nextMonth = [currentYearAndMonth[0] + 1, 1];
  } else {
    nextMonth = [currentYearAndMonth[0], currentYearAndMonth[1] + 1];
  }
  this.changeMonth(nextMonth);
}

function goPrevMonth() {
  const currentYearAndMonth = this.getYearAndMonth();
  let prevMonth;
  if (currentYearAndMonth[1] === 1) {
    prevMonth = [currentYearAndMonth[0] - 1, 12];
  } else {
    prevMonth = [currentYearAndMonth[0], currentYearAndMonth[1] - 1];
  }
  this.changeMonth(prevMonth);
}

function goCurrentYear() {
  const { jToday } = Store.store.calendarSlice;
  this.changeYear(jToday[0]);
}

function goNextYear() {
  const { surface_yearAndMonth } = Store.store.calendarSlice;
  this.changeYear(surface_yearAndMonth[0] + 1);
}

function goPrevYear() {
  const { surface_yearAndMonth } = Store.store.calendarSlice;
  this.changeYear(surface_yearAndMonth[0] - 1);
}

function goCurrentDecade() {
  const { jToday } = Store.store.calendarSlice;
  this.changeDecade(jToday[0]);
  this.changeYear(jToday[0]);
}

function goNextDecade() {
  const { surface_yearsOfDecade } = Store.store.calendarSlice;
  this.changeDecade(surface_yearsOfDecade[5] + 10);
}

function goPrevDecade() {
  const { surface_yearsOfDecade } = Store.store.calendarSlice;
  this.changeDecade(surface_yearsOfDecade[5] - 10);
}
/* End navigation methods */

function newBaseDate(dateTimeObj) {
  const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
  const jDate = Jalaali.toJalaali(...gDateArr);
  const jDateArr = Object.keys(jDate).map((key) => jDate[key]);
  reducers.setGToday(gDateArr);
  reducers.setJToday(jDateArr);
}

function baseDateChangeHandler(dateTimeObj) {
  const dateChanged = this.shouldBaseDateChange(dateTimeObj);
  const isFirstRun = this.isBaseDateSet();
  if (dateChanged) {
    const calendarSlice = Store.store.calendarSlice;
    this.newBaseDate(dateTimeObj);
    if (isFirstRun) {
      // Don't want to ruin user experience(mostly navigation) by changing surface dates automatically when base date changes
      // so run in first shot only
      // TODO: Maybe in future check for isFullRepresentationClose and then run reevaluateSurfaceDates()
      this.reevaluateSurfaceDates([calendarSlice.jToday[0], calendarSlice.jToday[1]]);
      reducers.setSelectedDate(calendarSlice.jToday);
    }
  }
}

function isBaseDateSet() {
  if (!Store.store || Object.keys(Store.store).length < 1) return false;
  // First run
  if (!Store.store.calendarSlice.gToday || !Store.store.calendarSlice.jToday) {
    return true;
  }
  return false;
}

function shouldBaseDateChange(dateTimeObj) {
  // Check for store initialization (caused by early function call within P5Support.DataSource main.qml)
  if (!Store.store.calendarSlice) return false;
  // First run
  if (!Store.store.calendarSlice.gToday || !Store.store.calendarSlice.jToday) {
    return true;
  }
  const gDateArr = [dateTimeObj.getFullYear(), dateTimeObj.getMonth() + 1, dateTimeObj.getDate()];
  // Date not changed
  if (
    Store.store.calendarSlice.gToday[0] === gDateArr[0] &&
    Store.store.calendarSlice.gToday[1] === gDateArr[1] &&
    Store.store.calendarSlice.gToday[2] === gDateArr[2]
  ) {
    return false;
  }
  // Date changed
  return true;
}

function calculateDecadeRange(year) {
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
}

function calculateDaysOfMonth(baseYearAndMonth) {
  const baseDate = [...baseYearAndMonth, 1];
  const firstDayOfMonth = [baseDate[0], baseDate[1], 1];
  const firstWeekOfMonth = Jalaali.jalaaliWeek(...firstDayOfMonth);
  const firstWeekSaturday = firstWeekOfMonth.saturday;
  const firstWeekFriday = firstWeekOfMonth.friday;
  const daysLimit = 42;

  // prev month offset
  const prevMonthDates = [];
  if (firstWeekSaturday.jm !== firstWeekFriday.jm) {
    const prevMonthLength = Jalaali.jalaaliMonthLength(firstWeekSaturday.jy, firstWeekSaturday.jm);
    for (let i = firstWeekSaturday.jd; i <= prevMonthLength; i++) {
      prevMonthDates.push([firstWeekSaturday.jy, firstWeekSaturday.jm, i]);
    }
  }

  // current month
  const currentMonthDates = [];
  const currentMonthLength = Jalaali.jalaaliMonthLength(baseDate[0], baseDate[1]);
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
}

function getYearAndMonth() {
  const calendarSlice = Store.store.calendarSlice;
  return [calendarSlice.surface_yearAndMonth[0], calendarSlice.surface_yearAndMonth[1]];
}

var reducers = {
  setJToday: function (payload) {
    Store.store.calendarSlice.jToday = [...payload];
  },
  setGToday: function (payload) {
    Store.store.calendarSlice.gToday = [...payload];
  },
  setSelectedDate: function (payload) {
    Store.store.calendarSlice.selectedDate = [payload[0], payload[1], payload[2]];
  },
  clearSelectedDate: function () {
    Store.store.calendarSlice.selectedDate = [];
  },
  setYearAndMonth: function (payload) {
    Store.store.calendarSlice.surface_yearAndMonth = [payload[0], payload[1]];
  },
  setDaysOfMonth: function (payload) {
    Store.store.calendarSlice.surface_daysOfMonth = [...payload];
  },
  setYearsOfDecade: function (payload) {
    Store.store.calendarSlice.surface_yearsOfDecade = [...payload];
  },
};
