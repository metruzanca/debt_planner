import gleam/list

/// Removes value at index and returns new list
pub fn remove_at(list: List(a), at index: Int) {
  list.append(list.take(list, index), list.drop(list, index + 1))
}
