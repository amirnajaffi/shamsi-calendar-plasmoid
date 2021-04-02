function daysInMonth (pDate) {
    const days = [];
    let startOfW = startOfWeek(pDate);

    for (let i=1; i <= pDate.daysInMonth(); i++) {
        days.push([pDate.year(), pDate.month(), i, startOfW ]);
        startOfW = startOfW >= 7 ? 1 : startOfW+1;
    }
    
    return days;
}

function startOfWeek (pDate) {
    const firstOfMonthDate = pDate.startOf('month');

    return firstOfMonthDate.day();
}

function getYears() {
    const startYear = 1350
    const endYear = 1500
    const years = [];
    
    for (let i = startYear; i <= endYear; i++) 
        years.push(i);

    return years;
}

function makeYears(modelId) {
    const years = getYears();
    
    years.forEach(element => {
        modelId.append({"name": element});
    });

    return true;
}

function yearChanged(year, currentDate = false) {
    if (!currentDate) currentDate = new persianDate();

    return currentDate.year(year);
}

function getYearIndexOf(year) {
    const years = getYears();

    return  years.indexOf(year);
}

function getMonths() {
    const tmpMonths = persianDate.rangeName().months;
    const months = [];

    for (let i = 0; i < 12; i++) {
        months.push({
            name: tmpMonths[i],
            monthNumber: i + 1
        })
    }

    return months;
}
function makeMonths(modelId) {
    const months = getMonths();
    
    months.forEach(element => {
        modelId.append(element);
    });

    return true;
}

function monthChanged(month, currentDate = false) {
    if (!currentDate) currentDate = new persianDate();

    return currentDate.month(month);
}

function getMonthIndexOf(month) {
    const months = getMonths();

    return months.map(function(x) { return x.monthNumber; }).indexOf(month);
}

function isHoliday(date) {
    const ph = Holidays.getPersianHolidays();
    const lh = Holidays.getLunarHolidays();

    // For performance hits i'm using jalali_to_gregorian instead of persianDate library
    const gregorianDate = Ghamari.jalali_to_gregorian(date[0], date[1], date[2]);
    const lunarDate = Ghamari.gregorian_to_islamic(gregorianDate[0], gregorianDate[1], gregorianDate[2]);

    return ph[date[1]][date[2]] != undefined || lh[lunarDate[1]][lunarDate[2]] != undefined;
}

function getHolidays(pDate) {
    const persianHodilays = Holidays.getPersianHolidays();
    const lunarHolidays = Holidays.getLunarHolidays();
    const gregorianDate = Ghamari.jalali_to_gregorian(pDate.year(), pDate.month(), pDate.date());
    const lunarDate = Ghamari.gregorian_to_islamic(gregorianDate[0], gregorianDate[1], gregorianDate[2]);
    const persianHolidaysResult = persianHodilays[pDate.month()][pDate.date()];
    const lunarHolidaysResult = lunarHolidays[lunarDate[1]][lunarDate[2]];

    let res = [];
    res = persianHolidaysResult != undefined ? res.concat(persianHolidaysResult) : res;
    res = lunarHolidaysResult != undefined ? res.concat(lunarHolidaysResult) : res;
    
    return res;
}
