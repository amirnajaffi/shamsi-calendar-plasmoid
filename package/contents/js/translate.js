// .pragma library

Qt.i18next.init({
  compatibilityJSON: 'v3',
  lng: 'en',
  debug: true,
  resources: {
    en: {
      translation: {
        month: {
          normal: {
            1: 'January',
            2: 'February',
            3: 'March',
            4: 'April',
            5: 'May',
            6: 'June',
            7: 'July',
            8: 'August',
            9: 'September',
            10: 'October',
            11: 'November',
            12: 'December',
          },
        },
      },
    },
    fa: {
      translation: {
        month: {
          normal: {
            1: 'فروردین',
            2: 'اردیبهشت',
            3: 'خرداد',
            4: 'تیر',
            5: 'مرداد',
            6: 'شهریور',
            7: 'مهر',
            8: 'آبان',
            9: 'آذر',
            10: 'دی',
            11: 'بهمن',
            12: 'اسفند',
          },
        },
      },
    },
  },
});

Qt.scTr = function (...key) {
  return Qt.i18next.t(...key);
};
