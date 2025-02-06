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
