import UIKit

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    // Capitalized first letter
    var capitalizedString: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let name = "Taylor"

for letter in name {
    print("Here is: \(letter)")
}

// Subscript, find a character in a String with an index
let fourthLetter = name[name.index(name.startIndex, offsetBy: 0)]
name[4]

// Remove certain characters in a String
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

let newPwrd = password.deletingPrefix("123")
let dropLastPwrd = password.deletingSuffix("45")

// Capitalize
let weather = "it's going to rain"
weather.capitalized
weather.capitalizedString
