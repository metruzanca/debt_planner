import gleam/dict.{type Dict}
import gleam/float
import gleam/list
import gleam/option

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
  list.fold(debts, dict.new(), fn(payments, debt) {
    dict.insert(payments, debt.name, debt.minimum)
  })
}

pub fn next_payment(debts: List(Debt), budget: Float) {
  let minimum_dict = next_minimum_payment(debts)
  let total =
    dict.fold(minimum_dict, 0.0, fn(accumulator, key, value) {
      accumulator +. value
    })

  let left_over_budget = budget -. total

  let assert Ok(first) = list.first(debts)

  dict.upsert(minimum_dict, first.name, fn(entry) {
    let assert option.Some(amount) = entry
    amount +. left_over_budget
  })
}

pub fn payment_plan(
  debts: List(Debt),
  budget: Float,
) -> List(Dict(String, Float)) {
  todo
}
