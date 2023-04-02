.pragma library

.import "./bin/i18next.js" as I18next

Qt.i18next.init({
  compatibilityJSON: 'v3',
  lng: 'en',
  debug: false,
  resources: {
    en: {
      translation: {
        /* Calendar UI */
        week_label: {
          1: 'Sat',
          2: 'Sun',
          3: 'Mon',
          4: 'Tue',
          5: 'Wed',
          6: 'Thu',
          7: 'Fri',
        },
        month: {
          normal: {
            1: 'Farvardin',
            2: 'Ordibehesht',
            3: 'Khordad',
            4: 'Tir',
            5: 'Mordad',
            6: 'Shahrivar',
            7: 'Mehr',
            8: 'Aban',
            9: 'Azar',
            10: 'Dey',
            11: 'Bahman',
            12: 'Esfand',
          },
        },
        today: 'Today',
        current_year: 'Current Year',
        current_decade: 'Current Decade',
        next_month: 'Next Month',
        next_year: 'Next Year',
        next_decade: 'Next Decade',
        previous_month: 'Previous Month',
        previous_year: 'Previous Year',
        previous_decade: 'Previous Decade',
        no_event: 'No Event',
        configure: 'Configure',
        keep_open: 'Keep Open',
        change_language: 'Change Language',
        /* Config */
        appearance: 'Appearance',
        event: 'Event',
        other: 'Other',
        panel: 'Panel',
        holiday_color: 'Holiday color',
        event_color: 'Event color',
        calendar_cell_font_mode: 'Calendar cell font mode',
        fit: 'Fit',
        fixed: 'Fixed',
        reset: 'Reset',
        scale: 'Scale',
        font: 'Font',
        default: 'Default',
        vazir: 'Vazir',
        best_look_in_persian: 'Best look in Persian.',
        manual: 'Manual',
        choose_font: 'Choose Font',
        only_font_name_is_applied: 'Only font name is applied.',
        enable_weekend_highlight: 'Enable weekend highlight',
        weekend: 'Weekend',
        primary_text: 'Primary Text',
        date_format: 'Date format',
        result: 'Result',
        templates: 'Templates',
        date_format_documentation:
          '<a href="https://github.com/babakhani/PersianDate#format">Date Format Documentation</a>',
        font_tag_documentation:
          '<a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/font#attributes">Font Tag Documentation</a>',
        format_description:
          'Just use the font tag. If you use a tag for styling, be sure to have an enclosing tag and then use the format and tags inside it as desired (see templates). You can use tags to change the font, color, etc. Styles applied by tags take precedence over setting values. Time formats are not currently supported.',
        secondary_text: 'Secondary Text',
        enable_secondary_text: 'Enable secondary text',
        height: 'Height',
        calendar: 'Calendar',
        available_events: 'Available events',
        events_list: {
          iransolar_desc: 'Official Iranian Solar(including holidays)',
          iranlunar_desc: 'Official Iranian Lunar(including holidays)',
          persian_desc: 'Ancient Persian',
          persianpersonage_desc: 'Persian Personages',
          world_desc: 'International',
        },
      },
    },
    fa: {
      translation: {
        /* Calendar UI */
        week_label: {
          1: 'ش',
          2: 'ی',
          3: 'د',
          4: 'س',
          5: 'چ',
          6: 'پ',
          7: 'ج',
        },
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
        today: 'امروز',
        current_year: 'سال جاری',
        current_decade: 'دهه جاری',
        next_month: 'ماه بعد',
        next_year: 'سال بعد',
        next_decade: 'دهه بعد',
        previous_month: 'ماه قبل',
        previous_year: 'سال قبل',
        previous_decade: 'دهه قبل',
        no_event: 'بدون رویداد',
        configure: 'تنظیمات',
        keep_open: 'باز نگه داشتن',
        change_language: 'تعویض زبان',
        /* Config */
        appearance: 'ظاهر',
        event: 'رویداد',
        other: 'دیگر',
        panel: 'پنل',
        holiday_color: 'رنگ تعطیلات',
        event_color: 'رنگ رویداد',
        calendar_cell_font_mode: 'حالت فونت در سلول تقویم',
        fit: 'تطبیقی',
        fixed: 'ثابت',
        reset: 'بازنشانی',
        scale: 'مقیاس',
        font: 'فونت',
        default: 'پیش‌فرض',
        vazir: 'وزیر',
        best_look_in_persian: 'بهترین نمایش به زبان فارسی.',
        manual: 'تنظیم دستی',
        choose_font: 'انتخاب فونت',
        only_font_name_is_applied: 'فقط نام فونت اعمال می‌شود.',
        enable_weekend_highlight: 'علامت‌گذاری تعطیلات آخر هفته',
        weekend: 'تعطیلات آخر هفته',
        primary_text: 'متن اصلی',
        date_format: 'فرمت تاریخ',
        result: 'نتیجه',
        templates: 'نمونه‌ها',
        date_format_documentation: '<a href="https://github.com/babakhani/PersianDate#format">مستندات فرمت تاریخ</a>',
        font_tag_documentation:
          '<a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/font#attributes">مستندات تگ فونت</a>',
        format_description:
          'فقط از تگ font استفاده کنید. در صورت استفاده از تگ جهت استایل دهی حتما یک تگ دربرگیرنده داشته باشید و سپس داخل آن به صورت دلخواه از فرمت و تگ‌ها استفاده کنید (نمونه‌ها را ببینید). شما میتوانید با استفاده از تگ‌ها فونت، رنگ و ... را تغییر دهید. استایل های اعمال شده توسط تگ‌ها مقدم بر مقادیر تنظیمات هستند. در حال حاضر فرمت‌های زمان پشتیبانی نمی‌شوند.',
        secondary_text: 'متن دوم',
        enable_secondary_text: 'فعال‌سازی متن دوم',
        height: 'ارتفاع',
        calendar: 'تقویم',
        available_events: 'رویداد‌ها',
        events_list: {
          iransolar_desc: 'رویدادهای رسمی ایران(شامل تعطیلات رسمی)',
          iranlunar_desc: 'رویدادهای مذهبی ایران(شامل تعطیلات رسمی)',
          persian_desc: 'رویدادهای ایران کهن',
          persianpersonage_desc: 'شخصیت‌های ایرانی',
          world_desc: 'رویدادهای جهانی',
        },
      },
    },
  },
});

