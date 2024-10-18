.pragma library

.import "./store.js" as Store
.import "./constants.js" as Const
.import "./calendar.js" as Calendar
.import "./utils.js" as Utils


function useLayoutDirection() {
  const lang = Store.store.configSlice.language;
  if (lang === Const.constants.LANG_FA) {
    return Qt.RightToLeft;
  } else if (lang === Const.constants.LANG_EN) {
    return Qt.LeftToRight;
  }
  return Qt.LeftToRight;
}

function useTextHorizontalAlignment(reverse = false) {
  const lang = Store.store.configSlice.language;
  if (lang === Const.constants.LANG_FA) {
    return reverse ? Qt.AlignLeft : Qt.AlignRight;
  } else if (lang === Const.constants.LANG_EN) {
    return reverse ? Qt.AlignRight : Qt.AlignLeft;
  }
  return Qt.AlignLeft;
}

function getWeekendHighlightIndexes(weekendHighlightDaysStr, rows, columns) {
  const weekendHighlightDays = Utils.stringToNumberArray(weekendHighlightDaysStr);
  const mustHighlight = [];
  weekendHighlightDays.forEach((item) => {
    for (let i = 0; i < rows - 1; i++) {
      mustHighlight.push(item + columns * i);
    }
  });
  return mustHighlight;
}

function toolTipText(jDateArr, format, locale) {
  return new persianDate(jDateArr).toLocale(locale).format(format);
}

function headerNavigation_goNextModelState(nextDirection) {
  const next = this._getNextNavigableData(nextDirection);
  next.callback.call(Calendar);
}

function headerNavigation_buttonName(buttonAction) {
  const next = this._getNextNavigableData(buttonAction);
  return next.buttonName;
}

function stackNavigation_toOrFromYearView() {
  const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Const.constants.stack;
  const { stack, yearViewComponent } = Store.store.uiReference;
  const isMonthView = this._isStackCurrentItem(MONTH_VIEW_AND_EVENTS.objectName);
  const isYearView = this._isStackCurrentItem(YEAR_VIEW.objectName);
  const isDecadeView = this._isStackCurrentItem(DECADE_VIEW.objectName);

  if (isMonthView) {
    // show year view
    stack.push(yearViewComponent);
    return;
  }
  if (isYearView || isDecadeView) {
    // if in year view go home
    // if in decade view go to year view
    stack.pop();
    return;
  }
}

function stackNavigation_toOrFromDecadeView(selectMode = false) {
  const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Const.constants.stack;
  const { stack, decadeViewComponent, yearViewComponent } = Store.store.uiReference;
  const isMonthView = this._isStackCurrentItem(MONTH_VIEW_AND_EVENTS.objectName);
  const isYearView = this._isStackCurrentItem(YEAR_VIEW.objectName);
  const isDecadeView = this._isStackCurrentItem(DECADE_VIEW.objectName);

  if (isMonthView) {
    stack.push([yearViewComponent, decadeViewComponent]);
    return;
  }
  if (isYearView) {
    stack.push(decadeViewComponent);
    return;
  }
  if (isDecadeView && selectMode) {
    stack.pop();
    return;
  } else if (isDecadeView) {
    stack.pop();
    stack.pop();
    return;
  }
}

function monthView_highlightOpacity(isHovered, monthCellData) {
  const { selectedDate, jToday } = Store.store.calendarSlice;
  if (jToday[0] === monthCellData[0] && jToday[1] === monthCellData[1] && jToday[2] === monthCellData[2]) {
    return 0.9; // current date
  }
  if (
    selectedDate &&
    selectedDate.length === 3 &&
    selectedDate[0] === monthCellData[0] &&
    selectedDate[1] === monthCellData[1] &&
    selectedDate[2] === monthCellData[2]
  ) {
    return 0.4; // selected
  }
  if (isHovered) return 0.1; // hovered
  return 0; // no highlight
}

function yearView_highlightOpacity(isHovered, monthNumberCell) {
  const { selectedDate, surface_yearAndMonth, jToday } = Store.store.calendarSlice;
  if (surface_yearAndMonth[0] === jToday[0] && monthNumberCell === jToday[1]) return 0.9; // current date
  if (
    selectedDate &&
    selectedDate.length === 3 &&
    surface_yearAndMonth[0] === selectedDate[0] &&
    selectedDate[1] === monthNumberCell
  ) {
    return 0.4; // selected
  }
  if (isHovered) return 0.1; // hovered
  return 0; // no highlight
}

function decadeView_highlightOpacity(isHovered, yearNumberCell) {
  const { selectedDate, jToday } = Store.store.calendarSlice;
  if (jToday[0] === yearNumberCell) return 0.9; // current date
  if (selectedDate && selectedDate.length === 3 && selectedDate[0] === yearNumberCell) {
    return 0.4; // selected
  }
  if (isHovered) return 0.1; // hovered
  return 0; // no highlight
}

function monthView_repeater_dayHasHoliday(dateIndex) {
  if (!Store.store.calendarSlice.events[dateIndex]) return false;
  const events = Store.store.calendarSlice.events;
  for (let i = 0; i < events[dateIndex].length; i++) {
    if (events[dateIndex][i][1] === true) return true;
  }
  return false;
}

function monthView_repeater_dayHasOtherEvent(dateIndex) {
  if (!Store.store.calendarSlice.events[dateIndex]) return false;
  const events = Store.store.calendarSlice.events;
  for (let i = 0; i < events[dateIndex].length; i++) {
    if (events[dateIndex][i][1] === false) return true;
  }
  return false;
}

function _getNextNavigableData(nextDirection) {
  const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Const.constants.stack;
  const isMonthView = this._isStackCurrentItem(MONTH_VIEW_AND_EVENTS.objectName);
  const isYearView = this._isStackCurrentItem(YEAR_VIEW.objectName);
  const isDecadeView = this._isStackCurrentItem(DECADE_VIEW.objectName);
  const navigationMap = this._getNavigationMap();
  let nextDirectionMapKey;
  if (isMonthView) {
    nextDirectionMapKey = `${nextDirection}_month`;
  } else if (isYearView) {
    nextDirectionMapKey = `${nextDirection}_year`;
  } else if (isDecadeView) {
    nextDirectionMapKey = `${nextDirection}_decade`;
  }

  return navigationMap[nextDirectionMapKey];
}

function _getNavigationMap() {
  return {
    current_month: { callback: Calendar.goCurrentDay, buttonName: 'today' },
    current_year: { callback: Calendar.goCurrentYear, buttonName: 'current_year' },
    current_decade: { callback: Calendar.goCurrentDecade, buttonName: 'current_decade' },
    next_month: { callback: Calendar.goNextMonth, buttonName: 'next_month' },
    next_year: { callback: Calendar.goNextYear, buttonName: 'next_year' },
    next_decade: { callback: Calendar.goNextDecade, buttonName: 'next_decade' },
    prev_month: { callback: Calendar.goPrevMonth, buttonName: 'previous_month' },
    prev_year: { callback: Calendar.goPrevYear, buttonName: 'previous_year' },
    prev_decade: { callback: Calendar.goPrevDecade, buttonName: 'previous_decade' },
  };
}

function _isStackCurrentItem(stackObjectName = null) {
  const { stack } = Store.store.uiReference;
  const inStackObjectName = stack.currentItem.objectName;
  if (inStackObjectName === stackObjectName) {
    return true;
  }
  return false;
}
