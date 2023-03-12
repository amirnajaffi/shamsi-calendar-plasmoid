.pragma library

.import "./events/iranSolar.js" as IranSolar
.import "./events/iranLunar.js" as IranLunar
.import "./events/persian.js" as Persian
.import "./events/persianPersonage.js" as PersianPersonage
.import "./events/world.js" as World

Qt._sc_.events = {
  getSelectedDateEvents: function () {
    const events = Qt._sc_.store.calendarSlice.events;
    const selectedDate = Qt._sc_.store.calendarSlice.selectedDate;
    const surface_daysOfMonth = Qt._sc_.store.calendarSlice.surface_daysOfMonth;

    if (events && selectedDate && events.length > 0 && selectedDate.length === 3) {
      /*
      surface_daysOfMonth   -> screen date
      events                -> contains events of screen dates

      events and surface_daysOfMonth Both have same index FOR SAME DATE,
      so we find event data in two steps:
      1. search for index of selectedDate inside surface_daysOfMonth
      2. get data from same index at events variable
      */
      const res = events.find((eventItem, i) => {
        return (
          eventItem &&
          surface_daysOfMonth[i][0] === selectedDate[0] &&
          surface_daysOfMonth[i][1] === selectedDate[1] &&
          surface_daysOfMonth[i][2] === selectedDate[2]
        );
      });
      return res || [];
    }
  },

  calculateAndSetSurfaceEvents: function (dates) {
    /*
    get array of dates and create new array of events
    index of created events array are same as given dates array
    */
    if (!dates) return;
    const jDates = [...dates];
    const iranSolar = new IranSolar.IranSolar();
    const iranLunar = new IranLunar.IranLunar();
    const persianPersonage = new PersianPersonage.PersianPersonage();
    const world = new World.World();
    const events = [];
    const pushEvent = (event, index) => (events[index] = [...(events[index] || []), [...event]]);

    for (let i = 0; i < jDates.length; i++) {
      const jDate = jDates[i];
      let gDate = Qt.jalaali.toGregorian(...jDate);
      gDate = [...Object.keys(gDate).map((key) => gDate[key])];
      const lunarDate = Qt.jalalidate.gregorian_to_islamic(...gDate);

      if (iranSolar.events[jDate[1]] && iranSolar.events[jDate[1]][jDate[2]]) {
        pushEvent(iranSolar.events[jDate[1]][jDate[2]], i);
      }

      if (iranLunar.events[lunarDate[1]] && iranLunar.events[lunarDate[1]][lunarDate[2]]) {
        pushEvent(iranLunar.events[lunarDate[1]][lunarDate[2]], i);
      }

      const persian = new Persian.Persian(jDate[0]);
      if (persian.events[jDate[1]] && persian.events[jDate[1]][jDate[2]]) {
        pushEvent(persian.events[jDate[1]][jDate[2]], i);
      }

      if (persianPersonage.events[jDate[1]] && persianPersonage.events[jDate[1]][jDate[2]]) {
        pushEvent(persianPersonage.events[jDate[1]][jDate[2]], i);
      }

      if (world.events[gDate[1]] && world.events[gDate[1]][gDate[2]]) {
        pushEvent(world.events[gDate[1]][gDate[2]], i);
      }
    }
    this.reducers.setEvents(events);
  },

  reducers: {
    setEvents: function (payload) {
      Qt._sc_.store.calendarSlice.events = [...payload];
    },
  },
};
