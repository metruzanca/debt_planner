import gleam/int
import gleam/io
import gleam/list
import gleam/order

pub type Debt {
  Debt(name: String, amount: Int, interest: Float, minimum: Int)
}

pub type Strategy {
  Biggest
  Snowball
}

pub type Payment {
  Payment(
    // id: Int,
    debt_name: String,
    amount: Int,
  )
}

pub type PaymentGroup {
  PaymentGroup(id: Int, payments: List(Payment), total: Int)
}

pub fn main() {
  let budget = 1000

  let strat = Biggest

  let sorted_debts =
    [Debt("Credit card", 500, 0.16, 50), Debt("Car", 1000, 0.27, 300)]
    |> sort_debts(strat)

  io.debug(sorted_debts)
}

// TODO maybe refactor this out?
fn compare_interest(strat: Strategy) -> fn(Debt, Debt) -> order.Order {
  fn(a: Debt, b: Debt) {
    case a.interest == b.interest {
      True -> order.Eq
      False ->
        case a.interest <. b.interest, strat {
          True, Biggest -> order.Gt
          False, Biggest -> order.Lt
          True, Snowball -> order.Lt
          False, Snowball -> order.Gt
        }
    }
  }
}

// TODO use phantom types to make a DebtList(ordered) & DebtList(unordered)

pub fn sort_debts(debts: List(Debt), strategy: Strategy) -> List(Debt) {
  int.compare
  list.sort(debts, compare_interest(strategy))
}
