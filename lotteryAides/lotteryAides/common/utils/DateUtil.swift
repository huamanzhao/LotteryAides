//
//  DateUtil.swift
//  Heymow
//
//  Created by zhouchao on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import Foundation

let FORMAT_WHOLE_DATE = "yyyy-MM-dd"
let FORMAT_TIME = "HH:mm"
let FORMAT_DATE_HHmm = "yyyy-MM-dd HH:mm"
let FORMAT_DATE_TIME = "yyyy-MM-dd HH:mm:ss"
let FORMAT_MONTH = "MM"
let FORMAT_DATE_SINGLE = "d"
let FORMAT_MONTH_DAY = "M-d"
let FORMAT_YEAR = "yyyy"
let FORMAT_WHOLE_DATE_1 = "yyyy.MM.dd"
let LOTTERY_PUBLISH_DATE = "yyyy/MM/dd HH:mm:ss"

let FORMAT_MONTH_CN = "MM月"
let FORMAT_MONTH_DAY_CN = "M月d日"
let FORMAT_WHOLE_DATE_CN = "yyyy年MM月dd日"
let FORMAT_DATE_TIME_CN = "yyyy年MM月dd日 HH:mm"

let TIME_INTERVALS_ONE_MINITE = 60
let TIME_INTERVALS_ONE_HOUR = (60 * TIME_INTERVALS_ONE_MINITE)
let TIME_INTERVALS_ONE_DAY = (24 * TIME_INTERVALS_ONE_HOUR)

class DateUtil: NSObject {

    static var formatterDic = Dictionary <String, DateFormatter> ()

    static func getFormatter(_ regex:String) -> DateFormatter {
        var formatter = formatterDic[regex]
        if (formatter == nil) {
            formatter = DateFormatter()
            formatter!.timeZone = TimeZone.autoupdatingCurrent
            formatter!.dateFormat = regex
            formatterDic.updateValue(formatter!, forKey: regex)
        }

        return formatter!
    }

    static func getCurrentDate(_ regex: String) -> String {
        let date = Date()
        return getFormatter(regex).string(from: date)
    }

    static func formatDate(_ regex: String, date: Date) -> String {
        return getFormatter(regex).string(from: date)
    }

    static func formatDate(_ regex: String, year:Int, month:Int, day: Int) -> String {
        let calendar = Calendar.current
        let date = (calendar as NSCalendar).date(era: year/100, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0)
        return formatDate(regex, date: date!)
    }

    static func formateDate(_ targetRegex: String, sourceRegex: String, dateStr: String) -> String {
        let date = getFormatter(sourceRegex).date(from: dateStr)
        return getFormatter(targetRegex).string(from: date!)
    }

    static func formatDate(_ regex: String, timeInMillisStr: String) -> String {
        let timeInMillis = Double(timeInMillisStr)! / 1000
        let date = Date(timeIntervalSince1970: timeInMillis)
        return getFormatter(regex).string(from: date)
    }

    static func parseDate(_ regex: String, dateStr: String) -> Date {
        return getFormatter(regex).date(from: dateStr)!
    }

    /* 获取某个日期的0点时间 */
    static func getDateStart(_ date: Date) -> Date {
        let dateStr = getFormatter("yyyy-MM-dd").string(from: date)
        return getFormatter("yyyy-MM-dd").date(from: dateStr)!
    }

    /* 获取某个日期的24点时间 */
    static func getDateEnding(_ date: Date) -> Date {
        let dateBegin = DateUtil.getDateStart(date)
        return dateBegin.addingTimeInterval(TimeInterval(24*3600))
    }

    /* 获取某天的某个点的时间*/
    static func getDateWithHour(_ date: Date, hour: Int) -> Date {
        let dateStr = DateUtil.getDateStart(date)
        return dateStr.addingTimeInterval(TimeInterval(hour*3600))
    }

    static func getLocalDate() -> Date{
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }

    static func getLocalByDate(_ date: Date) -> Date{
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }

    static func getLocalDate(_ regex: String) -> String {
        return getFormatter(regex).string(from: getLocalDate())
    }

    static func getFormateDateFromString(_ regex: String, dateStr: String) -> Date {
        let formatter = getFormatter(regex)

        return formatter.date(from: dateStr)!
    }

    //获取字符串时分今天时间
    static func getTodayDateFromString(_ dateStr: String) -> Date {
        let str = dateStr.components(separatedBy: ":")
        let timeInterval = Int(str[0])!*TIME_INTERVALS_ONE_HOUR + Int(str[1])!*TIME_INTERVALS_ONE_MINITE
        return DateUtil.getDateStart(Date()).addingTimeInterval(Double(timeInterval))
    }

