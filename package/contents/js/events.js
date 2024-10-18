.pragma library

.import "./store.js" as Store
.import "./events/iranSolar.js" as IranSolar
.import "./events/iranLunar.js" as IranLunar
.import "./events/persian.js" as Persian
.import "./events/persianPersonage.js" as PersianPersonage
.import "./events/world.js" as World
.import "./bin/hijri-date.js" as HijriDate
.import "./bin/jalaali.js" as Jalaali
.import "./utils.js" as Utils

function getSelectedDateEvents() {
  const events = Store.store.calendarSlice.events;
  const selectedDate = Store.store.calendarSlice.selectedDate;
  const surface_daysOfMonth = Store.store.calendarSlice.surface_daysOfMonth;

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
}

function calculateAndSetSurfaceEvents(dates) {
  /*
  get array of dates and create new array of events
  index of created events array are same as given dates array
  */
  if (!dates) return;
  const jDates = [...dates];

  const activeEventsArray = Utils.stringToArray(Store.store.configSlice.activeEvents);
  if (activeEventsArray.length < 1) return;

  // const iranSolar = new IranSolar.IranSolar();
  let iranSolar = new IranSolar.IranSolar(jDates[0][0]);
  const iranLunar = new IranLunar.IranLunar();
  let persian = new Persian.Persian(jDates[0][0]);
  const persianPersonage = new PersianPersonage.PersianPersonage();
  const world = new World.World();
  const isIranSolarActive = activeEventsArray.includes(iranSolar.id);
  const isIranLunarActive = activeEventsArray.includes(iranLunar.id);
  const isPersianActive = activeEventsArray.includes(persian.id);
  const isPersianPersonageActive = activeEventsArray.includes(persianPersonage.id);
  const isWorldActive = activeEventsArray.includes(world.id);

  const events = [];
  const pushEvent = (event, index) => (events[index] = [...(events[index] || []), [...event]]);
  let lastJYearForPersian = jDates[0][0];
  let lastJYearForIraSolar = jDates[0][0];

  for (let i = 0; i < jDates.length; i++) {
    const jDate = jDates[i];
    let gDate = Jalaali.toGregorian(...jDate);
    gDate = [...Object.keys(gDate).map((key) => gDate[key])];
    let lunarDate = HijriDate.fromGregorian(...gDate);
    lunarDate = Object.values(lunarDate);

    // if (isIranSolarActive && iranSolar.events[jDate[1]] && iranSolar.events[jDate[1]][jDate[2]]) {
    //   pushEvent(iranSolar.events[jDate[1]][jDate[2]], i);
    // }

    if (isIranSolarActive) {
      if (lastJYearForIraSolar !== jDate[0]) {
        iranSolar = new IranSolar.IranSolar(jDate[0]);
        lastJYearForIraSolar = jDate[0];
      }
      if (iranSolar.events[jDate[1]] && iranSolar.events[jDate[1]][jDate[2]]) {
        pushEvent(iranSolar.events[jDate[1]][jDate[2]], i);
      }
    }

    if (isIranLunarActive && iranLunar.events[lunarDate[1]] && iranLunar.events[lunarDate[1]][lunarDate[2]]) {
      pushEvent(iranLunar.events[lunarDate[1]][lunarDate[2]], i);
    }

    if (isPersianActive) {
      if (lastJYearForPersian !== jDate[0]) {
        persian = new Persian.Persian(jDate[0]);
        lastJYearForPersian = jDate[0];
      }
      if (persian.events[jDate[1]] && persian.events[jDate[1]][jDate[2]]) {
        pushEvent(persian.events[jDate[1]][jDate[2]], i);
      }
    }

    if (isPersianPersonageActive && persianPersonage.events[jDate[1]] && persianPersonage.events[jDate[1]][jDate[2]]) {
      pushEvent(persianPersonage.events[jDate[1]][jDate[2]], i);
    }

    if (isWorldActive && world.events[gDate[1]] && world.events[gDate[1]][gDate[2]]) {
      pushEvent(world.events[gDate[1]][gDate[2]], i);
    }
  }
  this.reducers.setEvents(events);
}

var reducers = {
  setEvents: function (payload) {
    Store.store.calendarSlice.events = [...payload];
  },
};
