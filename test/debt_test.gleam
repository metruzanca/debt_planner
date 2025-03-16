import debt.{Debt}
import gleam/dict
import gleam/list
import gleeunit/should

const debts = [
  Debt(0, "A", 37_300, 799, 724),
  Debt(1, "B", 4369, 34, 60),
  Debt(2, "C", 11_200, 2799, 445),
  Debt(3, "D", 5700, 2699, 196),
  Debt(4, "E", 2700, 2949, 92),
  Debt(5, "F", 4800, 2024, 297),
]

const mimimums = [
  #("B", 60),
  #("A", 724),
  #("F", 297),
  #("D", 196),
  #("C", 445),
  #("E", 92),
]

const first_payment = [
  #("B", 246),
  #("A", 724),
  #("F", 297),
  #("D", 196),
  #("C", 445),
  #("E", 92),
]

const budget = 2000

pub fn sort_debts_biggest_test() {
  debts
  |> debt.sort_debts(debt.Biggest)
  |> list.map(fn(d) { d.interest })
  |> should.equal([2949, 2799, 2699, 2024, 799, 34])
}

pub fn sort_debts_smallest_test() {
  debts
  |> debt.sort_debts(debt.Smallest)
  |> list.map(fn(d) { d.interest })
  |> should.equal([34, 799, 2024, 2699, 2799, 2949])
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
