import debt.{Debt}
import gleam/list
import gleeunit/should

const debts = [
  Debt("A", 37_300, 7.99, 724.0),
  Debt("B", 4369, 3.4, 60.0),
  Debt("C", 11_200, 27.99, 445.0),
  Debt("D", 5700, 26.99, 196.0),
  Debt("E", 2700, 29.49, 92.0),
  Debt("F", 4800, 20.24, 297.0),
]

pub fn sort_debts_biggest_test() {
  debts
  |> debt.sort_debts(debt.Biggest)
  |> list.map(fn(d) { d.interest })
  |> should.equal([29.49, 27.99, 26.99, 20.24, 7.99, 3.4])
}

pub fn sort_debts_smallest_test() {
  debts
  |> debt.sort_debts(debt.Smallest)
  |> list.map(fn(d) { d.interest })
  |> should.equal([3.4, 7.99, 20.24, 26.99, 27.99, 29.49])
}
