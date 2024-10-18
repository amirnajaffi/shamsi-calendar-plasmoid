.pragma library

.import "./bin/jalaali.js" as Jalaali
.import "./bin/persian-date.js" as PersianDate

var pcgs_adapter = {
  /*
    PCGS = Persian Gnome Calendar = https://github.com/omid/Persian-Calendar-for-Gnome-Shell
    this functions use in event folder to easily converting PersianDate methods to jalaali functions
    */
  gregorianToPersian: function (...props) {
    const jDate = Jalaali.toJalaali(...props);
    return { year: jDate.jy, month: jDate.jm, day: jDate.jd };
  },
  persianToGregorian: function (...props) {
    const jDate = Jalaali.toGregorian(...props);
    return { year: jDate.gy, month: jDate.gm, day: jDate.gd };
  },
  isLeap: function (...props) {
    return Jalaali.isLeapJalaaliYear(...props);
  },
};

function stringToArray(sourceStr) {
  return sourceStr.split(',').filter((item) => item != '');
}

function stringToNumberArray(sourceStr) {
  return sourceStr
    .split(',')
    .map((item) => (item == '' ? item : parseInt(item)))
    .filter((item) => item != '');
}

function richDateFormatParser(date, format, locale) {
  if (!format) return '';
  if (!format.startsWith('<')) {
    // if it's not rich format
    if (!date) return new persianDate().toLocale(locale).format(format);
    return new persianDate(date).toLocale(locale).format(format);
  }

  const foundedSlices = this.extractTextWithIndices(format);
  let result = format;
  let offset = 0;
  foundedSlices.forEach((item, index) => {
    foundedSlices[index].formattedText = new persianDate(date).toLocale(locale).format(item.format);
    const startIndex = item.startIndex + offset;
    const endIndex = item.endIndex + offset + 1;
    const originalFormat = item.format;
    const parsedFormat = foundedSlices[index].formattedText;
    result = this.replaceAt(result, startIndex, endIndex, parsedFormat);
    offset = offset + (parsedFormat.length - originalFormat.length);
  });
  return result;
}

function extractTextWithIndices(htmlString) {
  /*
    get html as string and return all of contents with start and end indices
    */
  const tagRegex = /<[^>]*>/g;
  let textWithIndices = [];
  let lastIndex = 0;
  let tagStack = [];

  // Loop through the HTML string to extract text content and indices
  for (let i = 0; i < htmlString.length; i++) {
    if (tagStack.length === 0 && htmlString[i] === '<') {
      // Start of a new HTML tag
      let text = htmlString.slice(lastIndex, i);
      if (text.length > 0) {
        textWithIndices.push({
          format: text,
          startIndex: lastIndex,
          endIndex: i - 1,
        });
      }
      lastIndex = i;
      tagStack.push(htmlString[i]);
    } else if (htmlString[i] === '<') {
      // Nested HTML tag
      tagStack.push(htmlString[i]);
    } else if (htmlString[i] === '>') {
      // End of an HTML tag
      tagStack.pop();
      if (tagStack.length === 0) {
        let text = htmlString.slice(lastIndex, i + 1).replace(tagRegex, '');
        if (text.length > 0) {
          textWithIndices.push({
            format: text,
            startIndex: lastIndex,
            endIndex: i,
          });
        }
        lastIndex = i + 1;
      }
    }
  }

  return textWithIndices;
}

function replaceAt(str, startIndex, endIndex, replacement) {
  const firstPart = str.substring(0, startIndex);
  const lastPart = str.substring(endIndex);
  return firstPart + replacement + lastPart;
}
