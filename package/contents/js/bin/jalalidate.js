/*
Source: https://github.com/SCR-IR/gnome-shamsi-calendar
*/

.pragma library

Qt.jalalidate = (function() {
	/**  Gregorian & Jalali (Hijri_Shamsi,Solar) Date Converter Functions
	Author: JDF.SCR.IR =>> Download Full Version :  http://jdf.scr.ir/jdf
	License: GNU/LGPL _ Open Source & Free :: Version: 2.81 : [2020=1399]
	---------------------------------------------------------------------
	355746=361590-5844 & 361590=(30*33*365)+(30*8) & 5844=(16*365)+(16/4)
	355666=355746-79-1 & 355668=355746-79+1 &  1595=605+990 &  605=621-16
	990=30*33 & 12053=(365*33)+(32/4) & 36524=(365*100)+(100/4)-(100/100)
	1461=(365*4)+(4/4) & 146097=(365*400)+(400/4)-(400/100)+(400/400)  */

	function gregorian_to_jalali(gy, gm, gd) {
		var g_d_m, jy, jm, jd, gy2, days;
		g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
		gy2 = (gm > 2) ? (gy + 1) : gy;
		days = 355666 + (365 * gy) + ~~((gy2 + 3) / 4) - ~~((gy2 + 99) / 100) + ~~((gy2 + 399) / 400) + gd + g_d_m[gm - 1];
		jy = -1595 + (33 * ~~(days / 12053));
		days %= 12053;
		jy += 4 * ~~(days / 1461);
		days %= 1461;
		if (days > 365) {
			jy += ~~((days - 1) / 365);
			days = (days - 1) % 365;
		}
		if (days < 186) {
			jm = 1 + ~~(days / 31);
			jd = 1 + (days % 31);
		} else {
			jm = 7 + ~~((days - 186) / 30);
			jd = 1 + ((days - 186) % 30);
		}
		return [jy, jm, jd];
		}
		
		function jalali_to_gregorian(jy, jm, jd) {
		var sal_a, gy, gm, gd, days;
		jy += 1595;
		days = -355668 + (365 * jy) + (~~(jy / 33) * 8) + ~~(((jy % 33) + 3) / 4) + jd + ((jm < 7) ? (jm - 1) * 31 : ((jm - 7) * 30) + 186);
		gy = 400 * ~~(days / 146097);
		days %= 146097;
		if (days > 36524) {
			gy += 100 * ~~(--days / 36524);
			days %= 36524;
			if (days >= 365) days++;
		}
		gy += 4 * ~~(days / 1461);
		days %= 1461;
		if (days > 365) {
			gy += ~~((days - 1) / 365);
			days = (days - 1) % 365;
		}
		gd = days + 1;
		sal_a = [0, 31, ((gy % 4 === 0 && gy % 100 !== 0) || (gy % 400 === 0)) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		for (gm = 0; gm < 13 && gd > sal_a[gm]; gm++) gd -= sal_a[gm];
		return [gy, gm, gd];
		}
		
		// Codes after current line are from : https://github.com/SCR-IR/gnome-shamsi-calendar

		/** تبدیل تاریخ میلادی به هجری قمری هلالی - طبق رؤیت ماه ایران
	 * 
	 * @param {number} gY - GregorianYear: Int
	 * @param {number} gM - GregorianMonth: Int
	 * @param {number} gD - GregorianDay: Int
	 * 
	 * @return {[number, number, number]} [IslamicYear: Int, IslamicMonth: Int, IslamicDay: Int]: Array
	 */
	const gregorian_to_islamic = (gY, gM, gD) => {
		return julianDay_to_islamic(gregorian_to_julianDay(gY, gM, gD));
		}

		const julianDay_to_islamic = (julianDay) => {
		const HILAL = hilalIM();
		if (julianDay < HILAL.startJD || julianDay > HILAL.endJD) {
			return julianDay_to_islamicA(julianDay);
		} else {
			let iY, iM;
			let iD = julianDay - HILAL.startJD + 1;
			for (iY in HILAL.iDoM) {
			if (iD > HILAL.iDoM[iY][0]) {
				iD -= HILAL.iDoM[iY][0];
			} else {
				for (iM = 1; iM < 13, iD > HILAL.iDoM[iY][iM]; iM++) {
				iD -= HILAL.iDoM[iY][iM];
				}
				break;
			}
			}
			return [+iY, iM, ~~iD];
		}
		}

		const islamic_to_julianDay = (iY, iM, iD) => {
		const HILAL = hilalIM();
		if (iY < HILAL.startYear || iY > HILAL.endYear) {
			return islamicA_to_julianDay(iY, iM, iD);
		} else {
			let julianDay = HILAL.startJD - 1 + iD;
			for (let y in HILAL.iDoM) {
			if (y < iY) {
				julianDay += HILAL.iDoM[y][0];
			} else {
				for (let m = 1; m < iM; m++)julianDay += HILAL.iDoM[iY][m];
				break;
			}
			}
			return julianDay;
		}
		}

		const julianDay_to_islamicA = (julianDay) => {
		var iy, im, id, tmp;
		julianDay = ~~(julianDay) + 350822.5;//350823d=990y
		iy = ~~(((30 * (julianDay - 1948439.5)) + 10646) / 10631);
		tmp = julianDay - (1948439.5 + ((iy - 1) * 354) + ~~((3 + (11 * iy)) / 30));
		iy -= 990;
		im = ~~(((tmp - 29) / 29.5) + 1.99);
		if (im > 12) im = 12;
		id = 1 + tmp - ~~((29.5 * (im - 1)) + 0.5);
		return [iy, im, id];
		}

		const hilalIM = (country = 'IR') => {
		return {
			"IR": {
			startYear: 1427,/* =iDoM:firstYear */
			startJD: 2453767,/* =islamicA_to_julianDay(startYear,1,1) */
		
			endYear: 1443,/* =iDoM:lastYear */
			endJD: 2459790,/* =islamicA_to_julianDay(endYear+1,1,1)-1 */
		
			iDoM: {
				1427: [355, 30, 29, 29, 30, 29, 30, 30, 30, 30, 29, 29, 30],
				1428: [354, 29, 30, 29, 29, 29, 30, 30, 29, 30, 30, 30, 29],
				1429: [354, 30, 29, 30, 29, 29, 29, 30, 30, 29, 30, 30, 29],
				1430: [354, 30, 30, 29, 29, 30, 29, 30, 29, 29, 30, 30, 29],
				1431: [354, 30, 30, 29, 30, 29, 30, 29, 30, 29, 29, 30, 29],
				1432: [355, 30, 30, 29, 30, 30, 30, 29, 29, 30, 29, 30, 29],
				1433: [355, 29, 30, 29, 30, 30, 30, 29, 30, 29, 30, 29, 30],
				1434: [354, 29, 29, 30, 29, 30, 30, 29, 30, 30, 29, 30, 29],
				1435: [355, 29, 30, 29, 30, 29, 30, 29, 30, 30, 30, 29, 30],
				1436: [354, 29, 30, 29, 29, 30, 29, 30, 29, 30, 29, 30, 30],
				1437: [354, 29, 30, 30, 29, 30, 29, 29, 30, 29, 29, 30, 30],
				1438: [354, 29, 30, 30, 30, 29, 30, 29, 29, 30, 29, 29, 30],
				1439: [354, 29, 30, 30, 30, 30, 29, 30, 29, 29, 30, 29, 29],
				1440: [355, 30, 29, 30, 30, 30, 29, 30, 30, 29, 29, 30, 29],
				1441: [355, 29, 30, 29, 30, 30, 29, 30, 30, 29, 30, 29, 30],
				1442: [354, 29, 29, 30, 29, 30, 29, 30, 30, 29, 30, 30, 29],
				1443: [354/*|355*/, 29, 30, 30, 29, 29, 30, 29, 29, 30, 30, 30, 29/*|30 :خنثی‌سازی اختلاف مجموع کل*/]
				/*
				اختلاف = endJD - islamicA_to_julianDay(endYear,12,29)
				*/
			}
			}
		}[country];
		}

		/** 
	 * @param {number} gY - Gregorian Year
	 * @param {number} gM - Gregorian Month
	 * @param {number} gD - Gregorian Day
	 * @return {number} JulianDay
	 */
	const gregorian_to_julianDay = (gY, gM, gD) => {
		var gDoM, gY2, julianDay;
		gDoM = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
		gY2 = (gM > 2) ? (gY + 1) : gY;
		julianDay = 1721059 + (365 * gY) + ~~((gY2 + 3) / 4) - ~~((gY2 + 99) / 100) + ~~((gY2 + 399) / 400) + gD + gDoM[gM - 1];
		/* 1721059 = gregorian_to_julianDay(0, 1, 1) - 1 */
		return julianDay;
	}
	const gregorian_to_julianDayFloat = (gY, gM, gD) => {
		return gregorian_to_julianDay(gY, gM, gD) - 0.5;
	}

	return {
		gregorian_to_jalali,
		jalali_to_gregorian,
		gregorian_to_islamic,
		julianDay_to_islamic,
		islamic_to_julianDay,
		julianDay_to_islamicA,
		hilalIM,
		gregorian_to_julianDay,
		gregorian_to_julianDayFloat	
	}
})();
