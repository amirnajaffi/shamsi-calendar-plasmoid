// .pragma library

Qt._sc_.calendarUI = {
  headerNavigation_goNextModelState: function (nextDirection) {
    const next = this._getNextNavigableData(nextDirection);
    next.callback.call(Qt._sc_.calendar);
  },

  headerNavigation_buttonName: function (buttonAction) {
    const next = this._getNextNavigableData(buttonAction);
    return next.buttonName;
  },

  stackNavigation_toOrFromYearView: function () {
    const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Qt._sc_.const.stack;
    const { stack, yearViewComponent } = Qt._sc_.store.uiReference;
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
  },

  stackNavigation_toOrFromDecadeView: function (selectMode = false) {
    const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Qt._sc_.const.stack;
    const { stack, decadeViewComponent, yearViewComponent } = Qt._sc_.store.uiReference;
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
  },

  monthView_highlightOpacity: function (isHovered, monthCellData) {
    const { selectedDate, jToday } = Qt._sc_.store.calendarSlice;
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
  },

  yearView_highlightOpacity: function (isHovered, celMonth) {
    const { selectedDate, surface_yearAndMonth, jToday } = Qt._sc_.store.calendarSlice;
    if (surface_yearAndMonth[0] === jToday[0] && celMonth === jToday[1]) return 0.9; // current date
    if (selectedDate && selectedDate.length === 3) {
      if (surface_yearAndMonth[0] === selectedDate[0] && selectedDate[1] === celMonth) return 0.4; // selected
    }
    if (isHovered) return 0.1; // hovered
    return 0; // no highlight
  },

  decadeView_highlightOpacity: function (isHovered, cellYear) {
    const { selectedDate, jToday } = Qt._sc_.store.calendarSlice;
    if (jToday[0] === cellYear) return 0.9; // current date
    if (selectedDate && selectedDate.length === 3) {
      if (selectedDate[0] === cellYear) return 0.4; // selected
    }
    if (isHovered) return 0.1; // hovered
    return 0; // no highlight
  },

  _getNextNavigableData: function (nextDirection) {
    const { MONTH_VIEW_AND_EVENTS, YEAR_VIEW, DECADE_VIEW } = Qt._sc_.const.stack;
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
  },

  _getNavigationMap: function () {
    return {
      current_month: { callback: Qt._sc_.calendar.goCurrentDay, buttonName: 'Today' },
      current_year: { callback: Qt._sc_.calendar.goCurrentYear, buttonName: 'Current Year' },
      current_decade: { callback: Qt._sc_.calendar.goCurrentDecade, buttonName: 'Current Decade' },
      next_month: { callback: Qt._sc_.calendar.goNextMonth, buttonName: 'Next Month' },
      next_year: { callback: Qt._sc_.calendar.goNextYear, buttonName: 'Next Year' },
      next_decade: { callback: Qt._sc_.calendar.goNextDecade, buttonName: 'Next Decade' },
      prev_month: { callback: Qt._sc_.calendar.goPrevMonth, buttonName: 'Previous Month' },
      prev_year: { callback: Qt._sc_.calendar.goPrevYear, buttonName: 'Previous Year' },
      prev_decade: { callback: Qt._sc_.calendar.goPrevDecade, buttonName: 'Previous Decade' },
    };
  },

  _isStackCurrentItem: function (stackObjectName = null) {
    const { stack } = Qt._sc_.store.uiReference;
    const inStackObjectName = stack.currentItem.objectName;
    if (inStackObjectName === stackObjectName) {
      return true;
    }
    return false;
  },
};
