import debt.{Debt}
import gleam/dict
import gleam/list
import gleeunit/should

const debts = [
  Debt(0, "A", 37_300.0, 7.99, 724.0),
  Debt(1, "B", 4369.0, 3.4, 60.0),
  Debt(2, "C", 11_200.0, 27.99, 445.0),
  Debt(3, "D", 5700.0, 26.99, 196.0),
  Debt(4, "E", 2700.0, 29.49, 92.0),
  Debt(5, "F", 4800.0, 20.24, 297.0),
]

const mimimums = [
  #("B", 60.0),
  #("A", 724.0),
  #("F", 297.0),
  #("D", 196.0),
  #("C", 445.0),
  #("E", 92.0),
]

const first_payment = [
  #("B", 246.0),
  #("A", 724.0),
  #("F", 297.0),
  #("D", 196.0),
  #("C", 445.0),
  #("E", 92.0),
]

const budget = 2000.0

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

pub fn next_minimum_test() {
  debts
  |> debt.sort_debts(debt.Smallest)
  |> debt.next_minimum_payment
  |> should.equal(dict.from_list(mimimums))
}

pub fn next_payment_test() {
  debts
  |> debt.sort_debts(debt.Smallest)
  |> debt.next_payment(budget)
  |> should.equal(dict.from_list(first_payment))
}
// pub fn payment_plan_test() {
//   todo
// }
