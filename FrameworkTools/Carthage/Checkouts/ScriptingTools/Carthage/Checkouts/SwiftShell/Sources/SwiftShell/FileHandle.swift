/*
* Released under the MIT License (MIT), http://opensource.org/licenses/MIT
*
* Copyright (c) 2015 Kåre Morstøl, NotTooBad Software (nottoobadsoftware.com)
*
*/

import Foundation

extension NSFileHandle {

	public func readSome (encoding encoding: NSStringEncoding = main.encoding) -> String? {
		let data: NSData = self.availableData

		guard data.length > 0 else { return nil }
		guard let result = NSString(data: data, encoding: encoding) else {
			exit(errormessage: "Could not convert binary data to text.")
		}

		return result as String
	}

	public func read (encoding encoding: NSStringEncoding = main.encoding) -> String {
		let data: NSData = self.readDataToEndOfFile()

		guard let result = NSString(data: data, encoding: encoding) else {
			exit(errormessage: "Could not convert binary data to text.")
		}

		return result as String
	}
}

extension NSFileHandle {

	public func write <T> (x: T, encoding: NSStringEncoding = main.encoding) {
		guard let data = String(x).dataUsingEncoding(encoding, allowLossyConversion:false) else {
			exit(errormessage: "Could not convert text to binary data.")
		}
		self.writeData(data)
	}

	public func writeln <T> (x: T, encoding: UInt = main.encoding) {
		self.write(x, encoding: encoding)
		self.write("\n", encoding: encoding)
	}
}
