import UIKit

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let name = "Taylor"

for letter in name {
    print("Here is: \(letter)")
}

let fourthLetter = name[name.index(name.startIndex, offsetBy: 0)]

name[4]