    //获取天数差值 tDate - sDate
    static func getDaysMargin(from sDate: Date, to tDate: Date) -> Int {
        //获取两个天数的零点
        let source = getDateStart(sDate)
        let target = getDateStart(tDate)

        let interval = Int(target.timeIntervalSince(source))

        let margin = interval / TIME_INTERVALS_ONE_DAY

        return margin
    }
    
    
    /*
     *   星期几计算
     */
    
    //获取星期几字符串 输入：代表星期几的数字数组
    //直接解析服务端返回的weekDay
    static func getWeekDays(_ weekInts: String) -> String {
        if weekInts.isEmpty {
            return ""
        }
        
        let weekDaysIntStringArr = weekInts.components(separatedBy: ",")
        let count = weekDaysIntStringArr.count
        //1. 如果只有一天，则返回星期几
        if count == 1 {
            let weekDayIntString = weekDaysIntStringArr.first! as NSString
            
            return getWeekDayCNString(Int(weekDayIntString.intValue))
        }
            
            //2. 如果只有两天，显示示例：周一、周二
        else if count == 2 {
            let firstInt = (weekDaysIntStringArr.first! as NSString).integerValue
            let firstCNInt = getWeekDayStringFromInt(firstInt)
            
            let lastInt  = (weekDaysIntStringArr.last!  as NSString).integerValue
            let lastCNInt = getWeekDayStringFromInt(lastInt)
            
            return "周" + firstCNInt + "、" + "周" + lastCNInt
        }
            
        else { //如果有三天以上
            var weekdays = ""
            
            let continuty = checkIntArrContinuity(weekDaysIntStringArr)
            //3.1 星期几不连续，显示示例：周一、三、五
            if !continuty {
                var cnString = ""
                for intStringValue in weekDaysIntStringArr {
                    let intValue = (intStringValue as NSString).integerValue
                    let cnValue = getWeekDayStringFromInt(intValue)
                    
                    if cnString.isEmpty {
                        cnString = cnValue
                    }
                    else {
                        cnString = cnString + "、" + cnValue
                    }
                }
                
                weekdays = "周" + cnString
            }
            else { //3.2 星期几连续，显示示例：周一至周四
                let firstInt = (weekDaysIntStringArr.first! as NSString).integerValue
                let firstCNInt = getWeekDayStringFromInt(firstInt)
                
                let lastInt  = (weekDaysIntStringArr.last!  as NSString).integerValue
                let lastCNInt = getWeekDayStringFromInt(lastInt)
                
                weekdays = "周" + firstCNInt + "至周" + lastCNInt
            }
            
            return weekdays
        }
    }
    
    
    //计算指定日期是星期几
    static func getWeekday(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.weekday], from: date)
        let weekDayInteger = dateComponents.weekday
        
        return getWeekDayCNString(weekDayInteger!)
    }
    
    //根据数字返回星期几字符串
    static func getWeekDayCNString(_ day: Int) -> String {
        return "星期" + getWeekDayStringFromInt(day)
    }
    
    
    //根据数字返回星期几的中文数字
    //TODO: 跟服务端确定数字跟星期几的对应关系
    private static func getWeekDayStringFromInt(_ day: Int) -> String {
        var weekDayString = ""
        
        switch day {
        case 1:
            weekDayString = "日"
            
        case 2:
            weekDayString = "一"
            
        case 3:
            weekDayString = "二"
            
        case 4:
            weekDayString = "三"
            
        case 5:
            weekDayString = "四"
            
        case 6:
            weekDayString = "五"
            
        case 7:
            weekDayString = "六"
            
        default:
            break
        }
        
        return weekDayString
    }
    
    
    //检查数字数组是否连续
    private static func checkIntArrContinuity(_ intStringArr: [String]) -> Bool {
        var lastValue = (intStringArr.first! as NSString).integerValue
        for (index, stringValue) in intStringArr.enumerated() {
            if index == 0 {
                continue
            }
            
            let intValue = (stringValue as NSString).integerValue
            if intValue != lastValue + 1 {
                return false
            }
            
            lastValue = intValue
        }
        
        return true
    }
}



public extension Date {
    //MARK: Static
    static func getDate(_ timeInMillis: Double) -> Date {
        let seconds = timeInMillis / 1000
        let date = Date(timeIntervalSince1970: seconds)
        return date
    }
    
    //获取当前本地时间（东8时区）
    static func localDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }
    
    //转化为本地时间（东8时区）
    public func toLocalDate() -> Date {
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: self)
        return self.addingTimeInterval(Double(interval))
    }
    
    //NSDate按格式转换成字符串
    public func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //从某日起到此日期的天数
    public func daysSinceDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day], from: date.startOfDay(), to: self.startOfDay(), options: [])
        return components.day!
    }
    
    //从此日期到某日之间的天数
    public func daysBeforeDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day], from: self.startOfDay(), to: date.startOfDay(), options: [])
        return components.day!
    }
    
    
    //某一天开始时间（零点）
    public func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    //获取当天零点时间
