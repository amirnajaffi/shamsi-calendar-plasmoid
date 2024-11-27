/*
Source: https://github.com/omid/Persian-Calendar-for-Gnome-Shell
*/

.import "../utils.js" as Utils

class IranSolar {
  constructor(pyear) {
    this.id = 'iransolar';
    this.name = 'مناسبت‌های رسمی ایران';
    this.type = 'persian';
    /* [month][day] = [title, isHoliday] */
    this.events = [[], [], [], [], [], [], [], [], [], [], [], [], []];

    this.events[1][1] = ['عید نوروز', true];
    this.events[1][2] = ['عید نوروز', true];
    this.events[1][3] = ['عید نوروز', true];
    this.events[1][4] = ['عید نوروز', true];
    this.events[1][12] = ['روز جمهوری اسلامی', true];
    this.events[1][13] = ['روز طبیعت', true];
    this.events[3][14] = ['رحلت امام خمینی', true];
    this.events[3][15] = ['قیام خونین ۱۵ خرداد', true];
    this.events[4][7] = ['شهادت دکتر بهشتی', false];
    this.events[6][8] = ['روز مبارزه با تروریسم', false];
    this.events[9][16] = ['روز دانشجو', false];
    this.events[9][30] = ['شب یلدا', false];
    this.events[11][22] = ['پیروزی انقلاب اسلامی', true];
    this.events[12][29] = ['روز ملی شدن صنعت نفت', true];
    this.events[12][30] = ['آخرین روز سال', true];

    this.addSpecificEvents(pyear);
  }

  /* Added by shamsi calendar plasmoid */
  addSpecificEvents(pyear) { 
    const PersianDate = Utils.pcgs_adapter; 

    let last_day_of_year;
    let leap = PersianDate.isLeap(pyear);

    if (!last_day_of_year) {
      last_day_of_year = 29 + leap;
    }

    if (last_day_of_year >= 30) {
      this.events[12][last_day_of_year] = [
        'آخرین روز سال',
        true,
      ];
    }
  }
};
