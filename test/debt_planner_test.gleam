import debt_planner.{Debt}
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const debts = [Debt("A", 500, 0.16, 50), Debt("B", 1000, 0.27, 300)]

pub fn sort_debts_biggest_test() {
  debts
  |> debt_planner.sort_debts(debt_planner.Biggest)
  |> list.map(fn(debt) { debt.interest })
  |> should.equal([0.27, 0.16])
}

pub fn sort_debts_snowball_test() {
  debts
  |> debt_planner.sort_debts(debt_planner.Snowball)
  |> list.map(fn(debt) { debt.interest })
  |> should.equal([0.16, 0.27])
}
