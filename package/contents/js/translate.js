.pragma library

Qt.i18next.init({
  compatibilityJSON: 'v3',
  lng: 'en',
  debug: true,
  resources: {
    en: {
      translation: {
        key: 'hello world',
      },
    },
    fa: {
      translation: {
        key: 'سلام دنیا',
      },
    },
  },
});

Qt.scTr = function (...key) {
  return Qt.i18next.t(...key);
};
