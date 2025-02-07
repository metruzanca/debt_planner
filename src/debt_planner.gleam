import gleam/int
import lustre
import lustre/element/html.{button, div, p, text}
import lustre/event

// get budget per payment period
// get debt list

// sort debts depending on strategy
// calculate payment plan:
// - each payment group must at least meet minimum payment
// - then must maximize either smallest/biggest depending on strategy
pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model =
  Int

fn init(_flags) -> Model {
  0
}

type Msg {
  Incr
  Decr
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Incr -> model + 1
    Decr -> model - 1
  }
}

fn view(model: Model) {
  let count = int.to_string(model)

  div([], [
    button([event.on_click(Incr)], [text("+")]),
    p([], [text(count)]),
    button([event.on_click(Decr)], [text("-")]),
  ])
}