Qt._sc_.t = function (...props) {
  /* translation function depends on store */
  Qt._sc_.store.configSlice.language;
  return Qt.i18next.t(...props);
};

Qt._sc_.tpd = function (number, source = undefined) {
  // To Persian Digits
  let lang;
  if (source) {
    lang = source;
  } else {
    lang = Qt._sc_.store.configSlice.language;
  }
  if (lang === Qt._sc_.const.LANG_FA) {
    const persian = {
      0: '۰',
      1: '۱',
      2: '۲',
      3: '۳',
      4: '۴',
      5: '۵',
      6: '۶',
      7: '۷',
      8: '۸',
      9: '۹',
    };
    number = number.toString().split('');
    let persianNumber = '';
    for (let i = 0; i < number.length; i++) {
      number[i] = persian[number[i]];
    }
    for (let i = 0; i < number.length; i++) {
      persianNumber += number[i];
    }
    return persianNumber;
  }
  return number;
};

Qt._sc_.useLocale = function (source = undefined) {
  let lang;
  if (source) {
    lang = source;
  } else {
    lang = Qt._sc_.store.configSlice.language;
  }

  if (lang === Qt._sc_.const.LANG_FA) {
    return 'fa';
  } else if (lang === Qt._sc_.const.LANG_EN) {
    return 'en';
  }
  return 'en';
};
