extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}