//    public func midnightUTCDate() -> NSDate {
//        let dc: NSDateComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: self)
//        dc.hour = 0
//        dc.minute = 0
//        dc.second = 0
//        dc.nanosecond = 0
//        dc.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        
//        return NSCalendar.currentCalendar().dateFromComponents(dc)!
//    }
    
    //某一天结束时间（24点）
    public func endOfDay() -> Date {
//        return startOfDay() + (60 * 60 * 24 - 1).seconds as! Double
        return Date()
    }

    //是否是今天
    public func isToday() -> Bool {
//        return self == Date()
        return self.compare(Date()) == ComparisonResult.orderedSame ? true : false
    }
    
    //加上n秒
    public func plusSeconds(_ s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //减去n秒
    public func minusSeconds(_ s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //加上n分钟
    public func plusMinutes(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //减去n分钟
    public func minusMinutes(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //加上n小时
    public func plusHours(_ h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //减去n小时
    public func minusHours(_ h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    //加上n天
    public func plusDays(_ d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    //减去n天
    public func minusDays(_ d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    //加上n周
    public func plusWeeks(_ w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    //减去n周
    public func minusWeeks(_ w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    //加上n月
    public func plusMonths(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    //减去n月
    public func minusMonths(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    //加上n年
    public func plusYears(_ y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    //减去n年
    public func minusYears(_ y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    //内部方法
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc: DateComponents = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return (Calendar.current as NSCalendar).date(byAdding: dc, to: self, options: [])!
    }
    
    //MARK: 两时间之差
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: d1, to: d2, options:[])
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: d1, to: d2, options: [])
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: d1, to: d2, options: [])
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: d1, to: d2, options: [])
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.weekOfYear, from: d1, to: d2, options: [])
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: d1, to: d2, options: [])
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: d1, to: d2, options: [])
        return dc.year!
    }
    
    //MARK- Computed Properties
    public var day: UInt {
        return UInt((Calendar.current as NSCalendar).component(.day, from: self))
    }
    
    public var month: UInt {
        return UInt((Calendar.current as NSCalendar).component(.month, from: self))
    }
    
    public var year: UInt {
        return UInt((Calendar.current as NSCalendar).component(.year, from: self))
    }
    
    public var hour: UInt {
        return UInt((Calendar.current as NSCalendar).component(.hour, from: self))
    }
    
    public var minute: UInt {
        return UInt((Calendar.current as NSCalendar).component(.minute, from: self))
    }
    
    public var second: UInt {
        return UInt((Calendar.current as NSCalendar).component(.second, from: self))
    }
    
    static func getDisplayTime(_ timeInMillis: String) -> String {
        let date = Date.getDate(Double(timeInMillis)!)
        let today = Date()
        
        let distance = Date.daysBetween(date1: date.startOfDay(), date2: today.startOfDay())
        
        //今年之前的，返回年月日
        if distance > 365 {
            return date.toString(FORMAT_WHOLE_DATE_CN)
        }
        
        //今年的，前天之前
        if distance > 2 {
            return date.toString(FORMAT_MONTH_DAY_CN)
        }
        
        //前天
        if distance == 2 {
            return "前天 " + date.toString(FORMAT_TIME)
        }
        
        //昨天
        if distance == 1 {
            return "昨天 " + date.toString(FORMAT_TIME)
        }
        
        //今天
        if distance == 0 {
            return "今天 " + date.toString(FORMAT_TIME)
        }
        
        return date.toString(FORMAT_WHOLE_DATE)
    }
}

//MARK: Int extension
public extension Int {
    public var seconds: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.second = self
        return dateComponents
    }
    
    public var minutes: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.minute = self
        return dateComponents
    }
    
    public var hours: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.hour = self
        return dateComponents
    }
    
    public var days: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.day = self
        return dateComponents
    }
    
    public var weeks: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.day = 7 * self
        return dateComponents
    }
    
    public var months: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.month = self
        return dateComponents
    }
    
    public var years: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.year = self
        return dateComponents
    }
}


//MARK: - 时间比较
//操作符扩展
//public func == (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
//}
//
//public func != (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 != rhs.timeIntervalSince1970
//}
//
//public func < (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
//}
//
//public func > (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
//}
//
//public func <= (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
//}
//
//public func >= (lhs: Date, rhs: Date) -> Bool {
//    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
//}
//
//public func + (lhs: Date, rhs: DateComponents) -> Date {
//    let calendar = Calendar.current
//    return (calendar as NSCalendar).date(byAdding: rhs, to: lhs, options: [])!
//}

extension Date {
    //MARK- 比较
    public func isLaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isEarlierThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }

}

extension String {
    //字符串按照指定格式转换成NSDate
    public func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

