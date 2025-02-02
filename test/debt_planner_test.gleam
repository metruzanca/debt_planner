import debt_planner.{Debt}
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const debts = [
  Debt("A", 37_300, 7.99, 724),
  Debt("B", 4369, 3.4, 60),
  Debt("C", 11_200, 27.99, 445),
  Debt("D", 5700, 26.99, 196),
  Debt("E", 2700, 29.49, 92),
  Debt("F", 4800, 20.24, 297),
]

pub fn sort_debts_biggest_test() {
  debts
  |> debt_planner.sort_debts(debt_planner.Biggest)
  |> list.map(fn(debt) { debt.interest })
  |> should.equal([29.49, 27.99, 26.99, 20.24, 7.99, 3.4])
}

pub fn sort_debts_smallest_test() {
  debts
  |> debt_planner.sort_debts(debt_planner.Smallest)
  |> list.map(fn(debt) { debt.interest })
  |> should.equal([3.4, 7.99, 20.24, 26.99, 27.99, 29.49])
}
