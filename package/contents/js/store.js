/*
Application store
*/

.pragma library

// Init Shamsi Calendar Object
if (!Qt._sc_) {
  Qt._sc_ = {};
}

Qt._sc_.storeUtils = {
  setStore: function (source) {
    Qt._sc_.store = source;
  },
};
