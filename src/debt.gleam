import gleam/dict.{type Dict}
import gleam/float
import gleam/list

pub type Debt {
  Debt(name: String, amount: Int, interest: Float, minimum: Float)
}

pub type Strategy {
  Biggest
  Smallest
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

pub fn sort_debts(debts: List(Debt), strategy: Strategy) -> List(Debt) {
  case strategy {
    Biggest ->
      list.sort(debts, fn(a, b) { float.compare(b.interest, a.interest) })
    Smallest ->
      list.sort(debts, fn(a, b) { float.compare(a.interest, b.interest) })
  }
}

// todo next_payment
// fn minimum_payments
// then
// fn maximize first
// TODO error: not enough budget to cover minimums

// ... maybe separate calculate minimums function for UI

pub fn next_minimum_payment(debts: List(Debt)) {
  use payments, debt <- list.fold(debts, dict.new())
  dict.insert(payments, debt.name, debt.minimum)
}

pub fn next_payment(debts: List(Debt), budget: Float) -> Dict(String, Float) {
  let minimum = next_minimum_payment(debts)
  // let minimum_amount = dict.fold(minimum, 0.0, fn(acc, curr) { acc +. curr })
  // let remaining = budget -. minimum_amount
}
