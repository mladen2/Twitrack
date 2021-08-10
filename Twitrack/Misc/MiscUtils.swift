//
//  MiscUtils.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 30/07/2021.
//

import Foundation

var format: DateFormatter?

public func fmt() -> DateFormatter {
    if format == nil {
        format = DateFormatter()
        format!.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    return format!
}

func pr(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line, thread: String = "\(Thread.current.desc)") {
    print("\(fmt().string(from: Date())) \(thread) \(file.components(separatedBy: "/").last!) \(function):\(line): \(message)")
}

public extension Thread {

    var desc: String {
        var extendedDetails = ""
        if Thread.isMainThread {
            extendedDetails += "main"
        } else {
            if let threadName = Thread.current.name, !threadName.isEmpty {
                extendedDetails += "\(threadName)"
            } else if let queueName = OperationQueue.current?.underlyingQueue?.label, !queueName.isEmpty {
                extendedDetails += "\(queueName)"
            } else {
                let firs = String(format: "%p", Thread.current)
                let scnd = firs.replacingOccurrences(of: "0x60000", with: "")
                extendedDetails += scnd
            }
        }
        return extendedDetails
    }
}
